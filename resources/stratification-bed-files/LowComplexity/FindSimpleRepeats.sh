#!/bin/sh

#  FindSimpleRepeats.sh
#  
#
#  Created by Zook, Justin on 3/30/15.
#
#if [ 0 -gt 1 ]; then

#homopolymers
python /Applications/bioinfo/forJustin7Nov12/findSimpleRegions_quad.py -p 3 -d 100000 -t 100000 -q 100000 /Volumes/SSD960/references/human_g1k_v37.fasta /Users/jzook/Documents/GA4GH/StratificationBedFiles/LowComplexity/SimpleRepeat_p3.bed &

python /Applications/bioinfo/forJustin7Nov12/findSimpleRegions_quad.py -p 6 -d 100000 -t 100000 -q 100000 /Volumes/SSD960/references/human_g1k_v37.fasta /Users/jzook/Documents/GA4GH/StratificationBedFiles/LowComplexity/SimpleRepeat_p6.bed &

python /Applications/bioinfo/forJustin7Nov12/findSimpleRegions_quad.py -p 11 -d 100000 -t 100000 -q 100000 /Volumes/SSD960/references/human_g1k_v37.fasta /Users/jzook/Documents/GA4GH/StratificationBedFiles/LowComplexity/SimpleRepeat_p11.bed &

#dinuc repeats
python /Applications/bioinfo/forJustin7Nov12/findSimpleRegions_quad.py -p 100000 -d 11 -t 100000 -q 100000 /Volumes/SSD960/references/human_g1k_v37.fasta /Users/jzook/Documents/GA4GH/StratificationBedFiles/LowComplexity/SimpleRepeat_d11.bed &

python /Applications/bioinfo/forJustin7Nov12/findSimpleRegions_quad.py -p 100000 -d 51 -t 100000 -q 100000 /Volumes/SSD960/references/human_g1k_v37.fasta /Users/jzook/Documents/GA4GH/StratificationBedFiles/LowComplexity/SimpleRepeat_d51.bed &

python /Applications/bioinfo/forJustin7Nov12/findSimpleRegions_quad.py -p 100000 -d 201 -t 100000 -q 100000 /Volumes/SSD960/references/human_g1k_v37.fasta /Users/jzook/Documents/GA4GH/StratificationBedFiles/LowComplexity/SimpleRepeat_d201.bed &

#trinuc repeats
python /Applications/bioinfo/forJustin7Nov12/findSimpleRegions_quad.py -p 100000 -d 100000 -t 11 -q 100000 /Volumes/SSD960/references/human_g1k_v37.fasta /Users/jzook/Documents/GA4GH/StratificationBedFiles/LowComplexity/SimpleRepeat_t11.bed &

python /Applications/bioinfo/forJustin7Nov12/findSimpleRegions_quad.py -p 100000 -d 100000 -t 51 -q 100000 /Volumes/SSD960/references/human_g1k_v37.fasta /Users/jzook/Documents/GA4GH/StratificationBedFiles/LowComplexity/SimpleRepeat_t51.bed &

python /Applications/bioinfo/forJustin7Nov12/findSimpleRegions_quad.py -p 100000 -d 100000 -t 201 -q 100000 /Volumes/SSD960/references/human_g1k_v37.fasta /Users/jzook/Documents/GA4GH/StratificationBedFiles/LowComplexity/SimpleRepeat_t201.bed &

#quadnuc repeats
python /Applications/bioinfo/forJustin7Nov12/findSimpleRegions_quad.py -p 100000 -d 100000 -t 100000 -q 11 /Volumes/SSD960/references/human_g1k_v37.fasta /Users/jzook/Documents/GA4GH/StratificationBedFiles/LowComplexity/SimpleRepeat_q11.bed &

python /Applications/bioinfo/forJustin7Nov12/findSimpleRegions_quad.py -p 100000 -d 100000 -t 100000 -q 51 /Volumes/SSD960/references/human_g1k_v37.fasta /Users/jzook/Documents/GA4GH/StratificationBedFiles/LowComplexity/SimpleRepeat_q51.bed &

python /Applications/bioinfo/forJustin7Nov12/findSimpleRegions_quad.py -p 100000 -d 100000 -t 100000 -q 201 /Volumes/SSD960/references/human_g1k_v37.fasta /Users/jzook/Documents/GA4GH/StratificationBedFiles/LowComplexity/SimpleRepeat_q201.bed &
#find ranges of repeats
/Applications/bioinfo/bedtools2/bin/subtractBed -a /Users/jzook/Documents/GA4GH/StratificationBedFiles/LowComplexity/SimpleRepeat_p3.bed -b /Users/jzook/Documents/GA4GH/StratificationBedFiles/LowComplexity/SimpleRepeat_p6.bed | /Applications/bioinfo/tabix/bgzip -c > /Users/jzook/Documents/GA4GH/StratificationBedFiles/LowComplexity/SimpleRepeat_homopolymer_3to5.bed.gz
#fi
/Applications/bioinfo/bedtools2/bin/subtractBed -a /Users/jzook/Documents/GA4GH/StratificationBedFiles/LowComplexity/SimpleRepeat_p6.bed -b /Users/jzook/Documents/GA4GH/StratificationBedFiles/LowComplexity/SimpleRepeat_p11.bed | /Applications/bioinfo/tabix/bgzip -c > /Users/jzook/Documents/GA4GH/StratificationBedFiles/LowComplexity/SimpleRepeat_homopolymer_6to10.bed.gz
/Applications/bioinfo/bedtools2/bin/slopBed -i /Users/jzook/Documents/GA4GH/StratificationBedFiles/LowComplexity/SimpleRepeat_p11.bed -b 10 -g /Applications/bioinfo/bedtools2/genomes/human.b37.genome | /Applications/bioinfo/tabix/bgzip -c  > /Users/jzook/Documents/GA4GH/StratificationBedFiles/LowComplexity/SimpleRepeat_homopolymer_gt10.bed.gz

