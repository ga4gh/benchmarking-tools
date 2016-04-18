Segmental duplication files from the Global Alliance for Genomics and Health (GA4GH) Benchmarking Team and the Genome in a Bottle Consortium

These files are intended as standard resource of bed files for use in stratifying true positive, false positive, and false negative variant calls into whether they are in segmental duplications.  

These files were created by Kevin Jacobs and are currently in alpha form.  More detailed information and/or revisions to the bed file will follow.

hg19_self_chain_split.sort.bed.gz is sorted in numerical chromosome order with only 1-22, X, Y, and MT

Because the above file is in bedpe format to show pairs of sites with mapping homology, we have also created a bed file with all sites in 3-column bed format (hg19_self_chain_split_both.bed.gz), as well as a file with only regions >10kb in size (hg19_self_chain_split_both_gt10k.bed.gz).

Code for processing raw file is in selfchain_sort.sh