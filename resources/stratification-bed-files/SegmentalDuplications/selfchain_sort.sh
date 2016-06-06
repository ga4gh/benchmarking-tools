# sort self-chain files in numerical chromosome order and remove extra contigs

gunzip -c /Users/jzook/Google\ Drive/Benchmarking\ Task\ Team/StratificationBedFiles/SegmentalDuplications/hg19_self_chain_split.bed.gz | sed 's/^X	/23	/;s/^Y	/24	/;s/^MT	/25	/' | awk '$1<26' | sort -k1,1n -k2,2n | sed 's/^23/X/;s/^24/Y/;s/^25/MT/' | /Applications/bioinfo/tabix-0.2.6/bgzip -c > /Users/jzook/Google\ Drive/Benchmarking\ Task\ Team/StratificationBedFiles/SegmentalDuplications/hg19_self_chain_split.sort.bed.gz

#Because the above file is in bedpe format to show pairs of sites with mapping homology, we have also created a bed file with all sites in 3-column bed format (hg19_self_chain_split_both.bed.gz), as well as a file with only regions >10kb in size (hg19_self_chain_split_both_gt10k.bed.gz).
gunzip -c /Users/jzook/Documents/GA4GH/StratificationBedFiles/LowComplexity/AllRepeats_gt200bp_gt95identity_merged.bed.gz  | sort -k1,1 -k2,2n > AllRepeats_gt200bp_gt95identity_merged_sort.bed

gunzip -c /Users/jzook/Documents/GA4GH/StratificationBedFiles/SegmentalDuplications/hg19_self_chain_split.sort.bed.gz | cut -f1-3 > hg19_self_chain_split.1.bed

gunzip -c /Users/jzook/Documents/GA4GH/StratificationBedFiles/SegmentalDuplications/hg19_self_chain_split.sort.bed.gz | cut -f4-6 > hg19_self_chain_split.2.bed

cat hg19_self_chain_split.1.bed hg19_self_chain_split.2.bed | sort -k1,1 -k2,2n | /Applications/bioinfo/bedtools2/bin/mergeBed -i stdin | bgzip -c > hg19_self_chain_split_both.bed.gz

cat hg19_self_chain_split.1.bed hg19_self_chain_split.2.bed | awk '{if ($3-$2>=10000) print $0}' | sort -k1,1 -k2,2n | /Applications/bioinfo/bedtools2/bin/mergeBed -i stdin | bgzip -c > hg19_self_chain_split_both_gt10k.bed.gz


#Create bed files with ALT loci included since original bed files did not include ALT mappings
/Applications/bioinfo/bedtools2.25.0/bin/bamToBed -i /Users/jzook/Downloads/hg19_self_chain_split.bam | cut -f1-3 | /Applications/bioinfo/bedtools2.25.0/bin/mergeBed -i stdin | /Applications/bioinfo/tabix-0.2.6/bgzip -c > /Users/jzook/Downloads/hg19_self_chain_split_all.bed.gz
gunzip -c /Users/jzook/Downloads/hg19_self_chain_split_all.bed.gz | awk '{if($3-$2>10000) sum+=$3;if($3-$2>10000) sum-=$2} END {print sum}' 
#146352960
gunzip -c /Users/jzook/Downloads/hg19_self_chain_split_all.bed.gz | awk '{if($3-$2>10000) print}' | /Applications/bioinfo/tabix-0.2.6/bgzip -c > /Users/jzook/Downloads/hg19_self_chain_split_withalts_gt10k.bed.gz

