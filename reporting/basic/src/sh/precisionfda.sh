set -e

export HGREF=/work/hg19.fa

# set up reference
if [[ ! -f /work/${reference}.fa  ]]; then
  echo "Invalid choice for the reference sequence: ${reference}"
  exit 1
fi

export HGREF="/work/${reference}.fa"
echo "using reference sequence ${HGREF}"

if [[ "${reference}" == "hg19" ]]; then
  fixchr=true
else
  fixchr=false
fi

mkdir -p results

HXX="-r ${HGREF} --verbose --gender ${sample_gender}"
COMPARISON_METHOD="${reference}"

if [[ "$truth_bed" != "" ]]; then
    HXX="${HXX} -f ${truth_bed_path}"
fi

if $fixchr; then
  echo "Adding chr prefix if necessary."
  HXX="${HXX} --fixchr"
fi

if $adjust_conf_regions; then
  HXX="${HXX} --adjust-conf-regions"
else
  HXX="${HXX} --no-adjust-conf-regions"
fi

if $use_partial_credit; then
  echo "using partial credit via variant decomposition"
  HXX="${HXX} --decompose --leftshift"
  COMPARISON_METHOD="${COMPARISON_METHOD}-partialcredit"
else
  echo "no partial credit / variant decomposition is used"
  HXX="${HXX} --no-decompose --no-leftshift"
  COMPARISON_METHOD="${COMPARISON_METHOD}-nopartialcredit"
fi

if $use_vcfeval; then
  echo "Using vcfeval for comparison"
  HXX="${HXX} --engine=vcfeval --engine-vcfeval-path=/opt/rtg/rtg"
  COMPARISON_METHOD="${COMPARISON_METHOD}-vcfeval"
else
  COMPARISON_METHOD="${COMPARISON_METHOD}-xcmp"
fi

if [[ "$target_bed" != "" ]]; then
  # make sure our query bed file also has chr prefixes
  if $fixchr; then
    zcat -f ${target_bed_path} | perl -pe 's/^([0-9XYM])/chr$1/' | perl -pe 's/chrMT/chrM/' > target.bed
  else
    cp -f ${target_bed_path} target.bed
  fi
  HXX="${HXX} -T target.bed"
  COMPARISON_METHOD="${COMPARISON_METHOD}-targeted"
fi

if  [[ "$use_stratification" != "none" ]]; then
    if [[ "$reference" != "hg19" ]] && [[ "$reference" != "hs37d5" ]]; then
        echo "Stratification regions are not supported on reference $reference"
        exit 1;
    fi
    strat="/opt/ga4gh-benchmarking-tools/resources/stratification-bed-files/ga4gh_${use_stratification}.tsv"
    if [[ -f "$strat" ]]; then
      HXX="${HXX} --stratification ${strat}"
      if $fixchr; then
          HXX="${HXX} --stratification-fixchr"
      fi
    else
       echo "Unknown stratification regions: ${use_stratification}"
       exit 1
    fi
fi

HAPPY="/opt/hap.py/bin/hap.py"
HAPPY_1="${HAPPY} ${truth_vcf_path} $query_vcf_path -o results/result_1 ${HXX}"
HAPPY_2="${HAPPY} ${truth_vcf_path} $query_2_vcf_path -o results/result_2 ${HXX}"

echo "$HAPPY_1"
$HAPPY_1 2>&1 | tee happy.log

SAFE_LABEL_1=$(echo "${query_method}" | sed -e 's/[^A-Za-z0-9\.,]/-/g')
SAFE_LABEL_M=$(echo "${COMPARISON_METHOD}" | sed -e 's/[^A-Za-z0-9\.,]/-/g')

REPPY_INPUTS="${SAFE_LABEL_1}_${SAFE_LABEL_M}:results/result_1.roc.all.csv.gz"
if [[ "$query_2_vcf" != "" ]]; then
  echo "$HAPPY_2"
  $HAPPY_2 2>&1 | tee happy.log

  SAFE_LABEL_2=$(echo "${query_2_method}" | sed -e 's/[^A-Za-z0-9\.,]/-/g')
  REPPY_INPUTS="${REPPY_INPUTS} ${SAFE_LABEL_2}_${SAFE_LABEL_M}:results/result_2.roc.all.csv.gz"
fi

REPPY="python /opt/ga4gh-reporting/bin/rep.py $REPPY_INPUTS -o output.html"
echo "$REPPY"
$REPPY

# zip detauiled results
tar czf output.tar.gz results

emit report_html output.html
emit happy_log happy.log
emit detailed_results output.tar.gz
