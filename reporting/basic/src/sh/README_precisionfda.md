# GA4GH Benchmarking App

Author: Peter Krusche <pkrusche@illumina.com>

This is a proposal for an app to implement a benchmarking workflow based on the recommendations by the
GA4GH benchmarking group.

A more detailed description of this work is available at [https://github.com/ga4gh/benchmarking-tools]()

# What it does

This app compares input VCFs to two truth datasets using the hg19 or the grch37 reference
(comparison is carried out on chr1-chr22 and chrX only).

Example truthsets we support are:

*  NIST Genome in a Bottle
*  Platinum Genomes

It is possible to supply a bed file of target regions to restrict the comparison to
variants only in that region.

