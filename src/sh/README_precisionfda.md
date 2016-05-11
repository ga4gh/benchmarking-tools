# GA4GH Benchmarking App

Author: Peter Krusche <pkrusche@illumina.com>

This is a proposal for an app to implement a benchmarking workflow based on the recommendations by the
GA4GH benchmarking group.

A more detailed description of this work is available at [https://github.com/ga4gh/benchmarking-tools]()

# What it does

This app compares input VCFs to two truth datasets using the hg19 or the grch37 reference
(comparison is carried out on chr1-chr22 and chrX only):

*  NIST Genome in a Bottle 2.19 for NA12878
*  Platinum Genomes (Kmer-filtered / pre-release)

Currently, either one or two query VCF files may be passed to the app to compare precision
and recall on the truthsets shown above.

It is possible to supply a bed file of target regions to restrict the comparison to
variants only in that region.

# Advanced options

*  **Use vcfeval or xcmp**: it is possible to switch the comparison engine from the hap.py default engine
   to rtgtools vcfeval. See the TODO list below for some caveats.
*  **Use partial credit**: different variant callers might output the same variants in different
   representations. One example are MNPs -- it is possible to write these as three SNPs or as a single
   MNP record. The partial credit attempts to normalize these representational differences before
   variant comparison, such that the counts of TPs / FPs / FNs will be more comparable.

# TODO List

*  Improved integration of vcfeval: enable partial-credit counting with vcfeval and improve ROC
   postprocessing

*  Improved counting: Currently, we count individual VCF records. Due to differences
   in variant representation between variant callers, this can make counts difficult to
   compare. A way to improve this is to count on a "super-locus-level", i.e. to count
   close-by variants together as one.

*  More metrics / plots (AuC, ROC curves)
