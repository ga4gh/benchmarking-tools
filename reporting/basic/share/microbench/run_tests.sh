#!/usr/bin/env bash
# 
# run all tests / demos
 
DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

mkdir -p ${DIR}/output

cd ${DIR}/output

# run reporter
sh ${DIR}/run_rep.sh

if [ $? -ne 0 ]; then
    echo "Reporting test failed!"
    exit 1
fi

# run multi-reporter
sh ${DIR}/run_microbench.sh

if [ $? -ne 0 ]; then
    echo "Run hap.py + reporting test failed!"
    exit 1
fi