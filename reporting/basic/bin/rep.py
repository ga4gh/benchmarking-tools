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

    parser.add_argument("input", help="Input file in GA4GH metrics CSV format. "
                                      "To label multiple results, use the following pattern: "
                                      "rep.py gatk-3_vcfeval-giab:gatk3.roc.all.csv.gz -o test.html ; this will"
                                      "use the label gatk-3 for 'Method', and vcfeval-giab for the "
                                      "'Comparison' header.", nargs="*")

    parser.add_argument("-o", "--output", help="Output file name for reports, e.g. 'report' to write "
                                               "report.html",
                        required=True)

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

    metrics = []
    for i in args.input:
        l = i.split(":")

        method_label = "default"
        cmethod_label = "default"

        if len(l) <= 1:
            rfiles = l[0]
        else:
            rfiles = l[1:]
            labels = l[0].split("_")
            if len(labels) > 0:
                method_label = labels[0]
            if len(labels) > 1:
                cmethod_label = labels[1]

        print "reading %s as %s / %s" % (str(rfiles), method_label, cmethod_label)

        row_metrics = report.metrics.read_qfy_csv(rfiles,
                                                  method=method_label,
                                                  cmethod=cmethod_label,
                                                  roc_metrics=["METRIC.Precision", "METRIC.Recall"],
                                                  roc_diff=args.roc_diff,
                                                  max_data_points=args.roc_datapoints,
                                                  minmax={"METRIC.Precision": {"min": args.min_precision},
                                                          "METRIC.Recall": {"min": args.min_recall}}
                                                  )
        metrics += row_metrics

    loader = jinja2.FileSystemLoader(searchpath=TEMPLATEDIR)
    env = jinja2.Environment(loader=loader)

    template_vars = {
        "content": report.make_report(metrics)
    }

    if not metrics:
        raise Exception("No inputs specified.")

    template = env.get_template("report.jinja2.html")
    template.stream(**template_vars).dump(args.output)


if __name__ == '__main__':
    main()
