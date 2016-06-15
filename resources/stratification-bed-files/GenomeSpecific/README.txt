Genome specific bed files from the Global Alliance for Genomics and Health (GA4GH) Benchmarking Team and the Genome in a Bottle Consortium

These files are intended as standard resource of bed files for use in stratifying true positive, false positive, and false negative variant calls into different categories of variants for specific benchmark genomes like NA12878/HG001 and the GIAB AJ and Chinese Trios.  

These files were created by Justin Zook at the National Institute of Standards and Technology.  Currently, this folder contains 2 types of files: (1) regions containing putative compound heterozygous variants and (2) regions containing multiple variants within 50bp of each other from v3.2.2 vcf of the GIAB samples HG001 (NA12878) and HG002 (AJ Son). Methods used to generate these files are below:

Compound heterozygous variants when phased variants within 50bp are merged for HG002 (HG002_GIAB_highconf_IllFB-IllGATKHC-CG-Ion-Solid_CHROM1-22_v3.2.2_highconf_geno2haplo.vcf.gz):
vcflib_140404/bin/vcfgeno2haplo -r human_g1k_v37.fasta  -w 50 AJSNPindels/AshkenazimTrio/HG002_NA24385_son/NISTv3.2.2/HG002_GIAB_highconf_IllFB-IllGATKHC-CG-Ion-Solid_CHROM1-22_v3.2.2_highconf.vcf.gz > AJSNPindels/HG002_GIAB_highconf_IllFB-IllGATKHC-CG-Ion-Solid_CHROM1-22_v3.2.2_highconf_geno2haplo.vcf

grep '1/2\|1|2\|2|1\|2/1' AJSNPindels/HG002_GIAB_highconf_IllFB-IllGATKHC-CG-Ion-Solid_CHROM1-22_v3.2.2_highconf_geno2haplo.vcf | awk 'BEGIN {FS = OFS = "\t"} {print $1,$2-50,$2+50}' | sed 's/^X/23/' | sort -k1,1 -k2,2n | sed 's/^23/X/' | bedtools2.25.0/bin/mergeBed -i stdin -d 50 > AJSNPindels/HG002_GIAB_highconf_IllFB-IllGATKHC-CG-Ion-Solid_CHROM1-22_v3.2.2_highconf_geno2haplo_compoundhet_slop50.bed


Compound heterozygous variants when phased variants within 50bp are merged for HG001 (NA12878_GIAB_highconf_IllFB-IllGATKHC-CG-Ion-Solid_ALLCHROM_v3.2.2_highconf_geno2haplo_compoundhet_slop50.bed.gz):
/Applications/bioinfo/vcflib_140404/bin/vcfgeno2haplo -r /Volumes/SSD960/references/human_g1k_v37.fasta  -w 50 /Volumes/UHTS1/NA12878SNPindels/NISTv3.2.2/NA12878_GIAB_highconf_IllFB-IllGATKHC-CG-Ion-Solid_ALLCHROM_v3.2.2_highconf.vcf.gz > /Volumes/UHTS1/NA12878SNPindels/NA12878_GIAB_highconf_IllFB-IllGATKHC-CG-Ion-Solid_ALLCHROM_v3.2.2_highconf_geno2haplo.vcf

grep '1/2\|1|2\|2|1\|2/1' /Volumes/UHTS1/NA12878SNPindels/NA12878_GIAB_highconf_IllFB-IllGATKHC-CG-Ion-Solid_ALLCHROM_v3.2.2_highconf_geno2haplo.vcf  | awk 'BEGIN {FS = OFS = "\t"} {print $1,$2-50,$2+50}' | sed 's/^X/23/' | sort -k1,1 -k2,2n | sed 's/^23/X/' | /Applications/bioinfo/bedtools2.25.0/bin/mergeBed -i stdin -d 50 > /Volumes/UHTS1/NA12878SNPindels/NA12878_GIAB_highconf_IllFB-IllGATKHC-CG-Ion-Solid_ALLCHROM_v3.2.2_highconf_geno2haplo_compoundhet_slop50.bed


Regions with nearby variants in HG002 (HG002_GIAB_highconf_IllFB-IllGATKHC-CG-Ion-Solid_CHROM1-22_v3.2.2_highconf_varswithin50bp.bed.gz):
zgrep -v ^# /Volumes/UHTS1/AJSNPindels/AshkenazimTrio/HG002_NA24385_son/NISTv3.2.2/HG002_GIAB_highconf_IllFB-IllGATKHC-CG-Ion-Solid_CHROM1-22_v3.2.2_highconf.vcf.gz | awk 'BEGIN {FS = OFS = "\t"} {print $1,$2-1,$2,1}' | /Applications/bioinfo/bedtools2.25.0/bin/mergeBed -i stdin -d 50 -c 4 -o sum | awk '{if($4>1) print}' | /Applications/bioinfo/bedtools2.25.0/bin/slopBed -i stdin -b 50 -g /Applications/bioinfo/BEDTools-Version-2.16.2/genomes/human.b37.genome | /Applications/bioinfo/bedtools2.25.0/bin/mergeBed -i stdin > /Volumes/UHTS1/AJSNPindels/HG002_GIAB_highconf_IllFB-IllGATKHC-CG-Ion-Solid_CHROM1-22_v3.2.2_highconf_varswithin50bp.bed


Regions with nearby variants in HG001 (NA12878_GIAB_highconf_IllFB-IllGATKHC-CG-Ion-Solid_ALLCHROM_v3.2.2_highconf_varswithin50bp.gz):
zgrep -v ^# /Volumes/UHTS1/NA12878SNPindels/NISTv3.2.2/NA12878_GIAB_highconf_IllFB-IllGATKHC-CG-Ion-Solid_ALLCHROM_v3.2.2_highconf.vcf.gz  | awk 'BEGIN {FS = OFS = "\t"} {print $1,$2-1,$2,1}' | /Applications/bioinfo/bedtools2.25.0/bin/mergeBed -i stdin -d 50 -c 4 -o sum | awk '{if($4>1) print}' | /Applications/bioinfo/bedtools2.25.0/bin/slopBed -i stdin -b 50 -g /Applications/bioinfo/BEDTools-Version-2.16.2/genomes/human.b37.genome | /Applications/bioinfo/bedtools2.25.0/bin/mergeBed -i stdin > /Volumes/UHTS1/NA12878SNPindels/NA12878_GIAB_highconf_IllFB-IllGATKHC-CG-Ion-Solid_ALLCHROM_v3.2.2_highconf_varswithin50bp.bed