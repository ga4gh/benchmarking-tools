# Genome in a Bottle

# Summary

The [Genome in a Bottle Consortium](http://www.genomeinabottle.org) has developed benchmark "high-confidence" variant calls and regions for several genomes that are Reference Materials (RMs) from the National Institute of Standards and Technology (NIST).  Currently, these genomes are:

* HG001/NA12878 - available as [NIST RM 8398](http://www.tinyurl.com/giabpilot)
* HG002/NA24385/AJ Son - available as [NIST RM 8391](http://www.tinyurl.com/giabajson) and [NIST RM 8392](http://www.tinyurl.com/giabajtrio)
* HG003/NA24149/AJ Father - available as [NIST RM 8392](http://www.tinyurl.com/giabajtrio)
* HG004/NA24143/AJ Mother - available as [NIST RM 8392](http://www.tinyurl.com/giabajtrio)
* HG005/NA24631/Chinese Son - available as [NIST RM 8393](http://www.tinyurl.com/giabchineseson)
* HG006/NA24694/Chinese Father - available only from Coriell
* HG007/NA24695/Chinese Mother - available only from Coriell

The various IDs for these genomes are in this table: [https://www.nature.com/articles/sdata201625/tables/3](https://www.nature.com/articles/sdata201625/tables/3)

The high-confidence calls were formed by integrating data from multiple technologies. The vcf and bed files are intended to be used in conjunction to benchmark accuracy of small variant calls.  We strongly recommend reading the information below prior to using these calls to understand how best to use them and their limitations.  A manuscript describing these calls is at [https://rdcu.be/bue67](https://rdcu.be/bue67).

To help us improve future versions of calls, we encourage you to report sites in the high-confidence regions that appear to be questionable in the high-confidence calls at:
[https://goo.gl/forms/6MTIUx4vmYtYyz1t1](https://goo.gl/forms/6MTIUx4vmYtYyz1t1)

# High-confidence VCF and BED Download

The latest VCF and BED files with the high-confidence calls and regions can be obtained from the "latest" directory under each genome at the Genome in a Bottle FTP site: 

[ftp://ftp-trace.ncbi.nlm.nih.gov/ReferenceSamples/giab/release/](ftp://ftp-trace.ncbi.nlm.nih.gov/ReferenceSamples/giab/release/)

A new v4.1 small variant benchmark covering more difficult regions is currently available only for HG002 at:
[ftp://ftp-trace.ncbi.nlm.nih.gov/ReferenceSamples/giab/data/AshkenazimTrio/analysis/NIST_v4.1_SmallVariantDraftBenchmark_12182019/](ftp://ftp-trace.ncbi.nlm.nih.gov/ReferenceSamples/giab/data/AshkenazimTrio/analysis/NIST_v4.1_SmallVariantDraftBenchmark_12182019/)

# Benchmarking Recipe

As an example for v4.1 benchmark calls for HG002/NA24385, using [hap.py](http://github.com/Illumina/hap.py), a query VCF file for GRCh37 can be compared to these high-confidence calls and regions as follows:

```bash
wget ftp://ftp-trace.ncbi.nlm.nih.gov/ReferenceSamples/giab/data/AshkenazimTrio/analysis/NIST_v4.1_SmallVariantDraftBenchmark_12182019/GRCh37/HG002_GRCh37_1_22_v4.1_draft_benchmark.vcf.gz
wget ftp://ftp-trace.ncbi.nlm.nih.gov/ReferenceSamples/giab/data/AshkenazimTrio/analysis/NIST_v4.1_SmallVariantDraftBenchmark_12182019/GRCh37/HG002_GRCh37_1_22_v4.1_draft_benchmark.vcf.gz.tbi
wget ftp://ftp-trace.ncbi.nlm.nih.gov/ReferenceSamples/giab/data/AshkenazimTrio/analysis/NIST_v4.1_SmallVariantDraftBenchmark_12182019/GRCh37/HG002_GRCh37_1_22_v4.1_draft_benchmark.bed

hap.py HG002_GRCh37_1_22_v4.1_draft_benchmark.vcf.gz query.vcf.gz -f HG002_GRCh37_1_22_v4.1_draft_benchmark.bed -o benchmarking-output
```

# Raw Data

Raw data sets and analyses are available from the GIAB ftp site under each genome at:
[ftp://ftp-trace.ncbi.nlm.nih.gov/ReferenceSamples/giab/data](ftp://ftp-trace.ncbi.nlm.nih.gov/ReferenceSamples/giab/data)

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
Changes in v4.1 from v3.3.2:
1. Use PacBio CCS calls from DeepVariant and GATK.  For DeepVariant, exclude RefCalls with GQ<40, but allow calls in homopolymers <11bp
2. Use 10x Genomics LongRanger variant calls instead of custom, conservative 10x calls
3. Used targeted diploid assembly of PacBio CCS to create benchmark variants and regions for MHC (6:28477800-31946000 and 6:32017001-33448350 in GRCh37, excluding a misassembly in the region containing CYP21A2, CYP21A1P, TNXA, and TNXB)
4. For GRCh37, we removed regions that were expanded or compressed in GRCh38 relative to GRCh37 are excluded from our GRCh37 benchmark regions (GRC and minimap2 alignments)
5. We used the new v0.6 structural variant calls to exclude putative structural variant regions, expanded by 50% on each side
6. We exclude regions with higher than expected (3rd Quartile + 1.5*IQR coverage in 1000 bp windows calculated using mosdepth) coverage in both PacBio and ONT to exclude potential duplications in HG002
7. We exclude regions called as duplications by MrCaNaVaR from Illumina WGS, which include segmental duplications in the reference, from short read callable regions
8. We exclude 15kb on either side of N’s in the reference to minimize errors around gaps in GRCh37 or GRCh38
9. We exclude regions covered by more than one contig for either haplotype of a diploid assembly generated from PacBio and from ONT
10. We exclude regions covered by segmental duplications greater than >10kb and more than 5 copies with >99% similarity to each other
11. We exclude L1H LINEs >500bp in length from short read callable regions to minimize clusters of variants missed by short reads
12. We exclude difficult to map regions from short reads
13. We now use additional tandem repeat and low complexity annotations from RepeatMasker and TRF because our previous bed files had missed excluding some long tandem repeats from short and linked read methods
14. Remove small benchmark regions <50bp in size
15. Now use a segmental duplications bed file for GRCh38 instead of the self-chain, since the GRCh38 self-chain had some problems


Changes in v3.3.2:
1. Fix bug in callable regions script for GATKHC gvcf, which was erroneously determining too many regions to be callable; add "difficult region" bed file annotation to high confidence vcf
2. filter sites that are within 50bp of another passing call but none of the callsets that support the 2 calls match, because some nearby conflicting calls from different callers were both considered high confidence if another callset from the same dataset was filtered.  This eliminates many problematic cases, but a small number of conflicting calls remain.
3. Subtract SV regions from HG005 bed when called by MetaSV in any member of the Chinese trio (Thanks to Roche/Bina for running MetaSV)
4. We have GRCh38 calls for all individuals.
5. For new GRCh38 analyses of Illumina and 10X data in AJ trio and Chinese son, use sentieon haplotyper in place of GATK-HC, since it gives essentially identical results and runs faster. (Thanks to Rafael Saldana at Sentieon for help running this)
6. Use RTG vcfeval tools to harmonize representation of complex variants in AJ trio prior to performing Mendelian inheritance analysis and phasing. Apply trio phasing to HG002 high confidence vcf, and exclude 50bp from high-confidence beds for all AJ trio individuals on either side of Mendelian inheritance errors that are not de novo mutations.
7. For the phased vcfs for HG001 and HG002, include phasing information both from family-based phasing and from local read-based phasing, prioritizing family-based phasing.  For family-based phased calls, the PS field contains PATMAT.  For local read-based phased calls, the PS field contains the PID from GATKHC.  For homozygous calls that were not otherwise phased, we changed their status to phased and put HOMVAR in PS.  Pedigree and trio phased calls have alleles in the order paternal|maternal. For phasing comparisons that require paternal|maternal phasing, only calls with PATMAT in PS should be included.  For HG001, 99.0% of high-confidence calls are phased by the Platinum Genome or RTG pedigree analyses, and 99.5% are phased by the pedigree, GATKHC, or are homozygous variant.  For HG002, 87.0% of high-confidence calls are phased by the trio, and 89.5% of calls are phased by the trio, GATKHC, or are homozygous variant. (Thanks to Sean Irvine and Len Trigg at RTG for help with these analyses)

Changes in v3.3.1:
1. Because freebayes sometimes misses calls in repetitive regions, now exclude tandem repeats of any size from freebayes callable regions. Also, exclude these regions from GATK-HC calls for Mate-Pair data since amplification causes a higher error rate.
2. Change GATK-HC gvcf parsing to ignore reference bases with low GQ within 10bp of an indel, since these often caused us to exclude good indels.  This significantly increases the number of indels to 505169 in 3.3.1 vs. 358753 in v3.3
3. Now make calls for GRCh38 in addition to GRCh37 (initially only for HG001). For illumina and 10X data, variant calls were made similarly to GRCh37 but from reads mapped to GRCh38 with decoy but no alts (ftp://ftp.ncbi.nlm.nih.gov/genomes/all/GCA_000001405.15_GRCh38/seqs_for_alignment_pipelines.ucsc_ids/GCA_000001405.15_GRCh38_no_alt_plus_hs38d1_analysis_set.fna.gz).  For Complete Genomics, Ion exome, and SOLiD data, vcf and callable bed files were converted from GRCh37 to GRCh38 by Cory McLean from Verily using the tool GenomeWarp (https://github.com/verilylifesciences/genomewarp).  This tool converts vcf and callable bed files in a conservative and sophisticated manner, accounting for base changes that were made between the two references.  Modeled centromere and heterochromatin regions are explicitly exclude from the high-confidence bed.
4. Add phasing information from Real Time Genomics and Illumina Platinum Genomes phased pedigree calls so that now 98-99% of calls are phased.  The process used is described below.

Phasing process applied to v3.3.1 for HG001 by RTG:
Using the fully-phased RTG SegregationPhasing v.37.3.3 and Illumina Platinum Genomes 2016-1.0 we used vcfeval to transfer phasing information to GIAB v3.3.1 for NA12878.  The resulting call sets for GRCh37 and GRCh38 are 98.6% and 98.0% phased, respectively.  The phase transfer is performed in such a way that the original calls and genotypes of GIAB v3.3.1 are not changed (other than phasing).  In both cases, the existing local phasing of GIAB v3.3.1 was dropped before doing the transfer.

Details for fully-phased sets:

SegregationPhasing: 100.0% (4222244/4224035)
Cleaned SegregationPhasing: 100.0% (4222244/4224024)
Platinum Genomes: 100.0% (4049512/4049512)
Cleaned Platinum Genomes: 100.0% (4049512/4049512)

Details for GRCh37:

Original calls: 10.1% (388646/3843181)
Original calls phasing removed: 0% (0/3843181)
SP Transfered: 98.1% (3770070/3843181)
SP and PG Transfered: 98.6% (3788674/3843181)

Failed Filters               : 0
Passed Filters               : 3843181
SNPs                         : 3271601
MNPs                         : 0
Insertions                   : 268387
Deletions                    : 287319
Indels                       : 15874
Same as reference            : 0
Phased Genotypes             : 98.6% (3788674/3843181)
SNP Transitions/Transversions: 2.09 (3090872/1477889)
Total Het/Hom ratio          : 1.53 (2323803/1519378)
SNP Het/Hom ratio            : 1.52 (1975346/1296255)
MNP Het/Hom ratio            : - (0/0)
Insertion Het/Hom ratio      : 1.40 (156335/112052)
Deletion Het/Hom ratio       : 1.59 (176522/110797)
Indel Het/Hom ratio          : 56.93 (15600/274)
Insertion/Deletion ratio     : 0.93 (268387/287319)
Indel/SNP+MNP ratio          : 0.17 (571580/3271601)


Details for GRCh38:

Original calls: 10.2% (377091/3709412)
Original calls phasing removed: 0% (0/3709412)
SP Transfered: 97.3% (3607917/3709412)
SP and PG Transfered: 98.0% (3634961/3709412)

Failed Filters               : 0
Passed Filters               : 3709412
SNPs                         : 3102724
MNPs                         : 0
Insertions                   : 293598
Deletions                    : 296423
Indels                       : 16667
Same as reference            : 0
Phased Genotypes             : 98.0% (3634961/3709412)
SNP Transitions/Transversions: 2.09 (2925118/1398168)
Total Het/Hom ratio          : 1.59 (2277006/1432406)
SNP Het/Hom ratio            : 1.54 (1883057/1219667)
MNP Het/Hom ratio            : - (0/0)
Insertion Het/Hom ratio      : 1.74 (186337/107261)
Deletion Het/Hom ratio       : 1.82 (191242/105181)
Indel Het/Hom ratio          : 55.12 (16370/297)
Insertion/Deletion ratio     : 0.99 (293598/296423)
Indel/SNP+MNP ratio          : 0.20 (606688/3102724)

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
