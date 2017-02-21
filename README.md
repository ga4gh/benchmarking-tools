# Benchmarking Tools and Standards

This is the repository for the work of the GA4GH Benchmarking Team, which is developing standardized definitions for genome variant calling performance metrics, as well as reference implementations of tools to calculate these performance metrics.  
We also provide links to our reference benchmarking engines and their implementations, as well as to benchmarking datasets.

** Note: This is work in progress. **

# Standards and Definitions

See [doc/standards/](doc/standards/) for the current
benchmarking standards and definitions.

# Reference tool implementations

A suite of reference implementations following the standards outlined above are available at [tools/](tools/). 
These are submodules which link to the original tool repositories.

# Benchmarking Intermediate Files

The benchmarking process contains a variety of steps and inputs. In
[doc/ref-impl/](doc/ref-impl/), we standardise intermediate
formats for specifying truth sets, stratification regions, and intermediate 
outputs from comparison tools.

# Benchmarking resources

In [resources/](resources/), we provide files useful in the benchmarking process.  Currently, this includes links to benchmarking calls and datasets as well as standardized bed files describing potentially difficult regions for performance stratification.
