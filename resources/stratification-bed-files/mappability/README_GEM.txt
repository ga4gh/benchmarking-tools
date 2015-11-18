Mappability files from the Global Alliance for Genomics and Health (GA4GH) Benchmarking Team and the Genome in a Bottle Consortium

These files are intended as standard resource of bed files for use in stratifying true positive, false positive, and false negative variant calls into different categories of mappability.  

These files were created by Justin Zook at the National Institute of Standards and Technology based on discussions in the GA4GH Benchmarking Team using GEM binary pre-release 3 from 20130406 (GEM-binaries-Linux-x86_64-core_i3-20130406-045632.tbz2 from http://sourceforge.net/projects/gemlibrary/files/gem-library/Binary%20pre-release%203/).  The GEM mappability tool finds l-bp regions that match other regions in the reference genome with fewer than m mismatches (SNPs) and fewer than ‘e’ indels < 15bp.  To generate these files, we used the GRCh37 fasta from 1000genomes.org without decoy sequences (human_g1k_v37.fasta). 

We generated mappability files for 100 bp (l100), 125 bp (l125), 150 bp (l150), and 250 bp (l250) single-end reads, allowing:
a) 0 mismatches and 0 indels (m0_e0)
b) 1 mismatches and 0 indels (m1_e0)
c) 2 mismatches and 0 indels (m2_e0)
d) 2 mismatches and 1 indels (m2_e1)
 
The bed files ending in “_uniq.sort.bed” contain only regions that are “mappable”, meaning they don’t have any homologous regions in the reference genome for the given read length, number of mismatches, and number of indels.

An example shell script for Sun Grid Engine that was used to generate mappable regions for 250bp reads with fewer than 2 mismatches and 1 indel is run_GEM_mappability.sh.  The number of bases covered by the different bed files is described in Mappable_bases_counts.xls.