#!/usr/bin/env python
# coding=utf-8
#
# Dependency finder for hap.py, vcfeval, resources
#
# Author:
#
# Peter Krusche <pkrusche@illumina.com>
#

import os
import sys

# paths to dependency tools / config things
DEPS = {}


def _which(program, must_be_executable=True, is_dir=False):
    """ see if we can find an executable in PATH
    http://stackoverflow.com/questions/377017/test-if-executable-exists-in-python
    """

    def is_exe(fpath):
        if not must_be_executable:
            if is_dir:
                return os.path.isdir(fpath)
            else:
                return os.path.isfile(fpath)
        return os.path.isfile(fpath) and os.access(fpath, os.X_OK)

    fpath, fname = os.path.split(program)
    if fpath:
        if is_exe(program):
            return program
    elif not is_dir:
        for path in os.environ["PATH"].split(os.pathsep):
            path = path.strip('"')
            exe_file = os.path.join(path, program)
            if is_exe(exe_file):
                return exe_file

    return None


def find(name, env_var=None, to_try=None, default=None,
         must_be_executable=True,
         is_dir=False):
    """ Dependency finder
    :param name: name of dependency
    :param env_var: environment variable to look up from
    :param to_try: list of locations to try
    :param default: default value
    :param must_be_executable: set to False to not require that file is executable
    :return: path to the executable, raises Exception when not found and when default is None
    """
    location = None
    if to_try is not None:
        for t in to_try:
            location = _which(t, must_be_executable=must_be_executable, is_dir=is_dir)
            if location:
                break
    if env_var is not None:
        try:
            location = os.environ[env_var]
        except:
            pass
    if location is None:
        location = default

    if location is None:
        raise Exception("Dependency '%s' not found!" % name)

    print >> sys.stderr, "%s found at %s" % (name, location)

    return location


def setup():
    DEPS["hap.py"] = find("hap.py",
                          env_var="HAPPY",
                          to_try=["/opt/hap.py/bin",
                                  "/illumina/development/haplocompare/hc-dev-builds/haplocompare-v0.3.0/bin/hap.py"])
    DEPS["rtgtools"] = find("rtgtools",
                            env_var="RTGTOOLS",
                            to_try=["/opt/rtg-tools-3.6-dev-2365fac/rtg",
                                    "/illumina/thirdparty/rtgtools/rtg-tools-3.6-dev-2365fac/rtg"])
    DEPS["hg19"] = find("hg19",
                        env_var="HG19",
                        to_try=["/work/hg19.fa",
                                "/illumina/development/Isas/Genomes/Homo_sapiens/UCSC/hg19/Sequence/WholeGenomeFasta/genome.fa",
                                "~/workspace/human_genome/hg19.fa"],
                        must_be_executable=False)
    DEPS["hg19.sdf"] = find("hg19.sdf",
                            env_var="HG19_SDF",
                            to_try=["/work/hg19.sdf",
                                    "/illumina/thirdparty/rtgtools/hg19.sdf",
                                    "~/workspace/human_genome/hg19.sdf"],
                            must_be_executable=False,
                            is_dir=True)


setup()
