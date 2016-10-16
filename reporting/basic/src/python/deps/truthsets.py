#!/usr/bin/env python
# coding=utf-8
#
# Store truthset information
#
# Author:
#
# Peter Krusche <pkrusche@illumina.com>
#

import os

from . import find


class Truthset:
    def __init__(self, name, truth_vcf, truth_bed):
        self.name = name
        if type(truth_vcf) is not list:
            truth_vcf = [truth_vcf]
        if type(truth_bed) is not list:
            truth_bed = [truth_bed]

        self.vcf = None
        for f in truth_vcf:
            if os.path.exists(f):
                self.vcf = f
        if not self.vcf:
            raise Exception("Truth VCF not found for %s in %s" % (name, str(truth_vcf)))
        self.bed = None
        for f in truth_bed:
            if os.path.exists(f):
                self.bed = f
        if not self.bed:
            raise Exception("Truth BED not found for %s in %s" % (name, str(truth_bed)))

