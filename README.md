# Germline Small Variant Benchmarking Tools and Standards

This repository hosts the work of the Global Alliance for Genomics and Health (GA4GH) Benchmarking Team, which is developing standardized performance metrics and tools for benchmarking germline small variant calls.  This Team includes representatives from sequencing technology developers, government agencies, academic bioinformatics researchers, clinical laboratories, and commercial technology and bioinformatics developers.  We have worked towards solutions for several challenges faced when benchmarking variant calls, including (1) defining high-confidence variant calls and regions that can be used as a benchmark, (2) developing tools to compare variant calls robust to differing representations, (3) defining performance metrics like false positive and false negative with respect to different matching stringencies, and (4) developing methods to stratify performance by variant type and genome context.
We also provide links to our reference benchmarking engines and their implementations, as well as to benchmarking datasets.

A manuscript from the GA4GH Benchmarking Team describing best practices for benchmarking germline small variant calls is on bioRxiv, and we ask that you cite this publication in any work using these tools:
[https://doi.org/10.1101/270157](https://doi.org/10.1101/270157)

** Note: This site is still a work in progress. **

# Standards and Definitions

See [doc/standards/](doc/standards/) for the current
benchmarking standards and definitions.

# Reference tool implementations

The primary reference implementation of the GA4GH Benchmarking methods is [hap.py](https://github.com/Illumina/hap.py), which enables users to choose between vcfeval (recommended) and xcmp as the comparison engine, and use of GA4GH stratification bed files to assess performance in different genome contexts.  A web-based implementation of this tool is available in [GA4GH Benchmarking app](https://precision.fda.gov/apps/app-F5YXbp80PBYFP059656gYxXQ) from peter.krusche on precisionFDA.

Other reference implementations following the standards outlined above are available at [tools/](tools/).
These are submodules which link to the original tool repositories.

# Benchmarking Intermediate Files

The benchmarking process contains a variety of steps and inputs. In
[doc/ref-impl/](doc/ref-impl/), we standardise intermediate
formats for specifying truth sets, stratification regions, and intermediate 
outputs from comparison tools.

# Benchmarking resources

In [resources/](resources/), we provide files useful in the benchmarking process.  Currently, this includes links to benchmarking calls and datasets from [Genome in a Bottle](www.genomeinabottle.org) and [Illumina Platinum Genomes](https://www.illumina.com/platinumgenomes.html), as well as standardized bed files describing potentially difficult regions for performance stratification.
