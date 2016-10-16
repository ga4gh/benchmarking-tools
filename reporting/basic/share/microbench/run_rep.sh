#!/usr/bin/env bash
#
# test for reporting tool
#

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

python ${DIR}/../../bin/rep.py -o ${DIR}/output/test_single.html -l ${DIR}/results/test.tsv

exit $?
