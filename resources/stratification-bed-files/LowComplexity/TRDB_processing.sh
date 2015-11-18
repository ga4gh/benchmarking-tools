#!/bin/sh

#  TRDB_processing.sh
#  
#
#  Created by Zook, Justin on 4/1/15.
#

#awk -v OFS="	" '{print $15,$2,$3,$4,$5,$6}' /Users/jzook/Google\ Drive/Benchmarking\ Task\ Team/StratificationBedFiles/LowComplexity/Human_Full_Genome_TRDB_hg19_150331.txt | sed 's/chr//;s/FastaHeader/#chr/' | /Applications/bioinfo/tabix-0.2.6/bgzip > /Users/jzook/Google\ Drive/Benchmarking\ Task\ Team/StratificationBedFiles/LowComplexity/Human_Full_Genome_TRDB_hg19_150331.bed.gz

#/Applications/bioinfo/BEDTools-Version-2.16.2/bin/mergeBed -i /Users/jzook/Google\ Drive/Benchmarking\ Task\ Team/StratificationBedFiles/LowComplexity/Human_Full_Genome_TRDB_hg19_150331.bed.gz | /Applications/bioinfo/tabix-0.2.6/bgzip > /Users/jzook/Google\ Drive/Benchmarking\ Task\ Team/StratificationBedFiles/LowComplexity/Human_Full_Genome_TRDB_hg19_150331_all_merged.bed.gz

#awk '$6>94' /Users/jzook/Google\ Drive/Benchmarking\ Task\ Team/StratificationBedFiles/LowComplexity/Human_Full_Genome_TRDB_hg19_150331.bed.gz | /Applications/bioinfo/BEDTools-Version-2.16.2/bin/mergeBed -i stdin | /Applications/bioinfo/tabix-0.2.6/bgzip > /Users/jzook/Google\ Drive/Benchmarking\ Task\ Team/StratificationBedFiles/LowComplexity/Human_Full_Genome_TRDB_hg19_150331_all_gt95identity_merged.bed.gz

#awk '$4<7 && $6>94 && $3-$2>200' /Users/jzook/Google\ Drive/Benchmarking\ Task\ Team/StratificationBedFiles/LowComplexity/Human_Full_Genome_TRDB_hg19_150331.bed.gz | /Applications/bioinfo/BEDTools-Version-2.16.2/bin/mergeBed -i stdin | /Applications/bioinfo/tabix-0.2.6/bgzip > /Users/jzook/Google\ Drive/Benchmarking\ Task\ Team/StratificationBedFiles/LowComplexity/Human_Full_Genome_TRDB_hg19_150331_TRlt7_gt200bp_gt95identity_merged.bed.gz

#awk '$4<7 && $6>94 && $3-$2>50 && $3-$2<201' /Users/jzook/Google\ Drive/Benchmarking\ Task\ Team/StratificationBedFiles/LowComplexity/Human_Full_Genome_TRDB_hg19_150331.bed.gz | /Applications/bioinfo/BEDTools-Version-2.16.2/bin/mergeBed -i stdin | /Applications/bioinfo/tabix-0.2.6/bgzip > /Users/jzook/Google\ Drive/Benchmarking\ Task\ Team/StratificationBedFiles/LowComplexity/Human_Full_Genome_TRDB_hg19_150331_TRlt7_51to200bp_gt95identity_merged.bed.gz

#awk '$4<7 && $6>94 && $3-$2<51' /Users/jzook/Google\ Drive/Benchmarking\ Task\ Team/StratificationBedFiles/LowComplexity/Human_Full_Genome_TRDB_hg19_150331.bed.gz | /Applications/bioinfo/BEDTools-Version-2.16.2/bin/mergeBed -i stdin | /Applications/bioinfo/tabix-0.2.6/bgzip > /Users/jzook/Google\ Drive/Benchmarking\ Task\ Team/StratificationBedFiles/LowComplexity/Human_Full_Genome_TRDB_hg19_150331_TRlt7_lt51bp_gt95identity_merged.bed.gz


#awk '$4>6 && $6>94 && $3-$2>200' /Users/jzook/Google\ Drive/Benchmarking\ Task\ Team/StratificationBedFiles/LowComplexity/Human_Full_Genome_TRDB_hg19_150331.bed.gz | /Applications/bioinfo/BEDTools-Version-2.16.2/bin/mergeBed -i stdin | /Applications/bioinfo/tabix-0.2.6/bgzip > /Users/jzook/Google\ Drive/Benchmarking\ Task\ Team/StratificationBedFiles/LowComplexity/Human_Full_Genome_TRDB_hg19_150331_TRgt6_gt200bp_gt95identity_merged.bed.gz

