#!/bin/sh

#  seqtk_gc.sh
#  Generate standardized GC content bed files with different GC content ranges using seqtk for the Global Alliance for Genomics and Health Benchmarking Team and Genome in a Bottle
#  First generate regions with <15, 20, 25, and 30% GC and >55, 60, 65, 70, 75, 80, and 85 % GC
#  Expand by 50bp on each side to get "200 bp regions in which the middle 100bp contains <x% or >x% GC", based on doi:10.1186/gb-2013-14-5-r51
#  Subtract more stringent bed from less stringent bed to get GC content ranges
#  Everything else goes in 30to65 bed file for moderate GC (this range was chosen based on where coverage starts decreasing or error rates start increasing for any technology in doi:10.1186/gb-2013-14-5-r51
#  Note that after adding 50bp slop, 272336 bp overlap between gc30 and gc65, or 0.07% of gc30 and 0.5% of gc65, so the bed files with different GC ranges are almost exclusive of each other, but not completely
#  Created by Zook, Justin at the National Institute of Standards and Technology on 3/30/15.
#

/Applications/bioinfo/seqtk/seqtk gc -f 0.55 -l 100 /Volumes/SSD960/references/human_g1k_v37.fasta  > /Volumes/SSD960/references/human_g1k_v37_l100_gc55.bed

/Applications/bioinfo/seqtk/seqtk gc -f 0.6 -l 100 /Volumes/SSD960/references/human_g1k_v37.fasta  > /Volumes/SSD960/references/human_g1k_v37_l100_gc60.bed

/Applications/bioinfo/seqtk/seqtk gc -f 0.65 -l 100 /Volumes/SSD960/references/human_g1k_v37.fasta  > /Volumes/SSD960/references/human_g1k_v37_l100_gc65.bed

/Applications/bioinfo/seqtk/seqtk gc -f 0.7 -l 100 /Volumes/SSD960/references/human_g1k_v37.fasta  > /Volumes/SSD960/references/human_g1k_v37_l100_gc70.bed

/Applications/bioinfo/seqtk/seqtk gc -f 0.75 -l 100 /Volumes/SSD960/references/human_g1k_v37.fasta  > /Volumes/SSD960/references/human_g1k_v37_l100_gc75.bed

/Applications/bioinfo/seqtk/seqtk gc -f 0.8 -l 100 /Volumes/SSD960/references/human_g1k_v37.fasta  > /Volumes/SSD960/references/human_g1k_v37_l100_gc80.bed

/Applications/bioinfo/seqtk/seqtk gc -f 0.85 -l 100 /Volumes/SSD960/references/human_g1k_v37.fasta  > /Volumes/SSD960/references/human_g1k_v37_l100_gc85.bed

#AT rich
/Applications/bioinfo/seqtk/seqtk gc -wf 0.7 -l 100 /Volumes/SSD960/references/human_g1k_v37.fasta  > /Volumes/SSD960/references/human_g1k_v37_l100_gc30.bed

/Applications/bioinfo/seqtk/seqtk gc -wf 0.75 -l 100 /Volumes/SSD960/references/human_g1k_v37.fasta  > /Volumes/SSD960/references/human_g1k_v37_l100_gc25.bed

/Applications/bioinfo/seqtk/seqtk gc -wf 0.8 -l 100 /Volumes/SSD960/references/human_g1k_v37.fasta  > /Volumes/SSD960/references/human_g1k_v37_l100_gc20.bed

/Applications/bioinfo/seqtk/seqtk gc -wf 0.85 -l 100 /Volumes/SSD960/references/human_g1k_v37.fasta  > /Volumes/SSD960/references/human_g1k_v37_l100_gc15.bed


#add 50bp on each side to get "200bp regions in which middle 100bp contains >x% GC or <x% GC
/Applications/bioinfo/BEDTools-Version-2.16.2/bin/slopBed -i /Volumes/SSD960/references/human_g1k_v37_l100_gc55.bed -g /Applications/bioinfo/BEDTools-Version-2.16.2/genomes/human.b37.genome -b 50 | awk '$3>0' | /Applications/bioinfo/BEDTools-Version-2.16.2/bin/mergeBed -i stdin > /Volumes/SSD960/references/human_g1k_v37_l100_gc55_slop50.bed