/Applications/bioinfo/bedtools2/bin/subtractBed -a /Users/jzook/Documents/GA4GH/StratificationBedFiles/LowComplexity/SimpleRepeat_d11.bed -b /Users/jzook/Documents/GA4GH/StratificationBedFiles/LowComplexity/SimpleRepeat_d51.bed | /Applications/bioinfo/tabix/bgzip -c > /Users/jzook/Documents/GA4GH/StratificationBedFiles/LowComplexity/SimpleRepeat_diTR_11to50.bed.gz
/Applications/bioinfo/bedtools2/bin/subtractBed -a /Users/jzook/Documents/GA4GH/StratificationBedFiles/LowComplexity/SimpleRepeat_d51.bed -b /Users/jzook/Documents/GA4GH/StratificationBedFiles/LowComplexity/SimpleRepeat_d201.bed | /Applications/bioinfo/tabix/bgzip -c > /Users/jzook/Documents/GA4GH/StratificationBedFiles/LowComplexity/SimpleRepeat_diTR_51to200.bed.gz
/Applications/bioinfo/tabix/bgzip -c /Users/jzook/Documents/GA4GH/StratificationBedFiles/LowComplexity/SimpleRepeat_d201.bed > /Users/jzook/Documents/GA4GH/StratificationBedFiles/LowComplexity/SimpleRepeat_diTR_gt200.bed.gz

/Applications/bioinfo/bedtools2/bin/subtractBed -a /Users/jzook/Documents/GA4GH/StratificationBedFiles/LowComplexity/SimpleRepeat_t11.bed -b /Users/jzook/Documents/GA4GH/StratificationBedFiles/LowComplexity/SimpleRepeat_t51.bed | /Applications/bioinfo/tabix/bgzip -c > /Users/jzook/Documents/GA4GH/StratificationBedFiles/LowComplexity/SimpleRepeat_triTR_11to50.bed.gz
/Applications/bioinfo/bedtools2/bin/subtractBed -a /Users/jzook/Documents/GA4GH/StratificationBedFiles/LowComplexity/SimpleRepeat_t51.bed -b /Users/jzook/Documents/GA4GH/StratificationBedFiles/LowComplexity/SimpleRepeat_t201.bed | /Applications/bioinfo/tabix/bgzip -c > /Users/jzook/Documents/GA4GH/StratificationBedFiles/LowComplexity/SimpleRepeat_triTR_51to200.bed.gz
/Applications/bioinfo/tabix/bgzip -c /Users/jzook/Documents/GA4GH/StratificationBedFiles/LowComplexity/SimpleRepeat_t201.bed > /Users/jzook/Documents/GA4GH/StratificationBedFiles/LowComplexity/SimpleRepeat_triTR_gt200.bed.gz

/Applications/bioinfo/bedtools2/bin/subtractBed -a /Users/jzook/Documents/GA4GH/StratificationBedFiles/LowComplexity/SimpleRepeat_q11.bed -b /Users/jzook/Documents/GA4GH/StratificationBedFiles/LowComplexity/SimpleRepeat_q51.bed | /Applications/bioinfo/tabix/bgzip -c > /Users/jzook/Documents/GA4GH/StratificationBedFiles/LowComplexity/SimpleRepeat_quadTR_11to50.bed.gz
/Applications/bioinfo/bedtools2/bin/subtractBed -a /Users/jzook/Documents/GA4GH/StratificationBedFiles/LowComplexity/SimpleRepeat_q51.bed -b /Users/jzook/Documents/GA4GH/StratificationBedFiles/LowComplexity/SimpleRepeat_q201.bed | /Applications/bioinfo/tabix/bgzip -c > /Users/jzook/Documents/GA4GH/StratificationBedFiles/LowComplexity/SimpleRepeat_quadTR_51to200.bed.gz
/Applications/bioinfo/tabix/bgzip -c /Users/jzook/Documents/GA4GH/StratificationBedFiles/LowComplexity/SimpleRepeat_q201.bed > /Users/jzook/Documents/GA4GH/StratificationBedFiles/LowComplexity/SimpleRepeat_quadTR_gt200.bed.gz

#Find imperfect homopolymers >10bp by merging shorter homopolymers separated by 1bp. Also, add 5bp padding on both sides to include errors around edges
/Applications/bioinfo/bedtools2.25.0/bin/mergeBed -i /Volumes/SSD960/references/findSimpleRegions/SimpleRepeat_p3.bed -d 1 | awk '{if($3-$2>10) print}' | /Applications/bioinfo/bedtools2.25.0/bin/slopBed -i stdin -b 5 -g /Applications/bioinfo/BEDTools-Version-2.16.2/genomes/human.b37.genome > /Volumes/SSD960/references/findSimpleRegions/SimpleRepeat_imperfecthomopolgt10_slop5.bed
