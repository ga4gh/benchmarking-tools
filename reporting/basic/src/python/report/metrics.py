#!/usr/bin/env python
# coding=utf-8
#
# Wrapper to read GA4GH report files
#
# Author:
#
# Peter Krusche <pkrusche@illumina.com>
#

import os
import csv
import math
import gzip


class Metrics:
    """ single data pint for metrics """

    # required metrics values
    METRIC_NAMES = [
        "QQ",
        "TRUTH.TP",
        "TRUTH.FN",
        "QUERY.FP",
        "QUERY.UNK",
        "TRUTH.TOTAL",
        "QUERY.TOTAL",
        "FP.gt",
        "FP.al",
        "METRIC.Recall",
        "METRIC.Precision",
        "METRIC.F1_Score",
        "METRIC.Frac_NA",
        "TRUTH.TOTAL.TiTv_ratio",
        "TRUTH.TOTAL.het_hom_ratio",
        "QUERY.TOTAL.TiTv_ratio",
        "QUERY.TOTAL.het_hom_ratio"
    ]

    METRIC_INDEX = {n: i for i, n in enumerate(METRIC_NAMES)}

    def __init__(self, **kwargs):
        # key fields
        self.metrics = [0 for _ in range(len(Metrics.METRIC_NAMES))]

        def safe_float(x):
            try:
                return float(x)
            except:
                return float("nan")

        for k, v in kwargs.iteritems():
            self.metric(k, safe_float(v))

        # fix for hap.py 0.3.0 which doesn't calculate F-Scores correctly
        try:
            r = self.metric("METRIC.Recall")
            p = self.metric("METRIC.Precision")
            self.metric("METRIC.F1_Score", 2.0 * p * r / (p + r))
        except:
            pass

    def metric(self, name, value=None):
        """ Metric getter / setter """
        if value is not None:
            self.metrics[Metrics.METRIC_INDEX[name]] = value
            return value
        else:
            return self.metrics[Metrics.METRIC_INDEX[name]]

    def to_dict(self):
        """ Turn into dictionary for JSON serialisation """
        result = {}
        for i, m in enumerate(Metrics.METRIC_NAMES):
            if math.isnan(self.metrics[i]):
                result[m] = "nan"
            else:
                result[m] = self.metrics[i]
        return result


class MetricSet:
    """ Set of metrics that belong together with a ROC and an aggregate result """
    def __init__(self,
                 method,
                 cmethod,
                 vartype,
                 subtype,
                 genotype,
                 varfilter,
                 subset,
                 qq_field
                 ):
        self.method = method
        self.comparisonmethod = cmethod
        self.type = vartype
        self.subtype = subtype
        self.genotype = genotype
        self.filter = varfilter
        self.subset = subset
        self.qq_field = qq_field
        self.roc = []
        self.aggregate = None

    def clip_roc(self, metrics, diff, max_data_points=1000, minmax=None):
        """ Clip ROC to reduce the number of data points

        (we embed into HTML, so keeping all points can be somewhat prohibitive)

        :param metrics: which metrics to do diffs on
        :type metrics: list of str
        :param diff: minimum difference
        :type diff: float
        :param max_data_points: maximum number of data points to return
        :type max_data_points: int
        :param minmax: dictionary giving min and max values for metrics: e.g. { "METRIC.Recall": { "min": 0.2 } }
        :type minmax: dict
        :rtype: list of Metrics
        """
        roc = self.roc
        if len(roc) == 0:
            return roc

        sorted_roc = sorted(roc, key=lambda point: point.metric("QQ"))
        last = sorted_roc[0]
        croc = [last]
        for i, x in enumerate(sorted_roc[1:]):
            if len(croc) > max_data_points:
                break

            # ignore metrics outside of range
            ignore = False
            for m in metrics:
                met = x.metric(m)
                if minmax is not None and m in minmax:
                    if "min" in minmax[m] and met < minmax[m]["min"]:
                        ignore = True
                        break
                    if "max" in minmax[m] and met > minmax[m]["max"]:
                        ignore = True
                        break
            if ignore:
                continue

            abs_diff = 0.0
            for m in metrics:
                abs_diff = max(abs_diff, abs(last.metric(m) - x.metric(m)))
            if abs_diff > diff:
                last = x
                croc.append(x)

        self.roc = croc
        return croc

    def to_dict(self):
        """ Convert to dictionary for JSON conversion """
        # remove intermediate steps
        result = {
            "method": self.method,
            "comparisonmethod": self.comparisonmethod,
            "type": self.type,
            "subtype": self.subtype,
            "genotype": self.genotype,
            "filter": self.filter,
            "subset": self.subset,
            "qq_field": self.qq_field,
            "roc": [r.to_dict() for r in self.roc],
        }
        result.update(self.aggregate.to_dict())
        return result


