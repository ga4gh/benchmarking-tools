set -e

SAFE_LABEL_1=$(echo "${method_1}" | sed -e 's/[^A-Za-z0-9\.,]/-/g')
SAFE_LABEL_M1=$(echo "${comparison_method_1}" | sed -e 's/[^A-Za-z0-9\.,]/-/g')
SAFE_LABEL_2=$(echo "${method_2}" | sed -e 's/[^A-Za-z0-9\.,]/-/g')
SAFE_LABEL_M2=$(echo "${comparison_method_2}" | sed -e 's/[^A-Za-z0-9\.,]/-/g')

mkdir -p results_1
cd results_1
tar xzvf ${result_1_path}
cd ..

mkdir -p results_2
cd results_2
tar xzvf ${result_2_path}
cd ..

REPPY_INPUTS=""

# GA4GH v25 app outputs might contain two results each
for f in results_1/results/result_1.roc.all.csv.gz  results_1/results/result_2.roc.all.csv.gz ; do
    if [[ -f $f ]]; then
        REPPY_INPUTS="${REPPY_INPUTS} ${SAFE_LABEL_1}_${SAFE_LABEL_M1}:$f"
    fi
done

for f in results_2/results/result_1.roc.all.csv.gz  results_2/results/result_2.roc.all.csv.gz ; do
    if [[ -f $f ]]; then
        REPPY_INPUTS="${REPPY_INPUTS} ${SAFE_LABEL_2}_${SAFE_LABEL_M2}:$f"
    fi
done

REPPY="python /opt/ga4gh-reporting/bin/rep.py $REPPY_INPUTS -o comparison.html"
echo "$REPPY"
$REPPY

emit report_html comparison.html
