#!/usr/bin/env bash
#
# small three-VCF benchmark to test reporting
#
# Note: qsub somewhere that can run hap.py

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

rm -rf ${DIR}/output/microbench
mkdir -p ${DIR}/output/microbench

python ${DIR}/../../bin/run.py -o test.html \
    ${DIR}/input/NA12878-GATK3-chr21.vcf.gz \
    ${DIR}/input/NA12878-Platypus-chr21.vcf.gz \
    ${DIR}/input/NA12878-Freebayes-chr21.vcf.gz \
    -r ${DIR}/input/hg38.chr21.fa \
    --happy-extra ' -l chr21' \
    --custom-truthset NA12878-PG-2.0.1-hg38:${DIR}/input/PG_NA12878_hg38-chr21.vcf.gz:${DIR}/input/PG_Conf_hg38-chr21.bed.gz \
    -t NA12878-PG-2.0.1-hg38 \
    -O ${DIR}/output/microbench

exit $?