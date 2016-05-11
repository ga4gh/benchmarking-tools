#!/usr/bin/env python
# coding=utf-8
#
# Run hap.py and run reporter on a list of VCF files
#
# Author:
#
# Peter Krusche <pkrusche@illumina.com>
#

import sys
import os
import argparse
import jinja2
import logging
import json
import gzip

LIBDIR = os.path.abspath(os.path.join(os.path.dirname(__file__), "..", "src", "python"))
sys.path.append(os.path.abspath(os.path.join(LIBDIR)))

from deps import DEPS
from deps.happy import happy
from deps.truthsets import TRUTHSETS, Truthset

import report
import report.metrics
from report.template import TEMPLATEDIR


def main():
    logging.basicConfig(level=logging.DEBUG,
                        format='%(asctime)s %(levelname)s %(message)s')

    parser = argparse.ArgumentParser(description="Benchmark a set of VCFs against "
                                                 "Platinum Genomes and Genome in a Bottle + produce a report.")

    parser.add_argument("input", help="input VCF files", nargs="+")

    parser.add_argument("-o", "--output", help="output HTML file name", dest="output")

    parser.add_argument("-O", "--keep-results", help="Specify a folder in which to keep the hap.py results.",
                        dest="keep_results", default=None)

    parser.add_argument("-t", "--truthsets", help="Truthsets to use in comma separated list (allowed: %s" %
                                                  str(TRUTHSETS.keys()),
                        default=",".join(TRUTHSETS.keys()))

    parser.add_argument("-e", "--engine", help="Comparison engine to use (xcmp / vcfeval)",
                        default="xcmp", choices=["xcmp", "vcfeval"])

    parser.add_argument("--custom-truthset", help="Add custom truthsets in this format: 'name:vcf:bed'",
                        default=[], action="append")

    parser.add_argument("--roc", help="ROC feature to use", dest="roc", default="QUAL")
    parser.add_argument("--ignore-filters", help="Filters to ignore (e.g. --ignore-filters MQ,lowQual).",
                        dest="roc_filters", default=None)

    parser.add_argument("--happy-extra", help="hap.py extra arguments", dest="happy_extra", default=None)
    parser.add_argument("-r", "--reference", help="Reference FASTA file to use",
                        dest="reference", default="hg19")

    parser.add_argument("--roc-max-datapoints",
                        help="Maximum number of data points in a ROC (higher numbers might slow down our plotting)",
                        dest="roc_datapoints", type=int, default=1000)

    parser.add_argument("--roc-resolution",
                        help="Minimum difference in precision / recall covered by the ROC curves.",
                        dest="roc_diff", type=float, default=0.005)
    parser.add_argument("--min-recall", help="Minimum recall for ROC curves (use to reduce size of output file by "
                                             "clipping the bits of the ROC that are not meaningful)",
                        dest="min_recall", type=float, default=0.2)
    parser.add_argument("--min-precision", help="Minimum precision for ROC curves (use to reduce size of output file by"
                                                " clipping the bits of the ROC that are not meaningful)",
                        dest="min_precision", type=float, default=0.0)

    args = parser.parse_args()

    if args.output.endswith(".gz"):
        args.output = gzip.GzipFile(args.output, "w")
    elif not args.output.endswith(".html"):
        args.output += ".html"

    if args.keep_results and not os.path.isdir(args.keep_results):
        raise Exception("Output folder %s does not exist." % args.keep_results)

    for x in args.custom_truthset:
        xs = x.split(":", 2)
        if len(xs) != 3:
            raise Exception("Invalid custom truthset: %s" % x)
        TRUTHSETS[xs[0]] = Truthset(xs[0], xs[1], xs[2])

    args.truthsets = [TRUTHSETS[ts] for ts in args.truthsets.split(",")]

    resultlist = []
    metrics = []

    logging.debug(str(DEPS))
    logging.debug(str(args))

    try:
        results_for_report = []

        for query in args.input:
            methodname = os.path.basename(query)
            if methodname.endswith(".gz"):
                methodname = methodname[:-3]
            if methodname.endswith(".vcf"):
                methodname = methodname[:-4]
            if methodname.endswith(".bcf"):
                methodname = methodname[:-4]

            for ts in args.truthsets:
                logging.info("Comparing %s against %s" % (query, ts.name))
                # run with PG
                happyfiles = happy(query,
                                   truth=ts.vcf,
                                   truth_conf=ts.bed,
                                   roc_feature=args.roc,
                                   roc_filters=args.roc_filters,
                                   engine=args.engine,
                                   ref=args.reference,
                                   extra=args.happy_extra,
                                   output_folder=args.keep_results,
                                   output_prefix=args.engine + "_" + methodname)
                resultlist += happyfiles

                results_for_report.append({
                    "method": methodname,
                    "cmethod": ts.name + "-" + args.engine,
                    "files": [r for r in happyfiles if r.endswith(".csv") and
                              ("roc.Locations." in r or r.endswith(".extended.csv"))]
                })

        if args.keep_results:
            with open(os.path.join(args.keep_results,
                                   os.path.splitext(
                                       os.path.basename(args.output))[0] + ".tsv"), "w") as f:
                print >> f, "\t".join(["method", "comparisonmethod", "files"])
                for row in results_for_report:
                    print >> f, "\t".join([row["method"],
                                           row["cmethod"],
                                           ",".join(row["files"])])

        for row in results_for_report:
            row_metrics = report.metrics.read_qfy_csv(row["files"],
                                                      method=row["method"],
                                                      cmethod=row["cmethod"],
                                                      roc_metrics=["METRIC.Precision", "METRIC.Recall"],
                                                      roc_diff=args.roc_diff,
                                                      max_data_points=args.roc_datapoints,
                                                      minmax={"METRIC.Precision": {"min": args.min_precision},
                                                              "METRIC.Recall": {"min": args.min_recall}}
                                                      )

            metrics = metrics + row_metrics
    finally:
        # clean results unless we want to keep the scratch space
        if not args.keep_results:
            for r in resultlist:
                try:
                    os.unlink(r)
                except:
                    pass

    logging.info("Making report %s from %i results" % (args.output, len(metrics)))

    loader = jinja2.FileSystemLoader(searchpath=TEMPLATEDIR)
    env = jinja2.Environment(loader=loader)

    template_vars = {
        "content": report.make_report(metrics)
    }

    template = env.get_template("report.jinja2.html")
    template.stream(**template_vars).dump(args.output)


if __name__ == "__main__":
    main()
