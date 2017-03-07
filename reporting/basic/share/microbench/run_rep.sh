#!/usr/bin/env bash
#
# test for reporting tool
#

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

python ${DIR}/../../bin/rep.py -o ${DIR}/test_single.html hap.py-results/gatk3.roc.all.csv.gz

exit $?
