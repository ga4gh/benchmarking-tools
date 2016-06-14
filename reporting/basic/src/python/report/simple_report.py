#!/usr/bin/env python
# coding=utf-8
#
# Read GA4GH report files
#
# Author:
#
# Peter Krusche <pkrusche@illumina.com>
#

from roc_plot import render_roc
from metrics_table import render_table

from metrics import MetricSet
import copy


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


def make_report(data):
    """ Render simple performance report from multiple metrics results
    :param data: list of Metrics sets
    :type data: list of MetricSet
    :rtype: str
    """

    result = ""
    data_subset = [d.to_dict() for d in data
                   if d.type in ["SNP", "INDEL"] and
                   d.filter in ["ALL", "PASS"] and
                   d.genotype == "*" and
                   d.aggregate.metric("TRUTH.TOTAL") > 0 and
                   d.aggregate.metric("QUERY.TOTAL") > 0]

    data_subset_snp = [d for d in data_subset if d["type"] == "SNP" and d["subtype"] == "*"]
    data_subset_indel = [d for d in data_subset if d["type"] == "INDEL"]

    data_subset_snp.sort(key=lambda x: x["subset"])
    # sort indel subtypes
    data_subset_indel.sort(key=lambda x: [x["subset"], _indel_type_order(x["subtype"])])

    data_subset_snp_roc = [copy.copy(d) for d in data_subset_snp if d["subtype"] == "*" and d["subset"] == "*"]
    data_subset_indel_roc = [copy.copy(d) for d in data_subset_indel if d["subtype"] == "*" and d["subset"] == "*"]

    # these just get turned into tables, so we don't need the ROC values
    for d in data_subset_snp:
        del d["roc"]
    for d in data_subset_indel:
        del d["roc"]

    result += "<h1>Summary Statistics</h1>"

    result += "<h2>SNPs</h2>"
    result += render_table("snp_table", data_subset_snp)

    result += "<h2>INDELs</h2>"
    result += render_table("indel_table", data_subset_indel)

    result += "<h1>Precision/Recall Curves</h1>"

    result += "<h2>SNPs</h2>"
    result += render_roc("snp_roc", data_subset_snp_roc)

    result += "<h2>INDELs</h2>"
    result += render_roc("indel_roc", data_subset_indel_roc)

    return result
