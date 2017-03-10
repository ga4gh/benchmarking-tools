#!/usr/bin/env bash
# Run hap.py on our test inputs.
# This assumes that hap.py is installed in /opt/hap.py and RTGtools in
# /opt/rtg (same as in the precisionFDA assets)

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

HAPPY=${HAPPY:-/opt/hap.py/bin/hap.py}
RTGTOOLS=${RTGTOOLS:-/opt/rtg/rtg}

export HGREF=${DIR}/input/hg38.chr21.fa

${HAPPY} ${DIR}/input/PG_NA12878_hg38-chr21.vcf.gz \
         ${DIR}/input/NA12878-GATK3-chr21.vcf.gz \
         -f ${DIR}/input/PG_Conf_hg38-chr21.bed.gz \
         --engine=vcfeval --engine-vcfeval-path=${RTGTOOLS} \
         -o ${DIR}/hap.py-results/gatk3 \
         --no-decompose --no-leftshift

${HAPPY} ${DIR}/input/PG_NA12878_hg38-chr21.vcf.gz \
         ${DIR}/input/NA12878-Platypus-chr21.vcf.gz \
         -f ${DIR}/input/PG_Conf_hg38-chr21.bed.gz \
         --engine=vcfeval --engine-vcfeval-path=${RTGTOOLS} \
         -o ${DIR}/hap.py-results/platypus \
         --no-decompose --no-leftshift

${HAPPY} ${DIR}/input/PG_NA12878_hg38-chr21.vcf.gz \
         ${DIR}/input/NA12878-Freebayes-chr21.vcf.gz \
         -f ${DIR}/input/PG_Conf_hg38-chr21.bed.gz \
         --engine=vcfeval --engine-vcfeval-path=${RTGTOOLS} \
         -o ${DIR}/hap.py-results/freebayes \
         --no-decompose --no-leftshift
