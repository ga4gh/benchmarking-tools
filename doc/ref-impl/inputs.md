Inputs
======

## Truth data

Truth datasets may consist of the following parts:

* a VCF file that provides variant calls
* a BED file to give confident regions. Typically, false-positive calls will
  be counted only in a subset of these regions.

The format of these files can vary depending on the benchmark type, e.g. for
diploid genotype comparisons, we require the `GT` format field to be present.

Note that "Confident Call Regions" from Truth and/or Query are applied only
after the VCF comparison to enable better comparison of variants that can
have different representations putting them either inside or outside the
confident call regions.  In contrast, if only variants inside the confident
call regions are included during the VCF comparison, then some TP calls are
incorrectly classified as FPs and/or FNs.

## Query data

The query data consists of a single (g)VCF file.
