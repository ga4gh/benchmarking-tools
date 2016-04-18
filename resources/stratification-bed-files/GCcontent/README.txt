GC content bed files from the Global Alliance for Genomics and Health (GA4GH) Benchmarking Team and the Genome in a Bottle Consortium

These files are intended as standard resource of bed files for use in stratifying true positive, false positive, and false negative variant calls into different ranges of GC content.  

These files were created by Justin Zook at the National Institute of Standards and Technology based on discussions in the GA4GH Benchmarking Team using Heng Li’s seqtk algorithm (https://github.com/lh3/seqtk; version 5e1e8dbd506ea1ff8c77d468a1f27b8e8f73eac0 downloaded 3/30/15).  This identifies >=x bp regions with >y% or <y% GC. The last column in the output BED gives how many G/C bases in each identified region. This algorithm automatically seeks the boundaries of high-GC regions.  As Heng describes in (https://groups.google.com/d/msgid/ga4gh-dwg-benchmarking/CAPipXk%2B4PCKE-AfxuKw5bLtJC0MgoamDiyE-bcJNUJCXvtZX6A%40mail.gmail.com): “For example, we give a score s(C)=s(G)=1 and s(A)=s(T)=-2. Let f(i) be the accumulative score at chr position i, which is computed by f(i)=f(i-1)+s(i) if f(i-1)+s(i) is positive; or zero otherwise. We move forwardly to find local maxima of f(i). These are the right boundaries of a high-GC regions. We then move backwardly from each local maximum to find the left boundaries. Under this scoring, identified segments must have a %GC above 2/(1+2)=67%. Phred and bwa trimming are both based on a similar idea.”   To generate these files, we used the GRCh37 fasta from 1000genomes.org without decoy sequences (human_g1k_v37.fasta). 

The process used to generate these regions was:
1.  First generate regions with <15, 20, 25, and 30% GC and >55, 60, 65, 70, 75, 80, and 85 % GC
2.  Expand by 50bp on each side to get "200 bp regions in which the middle 100bp contains <x% or >x% GC", based on doi:10.1186/gb-2013-14-5-r51
3.  Subtract more stringent bed from less stringent bed to get GC content ranges
4.  Everything else goes in 30to65 bed file for moderate GC (this range was chosen based on where coverage starts decreasing or error rates start increasing for any technology in doi:10.1186/gb-2013-14-5-r51
5.  Note that after adding 50bp slop, 272336 bp overlap between gc30 and gc65, or 0.07% of gc30 and 0.5% of gc65, so the bed files with different GC ranges are almost exclusive of each other, but not completely

We chose to stratify regions with <30% or >55% GC because these regions had decreased coverage or higher error rates for at least one of the technologies in doi:10.1186/gb-2013-14-5-r51, and we added 55-60 and 60-65 because we found increased error rates in these tranches in exploratory work.

The shell script used to generate these was seqtk_gc.sh, and used the seqtk version described above along with BEDTools-Version-2.16.2.

The number of bps within each bed file is:
awk '{ sum+=$3;sum-=$2 } END { print sum }' human_g1k_v37_l100_gc15_slop50.bed
#5225837
awk '{ sum+=$3;sum-=$2 } END { print sum }' human_g1k_v37_l100_gc15to20_slop50.bed
#14248633

awk '{ sum+=$3;sum-=$2 } END { print sum }' human_g1k_v37_l100_gc20to25_slop50.bed
#116727539

awk '{ sum+=$3;sum-=$2 } END { print sum }' human_g1k_v37_l100_gc25to30_slop50.bed
#392853128

awk '{ sum+=$3;sum-=$2 } END { print sum }' human_g1k_v37_l100_gc85_slop50.bed
#532129
awk '{ sum+=$3;sum-=$2 } END { print sum }' human_g1k_v37_l100_gc80to85_slop50.bed
#2569485

awk '{ sum+=$3;sum-=$2 } END { print sum }' human_g1k_v37_l100_gc75to80_slop50.bed
#5193906

awk '{ sum+=$3;sum-=$2 } END { print sum }' human_g1k_v37_l100_gc70to75_slop50.bed
#11661550

awk '{ sum+=$3;sum-=$2 } END { print sum }' human_g1k_v37_l100_gc65to70_slop50.bed
#34491477

awk '{ sum+=$3;sum-=$2 } END { print sum }' human_g1k_v37_l100_gc60to65_slop50.bed
#102128201

awk '{ sum+=$3;sum-=$2 } END { print sum }' human_g1k_v37_l100_gc55to60_slop50.bed
#243488547

awk '{ sum+=$3;sum-=$2 } END { print sum }' human_g1k_v37_l100_gc30to55_slop50.bed
#2176386041