/Applications/bioinfo/BEDTools-Version-2.16.2/bin/slopBed -i /Volumes/SSD960/references/human_g1k_v37_l100_gc60.bed -g /Applications/bioinfo/BEDTools-Version-2.16.2/genomes/human.b37.genome -b 50 | awk '$3>0' | /Applications/bioinfo/BEDTools-Version-2.16.2/bin/mergeBed -i stdin > /Volumes/SSD960/references/human_g1k_v37_l100_gc60_slop50.bed

/Applications/bioinfo/BEDTools-Version-2.16.2/bin/slopBed -i /Volumes/SSD960/references/human_g1k_v37_l100_gc65.bed -g /Applications/bioinfo/BEDTools-Version-2.16.2/genomes/human.b37.genome -b 50 | awk '$3>0' | /Applications/bioinfo/BEDTools-Version-2.16.2/bin/mergeBed -i stdin > /Volumes/SSD960/references/human_g1k_v37_l100_gc65_slop50.bed

/Applications/bioinfo/BEDTools-Version-2.16.2/bin/slopBed -i /Volumes/SSD960/references/human_g1k_v37_l100_gc70.bed -g /Applications/bioinfo/BEDTools-Version-2.16.2/genomes/human.b37.genome -b 50 | awk '$3>0' | /Applications/bioinfo/BEDTools-Version-2.16.2/bin/mergeBed -i stdin > /Volumes/SSD960/references/human_g1k_v37_l100_gc70_slop50.bed

/Applications/bioinfo/BEDTools-Version-2.16.2/bin/slopBed -i /Volumes/SSD960/references/human_g1k_v37_l100_gc75.bed -g /Applications/bioinfo/BEDTools-Version-2.16.2/genomes/human.b37.genome -b 50 | awk '$3>0' | /Applications/bioinfo/BEDTools-Version-2.16.2/bin/mergeBed -i stdin > /Volumes/SSD960/references/human_g1k_v37_l100_gc75_slop50.bed

/Applications/bioinfo/BEDTools-Version-2.16.2/bin/slopBed -i /Volumes/SSD960/references/human_g1k_v37_l100_gc80.bed -g /Applications/bioinfo/BEDTools-Version-2.16.2/genomes/human.b37.genome -b 50 | awk '$3>0' | /Applications/bioinfo/BEDTools-Version-2.16.2/bin/mergeBed -i stdin > /Volumes/SSD960/references/human_g1k_v37_l100_gc80_slop50.bed

/Applications/bioinfo/BEDTools-Version-2.16.2/bin/slopBed -i /Volumes/SSD960/references/human_g1k_v37_l100_gc85.bed -g /Applications/bioinfo/BEDTools-Version-2.16.2/genomes/human.b37.genome -b 50 | awk '$3>0' | /Applications/bioinfo/BEDTools-Version-2.16.2/bin/mergeBed -i stdin > /Volumes/SSD960/references/human_g1k_v37_l100_gc85_slop50.bed

/Applications/bioinfo/BEDTools-Version-2.16.2/bin/slopBed -i /Volumes/SSD960/references/human_g1k_v37_l100_gc30.bed -g /Applications/bioinfo/BEDTools-Version-2.16.2/genomes/human.b37.genome -b 50 | awk '$3>0' | /Applications/bioinfo/BEDTools-Version-2.16.2/bin/mergeBed -i stdin > /Volumes/SSD960/references/human_g1k_v37_l100_gc30_slop50.bed

/Applications/bioinfo/BEDTools-Version-2.16.2/bin/slopBed -i /Volumes/SSD960/references/human_g1k_v37_l100_gc25.bed -g /Applications/bioinfo/BEDTools-Version-2.16.2/genomes/human.b37.genome -b 50 | awk '$3>0' | /Applications/bioinfo/BEDTools-Version-2.16.2/bin/mergeBed -i stdin > /Volumes/SSD960/references/human_g1k_v37_l100_gc25_slop50.bed

/Applications/bioinfo/BEDTools-Version-2.16.2/bin/slopBed -i /Volumes/SSD960/references/human_g1k_v37_l100_gc20.bed -g /Applications/bioinfo/BEDTools-Version-2.16.2/genomes/human.b37.genome -b 50 | awk '$3>0' | /Applications/bioinfo/BEDTools-Version-2.16.2/bin/mergeBed -i stdin > /Volumes/SSD960/references/human_g1k_v37_l100_gc20_slop50.bed

