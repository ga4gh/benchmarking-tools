Inputs
======

## Truth data

Truth datasets may consist of the following parts:

* a VCF file that provides variant calls
* a BED file to give confident regions. Typically, false-positive calls will
  be counted only in a subset of these regions.

The format of these files can vary depending on the benchmark type, e.g. for
diploid genotype comparisons, we require the `GT` format field to be present.

## Query data

The query data consists of a single (g)VCF file.

