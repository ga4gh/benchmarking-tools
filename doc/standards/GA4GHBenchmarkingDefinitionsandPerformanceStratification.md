**Benchmarking Definitions and Performance Stratification for ****SNVs**** and ****Small Indels**

# **Definitions**

**Introduction:**

Assessing the performance of variant callers does not easily lend itself to the typical binary classification model of determining true and false "positives" and “negatives”. Several characteristics of the genome do not fit well in a binary classification model:

1. More than two possible genotypes exist at any given location. For SNVs (if ignoring phasing), any location can have one of 10 different true genotypes (i*.e.*, AA, AC, AG, AT, CC, CG, …). For indels and complex variants, an infinite number of possible genotypes exists (*e.g.*, any length of insertion). 

2. An increasing number of variant callers output "no-calls" at some genome positions or regions, indicating that neither a homozygous reference nor a specific variant call could be made. Some variant callers even output partial no-calls, calling one allele but not the other.

3. Complex variants (*i.e.*, nearby SNVs and/or indels) are particularly difficult to assess. This difficulty is especially pronounced because many variant callers do not yet output phasing information, so that the precise set of alleles in the region is ambiguous. In addition, the same complex variant can be represented in vcf files in multiple ways, making comparisons challenging. Complex variants can also be treated as a single positive event or as multiple distinct SNV and indel events.

4. Assessing accuracy of phasing is in its infancy, but it can be critical, particularly when multiple heterozygous variants exist in a small region (*e.g.*, complex variants).