def read_qfy_csv(files,
                 method=None,
                 cmethod=None,
                 roc_metrics=None,
                 roc_diff=0.001,
                 max_data_points=1000,
                 minmax=None):
    """ Read a metrics CSV file from hap.py / quantify
    :param files: list of file names to read
    :type files: list of str
    :param method: method that was used to produce the result
    :type method: str
    :param cmethod: comparison method that was used
    :type cmethod: str
    :param roc_metrics: which metrics to do diffs on
    :type roc_metrics: list of str
    :param roc_diff: minimum difference
    :type roc_diff: float
    :param max_data_points: maximum number of data points to return
    :type max_data_points: int
    :param minmax: dictionary giving min and max values for metrics: e.g. {"METRIC.Recall": { "min": 0.2 }}
    :type minmax: dict
    :return: a list of Metrics objects
    :rtype: list of MetricSet
    """
    results = {}

    if not roc_metrics:
        roc_metrics = ["METRIC.Recall", "METRIC.Precision"]

    for csv_file_name in files:
        if csv_file_name.endswith(".gz"):
            csvfile = gzip.open(csv_file_name, "rb")
        else:
            csvfile = open(csv_file_name, 'rb')
        try:
            dialect = csv.Sniffer().sniff(csvfile.read(8192))
            csvfile.seek(0)
            dr = csv.DictReader(csvfile, dialect=dialect)
        except:
            dr = csv.DictReader(csvfile, dialect="excel")
        # remove extension
        if not method:
            tmethod = os.path.basename(csv_file_name)
            tmethod = tmethod.replace(".gz", "")
            tmethod = tmethod.replace(".csv", "")
            tmethod = tmethod.replace(".extended.csv", "")
            tmethod = tmethod.replace(".roc.Locations", "")
        else:
            tmethod = method
        key_list = ["Type", "Subtype", "Genotype", "Filter", "Subset", "QQ.Field"]
        for line in dr:
            try:
                key = ":".join(map(str, [cmethod, tmethod]) + [line[k] for k in key_list])
            except:
                raise Exception("Misformatted input file: %s" % csv_file_name)
            if key not in results:
                results[key] = MetricSet(tmethod,
                                         cmethod,
                                         line["Type"],
                                         line["Subtype"],
                                         line["Genotype"],
                                         line["Filter"],
                                         line["Subset"],
                                         line["QQ.Field"])

            mvalues = {n: line[n] for n in Metrics.METRIC_NAMES}
            mobj = Metrics(**mvalues)

            if line["QQ"] == "*":
                if results[key].aggregate is not None:
                    raise Exception("Duplicate aggregate result for %s / %s" % (cmethod, key))
                results[key].aggregate = mobj
            else:
                results[key].roc.append(mobj)

    for key, v in results.iteritems():
        if not v.aggregate:
            raise Exception("Missing aggregate result for %s / %s" % (cmethod, key))
        v.clip_roc(roc_metrics, roc_diff, max_data_points, minmax)

    return [results[k] for k in sorted(results.keys())]