#awk '$4>6 && $6>94 && $3-$2>50 && $3-$2<201' /Users/jzook/Google\ Drive/Benchmarking\ Task\ Team/StratificationBedFiles/LowComplexity/Human_Full_Genome_TRDB_hg19_150331.bed.gz | /Applications/bioinfo/BEDTools-Version-2.16.2/bin/mergeBed -i stdin | /Applications/bioinfo/tabix-0.2.6/bgzip > /Users/jzook/Google\ Drive/Benchmarking\ Task\ Team/StratificationBedFiles/LowComplexity/Human_Full_Genome_TRDB_hg19_150331_TRgt6_51to200bp_gt95identity_merged.bed.gz

#awk '$4>6 && $6>94 && $3-$2<51' /Users/jzook/Google\ Drive/Benchmarking\ Task\ Team/StratificationBedFiles/LowComplexity/Human_Full_Genome_TRDB_hg19_150331.bed.gz | /Applications/bioinfo/BEDTools-Version-2.16.2/bin/mergeBed -i stdin | /Applications/bioinfo/tabix-0.2.6/bgzip > /Users/jzook/Google\ Drive/Benchmarking\ Task\ Team/StratificationBedFiles/LowComplexity/Human_Full_Genome_TRDB_hg19_150331_TRgt6_lt51bp_gt95identity_merged.bed.gz


#merge all repeats from TRDB and findSimpleRegions_quad.py in 3 size ranges: <51bp, 51-200, and | /Applications/bioinfo/tabix-0.2.6/bgzip >200bp
/Applications/bioinfo/BEDTools-Version-2.16.2/bin/complementBed -i /Users/jzook/Google\ Drive/Benchmarking\ Task\ Team/StratificationBedFiles/LowComplexity/Human_Full_Genome_TRDB_hg19_150331_TRlt7_lt51bp_gt95identity_merged.bed.gz -g /Applications/bioinfo/BEDTools-Version-2.16.2/genomes/human.b37.genome | /Applications/bioinfo/BEDTools-Version-2.16.2/bin/subtractBed -a stdin -b /Volumes/SSD960/references/findSimpleRegions/SimpleRepeat_homopolymer_6to10.bed.gz | /Applications/bioinfo/BEDTools-Version-2.16.2/bin/subtractBed -a stdin -b /Volumes/SSD960/references/findSimpleRegions/SimpleRepeat_homopolymer_gt10.bed.gz | /Applications/bioinfo/BEDTools-Version-2.16.2/bin/subtractBed -a stdin -b /Volumes/SSD960/references/findSimpleRegions/SimpleRepeat_diTR_11to50.bed.gz | /Applications/bioinfo/BEDTools-Version-2.16.2/bin/subtractBed -a stdin -b /Volumes/SSD960/references/findSimpleRegions/SimpleRepeat_triTR_11to50.bed.gz | /Applications/bioinfo/BEDTools-Version-2.16.2/bin/subtractBed -a stdin -b /Volumes/SSD960/references/findSimpleRegions/SimpleRepeat_quadTR_11to50.bed.gz | /Applications/bioinfo/BEDTools-Version-2.16.2/bin/subtractBed -a stdin -b /Users/jzook/Google\ Drive/Benchmarking\ Task\ Team/StratificationBedFiles/LowComplexity/Human_Full_Genome_TRDB_hg19_150331_TRgt6_lt51bp_gt95identity_merged.bed.gz | /Applications/bioinfo/BEDTools-Version-2.16.2/bin/complementBed -i stdin -g /Applications/bioinfo/BEDTools-Version-2.16.2/genomes/human.b37.genome | /Applications/bioinfo/tabix-0.2.6/bgzip > /Users/jzook/Google\ Drive/Benchmarking\ Task\ Team/StratificationBedFiles/LowComplexity/AllRepeats_lt51bp_gt95identity_merged.bed.gz

