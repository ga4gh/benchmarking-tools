# GA4GH Benchmarking App 

Author: Peter Krusche <pkrusche@illumina.com>

This is a proposal for an app to implement a benchmarking workflow based on the recommendations by the
GA4GH benchmarking group.

A more detailed description of this work is available at [https://github.com/ga4gh/benchmarking-tools]()

# What it does

This app compares input VCFs to truth datasets using the hg19, hs37d5 or hg38 references
(comparison is carried out on chr1-chr22 and chrX only, but can be restricted to target regions).

# Which reference to use

* The genome reference **must** match the reference that was used to create the inputs and truthsets. 
* For GIAB GRCh**37** truthsets, you should use hs37d5 as a reference.
* For Platinum Genomes hg19 truthsets, you should use hg19 as a reference.
* GRCh**37** / hs37d5 query files will work with the hg19 reference and PG truthsets (hap.py will add chr prefixes wherever necessary), but hg19 query files will not work with GRCh37 truthsets
* for GRCh38 / hg38, use the hg38 reference

# Advanced options

*  **Use vcfeval or xcmp**: it is possible to switch the comparison engine between xcmp (the hap.py comparison engine)
   to rtgtools vcfeval. Vcfeval will ignore all phasing constraints but has a more granular matching algorithm than
   xcmp.
*  **Use partial credit**: different variant callers might output the same variants in different
   representations. One example are MNPs -- it is possible to write these as three SNPs or as a single
   MNP record. The partial credit attempts to normalize these representational differences before
   variant comparison, such that the counts of TPs / FPs / FNs will be more comparable. This option is off by default
   since it requires more compute.
* **use GA4GH stratification regions**: select a set of stratification regions to use. **WARNING**: using "all" GA4GH stratification
  regions will take a long time and produce a result that might be difficult to interpret. Use with caution.
* **Adjust confident regions**: when using partial credit preprocessing, variants might move outside the confident regions.
  When this option is enabled, all truth variants will be included in the confident set. Note however that GiaB truthsets
  may contain additional variants which are not confident, these should be filtered out using bcftools before using this
  option.