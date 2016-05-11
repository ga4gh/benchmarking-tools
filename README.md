# GA4GH Reporting

This is a set of scripts to produce variant benchmarking reports.

# Input / Output

## Input

* one or more diploid test VCF files
* Genome in a Bottle or Platinum Genomes truth files

## Output

* a HTML report.

# Basic Usage

There are two scripts in the [bin] folder:

* **run.py** : run hap.py and produce a report 

```bash
python run.py -o test.html test.vcf.gz
```

* **rep.py** : report from hap.py results 

```bash
python run.py -o test.html result.extended.csv
```

See also [share/microbench](share/microbench) for a demo.

# Dependencies

* hap.py v0.3.0+ -- [https://github.com/Illumina/hap.py/tree/dev-0.3](https://github.com/Illumina/hap.py/tree/dev-0.3)
* [optional] rtgtools vcfeval in the GA4GH version: [https://github.com/RealTimeGenomics/rtg-tools/tree/ga4gh-test](https://github.com/RealTimeGenomics/rtg-tools/tree/ga4gh-test)
* A truth set, e.g. Platinum Genomes or Genome in a Bottle
* Python packages in [requirements.txt]:
    - flask
    - jinja2