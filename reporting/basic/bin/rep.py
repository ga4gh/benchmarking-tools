#!/usr/bin/env python
# coding=utf-8
#
# Create simple reports from GA4GH benchmarking results
#
# Usage:
#
# For usage instructions run with option --help
#
# Author:
#
# Peter Krusche <pkrusche@illumina.com>
#

import sys
import os
import csv
import argparse
import jinja2
import gzip

LIBDIR = os.path.abspath(os.path.join(os.path.dirname(__file__), "..", "src", "python"))
sys.path.append(os.path.abspath(os.path.join(LIBDIR)))

import report
import report.metrics
from report.template import TEMPLATEDIR


def main():
    parser = argparse.ArgumentParser(description="Create a variant calling report.")

    parser.add_argument("input", help="Input file in GA4GH metrics format", nargs="*")

    parser.add_argument("-o", "--output", help="Output file name for reports, e.g. 'report' to write "
                                               "report.html")

    parser.add_argument("-m", "--comparison-method", default="default", dest="comparison_method",
                        help="The comparison method that was used.")

    parser.add_argument("-l", "--result-list", default=[], dest="result_list", action="append",
                        help="Result list in delimited format. Must have these columns: "
                             "method, comparisonmethod, and files.")

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

    if args.input:
        metrics = report.metrics.read_qfy_csv(args.input, args.comparison_method)
    else:
        metrics = []

    for l in args.result_list:
        print "reading %s" % l
        csvfile = open(l, 'rb')
        dialect = csv.Sniffer().sniff(csvfile.read(8192))
        csvfile.seek(0)
        dr = csv.DictReader(csvfile, dialect=dialect)
        for row in dr:
            rfiles = [x.strip() for x in row["files"].split(",")]
            for i, rfile in enumerate(rfiles):
                if not os.path.exists(rfile):
                    rfiles[i] = os.path.abspath(os.path.join(os.path.dirname(l), rfile))
            row_metrics = report.metrics.read_qfy_csv(rfiles,
                                                      method=row["method"],
                                                      cmethod=row["comparisonmethod"],
                                                      roc_metrics=["METRIC.Precision", "METRIC.Recall"],
                                                      roc_diff=args.roc_diff,
                                                      max_data_points=args.roc_datapoints,
                                                      minmax={"METRIC.Precision": {"min": args.min_precision},
                                                              "METRIC.Recall": {"min": args.min_recall}}
                                                      )
            metrics = metrics + row_metrics

    loader = jinja2.FileSystemLoader(searchpath=TEMPLATEDIR)
    env = jinja2.Environment(loader=loader)

    template_vars = {
        "content": report.make_report(metrics)
    }

    template = env.get_template("report.jinja2.html")
    template.stream(**template_vars).dump(args.output)


if __name__ == '__main__':
    main()
