#!/bin/sh

#  FindSimpleRepeats.sh
#  
#
#  Created by Zook, Justin on 3/30/15.
#
if [ 0 -gt 1 ]; then

#homopolymers
python /Applications/bioinfo/forJustin7Nov12/findSimpleRegions_quad.py -p 3 -d 100000 -t 100000 -q 100000 /Volumes/SSD960/references/human_g1k_v37.fasta /Volumes/SSD960/references/findSimpleRegions/SimpleRepeat_p3.bed &

python /Applications/bioinfo/forJustin7Nov12/findSimpleRegions_quad.py -p 6 -d 100000 -t 100000 -q 100000 /Volumes/SSD960/references/human_g1k_v37.fasta /Volumes/SSD960/references/findSimpleRegions/SimpleRepeat_p6.bed &

python /Applications/bioinfo/forJustin7Nov12/findSimpleRegions_quad.py -p 11 -d 100000 -t 100000 -q 100000 /Volumes/SSD960/references/human_g1k_v37.fasta /Volumes/SSD960/references/findSimpleRegions/SimpleRepeat_p11.bed &

#dinuc repeats
python /Applications/bioinfo/forJustin7Nov12/findSimpleRegions_quad.py -p 100000 -d 11 -t 100000 -q 100000 /Volumes/SSD960/references/human_g1k_v37.fasta /Volumes/SSD960/references/findSimpleRegions/SimpleRepeat_d11.bed &

python /Applications/bioinfo/forJustin7Nov12/findSimpleRegions_quad.py -p 100000 -d 51 -t 100000 -q 100000 /Volumes/SSD960/references/human_g1k_v37.fasta /Volumes/SSD960/references/findSimpleRegions/SimpleRepeat_d51.bed &

python /Applications/bioinfo/forJustin7Nov12/findSimpleRegions_quad.py -p 100000 -d 201 -t 100000 -q 100000 /Volumes/SSD960/references/human_g1k_v37.fasta /Volumes/SSD960/references/findSimpleRegions/SimpleRepeat_d201.bed &

#trinuc repeats
python /Applications/bioinfo/forJustin7Nov12/findSimpleRegions_quad.py -p 100000 -d 100000 -t 11 -q 100000 /Volumes/SSD960/references/human_g1k_v37.fasta /Volumes/SSD960/references/findSimpleRegions/SimpleRepeat_t11.bed &

python /Applications/bioinfo/forJustin7Nov12/findSimpleRegions_quad.py -p 100000 -d 100000 -t 51 -q 100000 /Volumes/SSD960/references/human_g1k_v37.fasta /Volumes/SSD960/references/findSimpleRegions/SimpleRepeat_t51.bed &

python /Applications/bioinfo/forJustin7Nov12/findSimpleRegions_quad.py -p 100000 -d 100000 -t 201 -q 100000 /Volumes/SSD960/references/human_g1k_v37.fasta /Volumes/SSD960/references/findSimpleRegions/SimpleRepeat_t201.bed &

#quadnuc repeats
python /Applications/bioinfo/forJustin7Nov12/findSimpleRegions_quad.py -p 100000 -d 100000 -t 100000 -q 11 /Volumes/SSD960/references/human_g1k_v37.fasta /Volumes/SSD960/references/findSimpleRegions/SimpleRepeat_q11.bed &

python /Applications/bioinfo/forJustin7Nov12/findSimpleRegions_quad.py -p 100000 -d 100000 -t 100000 -q 51 /Volumes/SSD960/references/human_g1k_v37.fasta /Volumes/SSD960/references/findSimpleRegions/SimpleRepeat_q51.bed &

