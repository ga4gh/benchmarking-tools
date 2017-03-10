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
import json
import argparse
import jinja2
import gzip
import copy

TEMPLATEDIR = os.path.abspath(os.path.join(os.path.dirname(__file__), "..", "src", "html"))
LIBDIR = os.path.abspath(os.path.join(os.path.dirname(__file__), "..", "src", "python"))
sys.path.append(os.path.abspath(os.path.join(LIBDIR)))

import report.metrics


def extract_metrics(metrics):
    """ Extract metrics and get data for tables.

    This function takes a list of ROC values, and separates out the summary
    values (which go into the tables) and the ROC datapoints (which are drawn).

    :param metrics: a list of metrics as read by report.metrics
    :return: { "snp/indel_table" : ... , "snp/indel_roc": ... }
    """
    data_subset = [d.to_dict() for d in metrics
                   if d.type in ["SNP", "INDEL"] and
                   d.filter in ["ALL", "PASS"] and
                   d.genotype == "*"]

    data_subset_snp = [d for d in data_subset if d["type"] == "SNP" and d["subtype"] == "*"]
    data_subset_indel = [d for d in data_subset if d["type"] == "INDEL"]
    data_subset_snp.sort(key=lambda x: x["subset"])

    def _indel_type_order(t):
        """ sort indel subtypes """
        ordering = {
            "D1_5": 1,
            "I1_5": 2,
            "C1_5": 3,
            "D6_15": 4,
            "I6_15": 5,
            "C6_15": 6,
            "D16_PLUS": 7,
            "I16_PLUS": 8,
            "C16_PLUS": 9
        }
        try:
            return ordering[t]
        except:
            return 1000

    data_subset_indel.sort(key=lambda x: [x["subset"], _indel_type_order(x["subtype"])])

    data_subset_snp_roc = [copy.copy(d) for d in data_subset_snp if d["subtype"] == "*" and d["subset"] == "*"]
    data_subset_indel_roc = [copy.copy(d) for d in data_subset_indel if d["subtype"] == "*" and d["subset"] == "*"]

    # these just get turned into tables, so we don't need the ROC values
    for d in data_subset_snp:
        del d["roc"]
    for d in data_subset_indel:
        del d["roc"]

    qq_fields = list(set([x.qq_field for x in metrics]))

    # 3. run Jinja2 to make the HTML page
    return {
        "snp_table": json.dumps(json.dumps(data_subset_snp)),
        "snp_roc": json.dumps(json.dumps(data_subset_snp_roc)),
        "indel_table": json.dumps(json.dumps(data_subset_indel)),
        "indel_roc": json.dumps(json.dumps(data_subset_indel_roc)),
        "qq_fields": qq_fields,
    }


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

    # 1. Read input files

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
            rfiles = [l[0]]
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

    if not metrics:
        raise Exception("No inputs specified.")

    # 2. Subset data, only read SNP / indel, ALL, PASS
    template_vars = extract_metrics(metrics)

    # 3. render template
    loader = jinja2.FileSystemLoader(searchpath=TEMPLATEDIR)
    env = jinja2.Environment(loader=loader)

    template = env.get_template("report.jinja2.html")
    template.stream(**template_vars).dump(args.output)


if __name__ == '__main__':
    main()
