# Platinum Genomes

# Summary

The Platinum Genomes gold standard data provides a set of high-confidence variant calls for NA12877 and NA12878
by taking into account the inheritance constraints in the pedigree and the concordance of variant calls across
different methods.

This manuscript on bioRxiv gives more details about the methods: [http://biorxiv.org/content/early/2016/08/02/055541](http://biorxiv.org/content/early/2016/08/02/055541).
Please cite this manuscript in publications and other public usage of Platinum Genomes.

If you have any questions, please contact [platinumgenomes@illumina.com](mailto:platinumgenomes@illumina.com).
Please note that while Platinum Genomes are freely available, Illumina does not offer technical support for these resources.

# High-confidence VCF and BED Download

The latest VCF and BED files with the high-confidence calls and regions can be obtained as follows:

* From the Illumina FTP site: [ftp://ussd-ftp.illumina.com/2016-1.0/](ftp://ussd-ftp.illumina.com/2016-1.0/)

  If this link doesn't work in your browser try to directly ftp to ussd-ftp.illumina.com, with username=platgene_ro and empty password.

* From the Platinum Genomes project in BaseSpace Sequence Hub: [https://basespace.illumina.com/s/Tty7T2ppH3Tr](https://basespace.illumina.com/s/Tty7T2ppH3Tr)

# Benchmarking Recipe

Using [hap.py](http://github.com/Illumina/hap.py), a query VCF file for hg38 can be compared to this gold standard dataset as follows:

```bash
wget ftp://platgene_ro@ussd-ftp.illumina.com/2016-1.0/hg38/small_variants/NA12878/NA12878.vcf.gz
wget ftp://platgene_ro@ussd-ftp.illumina.com/2016-1.0/hg38/small_variants/NA12878/NA12878.vcf.gz.tbi
wget ftp://platgene_ro@ussd-ftp.illumina.com/2016-1.0/hg38/small_variants/ConfidentRegions.bed.gz

hap.py NA12878.vcf.gz query.vcf.gz -f ConfidentRegions.bed.gz -o benchmarking-output
```

# Raw Data

Raw data from these sequencing runs are available at the European Nucleotide Archive under the following accession numbers:

* PCR-free pedigree (@50x): [ERP001960](http://www.ebi.ac.uk/ena/data/view/ERP001960)
* PCR-free Trio and one technical replicate (@200x): [ERP001775](http://www.ebi.ac.uk/ena/data/view/ERP001775)

The raw data are also available from the Platinum Genomes project in [BaseSpace Sequence Hub](https://basespace.illumina.com/s/Tty7T2ppH3Tr).
For the FASTQ files, please navigate to the "Samples" section.


