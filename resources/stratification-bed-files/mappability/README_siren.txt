SiRen source available from https://github.com/amplab/siren-release.

Command lines below assume the user is in the siren-release directory.

To compile & build jar:
sbt/sbt assembly

Command line:
java -Xmx100g -cp target/scala-2.10/siren-assembly-0.0.jar snap.apps.SimFinder gridParallelAccumulator local[16] 20 100 5 1 hg19.dist1.txt 500 2

Before running, edit src/main/scala/siren/GenomeLoader.scala with the path to your genome file so all tasks have access to it.

SiRen tech report available at http://www.eecs.berkeley.edu/Pubs/TechRpts/2015/EECS-2015-159.html.

Briefly, the output of the SimFinder is a list of clusters.  Each cluster contains strings of equal length that differ from another string in the cluster by at most the merge distance.  That is, each cluster contains closely-related strings.  The bed file we generated is produced by merging any overlapping similar substrings to create contiguous regions.  See tech report for more info.