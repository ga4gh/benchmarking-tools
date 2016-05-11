# reference is set in run.py, this is only here to avoid an error message
export HGREF=/work/hg19.fa

mkdir results

set -e

COMMON_CMD="/opt/ga4gh-reporting/bin/run.py -o output.html -O results -t NA12878-PG-9.0.0-hg19,NA12878-GiaB-2.19-hg19 --roc-resolution 0.0025"

HXX=""

QUERIES=$query_vcf_path


if [[ "$query_2_vcf" != "" ]]; then
  QUERIES="${QUERIES} $query_2_vcf_path"
fi

if $use_partial_credit; then
  echo "using partial credit via variant decomposition"
else
  echo "no partial credit / variant decomposition is used"
  HXX=" --no-internal-leftshift --no-internal-preprocessing"
fi

# use VCFeval. TODO: implement partial credit with vcfeval
if $use_vcfeval; then
  echo "Using vcfeval for comparison"
  COMMON_CMD="${COMMON_CMD} -e vcfeval"
fi

if [[ "$target_bed" != "" ]]; then
  python ${COMMON_CMD} --happy-extra " -T ${target_bed_path}${HXX}" ${QUERIES}
else
  python ${COMMON_CMD} ${QUERIES}
fi

# zip detauiled results
tar czf output.tar.gz results

emit report_html output.html
emit detailed_results output.tar.gz