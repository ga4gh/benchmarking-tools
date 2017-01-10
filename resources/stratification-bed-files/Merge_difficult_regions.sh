#!/bin/sh

#  Merge_difficult_regions.sh
#  
#
#  Created by Zook, Justin on 12/13/16.
#

/Applications/bioinfo/bedtools2/bin/multiIntersectBed -i /Users/jzook/Downloads/work/bed_files/mappability/lowmappabilityall.bed.gz /Users/jzook/Downloads/work/bed_files/GCcontent/human_g1k_v37_l100_gclt25orgt65_slop50.bed.gz /Users/jzook/Downloads/work/bed_files/LowComplexity/AllRepeats_gt95percidentity_slop5.bed.gz /Users/jzook/Downloads/work/bed_files/SegmentalDuplications/segdupall.bed.gz /Users/jzook/Downloads/work/bed_files/FunctionalTechnicallyDifficultRegions/BadPromoters_gb-2013-14-5-r51-s1.bed.gz  | grep -v 'gl\|hap\|MT' | /Applications/bioinfo/bedtools2/bin/mergeBed -i stdin | /Applications/bioinfo/tabix/bgzip -c > /Users/jzook/Downloads/work/bed_files/alldifficultregions.bed.gz

/Applications/bioinfo/bedtools2/bin/intersectBed -a /Users/jzook/Documents/NA12878/PlatinumGenomes/PG2016-1.0/PG2016-1.0_NA12878_b37.vcf.gz -b /Users/jzook/Downloads/work/bed_files/alldifficultregions.bed.gz | wc -l
# 1131736
/Applications/bioinfo/bedtools2/bin/intersectBed -a /Users/jzook/Downloads/HG001_GRCh37_GIAB_highconf_CG-IllFB-IllGATKHC-Ion-10X-SOLID_CHROM1-X_v.3.3.2_highconf_RTGandPGphasetransfer.vcf.gz -b /Users/jzook/Downloads/work/bed_files/alldifficultregions.bed.gz | wc -l
#  904279

/Applications/bioinfo/bedtools2/bin/subtractBed -a /Applications/bioinfo/nist-integration-v3.1/resources/human.b37.genome.bed -b /Users/jzook/Downloads/work/bed_files/alldifficultregions.bed.gz | /Applications/bioinfo/tabix/bgzip -c > /Users/jzook/Downloads/work/bed_files/notinalldifficultregions.bed.gz

/Applications/bioinfo/bedtools2/bin/multiIntersectBed -i /Users/jzook/Downloads/work/bed_files/alldifficultregions.bed.gz /Users/jzook/Downloads/work/bed_files/GenomeSpecific/HG001_NA12878/HG001_genomespecific_RTG_PG_v3.3.2_SVs.bed.gz  | /Applications/bioinfo/bedtools2/bin/mergeBed -i stdin | /Applications/bioinfo/tabix/bgzip -c > /Users/jzook/Downloads/work/bed_files/GenomeSpecific/HG001_NA12878/HG001_genomespecific_RTG_PG_v3.3.2_SVs_alldifficultregions.bed.gz 

/Applications/bioinfo/bedtools2/bin/intersectBed -a /Users/jzook/Downloads/HG001_GRCh37_GIAB_highconf_CG-IllFB-IllGATKHC-Ion-10X-SOLID_CHROM1-X_v.3.3.2_highconf_RTGandPGphasetransfer.vcf.gz -b /Users/jzook/Downloads/work/bed_files/GenomeSpecific/HG001_NA12878/HG001_genomespecific_RTG_PG_v3.3.2_SVs_alldifficultregions.bed.gz | wc -l
# 1154476

/Applications/bioinfo/bedtools2/bin/subtractBed -a /Applications/bioinfo/nist-integration-v3.1/resources/human.b37.genome.bed -b /Users/jzook/Downloads/work/bed_files/GenomeSpecific/HG001_NA12878/HG001_genomespecific_RTG_PG_v3.3.2_SVs_alldifficultregions.bed.gz  | /Applications/bioinfo/tabix/bgzip -c > /Users/jzook/Downloads/work/bed_files/GenomeSpecific/HG001_NA12878/notinHG001_genomespecific_RTG_PG_v3.3.2_SVs_alldifficultregions.bed.gz 

/Applications/bioinfo/bedtools2/bin/multiIntersectBed -i /Users/jzook/Downloads/work/bed_files/alldifficultregions.bed.gz /Users/jzook/Downloads/work/bed_files/GenomeSpecific/HG002/HG002_genomespecific_v3.3.2_SVs.bed.gz | /Applications/bioinfo/bedtools2/bin/mergeBed -i stdin | /Applications/bioinfo/tabix/bgzip -c > /Users/jzook/Downloads/work/bed_files/GenomeSpecific/HG002/HG002_genomespecific_v3.3.2_SVs_alldifficultregions.bed.gz 

/Applications/bioinfo/bedtools2/bin/subtractBed -a /Applications/bioinfo/nist-integration-v3.1/resources/human.b37.genome.bed -b /Users/jzook/Downloads/work/bed_files/GenomeSpecific/HG002/HG002_genomespecific_v3.3.2_SVs_alldifficultregions.bed.gz | /Applications/bioinfo/tabix/bgzip -c > /Users/jzook/Downloads/work/bed_files/GenomeSpecific/HG002/notinHG002_genomespecific_v3.3.2_SVs_alldifficultregions.bed.gz 

