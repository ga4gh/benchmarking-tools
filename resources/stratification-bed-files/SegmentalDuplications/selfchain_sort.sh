# sort self-chain files in numerical chromosome order and remove extra contigs

gunzip -c /Users/jzook/Google\ Drive/Benchmarking\ Task\ Team/StratificationBedFiles/SegmentalDuplications/hg19_self_chain_split.bed.gz | sed 's/^X	/23	/;s/^Y	/24	/;s/^MT	/25	/' | awk '$1<26' | sort -k1,1n -k2,2n | sed 's/^23/X/;s/^24/Y/;s/^25/MT/' | /Applications/bioinfo/tabix-0.2.6/bgzip -c > /Users/jzook/Google\ Drive/Benchmarking\ Task\ Team/StratificationBedFiles/SegmentalDuplications/hg19_self_chain_split.sort.bed.gz