python /Applications/bioinfo/forJustin7Nov12/findSimpleRegions_quad.py -p 100000 -d 100000 -t 100000 -q 201 /Volumes/SSD960/references/human_g1k_v37.fasta /Volumes/SSD960/references/findSimpleRegions/SimpleRepeat_q201.bed &
#find ranges of repeats
/Applications/bioinfo/BEDTools-Version-2.16.2/bin/subtractBed -a /Volumes/SSD960/references/findSimpleRegions/SimpleRepeat_p3.bed -b /Volumes/SSD960/references/findSimpleRegions/SimpleRepeat_p6.bed | /Applications/bioinfo/tabix-0.2.6/bgzip -c > /Volumes/SSD960/references/findSimpleRegions/SimpleRepeat_homopolymer_3to5.bed.gz
fi
/Applications/bioinfo/BEDTools-Version-2.16.2/bin/subtractBed -a /Volumes/SSD960/references/findSimpleRegions/SimpleRepeat_p6.bed -b /Volumes/SSD960/references/findSimpleRegions/SimpleRepeat_p11.bed | /Applications/bioinfo/tabix-0.2.6/bgzip -c > /Volumes/SSD960/references/findSimpleRegions/SimpleRepeat_homopolymer_6to10.bed.gz
/Applications/bioinfo/tabix-0.2.6/bgzip -c /Volumes/SSD960/references/findSimpleRegions/SimpleRepeat_q201.bed > /Volumes/SSD960/references/findSimpleRegions/SimpleRepeat_homopolymer_gt10.bed.gz

/Applications/bioinfo/BEDTools-Version-2.16.2/bin/subtractBed -a /Volumes/SSD960/references/findSimpleRegions/SimpleRepeat_d11.bed -b /Volumes/SSD960/references/findSimpleRegions/SimpleRepeat_d51.bed | /Applications/bioinfo/tabix-0.2.6/bgzip -c > /Volumes/SSD960/references/findSimpleRegions/SimpleRepeat_diTR_11to50.bed.gz
/Applications/bioinfo/BEDTools-Version-2.16.2/bin/subtractBed -a /Volumes/SSD960/references/findSimpleRegions/SimpleRepeat_d51.bed -b /Volumes/SSD960/references/findSimpleRegions/SimpleRepeat_d201.bed | /Applications/bioinfo/tabix-0.2.6/bgzip -c > /Volumes/SSD960/references/findSimpleRegions/SimpleRepeat_diTR_51to200.bed.gz
/Applications/bioinfo/tabix-0.2.6/bgzip -c /Volumes/SSD960/references/findSimpleRegions/SimpleRepeat_d201.bed > /Volumes/SSD960/references/findSimpleRegions/SimpleRepeat_diTR_gt200.bed.gz

/Applications/bioinfo/BEDTools-Version-2.16.2/bin/subtractBed -a /Volumes/SSD960/references/findSimpleRegions/SimpleRepeat_t11.bed -b /Volumes/SSD960/references/findSimpleRegions/SimpleRepeat_t51.bed | /Applications/bioinfo/tabix-0.2.6/bgzip -c > /Volumes/SSD960/references/findSimpleRegions/SimpleRepeat_triTR_11to50.bed.gz
/Applications/bioinfo/BEDTools-Version-2.16.2/bin/subtractBed -a /Volumes/SSD960/references/findSimpleRegions/SimpleRepeat_t51.bed -b /Volumes/SSD960/references/findSimpleRegions/SimpleRepeat_t201.bed | /Applications/bioinfo/tabix-0.2.6/bgzip -c > /Volumes/SSD960/references/findSimpleRegions/SimpleRepeat_triTR_51to200.bed.gz
/Applications/bioinfo/tabix-0.2.6/bgzip -c /Volumes/SSD960/references/findSimpleRegions/SimpleRepeat_t201.bed > /Volumes/SSD960/references/findSimpleRegions/SimpleRepeat_triTR_gt200.bed.gz

/Applications/bioinfo/BEDTools-Version-2.16.2/bin/subtractBed -a /Volumes/SSD960/references/findSimpleRegions/SimpleRepeat_q11.bed -b /Volumes/SSD960/references/findSimpleRegions/SimpleRepeat_q51.bed | /Applications/bioinfo/tabix-0.2.6/bgzip -c > /Volumes/SSD960/references/findSimpleRegions/SimpleRepeat_quadTR_11to50.bed.gz
/Applications/bioinfo/BEDTools-Version-2.16.2/bin/subtractBed -a /Volumes/SSD960/references/findSimpleRegions/SimpleRepeat_q51.bed -b /Volumes/SSD960/references/findSimpleRegions/SimpleRepeat_q201.bed | /Applications/bioinfo/tabix-0.2.6/bgzip -c > /Volumes/SSD960/references/findSimpleRegions/SimpleRepeat_quadTR_51to200.bed.gz
/Applications/bioinfo/tabix-0.2.6/bgzip -c /Volumes/SSD960/references/findSimpleRegions/SimpleRepeat_q201.bed > /Volumes/SSD960/references/findSimpleRegions/SimpleRepeat_quadTR_gt200.bed.gz