/Applications/bioinfo/bedtools2/bin/intersectBed -a /Users/jzook/Downloads/HG002_GRCh37_GIAB_highconf_CG-IllFB-IllGATKHC-Ion-10X-SOLID_CHROM1-22_v.3.3.2_highconf_triophased.vcf.gz -b /Users/jzook/Downloads/work/bed_files/GenomeSpecific/HG002/HG002_genomespecific_v3.3.2_SVs_alldifficultregions.bed.gz | wc -l
# 1086255

#HG003
/Applications/bioinfo/bedtools2/bin/multiIntersectBed -i /Users/jzook/Downloads/work/bed_files/alldifficultregions.bed.gz /Users/jzook/Downloads/work/bed_files/GenomeSpecific/HG003/HG003_genomespecific_v3.3.2_SVs.bed.gz | /Applications/bioinfo/bedtools2/bin/mergeBed -i stdin | /Applications/bioinfo/tabix/bgzip -c > /Users/jzook/Downloads/work/bed_files/GenomeSpecific/HG003/HG003_genomespecific_v3.3.2_SVs_alldifficultregions.bed.gz 

/Applications/bioinfo/bedtools2/bin/subtractBed -a /Applications/bioinfo/nist-integration-v3.1/resources/human.b37.genome.bed -b /Users/jzook/Downloads/work/bed_files/GenomeSpecific/HG003/HG003_genomespecific_v3.3.2_SVs_alldifficultregions.bed.gz | /Applications/bioinfo/tabix/bgzip -c > /Users/jzook/Downloads/work/bed_files/GenomeSpecific/HG003/notinHG003_genomespecific_v3.3.2_SVs_alldifficultregions.bed.gz 

/Applications/bioinfo/bedtools2/bin/intersectBed -a /Users/jzook/Downloads/HG003_GRCh37_GIAB_highconf_CG-IllFB-IllGATKHC-Ion-10X_CHROM1-22_v.3.3.2_highconf.vcf.gz -b /Users/jzook/Downloads/work/bed_files/GenomeSpecific/HG003/HG003_genomespecific_v3.3.2_SVs_alldifficultregions.bed.gz | wc -l
# 1033576

#HG004
/Applications/bioinfo/bedtools2/bin/multiIntersectBed -i /Users/jzook/Downloads/work/bed_files/alldifficultregions.bed.gz /Users/jzook/Downloads/work/bed_files/GenomeSpecific/HG004/HG004_genomespecific_v3.3.2_SVs.bed.gz | /Applications/bioinfo/bedtools2/bin/mergeBed -i stdin | /Applications/bioinfo/tabix/bgzip -c > /Users/jzook/Downloads/work/bed_files/GenomeSpecific/HG004/HG004_genomespecific_v3.3.2_SVs_alldifficultregions.bed.gz 

/Applications/bioinfo/bedtools2/bin/subtractBed -a /Applications/bioinfo/nist-integration-v3.1/resources/human.b37.genome.bed -b /Users/jzook/Downloads/work/bed_files/GenomeSpecific/HG004/HG004_genomespecific_v3.3.2_SVs_alldifficultregions.bed.gz | /Applications/bioinfo/tabix/bgzip -c > /Users/jzook/Downloads/work/bed_files/GenomeSpecific/HG004/notinHG004_genomespecific_v3.3.2_SVs_alldifficultregions.bed.gz 

/Applications/bioinfo/bedtools2/bin/intersectBed -a /Users/jzook/Downloads/HG004_GRCh37_GIAB_highconf_CG-IllFB-IllGATKHC-Ion-10X_CHROM1-22_v.3.3.2_highconf.vcf.gz -b /Users/jzook/Downloads/work/bed_files/GenomeSpecific/HG004/HG004_genomespecific_v3.3.2_SVs_alldifficultregions.bed.gz | wc -l
# 1049355

#HG005
/Applications/bioinfo/bedtools2/bin/multiIntersectBed -i /Users/jzook/Downloads/work/bed_files/alldifficultregions.bed.gz /Users/jzook/Downloads/work/bed_files/GenomeSpecific/HG005/HG005_genomespecific_v3.3.2_SVs.bed.gz | /Applications/bioinfo/bedtools2/bin/mergeBed -i stdin | /Applications/bioinfo/tabix/bgzip -c > /Users/jzook/Downloads/work/bed_files/GenomeSpecific/HG005/HG005_genomespecific_v3.3.2_SVs_alldifficultregions.bed.gz 

/Applications/bioinfo/bedtools2/bin/subtractBed -a /Applications/bioinfo/nist-integration-v3.1/resources/human.b37.genome.bed -b /Users/jzook/Downloads/work/bed_files/GenomeSpecific/HG005/HG005_genomespecific_v3.3.2_SVs_alldifficultregions.bed.gz | /Applications/bioinfo/tabix/bgzip -c > /Users/jzook/Downloads/work/bed_files/GenomeSpecific/HG005/notinHG005_genomespecific_v3.3.2_SVs_alldifficultregions.bed.gz 

/Applications/bioinfo/bedtools2/bin/intersectBed -a /Users/jzook/Downloads/HG005_GRCh37_GIAB_highconf_CG-IllFB-IllGATKHC-Ion-SOLiD_CHROM1-22_v.3.3.2_highconf.vcf.gz -b /Users/jzook/Downloads/work/bed_files/GenomeSpecific/HG005/HG005_genomespecific_v3.3.2_SVs_alldifficultregions.bed.gz | wc -l
# 1086255
