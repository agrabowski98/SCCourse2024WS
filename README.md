# SCCourse2024WS
My scipt from the SC Course 23/24WS

what does each script do?

(not uploaded) indexing with star -> generating a index to make the allignment faster. it will look for certrain characteristics of the genome and then allign those to the short sequences. All mappers and alligners have their own indexer
    i.e. "STAR --runMode genomeGenerate --runThreadN 8 --genomeDir jaNemVect1.1_STAR --genomeFastaFiles GCF_932526225.1_jaNemVect1.1_genomic.fna --genomeSAindexNbases 13"

(Star_TEST.sh.txt) STAR -> Run the mapping job: align reads to a reference genome or transcriptome. STAR is a gap aligner. - results in a BAM file
   BAM: the Bam file in SAM format - Binary SAM file - like a zipped version of the SAM format 
      - Can use samtool to look at the zipped version - as unzipped it is a gigantic file 

(trimmomatic.sh.txt) trimmomatic -> read trimming to increase the quality of our read set
    - asseses the quality of reads and shortens or discards them
    - i.e. minimum length - dont want to remove more than half the average read length - remove reads that are too short 
    - sliding window of 6 bases if average quality drops below 15 then this and the rest of the read is trimmed off

(Star_TEST_after_trimmomatic.sh.txt) STAR after trimmomatic -> repeated STAR mapping to the same reference genome - to see the difference. i.e. uniquely mapped reads % increased from 58.26% to 64.86%

(not here) Fastqc -> look at what overall our library looks like (usually before you start with STAR and so on) - results in an HTML file you can look at

(SamtoolsFilter.txt) samtools view -> generate matrices to summarize all the reads that fit to one gene, filter for mapping quality and write out the file into a common folder so we can use all files from everyong for stringtie

(Stringtie.txt) Stringtie -> evidence based gene annotation. wanted to use all BAM files but did not work, as for some reason they are incompatible. Instead we just used our own.

Visualize the alignment using IGV

(augustus.sh) Augustus -> contains the command line for running augustus on chr 1. Used for ab initio gene prediction- will give output as general transcript format GTF or general feature format GFF



(not here) featureCounts -> using the annotation of our reference genome, summarize/count all the reads that fit to one gene. 
    featureCounts -p --countReadPairs -C -s 2 -Q 20 -T 16 \
      -a /scratch/course/2023w300106/jmontenegro/ex2/annotation/tmp.gtf \ ##our GTF was faulty so used one from here
      -o /scratch/course/2023w300106/grabowski/ex8/counts.tsv \
      /scratch/course/2023w300106/BAMS/*.bam 

(StarHADO01.txt) Star -> running star on a transcriptome instead of a reference genome
    -> comparison: at first glance the results from transcriptome alignment seem better (i.e. 79.6% uniquely mapped reads vs 58% (genome) or 64% (trim genome)
       however, this is largely due to fewer multimapping reads. In the genome many reads were multimappers but in the transcriptome cannot say if these transcripts come from one gene locus or multiple.
       The transcrptome has been overclusered. There are reads that should be multimappnig but they have been merged into a single gene – overmerged. 
       We can run Busco – tool to see if the genes we expect to see present in a genome that are universal single copy orthogogs in a branch of a species (like bacteria, eukaryota, fungi, plants etc) 
       expressed in over 95% of genomes. The higher the percentage of these orthoogs from busco is in your genome the more complete it is.

(interproscan.txt) interproscan -> high throughput functional annotation, combines predictive information about protein functions from multiple resources (cancelled after 15h, compatibility issue with java)

(eggnoggmapper.txt) eggnoggmapper -> another hight throughput functional annotation tool. Compares directly with uniprot and not with ncbi databases and therefore its faster - it will not give you a lot of functional information, but confident information
derive gene models from those files to make gtf or gff, combine with allignemnts to regerate readcount metrics, and to explore those metrics used R, if we went though the entire R process we could come up with a whole list of genes of interest that might be interesting to look at, but we want to know some functions from the genes so that is why we are running interproscanner or eggnoggmapper.
#then we can start running functional enrichment analysis of the genes that we want

(not here) cellranger mkref - Prepare a reference for use with 10x analysis software. Requires a GTF and FASTA
    cellranger mkref --genome=NV2Fluo \
      --fasta=/scratch/course/2023w300106/Nv2_wnt4_pcna_fluo.fa \
      --genes=/scratch/course/2023w300106/Nv2_wnt4_pcna_fluo.gtf \
      --nthreads=16

(CelltrangerCount.txt) cellrangercount -> call ranger matrix output that has readcounts per cell - then continue with alison to find geneclusters and identiy genes that are over or underexpressed ect.
    use cellranger to demuliplex the sequencing adapters and barcodes etc. cellranger in its pipeline will already know where all this is and do it automatically
    Now we use cellranger for single cell (also soloSTAR exhists for this)

