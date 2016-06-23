# **Benchmarking Performance Metrics Definitions for SNVs and Small Indels**

**Introduction:**

Assessing the performance of variant callers does not easily lend itself to the typical binary classification model of determining true and false "positives" and “negatives”. Several characteristics of the genome do not fit well in a binary classification model:

1. More than two possible genotypes exist at any given location. For SNVs (if ignoring phasing), any location can have one of 10 different true genotypes (*i.e.*, AA, AC, AG, AT, CC, CG, …). For indels and complex variants, an infinite number of possible genotypes exists (*e.g.*, any length of insertion). 

2. An increasing number of variant callers output "no-calls" at some genome positions or regions, indicating that neither a homozygous reference nor a specific variant call could be made. Some variant callers even output partial no-calls, calling one allele but not the other.

3. Complex variants (*i.e.*, nearby SNVs and/or indels) are particularly difficult to assess. This difficulty is especially pronounced because many variant callers do not yet output phasing information, so that the precise set of alleles in the region is ambiguous. In addition, the same complex variant can be represented in vcf files in multiple ways, making comparisons challenging. Complex variants can also be treated as a single positive event or as multiple distinct SNV and indel events.

4. Assessing accuracy of phasing is in its infancy, but it can be critical, particularly when multiple heterozygous variants exist in a small region (*e.g.*, complex variants).

