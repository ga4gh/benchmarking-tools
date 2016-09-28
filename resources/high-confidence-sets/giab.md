# Genome in a Bottle

# Summary

The [Genome in a Bottle Consortium](http://www.genomeinabottle.org) has developed high-confidence variant calls for several genomes that are Reference Materials (RMs) from the National Institute of Standards and Technology (NIST).  Currently, these genomes are:

* HG001/NA12878 - available as [NIST RM 8398](http://www.tinyurl.com/giabpilot)
* HG002/NA24385/AJ Son - available as [NIST RM 8391](http://www.tinyurl.com/giabajson) and [NIST RM 8392](http://www.tinyurl.com/giabajtrio)
* HG003/NA24149/AJ Father - available as [NIST RM 8392](http://www.tinyurl.com/giabajtrio)
* HG004/NA24143/AJ Mother - available as [NIST RM 8392](http://www.tinyurl.com/giabajtrio)
* HG005/NA24631/Chinese Son - available as [NIST RM 8393](http://www.tinyurl.com/giabchineseson)

The high-confidence calls were formed by integrating data from multiple technologies. The vcf and bed files are intended to be used in conjunction to benchmark accuracy of small variant calls.  We strongly recommend reading the information below prior to using these calls to understand how best to use them and their limitations.  A manuscript will be prepared about these calls in the future.  Until then, please cite http://www.nature.com/nbt/journal/v32/n3/full/nbt.2835.html (doi:10.1038/nbt.2835) and http://www.nature.com/articles/sdata201625 (doi:10.1038/sdata.2016.25) when using these calls.

If you have any questions, please contact us at [http://jimb.stanford.edu/contact/](http://jimb.stanford.edu/contact/).

To help us improve future versions of calls, we encourage you to report sites in the high-confidence regions that appear to be questionable in the high-confidence calls at:
[https://goo.gl/forms/6MTIUx4vmYtYyz1t1](https://goo.gl/forms/6MTIUx4vmYtYyz1t1)

# High-confidence VCF and BED Download

The latest VCF and BED files with the high-confidence calls and regions can be obtained from the "latest" directory under each genome at the Genome in a Bottle FTP site: 

[ftp://ftp-trace.ncbi.nlm.nih.gov/giab/ftp/release](ftp://ftp-trace.ncbi.nlm.nih.gov/giab/ftp/release)

# Benchmarking Recipe

As an example for v3.3 high-confidence calls for HG001/NA12878, using [hap.py](http://github.com/Illumina/hap.py), a query VCF file for GRCh37 can be compared to these high-confidence calls and regions as follows:

```bash
wget ftp://ftp-trace.ncbi.nlm.nih.gov/giab/ftp/release/NA12878_HG001/NISTv3.3/NA12878_GIAB_highconf_CG-IllFB-IllGATKHC-Ion-Solid-10X_CHROM1-X_v3.3_highconf.vcf.gz
wget ftp://ftp-trace.ncbi.nlm.nih.gov/giab/ftp/release/NA12878_HG001/NISTv3.3/NA12878_GIAB_highconf_CG-IllFB-IllGATKHC-Ion-Solid-10X_CHROM1-X_v3.3_highconf.vcf.gz.tbi
wget ftp://ftp-trace.ncbi.nlm.nih.gov/giab/ftp/release/NA12878_HG001/NISTv3.3/NA12878_GIAB_highconf_CG-IllFB-IllGATKHC-Ion-Solid-10X_CHROM1-X_v3.3_highconf.bed

hap.py NA12878_GIAB_highconf_CG-IllFB-IllGATKHC-Ion-Solid-10X_CHROM1-X_v3.3_highconf.vcf.gz query.vcf.gz -f NA12878_GIAB_highconf_CG-IllFB-IllGATKHC-Ion-Solid-10X_CHROM1-X_v3.3_highconf.bed -o benchmarking-output
```

# Raw Data

Raw data sets and analyses are available from the GIAB ftp site under each genome at:
[ftp://ftp-trace.ncbi.nlm.nih.gov/giab/ftp/data](ftp://ftp-trace.ncbi.nlm.nih.gov/giab/ftp/data)

Many of these data sets are described in a Scientific Data publication from 2016:
[http://www.nature.com/articles/sdata201625](http://www.nature.com/articles/sdata201625)

Many of the raw data sets are also available in the NCBI SRA under BioProject [PRJNA200694](http://www.ncbi.nlm.nih.gov/bioproject/PRJNA200694).

# Important Usage Notes
Benchmarking variant calls is a complex process, and best practices are still being developed by the Global Alliance for Genomics and Health (GA4GH) Benchmarking Team (https://github.com/ga4gh/benchmarking-tools/).  Several things are important to consider when benchmarking variant call accuracy:
1. Complex variants (e.g., nearby SNPs and indels or block substitutions) can often be represented correctly in multiple ways in the vcf format.  Therefore, we recommend using sophisticated benchmarking tools like those developed by members of the GA4GH benchmarking team.  The latest version of hap.py (https://github.com/Illumina/hap.py) now allows the user to choose between hap.py's xcmp and RTG's vcfeval comparison tools, both of which perform sophisticated variant comparisons.  Preliminary tests indicate they perform very similarly, but vcfeval matches some additional variants where only part of a complex variant is called.
2. By their nature, high-confidence variant calls and regions tend to include a subset of variants and regions that are easier to detect.  Accuracy of variant calls outside the high-confidence regions is generally likely to be lower than inside the high-confidence regions, so benchmarking against high-confidence calls will usually overestimate accuracy for all variants in the genome.  Similarly, it is possible that a variant calling method has higher accuracy statistics compared to other methods when compared to the high-confidence variant calls but has lower accuracy compared to other methods for all variants in the genome.
3. Stratification of performance for different variant types and different genome contexts can be very useful when assessing performance, because performance often differs between variant types and genome contexts.  In addition, stratification can elucidate variant types and genome contexts that fall primarily outside high-confidence regions.  Standardized bed files for stratifying by genome context are available from GA4GH at https://github.com/ga4gh/benchmarking-tools/tree/master/resources/stratification-bed-files, and these can be added directly into the hap.py comparison framework. 
4. Particularly for targeted sequencing, it is critical to calculate confidence intervals around statistics like sensitivity because there may be very few examples of variants of some types in the benchmark calls in the targeted regions.
Manual curation of sequence data in a genome browser for a subset of false positives and false negatives is essential for an accurate understanding of statistics like sensitivity and precision.  Curation can often help elucidate whether the benchmark callset is wrong, the test callset is wrong, both callsets are wrong, or the true answer is unclear from current technologies.  If you find questionable or challenging sites, reporting them will help improve future callsets.  We encourage anyone to report information about particular sites at http://goo.gl/forms/OCUnvDXMEt1NEX8m2. 

# Version History
Changes in v3.3:
Enable use of phased calls and phase ID's from GATK-HC and output these in GT and PID when possible for locally phased variants
Enable bed files describing difficult regions to be excluded per callset when defining callable regions rather than excluded from the high-confidence bed file at the end.  This allows us, for example, to exclude tandem repeats from 10X Genomics and exclude decoy and segmental duplications from everything except 10X Genomics. These bed files are included in the supplementaryFiles directory
We now include 10X Genomics calls in our integration process for HG001-HG004.  Specifically, we designed a custom process requiring high quality calls in both haplotypes in the gvcf output of GATK-HC when calling separately on each haplotype. Although still conservative, this allows us to call variants and homozygous reference in some more difficult regions like segmental duplications and those homologous to the decoy sequence
For Illumina and 10X GATK-HC calls, use the GQ field in the gvcf to define the callable regions instead of GATK CallableLoci.  Because GATK-HC ensures that sufficient reads completely cross homopolymers when assigning a high GQ, this allows us to not generally exclude all homopolymers >10bp from GATK-HC callable regions, as long as the GQ is high.  As a result, our high-confidence calls and regions now include some variant and homozygous reference calls in long homopolymers.
Add 250x250bp Illumina datasets for AJ Trio
Add 6kb mate pair Illumina datasets fro AJ Trio and Chinese son
For annotations used for filtering, now use the minimum value if it is a multi-valued annotation (e.g., CGA_CEHQ from Complete Genomics)
Exclude overlapping variants from high-confidence regions, since they are often not ideally represented
Exclude heterozygous variants with net allele fractions <0.2 or >0.8 from high-confidence regions. Also added AD to FORMAT annotations in high-confidence vcf
Now annotate vcf with "callable" regions from each callset instead of the regions that are not callable, which were previously annotated as "lowcov"
Now annotate vcf with difficult regions bed files

Changes in v3.2.2:
We found a bug in one of the input call sets that was causing many of the variants on chr7 in HG001 and HG002 and on chr9 on HG002 to be reported as not high confidence.  We have corrected this issue, and all other chromosomes are the same as in v3.2.1.

Changes in v3.2.1:
The only change in v3.2.1 is to exclude regions from our high confidence bed file if they have homology to the decoy sequence hs37d5.  These decoy-related regions were generated by Heng Li and are available as mm-2-merged.bed at https://github.com/ga4gh/benchmarking-tools/tree/master/resources/stratification-bed-files/SegmentalDuplications. Our high-confidence vcf generally does not include variants if they are homologous to decoy sequence. Although most of these likely should be excluded, some real variants may be missed, so we are excluding these regions from our high-confidence regions until they are better characterized. However, it is important to note that these regions may be enriched for false positives if the decoy is not used in mapping.
 
Differences between v2.19 and v3.2 integration methods
The new v3.2 integration methods differ from the previous GIAB calls (v2.18 and v2.19) in several ways, both in the data used and the integration process and heuristics:
1. Only 4 datasets were used, selected because they represent 4 sequencing technologies that were generated from the NIST RM 8398 batch of DNA.  They are: 300x Illumina paired end WGS, 100x Complete Genomics WGS, 1000x Ion exome sequencing, and SOLID WGS.
 
2. Mapping and variant calling algorithms designed specifically for each technology were used to generate sensitive variant callsets where possible: novoalign + GATK-haplotypecaller and freebayes for Illumina, the vcfBeta file from the standard Complete Genomics pipeline, tmap+TVC for Ion exome, and Lifescope+GATK-HC for SOLID.  This is intended to minimize bias towards any particular bioinformatics toolchain.
 
3. Instead of forcing GATK to call genotypes at candidate variants in the bam files from each technology, we generate sensitive variant call sets and a bed file that describes the regions that were callable from each dataset.  For Illumina, we used GATK callable loci to find regions with at least 20 reads with MQ >= 20 and with coverage less than 2x the median.  For Complete Genomics, we used the callable regions defined by the vcfBeta file and excluded +-50bp around any no-called or half-called variant.  For Ion, we intersected the exome targeted regions with callableloci (requiring at least 20 reads with MQ >= 20).  Due to the shorter reads and low coverage for SOLID, it was only used to confirm variants, so no regions were considered callable.
 
4. A new file with putative structural variants was used to exclude potential errors around SVs.  For NA12878, these were SVs derived from multiple PacBio callers (ftp://ftp-trace.ncbi.nlm.nih.gov/giab/ftp/data/NA12878/NA12878_PacBio_MtSinai/) and multiple integrated illumina callers using MetaSV (ftp://ftp-trace.ncbi.nlm.nih.gov/giab/ftp/technical/svclassify_Manuscript/Supplementary_Information/metasv_trio_validation/).  These make up a significantly smaller fraction of the calls and genome (~4.5%) than the previous bed, which was a union of all dbVar calls for NA12878 (~10%). For the AJ Trio, the union of >10 submitted SV callsets from Illumina, PacBio, BioNano, and Complete Genomics from all members of the trio combined was used to exclude potential SV regions.  For the Chinese Trio, only Complete Genomics and GATK-HC and freebayes calls >49bp and surrounding regions were excluded due to the lack of available SV callsets for this genome at this time, which may result in a greater error rate in this genome.  The SV bed files for each genome are under the supplementaryFiles directory.
 
5. Homopolymers >10bp in length, including those interrupted by one nucleotide different from the homopolymer, are now excluded from the high-confidence regions, because these were seen to have a high error rate for all technologies.  This constitutes a high fraction of the putative indel calls, so more work is needed to resolve these.
 
6. A bug that caused nearby variants to be missed in v2.19 is fixed in the new calls.
 
7. The new vcf contains variants outside the high-confidence bed file.  This enables more robust comparison of complex variants or nearby variants that are near the boundary of the bed file.  It also allows the user to evaluate concordance outside the high-confidence regions, but these concordance metrics should be interpreted with great care.
 
8. We now output local phasing information when possible.
