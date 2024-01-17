# SCCourse2024WS
My scipt from the SC Course 23/24WS

what does each script do?

indexing with star -> generating a index to make the allignment faster. it will look for certrain characteristics of the genome and then allign those to the short sequences. All mappers and alligners have their own indexer
    i.e. "STAR --runMode genomeGenerate --runThreadN 8 --genomeDir jaNemVect1.1_STAR --genomeFastaFiles GCF_932526225.1_jaNemVect1.1_genomic.fna --genomeSAindexNbases 13"

STAR -> Run the mapping job: align reads to a reference genome or transcriptome. STAR is a gap aligner. - results in a BAM file
   BAM: the Bam file in SAM format - Binary SAM file - like a zipped version of the SAM format 
      - Can use samtool to look at the zipped version - as unzipped it is a gigantic file 

trimmomatic -> read trimming to increase the quality of our read set
    - asseses the quality of reads and shortens or discards them
    - i.e. minimum length - dont want to remove more than half the average read length - remove reads that are too short 
    - sliding window of 6 bases if average quality drops below 15 then this and the rest of the read is trimmed off

STAR after trimmomatic -> repeated STAR mapping to the same reference genome - to see the difference. i.e. uniquely mapped reads % increased from 58.26% to 64.86%

Fastqc -> look at what overall our library looks like (usually before you start with STAR and so on) - results in an HTML file you can look at

Visualize the alignment using IGV

Augustus.sh -> contains command line for running augustus on chr 1

use out BAM evidence to predict genes - willl give output as general transcript format GTF or general feature format GFF

samtoolsFilter ->

featureCounts -> 

SUBREAD -> 