/Applications/bioinfo/BEDTools-Version-2.16.2/bin/complementBed -i /Users/jzook/Google\ Drive/Benchmarking\ Task\ Team/StratificationBedFiles/LowComplexity/Human_Full_Genome_TRDB_hg19_150331_TRlt7_51to200bp_gt95identity_merged.bed.gz -g /Applications/bioinfo/BEDTools-Version-2.16.2/genomes/human.b37.genome | /Applications/bioinfo/BEDTools-Version-2.16.2/bin/subtractBed -a stdin -b /Volumes/SSD960/references/findSimpleRegions/SimpleRepeat_diTR_51to200.bed.gz | /Applications/bioinfo/BEDTools-Version-2.16.2/bin/subtractBed -a stdin -b /Volumes/SSD960/references/findSimpleRegions/SimpleRepeat_triTR_51to200.bed.gz | /Applications/bioinfo/BEDTools-Version-2.16.2/bin/subtractBed -a stdin -b /Volumes/SSD960/references/findSimpleRegions/SimpleRepeat_quadTR_51to200.bed.gz | /Applications/bioinfo/BEDTools-Version-2.16.2/bin/subtractBed -a stdin -b /Users/jzook/Google\ Drive/Benchmarking\ Task\ Team/StratificationBedFiles/LowComplexity/Human_Full_Genome_TRDB_hg19_150331_TRgt6_51to200bp_gt95identity_merged.bed.gz | /Applications/bioinfo/BEDTools-Version-2.16.2/bin/complementBed -i stdin -g /Applications/bioinfo/BEDTools-Version-2.16.2/genomes/human.b37.genome | /Applications/bioinfo/tabix-0.2.6/bgzip > /Users/jzook/Google\ Drive/Benchmarking\ Task\ Team/StratificationBedFiles/LowComplexity/AllRepeats_51to200bp_gt95identity_merged.bed.gz

/Applications/bioinfo/BEDTools-Version-2.16.2/bin/complementBed -i /Users/jzook/Google\ Drive/Benchmarking\ Task\ Team/StratificationBedFiles/LowComplexity/Human_Full_Genome_TRDB_hg19_150331_TRlt7_gt200bp_gt95identity_merged.bed.gz -g /Applications/bioinfo/BEDTools-Version-2.16.2/genomes/human.b37.genome | /Applications/bioinfo/BEDTools-Version-2.16.2/bin/subtractBed -a stdin -b /Volumes/SSD960/references/findSimpleRegions/SimpleRepeat_diTR_gt200.bed.gz | /Applications/bioinfo/BEDTools-Version-2.16.2/bin/subtractBed -a stdin -b /Volumes/SSD960/references/findSimpleRegions/SimpleRepeat_triTR_gt200.bed.gz | /Applications/bioinfo/BEDTools-Version-2.16.2/bin/subtractBed -a stdin -b /Volumes/SSD960/references/findSimpleRegions/SimpleRepeat_quadTR_gt200.bed.gz | /Applications/bioinfo/BEDTools-Version-2.16.2/bin/subtractBed -a stdin -b /Users/jzook/Google\ Drive/Benchmarking\ Task\ Team/StratificationBedFiles/LowComplexity/Human_Full_Genome_TRDB_hg19_150331_TRgt6_gt200bp_gt95identity_merged.bed.gz | /Applications/bioinfo/BEDTools-Version-2.16.2/bin/complementBed -i stdin -g /Applications/bioinfo/BEDTools-Version-2.16.2/genomes/human.b37.genome | /Applications/bioinfo/tabix-0.2.6/bgzip > /Users/jzook/Google\ Drive/Benchmarking\ Task\ Team/StratificationBedFiles/LowComplexity/AllRepeats_gt200bp_gt95identity_merged.bed.gz


#awk '{sum+=$3;sum-=$2} END {print sum}'  /Users/jzook/Google\ Drive/Benchmarking\ Task\ Team/StratificationBedFiles/LowComplexity/Human_Full_Genome_TRDB_hg19_150331_all_merged.bed
#71143602
#awk '{sum+=$3;sum-=$2} END {print sum}'  /Users/jzook/Google\ Drive/Benchmarking\ Task\ Team/StratificationBedFiles/LowComplexity/Human_Full_Genome_TRDB_hg19_150331_all_gt95identity_merged.bed
#23789309
#awk '{sum+=$3;sum-=$2} END {print sum}'  /Users/jzook/Google\ Drive/Benchmarking\ Task\ Team/StratificationBedFiles/LowComplexity/Human_Full_Genome_TRDB_hg19_150331_TRlt7_gt100bp_gt95identity_merged.bed
#140076
#awk '{sum+=$3;sum-=$2} END {print sum}'  /Users/jzook/Google\ Drive/Benchmarking\ Task\ Team/StratificationBedFiles/LowComplexity/Human_Full_Genome_TRDB_hg19_150331_TRlt7_lt101bp_gt95identity_merged.bed
#7181114
#awk '{sum+=$3;sum-=$2} END {print sum}'  /Users/jzook/Google\ Drive/Benchmarking\ Task\ Team/StratificationBedFiles/LowComplexity/Human_Full_Genome_TRDB_hg19_150331_TRgt6_gt100bp_gt95identity_merged.bed
#8568047
#awk '{sum+=$3;sum-=$2} END {print sum}'  /Users/jzook/Google\ Drive/Benchmarking\ Task\ Team/StratificationBedFiles/LowComplexity/Human_Full_Genome_TRDB_hg19_150331_TRgt6_lt101bp_gt95identity_merged.bed
#8167453