We have created a table (https://docs.google.com/spreadsheets/d/1zdzNpldjYLGuuFlE_lcwDad-O7aoAUuTZkt4JmKD-Pw/edit#gid=1080374770) that outlines several approaches for categorizing different pairs of benchmark and Query Call Set genotypes as true positives, false positives, true negatives, and false negatives. To allow us to start with a simpler set of benchmarking rules that will reduce the barriers to initial implementation, we decided to delay performing a full implementation of any of the approaches outlined in this table. Note that we have chosen not to include true negatives (or consequently specificity) in the definitions below. This is due to the challenge in defining the number of true negatives, particularly around complex variants.  In addition, positive predictive value is often a more useful metric than specificity due to the very large proportion of true negative positions in the genome.

Instead of a full implementation of this table, we chose to create several different definitions of TP, FP, and FN that vary in the stringency of the match required between the benchmark and test calls. It is important to understand the meaning of the outputs of each of these definitions, since one or more definitions may be most important depending on the application. For example, one clinical lab might only need a variant or no-call somewhere in the region of a real variant (Comparison Method #1) because they do Sanger validation or manually inspect the reads around some or all potentially interesting variants or no-calls to determine the true variant. In contrast, if a lab wants to rely solely on the output of an automated functional annotation pipeline, they may want to require that both the genotype and local phasing information are accurate (Comparison Method #4). For "no-calls" and partial “no-calls”, note in particular that they are treated as variants in Method #1 and as homozygous reference in Methods #2-4. Also note that complex variants are not required to have phasing information in Methods #1-3 so that the real haplotypes may not be known, whereas correct phasing is required for Method #4. Each of these comparison methods could be implemented separately in stages or they could all be implemented in a single tool, so we will work with the implementers of benchmarking to prioritize these methods. We also may develop additional comparison methods over time as needed.

**Truth Call Set:** The set of high-confidence variant, reference, and no calls to which the user shall compare their calls. There may be more than one Truth Call Set. Additionally, Truth Call Sets will likely change over time, and should be versioned in a robust way. It is important to recognize that "Truth Call Sets" are likely not perfect and are only treated as such for the purposes of calculating the statistics below.

**Query Call Set:** The set of variant (and optionally reference and no calls) for which accuracy is being assessed.

Note: The aim of the comparison software is to minimize the number of discrepancies between the Truth Call Set and the Query Call Set. This is particularly important in the case when complex variants are assessed and there may be multiple equivalent ways to compare these. The optimal solution would be the one that minimizes the number of FP and FN. Global optimization techniques can be used to accomplish this.

A description of how different combinations of Truth and Query genotypes are counted in each comparison method is outlined in tables in slides.

*Comparison Method #3 below is currently performed by hap.py, though not all statistics are yet calculated.*

**Comparison Method #1: Loose Regional Comparison**

**Positives (P):** the number of variants in the Truth Call Set

**Negatives (N):** the number of hom-REF bases in the Truth Call Set (*i.e*, the number of bases in the high-confidence regions minus the bases covered by true variants)

**True Positive (TP):** a variant site in the Truth Call Set that is within x-bp of any variant, no-call, or partial no-call in the Query Call Set.

**False Positive (FP):** a variant in the Query Call Set that is not within x-bp of a variant site in the Truth Call Set.

**False Negative (FN):** a true variant site in the Truth Call Set that is not within x-bp of any variant, no-call, or partial no-call in the Query Call Set. P=FN+TP always stands.

**True Negative (TN):** the number of bases in the high-confidence regions that are not "no-called" or Missing in the Query Call Set (note that this is an approximation that assumes only a small fraction of bases are positives (usually about 0.1 %))

**Not Assessed (QUERY.UNK):** a variant in the Query Call Set that is not in the high-confidence regions of the Truth Call Set

**Fraction Not Assessed (METRIC.Frac_NA):** QUERY.UNK/QUERY.TOTAL

**Missing (M):** a variant in the Truth Call Set that is outside the bed file accompanying the Query Call Set (if applicable)

**No-call (NC):** number of no-call/no-call bases (including partial no-calls) that overlap the P+N regions. Only the positions covered by the REF string are included as no-call bases.

**No-call variant (NCV):** a variant site in the Truth Call Set that is within x-bp of any no-call or partial no-call in the Query Call Set and not within x-bp of a variant call (*i.e.*, these are a subset of TPs that are TPs only because of their proximity to a no-call)

**Recall** (aka, True Positive Rate or Sensitivity): TP/(TP+FN)

**Positive Predictive Value** (aka, Precision, though Precision has different meanings in different communities): TP/(TP+FP)

**Negative Predictive Value**: FP/(FP+FN)

**False Positive Rate (FPR):** FP/N

**No-call Rate:** NC / (P+N)

**No-call Variant Rate:** NCV / (P)

**ROC Curve:** A receiver operating characteristic (ROC), or ROC curve, is a graphical plot which illustrates the performance of a variant quality value score of a Query Call Set as its discrimination threshold is varied, compared to the Truth Call Set. The curve is created by plotting the true positive rate against the false positive rate at various threshold settings. Commonly used quality value scores include GQ (genotype quality), VQSLOD, and AVR. An important rule of ROC curve generation is that TP plus FN should equal the total number of variants in the baseline Truth Call Set.

**Area under the ROC curve:** Area under the ROC the full curve (AUC) , or to a specified FP or TP threshold selected by the user. The greater the area, the better the performance of the scoring system. Ideally, the full raw set of variants in the Query Call Set is provided without filtering since different TP/FP rates may be required for different applications. The above metrics can also be calculated at the given specified FP or TP threshold.

**Note #1**: Prior to performing the comparison, hap.py will decompose complex variants into individual SNPs and indels when possible to better compare metrics from different callsets. 

**Note #2**: After performing the comparison, variants outside high-confidence regions defined in the Truth Call Set are excluded from TP, FP, and FN counts and counted instead as NA. This will remove most comparison problems where only half of a complex variant is included in the Truth Call Set or Query Call Set due to ignoring calls outside the high-confidence regions.


**Comparison Method #2: Allele Match Required**

**Positives (P):** the number of true ALT alleles (see Note #1 below about homozygous and compound heterozygous sites)

**Negatives (N):** the number of true hom-REF bases (*i.e*, the number of bases in the high-confidence regions minus the bases covered by true ALT alleles)

**True Positive (TP):** an ALT allele in the Truth Call Set for which there is a path through the Query Call Set that contains this allele. Genotype match is not required (*e.g.*, if Truth Call Set is hom-ALT and Query Call Set is ALT/REF, then it is a TP and not an FP or FN.) No-calls are considered to be hom-REF.

**False Positive (FP):** an ALT allele in the Query Call Set for which there is no path through the Truth Call Set that contains this allele

**False Negative (FN):** an ALT allele in the Truth Call Set for which there is no path through the Query Call Set that contains this allele. P=FN+TP always stands.

**True Negative (TN):** the number of bases in the high-confidence regions that are not "no-called" or Missing in the Query Call Set (note that this is an approximation that assumes only a small fraction of bases are positives (usually about 0.1 %))

**Not Assessed (QUERY.UNK):** a variant in the Query Call Set that is not in the high-confidence regions of the Truth Call Set

**Fraction Not Assessed (METRIC.Frac_NA):** QUERY.UNK/QUERY.TOTAL

**Missing (M):** a variant in the Truth Call Set that is outside the bed file accompanying the Query Call Set (if applicable)

**No-call (NC):** number of no-call/no-call bases (including partial no-calls) that overlap the P+N regions. Only the positions covered by the REF string are included as no-call bases. This is the same as in Comparison Method #1

**No-call variant (NCV):** an ALT allele in the Truth Call Set for which there is no path through the Query Call Set that contains this allele but there is a path through the Query Call Set that contains a no-call or half-call**No-call variant (NCV):** a variant site in the Truth Call Set that is within x-bp of any no-call or partial no-call in the Query Call Set and not within x-bp of a variant call (i.e., these are a subset of TPs that are TPs only because of their proximity to a no-call)

**Genotype error (GE):** Site with the correct variant allele but incorrect genotype

**Genotype error rate (GER):** GE/TP

**Recall** (aka, True Positive Rate or Sensitivity): TP/(TP+FN)

**Precision** (AKA, Positive Predictive Value): TP/(TP+FP)

**Negative Predictive Value:** FP/(FP+FN)

**False Positive Rate (FPR):** FP/N

**No-call Rate:** NC / (P+N)

**No-call Variant Rate:** NCV / (P)

**ROC Curve:** A receiver operating characteristic (ROC), or ROC curve, is a graphical plot which illustrates the performance of a variant quality value score of a Query Call Set as its discrimination threshold is varied, compared to the Truth Call Set. The curve is created by plotting the true positive rate against the false positive rate at various threshold settings. Commonly used quality value scores include GQ (genotype quality), VQSLOD, and AVR. An important rule of ROC curve generation is that TP plus FN should equal the total number of variants in the baseline Truth Call Set.

**Area under the ROC curve:** Area under the ROC the full curve, or to a specified FP or TP threshold selected by the user. The greater the area, the better the performance of the scoring system. Ideally, the full raw set of variants in the Query Call Set is provided without filtering since different TP/FP rates may be required for different applications. The above metrics can also be calculated at the given specified FP or TP threshold.

**Note #1:** A homozygous variant shall be considered a single ALT allele, but a compound heterozygous variant at a single site shall be considered two separate ALT alleles

**Note #2**: Prior to performing the comparison, hap.py will decompose complex variants into individual SNPs and indels when possible to better compare metrics from different callsets. 

**Note #3**: After performing the comparison, variants outside high-confidence regions defined in the Truth Call Set are excluded from TP, FP, and FN counts and counted instead as NA. This will remove most comparison problems where only half of a complex variant is included in the Truth Call Set or Query Call Set due to ignoring calls outside the high-confidence regions.


**Comparison Method #3: Genotype Match Required**

**Positives (TRUTH.TOTAL):** the number of sites that are not hom-REF (complex variants are treated as multiple sites - see Note #1 below)

**Query total sites (QUERY.TOTAL):** the number of sites in Query Call Set that are not hom-REF (complex variants are treated as multiple sites - see Note #1 below)

**Negatives (N):** the number of true hom-REF bases (*i.e.*, the number of bases in the high-confidence regions minus the bases covered by true P sites)

**True Positive in Truth (TRUTH.TP):** a site in the Truth Call Set for which there are paths through the Query Call Set that are consistent with all of the alleles at this site, and for which there is an accurate genotype call for the event. Phasing of complex variants is not required. No-calls and partial no-calls are considered to be hom-REF.

**True Positive in Query (QUERY.TP):** a site in the Query Call Set for which there are paths through the Truth Call Set that are consistent with all of the alleles at this site, and for which there is an accurate genotype call for the event. Phasing of complex variants is not required. No-calls and partial no-calls are considered to be hom-REF.

**False Positive (QUERY.FP):** a site in the Query Call Set for which there is no path through the Truth Call Set that is consistent with this site. Sites with correct variant but incorrect genotype are counted here.

**False Negative (TRUTH.FN):** a site in the Truth Call Set for which there is no path through the Query Call Set that is consistent with all of the alleles at this site, or sites for which there is an inaccurate genotype call for the event. No-calls and partial no-calls are considered to be hom-REF. P=FN+TP always stands. Sites with correct variant but incorrect genotype are counted here.

**True Negative (TN):** the number of bases in the high-confidence regions that are not "no-called" or Missing in the Query Call Set (note that this is an approximation that assumes only a small fraction of bases are positives (usually about 0.1 %))

**Not Assessed (QUERY.UNK):** a variant in the Query Call Set that is not in the high-confidence regions of the Truth Call Set

**Fraction Not Assessed (METRIC.Frac_NA):** QUERY.UNK/QUERY.TOTAL

**Missing (M):** a variant in the Truth Call Set that is outside the bed file accompanying the Query Call Set (if applicable)

**No-call (NC):** number of no-call/no-call bases (including partial no-calls) that overlap the P+N regions. Only the positions covered by the REF string are included as no-call bases. 

**No-call variant (NCV):** an ALT allele in the Truth Call Set for which the path through the Query Call Set contains a no-call or half-call

**Genotype error (FP.gt):** Site with the correct variant allele but incorrect genotype

**Allele error (FP.al):** Site with the correct position of the variant but at least one incorrect variant allele. 

**Genotype error rate (GER):** FP.GT/TRUTH.TP

**Recall (METRIC.Recall)** (aka, True Positive Rate or Sensitivity): TRUTH.TP/(TRUTH.TP+TRUTH.FN)

**Precision (METRIC.Precision)** (aka, Positive Predictive Value): TRUTH.TP/(TRUTH.TP+QUERY.FP)

**Negative Predictive Value:** QUERY.FP/(QUERY.FP+TRUTH.FN)

**False Positive Rate (FPR):** QUERY.FP/N

**ROC Curve:** A receiver operating characteristic (ROC), or ROC curve, is a graphical plot which illustrates the performance of a variant quality value score of a Query Call Set as its discrimination threshold is varied, compared to the Truth Call Set. The curve is created by plotting the true positive rate against the false positive rate at various threshold settings. Commonly used quality value scores include GQ (genotype quality), VQSLOD, and AVR. An important rule of ROC curve generation is that TP plus FN should equal the total number of variants in the baseline Truth Call Set.

**Area under the ROC curve:** Area under the ROC the full curve, or to a specified FP or TP threshold selected by the user. The greater the area, the better the performance of the scoring system. Ideally, the full raw set of variants in the Query Call Set is provided without filtering since different TP/FP rates may be required for different applications. The above metrics can also be calculated at the given specified FP or TP threshold.

**Note #1**: Prior to performing the comparison, hap.py will decompose complex variants into individual SNPs and indels when possible to better compare metrics from different callsets. 

**Note #2**: After performing the comparison, variants outside high-confidence regions defined in the Truth Call Set are excluded from TP, FP, and FN counts and counted instead as NA. This will remove most comparison problems where only half of a complex variant is included in the Truth Call Set or Query Call Set due to ignoring calls outside the high-confidence regions.


**Comparison Method #4: Genotype Match and Local Phasing Required**

**Positives (P):** the number of sites that are not hom-REF (complex variants are treated as a single site - see Note #1 below)

**Negatives (N):** the number of true hom-REF bases (*i.e.*, the number of bases in the high-confidence regions minus the bases covered by true P sites)

**True Positive (TP):** a site in the Truth Call Set for which there are paths through the Query Call Set that are consistent with all of the alleles at this site, and for which there is an accurate genotype call for the event, and for which phasing of the variants in the site is correct. No-calls and partial no-calls are considered to be hom-REF.

**False Positive (FP):** a site in the Query Call Set for which there is no path through the Truth Call Set that is consistent with this site. Genotype errors are not counted here, but phasing errors are counted here.

**False Negative (FN):** a site in the Truth Call Set for which there is no path through the Query Call Set that is consistent with all of the alleles at this site, or sites for which there is an inaccurate genotype call for the event, or sites for which phasing of the variants in the site is incorrect. No-calls and partial no-calls are considered to be hom-REF. P=FN+TP always stands.

**True Negative (TN):** the number of bases in the high-confidence regions that are not "no-called" or Missing in the Query Call Set (note that this is an approximation that assumes only a small fraction of bases are positives (usually about 0.1 %))

**Not Assessed (QUERY.UNK):** a variant in the Query Call Set that is not in the high-confidence regions of the Truth Call Set

**Fraction Not Assessed (METRIC.Frac_NA):** QUERY.UNK/QUERY.TOTAL

**Missing (M):** a variant in the Truth Call Set that is outside the bed file accompanying the Query Call Set (if applicable)

**Recall** (aka, True Positive Rate or Sensitivity): TP/(TP+FN)

**Precision** (AKA, Positive Predictive Value): TP/(TP+FP)

**Negative Predictive Value**: FP/(FP+FN)

**False Positive Rate (FPR):** FP/N

**ROC Curve:** A receiver operating characteristic (ROC), or ROC curve, is a graphical plot which illustrates the performance of a variant quality value score of a Query Call Set as its discrimination threshold is varied, compared to the Truth Call Set. The curve is created by plotting the true positive rate against the false positive rate at various threshold settings. Commonly used quality value scores include GQ (genotype quality), VQSLOD, and AVR. An important rule of ROC curve generation is that TP plus FN should equal the total number of variants in the baseline Truth Call Set.

**Area under the ROC curve:** Area under the ROC the full curve, or to a specified FP or TP threshold selected by the user. The greater the area, the better the performance of the scoring system. Ideally, the full raw set of variants in the Query Call Set is provided without filtering since different TP/FP rates may be required for different applications. The above metrics can also be calculated at the given specified FP or TP threshold.ROC Curve: A receiver operating characteristic (ROC), or ROC curve, is a graphical plot which illustrates the performance of a variant quality value score of a Query Call Set as its discrimination threshold is varied, compared to the Truth Call Set. The curve is created by plotting the true positive rate against the false positive rate at various threshold settings. Commonly used quality value scores include GQ (genotype quality), VQSLOD, and AVR. An important rule of ROC curve generation is that TP plus FN should equal the total number of variants in the baseline Truth Call Set.

**Area under the ROC curve:** Area under the ROC the full curve, or to a specified FP threshold selected by the user.

**Note #1**: Prior to performing the comparison, hap.py will decompose complex variants into individual SNPs and indels when possible to better compare metrics from different callsets. 

**Note #2**: After performing the comparison, variants outside high-confidence regions defined in the Truth Call Set are excluded from TP, FP, and FN counts and counted instead as NA. This will remove most comparison problems where only half of a complex variant is included in the Truth Call Set or Query Call Set due to ignoring calls outside the high-confidence regions.

**Note #3:** This method in general should not require a realignment-based comparison, but could likely be done with a simple comparison tool if vcfgeno2haplo or vcfallelicprimitives is run first.

**Note #4:** For generating a receiving operator characteristics (ROC) curve, the number of true positive and false positive variants must be counted. Generally each called variant will have a corresponding base line variant but due to the nature of complex calling there can be many to many relationships between baseline and called variants. To keep number of true positives plus the number of false negatives equals to the total number of calls in the baseline, each called true positive call must be weighted. See supplement of Cleary, J. G., et al. bioRxiv (2014). doi:10.1101/001958 for methods for weighting.


**Comparison Method #5: Accuracy of phasing vs. distance between variants**

*To be developed*