/Applications/bioinfo/BEDTools-Version-2.16.2/bin/slopBed -i /Volumes/SSD960/references/human_g1k_v37_l100_gc15.bed -g /Applications/bioinfo/BEDTools-Version-2.16.2/genomes/human.b37.genome -b 50 | awk '$3>0' | /Applications/bioinfo/BEDTools-Version-2.16.2/bin/mergeBed -i stdin > /Volumes/SSD960/references/human_g1k_v37_l100_gc15_slop50.bed

#get ranges of GC content by subtracting more stringent from more lenient gc contents.  Note that after adding 50bp slop, 272336 bp overlap between gc30 and gc65, or 0.07% of gc30 and 0.5% of gc65
#/Applications/bioinfo/BEDTools-Version-2.16.2/bin/intersectBed -a /Volumes/SSD960/references/human_g1k_v37_l100_gc65_slop50.bed -b /Volumes/SSD960/references/human_g1k_v37_l100_gc30_slop50.bed | awk '{ sum+=$3;sum-=$2 } END { print sum }'
#272336

/Applications/bioinfo/BEDTools-Version-2.16.2/bin/subtractBed -a /Volumes/SSD960/references/human_g1k_v37_l100_gc20_slop50.bed -b /Volumes/SSD960/references/human_g1k_v37_l100_gc15_slop50.bed > /Volumes/SSD960/references/human_g1k_v37_l100_gc15to20_slop50.bed

/Applications/bioinfo/BEDTools-Version-2.16.2/bin/subtractBed -a /Volumes/SSD960/references/human_g1k_v37_l100_gc25_slop50.bed -b /Volumes/SSD960/references/human_g1k_v37_l100_gc20_slop50.bed > /Volumes/SSD960/references/human_g1k_v37_l100_gc20to25_slop50.bed

/Applications/bioinfo/BEDTools-Version-2.16.2/bin/subtractBed -a /Volumes/SSD960/references/human_g1k_v37_l100_gc30_slop50.bed -b /Volumes/SSD960/references/human_g1k_v37_l100_gc25_slop50.bed > /Volumes/SSD960/references/human_g1k_v37_l100_gc25to30_slop50.bed

/Applications/bioinfo/BEDTools-Version-2.16.2/bin/subtractBed -a /Volumes/SSD960/references/human_g1k_v37_l100_gc80_slop50.bed -b /Volumes/SSD960/references/human_g1k_v37_l100_gc85_slop50.bed > /Volumes/SSD960/references/human_g1k_v37_l100_gc80to85_slop50.bed

/Applications/bioinfo/BEDTools-Version-2.16.2/bin/subtractBed -a /Volumes/SSD960/references/human_g1k_v37_l100_gc75_slop50.bed -b /Volumes/SSD960/references/human_g1k_v37_l100_gc80_slop50.bed > /Volumes/SSD960/references/human_g1k_v37_l100_gc75to80_slop50.bed

/Applications/bioinfo/BEDTools-Version-2.16.2/bin/subtractBed -a /Volumes/SSD960/references/human_g1k_v37_l100_gc70_slop50.bed -b /Volumes/SSD960/references/human_g1k_v37_l100_gc75_slop50.bed > /Volumes/SSD960/references/human_g1k_v37_l100_gc70to75_slop50.bed

/Applications/bioinfo/BEDTools-Version-2.16.2/bin/subtractBed -a /Volumes/SSD960/references/human_g1k_v37_l100_gc65_slop50.bed -b /Volumes/SSD960/references/human_g1k_v37_l100_gc70_slop50.bed > /Volumes/SSD960/references/human_g1k_v37_l100_gc65to70_slop50.bed

/Applications/bioinfo/BEDTools-Version-2.16.2/bin/subtractBed -a /Volumes/SSD960/references/human_g1k_v37_l100_gc60_slop50.bed -b /Volumes/SSD960/references/human_g1k_v37_l100_gc65_slop50.bed > /Volumes/SSD960/references/human_g1k_v37_l100_gc60to65_slop50.bed

/Applications/bioinfo/BEDTools-Version-2.16.2/bin/subtractBed -a /Volumes/SSD960/references/human_g1k_v37_l100_gc55_slop50.bed -b /Volumes/SSD960/references/human_g1k_v37_l100_gc60_slop50.bed > /Volumes/SSD960/references/human_g1k_v37_l100_gc55to60_slop50.bed

/Applications/bioinfo/BEDTools-Version-2.16.2/bin/subtractBed -a /Applications/bioinfo/BEDTools-Version-2.16.2/genomes/human.b37.genome.bed -b /Volumes/SSD960/references/human_g1k_v37_l100_gc55_slop50.bed | /Applications/bioinfo/BEDTools-Version-2.16.2/bin/subtractBed -a stdin -b /Volumes/SSD960/references/human_g1k_v37_l100_gc30_slop50.bed > /Volumes/SSD960/references/human_g1k_v37_l100_gc30to55_slop50.bed

