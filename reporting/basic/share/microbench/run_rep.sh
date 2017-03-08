#!/usr/bin/env bash
#
# test for reporting tool.
#
# run run_happy.sh first to regenerate the required outputs
#

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

python ${DIR}/../../bin/rep.py -o ${DIR}/test_single.html ${DIR}/hap.py-results/gatk3.roc.all.csv.gz

rc=$?
if [[ ${rc} != 0 ]]; then
    echo "rep.py failed with exit code $rc"
    exit ${rc}
fi

python ${DIR}/../../bin/rep.py gatk-3_hap.py:${DIR}/hap.py-results/gatk3.roc.all.csv.gz \
                               platypus_hap.py:${DIR}/hap.py-results/platypus.roc.all.csv.gz \
                               freebayes_hap.py:${DIR}/hap.py-results/freebayes.roc.all.csv.gz \
                               -o ${DIR}/test_multiple.html

rc=$?
if [[ ${rc} != 0 ]]; then
    echo "rep.py failed with exit code $rc"
    exit ${rc}
fi

