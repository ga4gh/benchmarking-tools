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
   - Not-assessed / `N`: call was not assigned a match status
*  (optionally) output additional information about each decision

Note that we would output the FP/TP/FN/N labels separately for truth and
for query variants. For simple comparison types which do not attempt to
reconcile different variant representations, the assigned type for truth
and query might be the same. However, more sophisticated methods (e.g.
vcfeval) will be able to type truth and query variants separately.

The N label may be applied for a variety of reasons, which may be
specific to the comparison engine. For example, a comparison engine
might not assess input calls which had non-PASS FILTER fields, or may
choose to ignore half-calls. Alternatively an engine may find that some
call regions are too complex to confidently assess. Additional
information may be included in the BI annotation.

A comparison engine should also preserve input INFO / FORMAT annotations to the
largest degree possible (depending on the variant processing it does).

## Required VCF Annotations

The intermediate VCF must have two columns named TRUTH and QUERY, with
these FORMAT annotations:

```
##FORMAT=<ID=BK,Number=1,Type=String,Description="Sub-type for decision (match/mismatch type)">
```

The value of BK specifies the class of match for each variant record:

1. `.`: *missing* = no match at any level tested by the comparison tool
2. `lm`: *loose match* = the truth/query variant is nearby a variant in the
   query/truth -- if the tool outputs such match types, it should annotate
   the VCF header with the definition of loose matches (e.g. match within a
   fixed window, or within the same superlocus).
3. `am`: *almatch* = the variant forms (part of) an allele match (independent of
   representation, i.e. one-sided haplotype match)
4. `gm`: *gtmatch* = diploid haplotypes (and genotypes) were resolved to be the same
   (independent of representation)

Based on the values in BK, comparison tools must assign a decision for each
variant call that assigns true/false postive/negative status. This status is
output in the BD format field:

```
##FORMAT=<ID=BD,Number=1,Type=String,Description="Decision for call (TP/FP/FN/N)">
```

The mapping of combinations of BK values to BD may vary for different comparison
types. Here are examples corresponding to the
[three standard comparison methods](../standards/GA4GHBenchmarkingPerformanceMetricsDefinitions.md).

### Loose variant comparison

Find all variants in the query where another variant was seen nearby in the
truth.

|  **BK**  | **BD (Truth)** | **BD (Query)** |
|:--------:|:--------------:|:--------------:|
|    .     |       FN       |       FP       |
| lm/am/gm |       TP       |       TP       |

### Allele Comparison

Test allele-level concordance between truth and query.

| **BK** |     **BD (Truth)**     |     **BD (Query)**     |
|:------:|:----------------------:|:----------------------:|
|  ./lm  |           FN           |           FP           |
| am/gm  |           TP           |           TP           |

### Genotype Comparison

Test genotype concordance between truth and query.

| **BK** |     **BD (Truth)**     |     **BD (Query)**     |
|:------:|:----------------------:|:----------------------:|
|  ./lm  |           FN           |           FP           |
|   am   | FN (genotype mismatch) | FP (genotype mismatch) |
|   gm   |           TP           |           TP           |


## Additional VCF Annotations

Comparison engines may have engine-specific status information that is
useful to present in the output (for example, error status, specific
match sub-algorithm used, etc). This can be recorded in the optional
BI annotation:

```
##FORMAT=<ID=BI,Number=1,Type=String,Description="Additional match status information">
```

We allow for comparison engines to transform the input variants for more
granular accounting / comparison. To facilitate ROC creation based on such
a processed variant file, we define the following FORMAT annotation to
pass on a variant quality score obtained from the input variants:

```
##FORMAT=<ID=QQ,Number=1,Type=Float,Description="Variant quality for ROC creation.">
```

Since we aim to benchmark variant calls independently of their
representation, we also define *superloci*. A *superlocus* is a
set of variant calls that intends to fully describe the variation within
a contiguous reference
region that may contain complex variation with different representations.
In order to group variants into blocks by superlocus, we introduce
the following INFO annotation that allows us to assign a benchmarking
superlocus ID to each variant record.

```
##INFO=<ID=BS,Number=1,Type=Integer,Description="Benchmarking superlocus ID for these variants.">
```

In downstream tools, this may e.g. be used to count with superlocus
granularity.
