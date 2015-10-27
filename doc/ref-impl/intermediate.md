Intermediate Files
==================

## Intermediate VCF Files

The intermediate VCF file is produced by a comparison engine (like
xcmp / vcfeval / xcmp in hap.py).

A comparison engine should

*  assess for each call in the truth and in the query whether this call is
   considered a match or mismatch
*  output corresponding labels:
   - True Positive / `TP`: present in both truth and query
   - False Positive / `FP`: present only in the query
   - False Negative / `FN`: present only in the truth
*  (optionally) output additional information about each decision

Note that we would output the FP/TP/FN labels separately for truth and
for query variants. For simple comparison types which do not attempt to
reconcile different variant representations, the assigned type for truth
and query might be the same. However, more sophisticated methods (e.g.
vcfeval) will be able to type truth and query variants separately.

A comparison engine should also preserve input INFO / FORMAT annotations to the
largest degree possible (depending on the variant processing it does).

## Required VCF Annotations

The intermediate VCF must have two columns named TRUTH and QUERY, with
these FORMAT annotations:

```
##FORMAT=<ID=BD,Number=1,Type=String,Description="Decision for call (TP/FP/FN/N)">
##FORMAT=<ID=BK,Number=1,Type=String,Description="Sub-type for decision (match/mismatch type)">
```

Currently, we distinguish the following subtypes:

| BK (rows) / BD (cols) | TP                                           | FP / FN             |
|:----------------------|:--------------------------------------------:|:-------------------:|
| m            | direct match                                 | (invalid)           |
| cm           | complex match (together with other variants) | (invalid)           |
| pm           | (invalid)                                    | complex mismatch    |
| gtmm         | (invalid)                                    | Genotypes mismatch  |
| almm         | (invalid)                                    | Alleles mismatch    |
| miss         | (invalid)                                    | Variant not present |

## Additional VCF Annotations

We allow for comparison engines to transform the input variants for more
granular accounting / comparison. To facilitate ROC creation based on such
a processed variant file, we define the following FORMAT annotations to
pass on additional information.

Optionally, these can be passed for ROC creation / further processing:

```
##FORMAT=<ID=BT,Number=1,Type=String,Description="Type of comparison performed">
##FORMAT=<ID=QQ,Number=1,Type=Float,Description="Variant quality for ROC creation.">
```

Another feature that is common to our comparison engines is the idea of
separating out regions in which variants might interact due to different
representation. In order to group variants into such blocks, we introduce
the following INFO annotation that allows us to assign a superlocus ID to
each variant record.

```
##INFO=<ID=SUPERLOCUS_ID,Number=1,Type=Integer,Description="Superlocus ID for these variants.">
```

In downstream tools, this may e.g. be used to count with superlocus
granularity.  