We have created a table (https://docs.google.com/spreadsheets/d/1zdzNpldjYLGuuFlE_lcwDad-O7aoAUuTZkt4JmKD-Pw/edit#gid=1080374770) that outlines several approaches for categorizing different pairs of benchmark and test set genotypes as true positives, false positives, true negatives, and false negatives. To allow us to start with a simpler set of benchmarking rules that will reduce the barriers to initial implementation, we decided to delay performing a full implementation of any of the approaches outlined in this table. Note that we have chosen not to include true negatives (or consequently specificity) in the definitions below. This is due to the challenge in defining the number of true negatives, particularly around complex variants.  In addition, positive predictive value is often a more useful metric than specificity due to the very large proportion of true negative positions in the genome.

Instead of a full implementation of this table, we chose to create several different definitions of TP, FP, and FN that vary in the stringency of the match required between the benchmark and test calls. It is important to understand the meaning of the outputs of each of these definitions, since one or more definitions may be most important depending on the application. For example, one clinical lab might only need a variant or no-call somewhere in the region of a real variant (Comparison Method #1) because they do Sanger validation or manually inspect the reads around some or all potentially interesting variants or no-calls to determine the true variant. In contrast, if a lab wants to rely solely on the output of an automated functional annotation pipeline, they may want to require that both the genotype and local phasing information are accurate (Comparison Method #4). For "no-calls" and partial “no-calls”, note in particular that they are treated as variants in Method #1 and as homozygous reference in Methods #2-4. Also note that complex variants are not required to have phasing information in Methods #1-3 so that the real haplotypes may not be known, whereas correct phasing is required for Method #4. Each of these comparison methods could be implemented separately in stages or they could all be implemented in a single tool, so we will work with the implementers of benchmarking to prioritize these methods. We also may develop additional comparison methods over time as needed.

**Benchmark Call Set:** The set of high-confidence variant, reference, and no calls to which an RM customer shall compare their calls. There may be more than one Benchmark Call Set. Additionally, Benchmark Call Sets will likely change over time, suggesting the need to version these in a robust way.

**Test Set:** The set of variant (and optionally reference and no calls) for which accuracy is being assessed.

Note: It is important to note that the aim of the comparison software is to minimize the global number of discrepancies between the Benchmark Call Set and the Test Set. This is particularly important in the case when complex variants are assessed and there may be multiple equivalent ways to compare these. The optimal solution would be the one that minimizes the number of FP and FN. Global optimization techniques can be used to accomplish this.

A description of how different combinations of Benchmark and Test genotypes are counted in each comparison method is outlined in tables in slides.

**Comparison Method #1: Loose Regional Comparison**

**Positives (P):** the number of variants in the Benchmark Call Set

**Negatives (N):** the number of hom-REF bases in the Benchmark Call Set (*i.e*, the number of bases in the high-confidence regions minus the bases covered by true variants)

**True Positive (TP):** a variant site in the Benchmark Call Set that is within x-bp of any variant, no-call, or partial no-call in the test set.

**False Positive (FP):** a variant in the Test Set that is not within x-bp of a variant site in the Benchmark Call Set.

**False Negative (FN):** a true variant site in the Benchmark Call Set that is not within x-bp of any variant, no-call, or partial no-call in the test set. P=FN+TP always stands.

**True Negative (TN):** the number of bases in the high-confidence regions that are not "no-called" or Missing in the Test Set (note that this is an approximation that assumes only a small fraction of bases are positives (usually about 0.1 %))

**Not Assessed (NA):** a variant in the Test Set that is not in the high-confidence regions of the Benchmark Call Set

**Missing (M):** a variant in the Benchmark Call Set that is outside the bed file accompanying the Test Set (if applicable)

**No-call (NC): **number of no-call/no-call bases (including partial no-calls) that overlap the P+N regions. Only the positions covered by the REF string are included as no-call bases.

**No-call variant (NCV)****:** a variant site in the Benchmark Call Set that is within x-bp of any no-call or partial no-call in the test set and not within x-bp of a variant call (*i.e.*, these are a subset of TPs that are TPs only because of their proximity to a no-call)

**Sensitivity** (AKA True Positive Rate or Recall): TP/(TP+FN)

**Positive Predictive Value** (aka, Precision, though Precision has different meanings in different communities): TP/(TP+FP)

**Negative Predictive Value**: FP/(FP+FN)

**False Positive Rate (FPR):** FP/N

**No-call Rate:** NC / (P+N)

**No-call Variant Rate:** NCV / (P)

ROC Curve: A receiver operating characteristic (ROC), or ROC curve, is a graphical plot which illustrates the performance of a variant quality value score of a test call set as its discrimination threshold is varied, compared to the reference call set. The curve is created by plotting the true positive rate against the false positive rate at various threshold settings. Commonly used quality value scores include GQ (genotype quality), VQSLOD, and AVR. An important rule of ROC curve generation is that TP plus FN should equal the total number of variants in the baseline Reference Call Set.

Area under the ROC curve: Area under the ROC the full curve (AUC) , or to a specified FP or TP threshold selected by the user. The greater the area, the better the performance of the scoring system. Ideally, the full raw set of variants in the test set is provided without filtering since different TP/FP rates may be required for different applications. The above metrics can also be calculated at the given specified FP or TP threshold.

**Note #1**: Prior to performing the comparison, phased complex variants in the Reference Call Set and Test Set should be merged into a single event with results comparable to the output of vcflib vcfgeno2haplo, and shall be counted as a single event. 

**Note #2**: After performing the comparison, 49-bp shall be excluded from each edge of every high-confidence region defined in the Reference Call Set (*i.e.*, the comparison tool shall exclude all P, N, TP, FP, and FN events that are within 49-bp of any edge of a high-confidence region). This will remove most comparison problems where only half of a complex variant is included in the Reference Call Set or Test Set due to ignoring calls outside the high-confidence regions. **Not sure this is necessary for loose comparisons...**

**Comparison Method #2: Allele Match Required**

**Positives (P):** the number of true ALT alleles (see Note #1 below about homozygous and compound heterozygous sites)

**Negatives (N):** the number of true hom-REF bases (*i.e*, the number of bases in the high-confidence regions minus the bases covered by true ALT alleles)

**True Positive (TP):** an ALT allele in the Reference Call Set for which there is a path through the Test Call Set that contains this allele. Genotype match is not required (*e.g.*, if Benchmark Call set is hom-ALT and test set is ALT/REF, then it is a TP and not an FP or FN.) No-calls are considered to be hom-REF.

**False Positive (FP):** an ALT allele in the Test Call Set for which there is no path through the Reference Call Set that contains this allele

**False Negative (FN):** an ALT allele in the Reference Call Set for which there is no path through the Test Call Set that contains this allele. P=FN+TP always stands.

**No-call (NC): **number of no-call/no-call bases (including partial no-calls) that overlap the P+N regions. Only the positions covered by the REF string are included as no-call bases. This is the same as in Comparison Method #1

No-call variant (NCV): an ALT allele in the Reference Call Set for which there is no path through the Test Call Set that contains this allele but there is a path through the Test Call Set that contains a no-call or half-call**No-call variant (NCV):** a variant site in the Benchmark Call Set that is within x-bp of any no-call or partial no-call in the test set and not within x-bp of a variant call (i.e., these are a subset of TPs that are TPs only because of their proximity to a no-call)

**Genotype error (GE): **Site with the correct variant allele but incorrect genotype

**Genotype error rate (GER): **GE/TP

**Sensitivity** (AKA, True Positive Rate or Recall): TP/(TP+FN)

**Precision** (AKA, Positive Predictive Value): TP/(TP+FP)

**Negative Predictive Value**: FP/(FP+FN)

**False Positive Rate (FPR):** FP/N

**No-call Rate:** NC / (P+N)

**No-call Variant Rate:** NCV / (P)

ROC Curve: A receiver operating characteristic (ROC), or ROC curve, is a graphical plot which illustrates the performance of a variant quality value score of a test call set as its discrimination threshold is varied, compared to the reference call set. The curve is created by plotting the true positive rate against the false positive rate at various threshold settings. Commonly used quality value scores include GQ (genotype quality), VQSLOD, and AVR. An important rule of ROC curve generation is that TP plus FN should equal the total number of variants in the baseline Reference Call Set.

Area under the ROC curve: Area under the ROC the full curve, or to a specified FP or TP threshold selected by the user. The greater the area, the better the performance of the scoring system. Ideally, the full raw set of variants in the test set is provided without filtering since different TP/FP rates may be required for different applications. The above metrics can also be calculated at the given specified FP or TP threshold.

Note #1: A homozygous variant shall be considered a single ALT allele, but a compound heterozygous variant at a single site shall be considered two separate ALT alleles

Note #2: Prior to performing the comparison, phased complex variants (within x-bp of each other) in the Reference Call Set and Test Set should be merged into a single event with results comparable to the output of vcflib vcfgeno2haplo, and shall be counted as a single event.

Note #3: After performing the comparison, 49-bp shall be excluded from each edge of every high-confidence region defined in the Reference Call Set (i.e., the comparison tool shall exclude all P, N, TP, FP, and FN events that are within 49-bp of any edge of a high-confidence region). This will remove most comparison problems where only half of a complex variant is included in the Reference Call Set or Test Set due to ignoring calls outside the high-confidence regions.

**Comparison Method #3: ****Genotype Match Required**

**Positives (P):** the number of sites that are not hom-REF (complex variants are treated as a single site - see Note #1 below)

**Negatives (N):** the number of true hom-REF bases (*i.e.*, the number of bases in the high-confidence regions minus the bases covered by true P sites)

**True Positive (TP):** a site in P for which there are paths through the Test Call Set that are consistent with all of the alleles at this site, and for which there is an accurate genotype call for the event. Phasing of complex variants is not required. No-calls and partial no-calls are considered to be hom-REF.

**False Positive (FP):** a site in the Test Call Set for which there is no path through the Reference Call Set that is consistent with this site. Genotype errors are not counted here.

**False Negative (FN):** a site in P for which there is no path through the Test Call Set that is consistent with all of the alleles at this site, or sites for which there is an inaccurate genotype call for the event. No-calls and partial no-calls are considered to be hom-REF. P=FN+TP always stands.

No-call (NC): number of no-call/no-call bases (including partial no-calls) that overlap the P+N regions. Only the positions covered by the REF string are included as no-call bases. 

No-call variant (NCV): an ALT allele in the Reference Call Set for which the path through the Test Call Set contains a no-call or half-call

**Sensitivity** (aka, True Positive Rate or Recall): TP/(TP+FN)

**Precision** (aka, Positive Predictive Value): TP/(TP+FP)

**Negative Predictive Value**: FP/(FP+FN)

**False Positive Rate (FPR):** FP/N

ROC Curve: A receiver operating characteristic (ROC), or ROC curve, is a graphical plot which illustrates the performance of a variant quality value score of a test call set as its discrimination threshold is varied, compared to the reference call set. The curve is created by plotting the true positive rate against the false positive rate at various threshold settings. Commonly used quality value scores include GQ (genotype quality), VQSLOD, and AVR. An important rule of ROC curve generation is that TP plus FN should equal the total number of variants in the baseline Reference Call Set.

Area under the ROC curve: Area under the ROC the full curve, or to a specified FP or TP threshold selected by the user. The greater the area, the better the performance of the scoring system. Ideally, the full raw set of variants in the test set is provided without filtering since different TP/FP rates may be required for different applications. The above metrics can also be calculated at the given specified FP or TP threshold.

Note #1: Prior to performing the comparison, phased complex variants (within x-bp of each other) in the Reference Call Set and Test Set should be merged into a single event with results comparable to the output of vcflib vcfgeno2haplo, and shall be counted as a single event. 

Note #2: After performing the comparison, 49-bp shall be excluded from each edge of every high-confidence region defined in the Reference Call Set (*i.e.*, the comparison tool shall exclude all P, N, TP, FP, and FN events that are within 49-bp of any edge of a high-confidence region). This will remove most comparison problems where only half of a complex variant is included in the Reference Call Set or Test Set due to ignoring calls outside the high-confidence regions.

**Comparison Method #4: Genotype Match and Local Phasing Required**

**Positives (P):** the number of sites that are not hom-REF (complex variants are treated as a single site - see Note #1 below)

**Negatives (N):** the number of true hom-REF bases (*i.e.*, the number of bases in the high-confidence regions minus the bases covered by true P sites)

**True Positive (TP):** a site in P for which there are paths through the Test Call Set that are consistent with all of the alleles at this site, and for which there is an accurate genotype call for the event, and for which phasing of the variants in the site is correct. No-calls and partial no-calls are considered to be hom-REF.

**False Positive (FP):** a site in the Test Call Set for which there is no path through the Reference Call Set that is consistent with this site. Genotype errors are not counted here, but phasing errors are counted here.

**False Negative (FN):** a site in P for which there is no path through the Test Call Set that is consistent with all of the alleles at this site, or sites for which there is an inaccurate genotype call for the event, or sites for which phasing of the variants in the site is incorrect. No-calls and partial no-calls are considered to be hom-REF. P=FN+TP always stands.

**Sensitivity** (AKA, True Positive Rate or Recall): TP/(TP+FN)

**Precision** (AKA, Positive Predictive Value): TP/(TP+FP)

**Negative Predictive Value**: FP/(FP+FN)

**False Positive Rate (FPR):** FP/N

ROC Curve: A receiver operating characteristic (ROC), or ROC curve, is a graphical plot which illustrates the performance of a variant quality value score of a test call set as its discrimination threshold is varied, compared to the reference call set. The curve is created by plotting the true positive rate against the false positive rate at various threshold settings. Commonly used quality value scores include GQ (genotype quality), VQSLOD, and AVR. An important rule of ROC curve generation is that TP plus FN should equal the total number of variants in the baseline Reference Call Set.

Area under the ROC curve: Area under the ROC the full curve, or to a specified FP or TP threshold selected by the user. The greater the area, the better the performance of the scoring system. Ideally, the full raw set of variants in the test set is provided without filtering since different TP/FP rates may be required for different applications. The above metrics can also be calculated at the given specified FP or TP threshold.ROC Curve: A receiver operating characteristic (ROC), or ROC curve, is a graphical plot which illustrates the performance of a variant quality value score of a test call set as its discrimination threshold is varied, compared to the reference call set. The curve is created by plotting the true positive rate against the false positive rate at various threshold settings. Commonly used quality value scores include GQ (genotype quality), VQSLOD, and AVR. An important rule of ROC curve generation is that TP plus FN should equal the total number of variants in the baseline Reference Call Set.

Area under the ROC curve: Area under the ROC the full curve, or to a specified FP threshold selected by the user.

Note #1: Prior to performing the comparison, phased complex variants (within x-bp of each other) in the Reference Call Set and Test Set should be merged into a single event with results comparable to the output of vcflib vcfgeno2haplo, and shall be counted as a single event. 

Note #2: After performing the comparison, 49-bp shall be excluded from each edge of every high-confidence region defined in the Reference Call Set (i.e., the comparison tool shall exclude all P, N, TP, FP, and FN events that are within 49-bp of any edge of a high-confidence region). This will remove most comparison problems where only half of a complex variant is included in the Reference Call Set or Test Set due to ignoring calls outside the high-confidence regions.

Note #3: This method in general should not require a realignment-based comparison, but could likely be done with a simple comparison tool if vcfgeno2haplo or vcfallelicprimitives is run first.

Note #4: For generating a receiving operator characteristics (ROC) curve, the number of true positive and false positive variants must be counted. Generally each called variant will have a corresponding base line variant but due to the nature of complex calling there can be many to many relationships between baseline and called variants. To keep number of true positives plus the number of false negatives equals to the total number of calls in the baseline, each called true positive call must be weighted. See supplement of Cleary, J. G., et al. bioRxiv (2014). doi:10.1101/001958 for methods for weighting.

**Comparison Method #5: Accuracy of phasing vs. distance between variants**

**To be developed**

# **Stratification of Performance Metrics**

A major difference between traditional measurements and genome sequencing is the large number of simultaneous tests performed.  Instead of testing one known analyte, genome sequencing effectively tests for an infinite number of potential variants, which leads to several problems for traditional performance metrics.

  First, this infinite number of potential variants means that any genome sequencing test has an infinite number of true negatives, so the traditional definition of specificity is meaningless because it is always 1.  Therefore, other metrics for false positives are usually used, such as False Discovery Rate, false positive rate per base pair, false positive rate per test, or false positive rate per gene.

The second problem with the infinite number of potential variants is that it is impossible for a lab to test sensitivity and specificity for every potential variant.  One solution to this problem is to sequence one or more samples that are well-characterized, such as the NIST Reference Materials being characterized by the GIAB.  Then, if the lab assumes that the variants and homozygous reference regions in these samples are representative of all variants and homozygous reference regions, the lab can report their performance for the test.  There are two potential problems with this method.  First, the variants and homozygous reference regions in the reference materials are often not representative of the variants a typical clinical lab is interested in, both because clinically interesting variants are often rare or even novel and because only the easier-to-sequence regions are characterized. Second, the performance metrics for the test as a whole are often misleading because the test might perform very well for certain types of variants (e.g., SNVs in easy parts of the genome) and very poorly for other types of variants (e.g., indels in large repetitive regions). In practice, this might mean that a lab decides to validate every variant with a different technology, when in fact they might only need to validate a small fraction of variants in difficult regions. Therefore, to understand performance, it is important to stratify variants and the genome into different types of variants and sequence contexts. Stratification also helps address the problem of understanding whether the variants and regions in the reference material are representative of the variants and regions in which the lab is interested.

An initial step in understanding how to stratify variants is to collect the different potential ways to stratify into categories and develop methods to stratify variants into these categories. Stratification can be performed in several distinct ways: by variant type, by sequence context, by functional significance, and by characteristics of the sequencing reads.  These different ways to stratify can be combined in a multitude of ways (e.g., SNVs in homopolymers in exons with coverage > 20), which can help focus validation only on specific types of variants for which performance is poor.  However, it should be noted that as performance is stratified into increasingly smaller categories, there may no longer be sufficient variants or homozygous reference bases to get useful estimates of performance metrics because the confidence intervals on the metrics become too large.  Therefore, it will be necessary to understand how best to stratify variants for each sequencing and bioinformatics pipeline.

The software shall be able to output performance for different types of variants:

* ○ SNVs

* ○ insertions <50bp

* ○ deletions < 50bp

* ○ complex variants (SNVs and indels within 50bp of each other and total change of <50bp, including compound heterozygous or multiallelic calls at a single position). These could be further sub-divided:

        * ■ All SNVs *vs.* >0 indels

        * ■ All homozygous vs 1 heterozygous vs >1 heterozygous compound vs >1 heterozygous on single haplotype

* ○ insertions 50-200bp

* ○ deletions 50-200bp

* ○ insertions >200bp

* ○ deletions >200bp

* ○ inversions

* ○ tandem duplications

* ○ copy number gain/dispersed duplications

* ○ complex structural variant (not a simple deletion, insertion, or inversion) with total bases changed >=50bp (Eventually, we might want to sub-divide this into those containing an inversion or not, and those with a net gain or loss of bases)

* ○ large "sequence alteration" (from NCBI, but unclear how this differs from complex SVs

* ○ The high-confidence calls will be pre-annotated with these. How should we annotate the FP variants in the assessed call-set? In particular, if a SNV or indel is called incorrectly inside or near a real complex variant, should it be classified as a FP SNV or indel and FN complex variant, or put in a separate category as a partially called complex variant?

The software shall be able to output performance for different sequence contexts (italicized have standard bed files created for GRCh37):

* *○** **Homopolymers (3-5bp)*

* *○** **Homopolymers (6-10bp)*

* *○** **Homopolymers (>10bp)*

* *○** **tandem repeats with unit of 2, 3, or 4 bp and length 11-50bp*

* *○** **tandem repeats with unit of 2, 3, or 4 bp and length 51-200bp*

* *○** **tandem repeats with unit of 2, 3, or 4 bp and length >200bp*

* *○** **other low complexity regions** (including imperfect homopolymers and tandem repeats of all unit lengths)*

    * *Use output from TRDB for hg19, selecting only regions with >=95% identity*

        * *divide into those with unit length <=6bp and >6bp*

        * *Divide into total length <51bp, 51-200bp, and >200bp (from beginning of first copy to end of last copy)*

    * *Alternatively, Heng Li contributed low complexity regions based on DUST *

* *○** **GC content <15%, 15-20%, 20-25%, 25-30%, 30-65%, 65-70%, 70-75%, 75-80%, 80-85% or >85% (in 100bp region + 50bp on each side)*

* *○** **difficult to map regions** *

    * *use GEM mappability tool*

        * *read lengths of 100, 125, 150, and 250bp*

        * *allowing 0, 1, or 2 substitutions with no indels, or 2 substitutions with 1 indel <15bp *

* Segmental duplications

    * *in reference assembly - self-chain tool from Kevin Jacobs*

    * Eichler group list, including those not in reference assembly

* ○ SNVs and indels at breakpoints of an SV (we’re still working on developing a good list of SV regions, but these will definitely be incomplete)

* ○ SNVs and indels called inside an SV (unclear what these mean for CNVs)

* ○ Bed files defining the above regions shall be zero-based. The sequence context shall be defined by a central group and all programs shall use the same set of regions.

* "Poison Motifs" (will be tech specific)

The software shall be able to output performance for different categories of potentially "functional" variants:

* ○ whole genome

* ○ exome **- What definition to use? Give multiple options (****RefSeq****, Ensembl, GenCode, others?)**

    * *Coding RefSeq bed file*

* ○ promoters

* ○ first exons

* ○ synonymous

* ○ nonsynonymous

* ○ truncating

* ○ splice site

* ○ enhancer regions (and "super-enhancers")

* ○ centromeres, telomeres, *etc.*

* *"Bad promoters" from http://genomebiology.com/content/supplementary/gb-2013-14-5-r51-s1.txt*

* ○ Bed files defining the above regions shall be zero-based. The functional elements of the assembly shall be defined by a central resource and used by all programs. **We probably can’t pre-calculate this for synonymous, nonsynonymous, truncating, and maybe splice-site mutations**

The software shall stratify by different characteristics of the data at the location:

* Coverage <5

* Coverage 5-10

* Coverage 10-20

* coverage >20

* Mapping quality (mean?, fraction of MQ0?)

* Filtered vs unfiltered

* Strand bias

* variant allele fraction

* Allow user to specify? 

    * e.g., GATK VQSLOD

