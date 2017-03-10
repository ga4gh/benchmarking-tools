# GA4GH Benchmarking App

This is a proposal for an app to implement a benchmarking workflow based on the recommendations by the
GA4GH benchmarking group.

A more detailed description of this work is available at [https://github.com/ga4gh/benchmarking-tools]()

# Input / Output

## Input

* Hap.py / quantify outputs from a comparison with vcfeval or hap.py
* Genome in a Bottle or Platinum Genomes truth files

## Output

* a HTML report.

# Basic Usage

* **rep.py** : make a report from hap.py results

```bash
python rep.py -o test.html method_comparison:result.roc.all.csv.gz
```

See also [share/microbench](share/microbench) for a demo.

# Dependencies

* hap.py v0.3.7+ -- [https://github.com/Illumina/hap.py/tree/dev-0.3](https://github.com/Illumina/hap.py/tree/dev-0.3)
* rtgtools vcfeval in the GA4GH version: [https://github.com/RealTimeGenomics/rtg-tools/tree/ga4gh-test](https://github.com/RealTimeGenomics/rtg-tools/tree/ga4gh-test)
  hap.py should me compiled with vcfeval support, which downloads the correct version automatically
* A truth set, e.g. Platinum Genomes or Genome in a Bottle
* Python packages in [requirements.txt]:
    - jinja2
* Included Javascript/CSS packages:
    - D3.js (BSD 3-clause license, see [src/html/lib/d3/LICENSE]() and [https://github.com/mbostock/d3]())
    - bijou CSS styles (MIT license, see [src/html/lib/bijou/LICENSE]() and [https://github.com/andhart/bijou]())
