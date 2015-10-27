Output Files
============

## Summary

The output files contain metrics like precision, recall and TP/FP/FN
counts for all variants. Also, we a VCF file giving the assessment for
each variant call.

## Output Table format

Output tables are in CSV format.

|                        | Metric 1         | Metric 2          | ... |
| :--------------------- | :--------------: |:-----------------:|:---:|
| Location/count type 1  |  &lt; value &gt; |  &lt; value &gt;  | ... |
| Location/count type 2  |  &lt; value &gt; |  &lt; value &gt;  | ... |
| ...                    |  &lt; value &gt; |  &lt; value &gt;  | ... |

Here is an example from hap.py:

|                        | METRIC.Recall    | METRIC.Precision  | ... |
| :--------------------- | :--------------: |:-----------------:|:---:|
| Locations.SNP          |  0.97            |  0.99             | ... |
| Locations.INDEL        |  0.8             |  0.95             | ... |
| ...                    |  ...             | ...               | ... |


## Output VCF Files

The output VCF file is similar to the [intermediate VCF file](intermediate.md). 
We add one additional variant classification: in
addition to `FP`/`FN`/`TP`, each variant call can also be assigned the status
`UNK` for unknown / outside the regions which the truthset covers.

A simple definition for `UNK` variants is as follows: We call any variant
unknown if it `BT` == `FP` and `BK` == `miss` and if the variant is outside
the confident call regions of the truth set. If the truthset does not give
confident call regions, no `UNK` variants are output.

We introduce the following additional fields:

```
##INFO=<ID=Regions,Number=.,Type=String,Description="Tags for confident / stratification regions.">
##FORMAT=<ID=BVT,Number=1,Type=String,Description="High-level variant type in truth/query (SNP|INDEL|COMPLEX).">
##FORMAT=<ID=BLT,Number=1,Type=String,Description="High-level location type in truth/query (het|hom|hetalt|halfcall|multiallelic|nocall).">
```

Optional: variant types seen and counted for this record.

```
##INFO=<ID=VTC,Number=.,Type=String,Description="Variant types used for counting.">
```
