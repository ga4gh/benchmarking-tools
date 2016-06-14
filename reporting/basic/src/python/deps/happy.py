#!/usr/bin/env python
# coding=utf-8
#
# Run hap.py and run reporter on a list of VCF files
#
# Author:
#
# Peter Krusche <pkrusche@illumina.com>
#

from . import DEPS

import subprocess
import tempfile
import glob
import shutil
import os
import logging


def happy(query,
          truth,
          truth_conf,
          ref="hg19",
          roc_feature="QUAL",
          roc_filters=None,
          engine="xcmp",
          extra=None,
          output_prefix=None,
          output_folder=None):
    """
    Run Hap.py
    :param query: query VCF path
    :param truth: Truth VCF path
    :param truth_conf: Truth confident region bed path
    :param ref: reference pointer, resolved via DEPS
    :param roc_feature: feature to calculate ROC for
    :param roc_filters: filters to remove for ROC calculation
    :param engine: "xcmp" or "vcfeval"
    :param extra: extra arguments for hap.py
    :param output_prefix: use fixed prefix instead of temp file
    :param output_folder: folder for the hap.py results
    :return:
    """
    args = [DEPS["hap.py"],
            truth, query]

    if truth_conf:
        args += ["-f", truth_conf]

    try:
        refpath = DEPS[ref]
    except:
        refpath = os.path.abspath(ref)
    args += ["-r", refpath]

    if roc_feature:
        args += ["--roc", roc_feature]

    sdf_temp = tempfile.NamedTemporaryFile()
    run_pass_all = False
    if engine == "xcmp":
        run_pass_all = False
    elif engine == "vcfeval":
        run_pass_all = True
        try:
            sdfpath = DEPS[ref + ".sdf"]
        except:
            # SDF doesn't exist, create
            sdfpath = sdf_temp + ".sdf"
            rtg_args = [DEPS["rtgtools"],
                        "format", "-o", sdfpath]
            logging.debug("Running: %s" % " ".join(rtg_args))
            subprocess.check_call(rtg_args, shell=False)

        args += ["--engine", "vcfeval",
                 "--engine-vcfeval-path", DEPS["rtgtools"],
                 "--engine-vcfeval-template", sdfpath]

    try:
        if extra and type(extra) is list:
            args += extra
        elif extra:
            args += (str(extra).lstrip().split(" "))

        results = []

        output_flag = tempfile.NamedTemporaryFile(prefix=output_prefix, dir=output_folder)
        all_args = args + ["-o", output_flag.name]
        logging.debug("Running: %s" % " ".join(map(str, all_args)))
        subprocess.check_call(all_args, shell=False)
        results += glob.glob(output_flag.name + ".*")
        output_flag.close()

        if run_pass_all:
            output_flag = tempfile.NamedTemporaryFile(prefix=output_prefix, dir=output_folder)
            all_args = args + ["-o", output_flag.name,
                               "--pass-only"]
            if roc_filters:
                all_args += ["--roc-filter", roc_filters]

            logging.debug("Running: %s" % " ".join(map(str, all_args)))
            subprocess.check_call(all_args, shell=False)
            results += glob.glob(output_flag.name + ".*")
            output_flag.close()
    finally:
        # remove temporary SDF
        if os.path.isdir(sdf_temp.name + ".sdf"):
            shutil.rmtree(sdf_temp.name + ".sdf")
    return results
