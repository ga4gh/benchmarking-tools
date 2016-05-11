#!/usr/bin/env python
# coding=utf-8
#
# Read GA4GH report files
#
# Author:
#
# Peter Krusche <pkrusche@illumina.com>
#

import simple_report
import metrics

REPORT_TYPES = {
    "simple": simple_report
}


def make_report(data, reporttype=REPORT_TYPES.keys()[0]):
    """Report factory
    :param data: the data to plot. Should be a list of metrics objects
    :type data: list of metrics.MetricSet
    :param reporttype: type of report
    :return:
    """
    return REPORT_TYPES[reporttype].make_report(data)


