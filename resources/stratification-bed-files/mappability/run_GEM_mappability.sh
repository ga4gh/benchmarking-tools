#$ -cwd
#$ -S /bin/sh
#$ -j y
#$ -l h_rt=5:00:00
#$ -l h_vmem=2500M
#$ -N GEM_map_l250_m2_e1
#$ -pe thread 8
#$ -t 1

 
echo "Running job $JOB_NAME, $JOB_ID on $HOSTNAME"



START_STIME=`date +%Y%m%dT%H%M%S`
START_TIME=`date +%s`

export PATH=/home/justin.zook/bin:/home/justin.zook/GEM_mappability/GEM-binaries-Linux-x86_64-core_i3-20130406-045632/bin:$PATH

#gem-indexer -i /projects/justin.zook/from-projects/references/human_g1k_v37.fasta -o /projects/justin.zook/from-projects/references/human_g1k_v37_gemidx --complement emulate -T 8 

#gem-mappability -m 2 -e 1 -T 4 -I /projects/justin.zook/from-projects/references/human_g1k_v37_gemidx.gem -l 250 -o /projects/justin.zook/from-projects/references/human_g1k_v37_gemmap_l250_m2_e1

gem-2-wig -I /projects/justin.zook/from-projects/references/human_g1k_v37_gemidx.gem -i /projects/justin.zook/from-projects/references/human_g1k_v37_gemmap_l250_m2_e1.mappability -o /projects/justin.zook/from-projects/references/human_g1k_v37_gemmap_l250_m2_e1

sed 's/ dna//' /projects/justin.zook/from-projects/references/human_g1k_v37_gemmap_l250_m2_e1.wig > /projects/justin.zook/from-projects/references/human_g1k_v37_gemmap_l250_m2_e1_nodna.wig
sed 's/ dna//' /projects/justin.zook/from-projects/references/human_g1k_v37_gemmap_l250_m2_e1.sizes > /projects/justin.zook/from-projects/references/human_g1k_v37_gemmap_l250_m2_e1_nodna.sizes

~/bin/wig2bed -m 16G < /projects/justin.zook/from-projects/references/human_g1k_v37_gemmap_l250_m2_e1_nodna.wig > /projects/justin.zook/from-projects/references/human_g1k_v37_gemmap_l250_m2_e1.bed

awk '$5>0.9' /projects/justin.zook/from-projects/references/human_g1k_v37_gemmap_l250_m2_e1.bed > /projects/justin.zook/from-projects/references/human_g1k_v37_gemmap_l250_m2_e1_uniq.bed

/home/justin.zook/GEM_mappability/wigToBigWig /projects/justin.zook/from-projects/references/human_g1k_v37_gemmap_l250_m2_e1_nodna.wig /projects/justin.zook/from-projects/references/human_g1k_v37_gemmap_l250_m2_e1_nodna.sizes /projects/justin.zook/from-projects/references/human_g1k_v37_gemmap_l250_m2_e1.bw
END_TIME=`date +%s`
ELAPSED_TIME=`expr $END_TIME - $START_TIME`

echo "$START_STIME  $ELAPSED_TIME" $JOB_ID $HOSTNAME 