# **Benchmarking Performance Stratification for SNVs and Small Indels**

A major difference between traditional measurements and genome sequencing is the large number of simultaneous tests performed.  Instead of testing one known analyte, genome sequencing effectively tests for an infinite number of potential variants, which leads to several problems for traditional performance metrics.

  First, this infinite number of potential variants means that any genome sequencing test has an infinite number of true negatives, so the traditional definition of specificity is meaningless because it is always 1.  Therefore, other metrics for false positives are usually used, such as False Discovery Rate, false positive rate per base pair, false positive rate per test, or false positive rate per gene.

The second problem with the infinite number of potential variants is that it is impossible for a lab to test sensitivity and specificity for every potential variant.  One solution to this problem is to sequence one or more samples that are well-characterized, such as the NIST Reference Materials being characterized by the GIAB.  Then, if the lab assumes that the variants and homozygous reference regions in these samples are representative of all variants and homozygous reference regions, the lab can report their performance for the test.  There are two potential problems with this method.  First, the variants and homozygous reference regions in the reference materials are often not representative of the variants a typical clinical lab is interested in, both because clinically interesting variants are often rare or even novel and because only the easier-to-sequence regions are characterized. Second, the performance metrics for the test as a whole are often misleading because the test might perform very well for certain types of variants (e.g., SNVs in easy parts of the genome) and very poorly for other types of variants (e.g., indels in large repetitive regions). In practice, this might mean that a lab decides to validate every variant with a different technology, when in fact they might only need to validate a small fraction of variants in difficult regions. Therefore, to understand performance, it is important to stratify variants and the genome into different types of variants and sequence contexts. Stratification also helps address the problem of understanding whether the variants and regions in the reference material are representative of the variants and regions in which the lab is interested.

An initial step in understanding how to stratify variants is to collect the different potential ways to stratify into categories and develop methods to stratify variants into these categories. Stratification can be performed in several distinct ways: by variant type, by sequence context, by functional significance, and by characteristics of the sequencing reads.  These different ways to stratify can be combined in a multitude of ways (e.g., SNVs in homopolymers in exons with coverage > 20), which can help focus validation only on specific types of variants for which performance is poor.  However, it should be noted that as performance is stratified into increasingly smaller categories, there may no longer be sufficient variants or homozygous reference bases to get useful estimates of performance metrics because the confidence intervals on the metrics become too large.  Therefore, it will be necessary to understand how best to stratify variants for each sequencing and bioinformatics pipeline.

The software shall be able to output performance for different types of variants:

* SNVs

* insertions <50bp

* deletions < 50bp

* complex variants (SNVs and indels within 50bp of each other and total change of <50bp, including compound heterozygous or multiallelic calls at a single position). These could be further sub-divided:

        * All SNVs *vs.* >0 indels

        * All homozygous vs 1 heterozygous vs >1 heterozygous compound vs >1 heterozygous on single haplotype

* insertions 50-200bp

* deletions 50-200bp

* insertions >200bp

* deletions >200bp

* inversions

* tandem duplications

* copy number gain/dispersed duplications

* complex structural variant (not a simple deletion, insertion, or inversion) with total bases changed >=50bp (Eventually, we might want to sub-divide this into those containing an inversion or not, and those with a net gain or loss of bases)

* large "sequence alteration" (from NCBI, but unclear how this differs from complex SVs

* The high-confidence calls will be pre-annotated with these. How should we annotate the FP variants in the assessed call-set? In particular, if a SNV or indel is called incorrectly inside or near a real complex variant, should it be classified as a FP SNV or indel and FN complex variant, or put in a separate category as a partially called complex variant?

The software shall be able to output performance for different sequence contexts (italicized have standard bed files created for GRCh37):

* *Homopolymers (3-5bp)*

* *Homopolymers (6-10bp)*

* *Homopolymers (>10bp)*

* *tandem repeats with unit of 2, 3, or 4 bp and length 11-50bp*

* *tandem repeats with unit of 2, 3, or 4 bp and length 51-200bp*

* *tandem repeats with unit of 2, 3, or 4 bp and length >200bp*

* *other low complexity regions** (including imperfect homopolymers and tandem repeats of all unit lengths)*

    * *Use output from TRDB for hg19, selecting only regions with >=95% identity*

        * *divide into those with unit length <=6bp and >6bp*

        * *Divide into total length <51bp, 51-200bp, and >200bp (from beginning of first copy to end of last copy)*

    * *Alternatively, Heng Li contributed low complexity regions based on DUST *

* *GC content <15%, 15-20%, 20-25%, 25-30%, 30-65%, 65-70%, 70-75%, 75-80%, 80-85% or >85% (in 100bp region + 50bp on each side)*

* *difficult to map regions** *

    * *use GEM mappability tool*

        * *read lengths of 100, 125, 150, and 250bp*

        * *allowing 0, 1, or 2 substitutions with no indels, or 2 substitutions with 1 indel <15bp *

* Segmental duplications

    * *in reference assembly - self-chain tool from Kevin Jacobs*

    * Eichler group list, including those not in reference assembly

* SNVs and indels at breakpoints of an SV (we’re still working on developing a good list of SV regions, but these will definitely be incomplete)

* SNVs and indels called inside an SV (unclear what these mean for CNVs)

* Bed files defining the above regions shall be zero-based. The sequence context shall be defined by a central group and all programs shall use the same set of regions.

* "Poison Motifs" (will be tech specific)

The software shall be able to output performance for different categories of potentially "functional" variants:

* whole genome

* exome **- What definition to use? Give multiple options (****RefSeq****, Ensembl, GenCode, others?)**

    * *Coding RefSeq bed file*

* promoters

* first exons

* synonymous

* nonsynonymous

* truncating

* splice site

* enhancer regions (and "super-enhancers")

* centromeres, telomeres, *etc.*

* "Bad promoters" from http://genomebiology.com/content/supplementary/gb-2013-14-5-r51-s1.txt

* Bed files defining the above regions shall be zero-based. The functional elements of the assembly shall be defined by a central resource and used by all programs. **We probably can’t pre-calculate this for synonymous, nonsynonymous, truncating, and maybe splice-site mutations**

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

