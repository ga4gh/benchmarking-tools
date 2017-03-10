# GA4GH Benchmarking App 

Author: Peter Krusche <pkrusche@illumina.com>

This is a proposal for an app to implement a benchmarking workflow based on the recommendations by the
GA4GH benchmarking group.

A more detailed description of this work is available at [https://github.com/ga4gh/benchmarking-tools]()

# What it does

This app compares input VCFs to truth datasets using the hg19, hs37d5 or hg38 references
(comparison is carried out on chr1-chr22 and chrX only, but can be restricted to target regions).

# Which reference to use

* The genome reference **must** match the reference that was used to create the inputs and truthsets. 
* For GIAB GRCh**37** truthsets, you should use hs37d5 as a reference.
* For Platinum Genomes hg19 truthsets, you should use hg19 as a reference.
* GRCh**37** / hs37d5 query files will work with the hg19 reference and PG truthsets (hap.py will add chr prefixes wherever necessary), but hg19 query files will not work with GRCh37 truthsets
* for GRCh**38** / hg38, use the hg38 reference

# Advanced options

*  **Use vcfeval or xcmp**: it is possible to switch the comparison engine between xcmp (the hap.py comparison engine)
   to rtgtools vcfeval. Vcfeval will ignore all phasing constraints but has a more granular matching algorithm than
   xcmp.
*  **Use partial credit**: different variant callers might output the same variants in different
   representations. One example are MNPs -- it is possible to write these as three SNPs or as a single
   MNP record. The partial credit attempts to normalize these representational differences before
   variant comparison, such that the counts of TPs / FPs / FNs will be more comparable. This option is off by default
   since it requires more compute.
* **use GA4GH stratification regions**: select a set of stratification regions to use. **WARNING**: using "all" GA4GH stratification
  regions will take a long time and produce a result that might be difficult to interpret. Use with caution.
* **Adjust confident regions**: when using partial credit preprocessing, variants might move outside the confident regions.
  When this option is enabled, all truth variants will be included in the confident set. Note however that GiaB truthsets
  may contain additional variants which are not confident, these should be filtered out using bcftools before using this
  option.
  
# Stratification region sets

## GA4GH Repeats

| Region name | Description |
|-------------|-------------|
| lowcmp_AllRepeats_gt200bp_gt95identity_merged &nbsp;| 	All perfect and imperfect tandem repeats >200bp in length |
| lowcmp_AllRepeats_51to200bp_gt95identity_merged &nbsp;| All perfect and imperfect tandem repeats 51-200bp in length | 
| lowcmp_AllRepeats_lt51bp_gt95identity_merged	&nbsp; | All perfect and imperfect tandem repeats <51bp in length |
| segdup	&nbsp;| Segmental duplications in GRCh37 of all sizes, not including ALTs from GRCh37 |
| segdupwithalt	&nbsp; | Segmental duplications in GRCh37 >10kb, including ALTs from GRCh37 |

## GA4GH other regions

| Region name | Description |
|-----|----|
| map_siren &nbsp; | Regions considered difficult to map by amplab SiRen  | 
| tech_badpromoters &nbsp; | 1000 promoter regions with lowest relative coverage in Illumina, relatively GC-rich | 
| func_cds &nbsp; | coding exons from RefSeq | 
| decoy &nbsp; | Regions in GRCh37 to which decoy sequences in hs37d5 map | 

## GA4GH all regions


| Region name | Description |
|-----|----|
| map_l100_m2_e1 &nbsp; | Regions in which 100bp reads map to >1 location with up to 2 mismatches and up to 1 indel | 
| map_l150_m0_e0 &nbsp; | Regions in which 150bp reads map to >1 location with up to 0 mismatches and up to 0 indels | 
| map_l150_m2_e1 &nbsp; | Regions in which 150bp reads map to >1 location with up to 2 mismatches and up to 1 indel | 
| map_l150_m2_e0 &nbsp; | Regions in which 150bp reads map to >1 location with up to 2 mismatches and up to 0 indels | 
| map_l100_m1_e0 &nbsp; | Regions in which 100bp reads map to >1 location with up to 1 mismatch and up to 0 indels | 
| map_l125_m1_e0 &nbsp; | Regions in which 125bp reads map to >1 location with up to 1 mismatch and up to 0 indels | 
| map_l250_m2_e1 &nbsp; | Regions in which 250bp reads map to >1 location with up to 2 mismatches and up to 1 indel | 
| map_l250_m0_e0 &nbsp; | Regions in which 250bp reads map to >1 location with up to 0 mismatches and up to 0 indels | 
| map_l150_m1_e0 &nbsp; | Regions in which 150bp reads map to >1 location with up to 1 mismatch and up to 0 indels | 
| map_l125_m2_e0 &nbsp; | Regions in which 125bp reads map to >1 location with up to 2 mismatches and up to 0 indels | 
| map_l100_m0_e0 &nbsp; | Regions in which 100bp reads map to >1 location with up to 0 mismatches and up to 0 indels | 
| map_l250_m1_e0 &nbsp; | Regions in which 250bp reads map to >1 location with up to 1 mismatch and up to 0 indels | 
| map_l125_m2_e1 &nbsp; | Regions in which 125bp reads map to >1 location with up to 2 mismatches and up to 1 indel | 
| map_l250_m2_e0 &nbsp; | Regions in which 250bp reads map to >1 location with up to 2 mismatches and up to 0 indels | 
| map_l125_m0_e0 &nbsp; | Regions in which 125bp reads map to >1 location with up to 0 mismatches and up to 0 indels | 
| map_l100_m2_e0 &nbsp; | Regions in which 100bp reads map to >1 location with up to 2 mismatches and up to 0 indels | 
| map_siren &nbsp; | Regions considered difficult to map by amplab SiRen  | 
| tech_badpromoters &nbsp; | 1000 promoter regions with lowest relative coverage in Illumina, relatively GC-rich | 
| func_cds &nbsp; | coding exons from RefSeq | 
| lowcmp_SimpleRepeat_homopolymer_gt10 &nbsp; | Homopolymers >10bp in length | 
| lowcmp_SimpleRepeat_triTR_11to50 &nbsp; | Exact 3bp tandem repeats 11-50bp in length | 
| lowcmp_Human_Full_Genome_TRDB_hg19_150331_TRgt6_lt51bp_gt95identity_merged &nbsp; | Tandem repeats with >6bp unit size and <51bp in length and >95% identity | 
| lowcmp_Human_Full_Genome_TRDB_hg19_150331_all_merged &nbsp; | All tandem repeats from TRDB with adjacent repeats merged | 
| lowcmp_SimpleRepeat_quadTR_11to50 &nbsp; | Exact 4bp tandem repeats 11-50bp in length | 
| lowcmp_Human_Full_Genome_TRDB_hg19_150331_TRlt7_gt200bp_gt95identity_merged &nbsp; | Tandem repeats with 1-6bp unit size and >200bp in length and >95% identity | 
| lowcmp_Human_Full_Genome_TRDB_hg19_150331_TRlt7_lt101bp_gt95identity_merged &nbsp; | Tandem repeats with 1-6bp unit size and <101bp in length and >95% identity | 
| lowcmp_SimpleRepeat_quadTR_gt200 &nbsp; | Exact 4bp tandem repeats >200bp in length | 
| lowcmp_Human_Full_Genome_TRDB_hg19_150331_TRgt6_lt101bp_gt95identity_merged &nbsp; | Tandem repeats with >6bp unit size and <101bp in length and >95% identity | 
| lowcmp_AllRepeats_gt200bp_gt95identity_merged &nbsp; | All perfect and imperfect tandem repeats >200bp in length | 
| lowcmp_Human_Full_Genome_TRDB_hg19_150331_TRgt6_51to200bp_gt95identity_merged &nbsp; | Tandem repeats with >6bp unit size and 51-200bp in length and >95% identity | 
| lowcmp_Human_Full_Genome_TRDB_hg19_150331_all_gt95identity_merged &nbsp; | All tandem repeats from TRDB with >95% identity | 
| lowcmp_SimpleRepeat_triTR_gt200 &nbsp; | Exact 3bp tandem repeats >200bp in length | 
| lowcmp_SimpleRepeat_triTR_51to200 &nbsp; | Exact 3bp tandem repeats 51-200bp in length | 
| lowcmp_Human_Full_Genome_TRDB_hg19_150331_TRlt7_lt51bp_gt95identity_merged &nbsp; | Tandem repeats with 1-6bp unit size and <51bp in length and >95% identity | 
| lowcmp_Human_Full_Genome_TRDB_hg19_150331_TRlt7_51to200bp_gt95identity_merged &nbsp; | Tandem repeats with 1-6bp unit size and 51-200bp in length and >95% identity | 
| lowcmp_AllRepeats_51to200bp_gt95identity_merged &nbsp; | All perfect and imperfect tandem repeats 51-200bp in length | 
| lowcmp_Human_Full_Genome_TRDB_hg19_150331 &nbsp; | All tandem repeats from TRDB | 
| lowcmp_SimpleRepeat_quadTR_51to200 &nbsp; | Exact 4bp tandem repeats 51-200bp in length | 
| lowcmp_AllRepeats_lt51bp_gt95identity_merged &nbsp; | All perfect and imperfect tandem repeats <51bp in length | 
| lowcmp_SimpleRepeat_homopolymer_6to10 &nbsp; | All homopolymers 6-10bp in length | 
| lowcmp_SimpleRepeat_diTR_gt200 &nbsp; | Exact 2bp tandem repeats >200bp in length | 
| lowcmp_SimpleRepeat_diTR_11to50 &nbsp; | Exact 2bp tandem repeats 11-50bp in length | 
| lowcmp_SimpleRepeat_diTR_51to200 &nbsp; | Exact 2bp tandem repeats 51-200bp in length | 
| lowcmp_Human_Full_Genome_TRDB_hg19_150331_TRgt6_gt200bp_gt95identity_merged &nbsp; | Tandem repeats with >6bp unit size and >200bp in length and >95% identity | 
| segdup &nbsp; | Segmental duplications in GRCh37 of all sizes, not including ALTs from GRCh37 | 
| segdupwithalt &nbsp; | Segmental duplications in GRCh37 >10kb, including ALTs from GRCh37 | 
| decoy &nbsp; | Regions in GRCh37 to which decoy sequences in hs37d5 map | 