awk '{ sum+=$3;sum-=$2 } END { print sum }' /Volumes/SSD960/references/human_g1k_v37_l100_gc15_slop50.bed
#5225837
awk '{ sum+=$3;sum-=$2 } END { print sum }' /Volumes/SSD960/references/human_g1k_v37_l100_gc15to20_slop50.bed
#14248633

awk '{ sum+=$3;sum-=$2 } END { print sum }' /Volumes/SSD960/references/human_g1k_v37_l100_gc20to25_slop50.bed
#116727539

awk '{ sum+=$3;sum-=$2 } END { print sum }' /Volumes/SSD960/references/human_g1k_v37_l100_gc25to30_slop50.bed
#392853128

awk '{ sum+=$3;sum-=$2 } END { print sum }' /Volumes/SSD960/references/human_g1k_v37_l100_gc85_slop50.bed
#532129
awk '{ sum+=$3;sum-=$2 } END { print sum }' /Volumes/SSD960/references/human_g1k_v37_l100_gc80to85_slop50.bed
#2569485

awk '{ sum+=$3;sum-=$2 } END { print sum }' /Volumes/SSD960/references/human_g1k_v37_l100_gc75to80_slop50.bed
#5193906

awk '{ sum+=$3;sum-=$2 } END { print sum }' /Volumes/SSD960/references/human_g1k_v37_l100_gc70to75_slop50.bed
#11661550

awk '{ sum+=$3;sum-=$2 } END { print sum }' /Volumes/SSD960/references/human_g1k_v37_l100_gc65to70_slop50.bed
#34491477

awk '{ sum+=$3;sum-=$2 } END { print sum }' /Volumes/SSD960/references/human_g1k_v37_l100_gc60to65_slop50.bed
#102128201

awk '{ sum+=$3;sum-=$2 } END { print sum }' /Volumes/SSD960/references/human_g1k_v37_l100_gc55to60_slop50.bed
#243488547

awk '{ sum+=$3;sum-=$2 } END { print sum }' /Volumes/SSD960/references/human_g1k_v37_l100_gc30to55_slop50.bed
#2176386041


/Applications/bioinfo/tabix-0.2.6/bgzip /Volumes/SSD960/references/human_g1k_v37_l100_gc15_slop50.bed

/Applications/bioinfo/tabix-0.2.6/bgzip /Volumes/SSD960/references/human_g1k_v37_l100_gc15to20_slop50.bed

/Applications/bioinfo/tabix-0.2.6/bgzip /Volumes/SSD960/references/human_g1k_v37_l100_gc20to25_slop50.bed

/Applications/bioinfo/tabix-0.2.6/bgzip /Volumes/SSD960/references/human_g1k_v37_l100_gc25to30_slop50.bed

/Applications/bioinfo/tabix-0.2.6/bgzip /Volumes/SSD960/references/human_g1k_v37_l100_gc85_slop50.bed

/Applications/bioinfo/tabix-0.2.6/bgzip /Volumes/SSD960/references/human_g1k_v37_l100_gc80to85_slop50.bed

/Applications/bioinfo/tabix-0.2.6/bgzip /Volumes/SSD960/references/human_g1k_v37_l100_gc75to80_slop50.bed

/Applications/bioinfo/tabix-0.2.6/bgzip /Volumes/SSD960/references/human_g1k_v37_l100_gc70to75_slop50.bed

/Applications/bioinfo/tabix-0.2.6/bgzip /Volumes/SSD960/references/human_g1k_v37_l100_gc65to70_slop50.bed

/Applications/bioinfo/tabix-0.2.6/bgzip /Volumes/SSD960/references/human_g1k_v37_l100_gc60to65_slop50.bed

/Applications/bioinfo/tabix-0.2.6/bgzip /Volumes/SSD960/references/human_g1k_v37_l100_gc55to60_slop50.bed

/Applications/bioinfo/tabix-0.2.6/bgzip /Volumes/SSD960/references/human_g1k_v37_l100_gc30to55_slop50.bed

cp /Volumes/SSD960/references/human_g1k_v37_l100*_slop50.bed.gz /Users/jzook/Google\ Drive/Benchmarking\ Task\ Team/StratificationBedFiles/GC/
