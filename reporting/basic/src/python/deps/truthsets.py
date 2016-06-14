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

TRUTHSETS = {}


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


TRUTHSETS["NA12878-PG-8.0.1-hg19"] = Truthset("NA12878-PG-8.0.1-hg19",
                                              find("PG_NA12878_VCF",
                                                   env_var="PG_NA12878_VCF",
                                                   to_try=["/work/pg-8.0.1/NA12878.vcf.gz",
                                                           "/illumina/development/PlatinumGenomes/hg19/8.0.1/"
                                                           "NA12878/NA12878.vcf.gz"],
                                                   must_be_executable=False),
                                              find("PG_NA12878_BED",
                                                   env_var="PG_NA12878_BED",
                                                   to_try=["/work/pg-8.0.1/ConfidentRegions.bed.gz",
                                                           "/illumina/development/PlatinumGenomes/"
                                                           "hg19/8.0.1/NA12878/ConfidentRegions.bed.gz"],
                                                   must_be_executable=False))

TRUTHSETS["NA12878-GiaB-2.19-hg19"] = Truthset("NA12878-GiaB-2.19-hg19",
                                               find("GIAB_NA12878_VCF",
                                                    env_var="GIAB_NA12878_VCF",
                                                    to_try=["/work/giab/giab.2.19.chr.vcf.gz",
                                                            "/illumina/development/precise/prec-data/NIST-v2.19/"
                                                            "giab.2.19.chr.vcf.gz"],
                                                    must_be_executable=False),
                                               find("GIAB_NA12878_BED",
                                                    env_var="GIAB_NA12878_BED",
                                                    to_try=["/work/giab/confident.chr.bed.gz",
                                                            "/illumina/development/precise/prec-data/"
                                                            "NIST-v2.19/confident.chr.bed.gz"],
                                                    must_be_executable=False))

TRUTHSETS["NA12878-PG-9.0.0-hg19"] = Truthset("NA12878-PG-9.0.0-hg19",
                                              find("PG_NA12878_VCF",
                                                   env_var="PG_NA12878_VCF",
                                                   to_try=["/work/pg_9.0.0/NA12878.vcf.gz",
                                                           "/illumina/development/precise/prec-data/PG-7.1-KF/"
                                                           "platinum_NA12878_v7.1.0-kmer_filtered.vcf.gz"],
                                                   must_be_executable=False),
                                              find("PG_NA12878_BED",
                                                   env_var="PG_NA12878_BED",
                                                   to_try=["/work/pg_9.0.0/ConfidentRegions.bed.gz",
                                                           "/illumina/development/precise/prec-data/PG-7.1-KF"
                                                           "/platinum_all.chr.bed.gz"],
                                                   must_be_executable=False))
