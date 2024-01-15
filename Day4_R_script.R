### first part copied from the console and then started writing in the script ###
> getwd()
[1] "/lisc/user/grabowski"
> #this is my home diretory 
  > setwd("/lisc/scratch/course/2023w300106/grabowski/")
> getwd()
[1] "/lisc/scratch/course/2023w300106/grabowski"
> #R works in vectors and can work on many vectors at the same time 
  > vector1 <- #vector 1 is the name if the vector we are creating
    + 5
  > vector1 +100
  [1] 105
  > vector1 <- "class"
  > vector1 +100
  Error in vector1 + 100 : non-numeric argument to binary operator
  > #now it doesnt work because class is a name and not a number so it gives an error
    > vector1 <-105
  > vector1 <- c(1,2,3,4,5,6,7,8,9,10)
  > vector1*2
  [1]  2  4  6  8 10 12 14 16 18 20
  > mean(vector1)
  [1] 5.5
  > median(vector1)
  [1] 5.5
  
  # R automatically gives you some plotting functions 
  boxplot(vector1)
  
  accel <- vector1^2
  accel
#ctrl enter to run right away
plot(vector1, accel)  

plot(vector1, accel^2)
# will use gg plot fot the nicer plots, R for quick plotting

#need to be able to load things into R because cant tipe in all the data

summary <- read.table ("counts.tsv.summary", sep = "\t", comment.char = "#", header = TRUE) # need to tell it how to read the command
setwd("/lisc/scratch/course/2023w300106/grabowski/ex8")
getwd ()
setwd ("/lisc/scratch/course/2023w300106/grabowski/ex8")
summary <- read.table ("counts.tsv.summary", sep = "\t", comment.char = "#", header = TRUE)
summary
# if you want to see what is in the directory that you are in then just type " and it will show you a list 
# tidyverse has a lot of data handeling tools that you can load
library (tidyverse)
summary<-read_tsv("counts.tsv.summary", comment = "#")
summary
summary [1,]
summary [1,2:12]
summary [ ,4]
#what is the averge number of reads that were assigned 
mean(unlist(summary[1, 2:12]))
#need a vector that contains the total number of reads per library - need to know what the total number of reads in each library is
#need to sumup all the columns except the first one
colSums(summary[,2:12])
scaled <- summary [,2:12]/colSums(summary[,2:12])*1000000
# now we scaled the values to pretend that each library is 1,000,000 reads long. - so we can compare them better
scaled
#something wrong - there is more than 100% which doesnt work 1,192,705.875 /1,000,000
#so now we use a different tool:
library (edgeR)
scaled <- cpm(summary[, 2:12])
scaled
boxplot(scaled [1, ]) # chose the first row -not a column

boxplot(scaled [12,]) #reads that allign to the genome but do not allign with any anotation - noise or unannoted genes
boxplot(scaled [14,]) #reads that are ambiguous - they allign with a gene but on the reverse strand

# if you want to know what libraries you have:
sessionInfo()
#will also need to put the session info into a aper soem way - for exaple by a github link or so

# ggplot ----------------------------------------------

#first assign mames to the scaled rows
rownames(scaled) <- unlist(summary[,1]) #first ned to ist (unlist) them so it becomes a vecor 
scaled
library(reshape2)
scaledMelt <- melt(scaled)
head(scaledMelt)
dim(scaledMelt)
ggplot(scaledMelt,aes(x=Var1,y=value)) + geom_boxplot()
ggplot(scaledMelt,aes(x=Var1,y=value)) + geom_boxplot() + coord_flip() # this way we can read the Var1
#can remove all vlaues that equal o
scaledMelt <- melt(scaled[rowSums(scaled)>0, ]) # want to only keep the rows that have more than 0 in them but in all columns
scaledMelt
ggplot(scaledMelt,aes(x=Var1,y=value)) + geom_boxplot() + coord_flip()
ggplot(scaledMelt,aes(x=Var1,y=value)) + geom_violin() + coord_flip()
ggplot(scaledMelt,aes(x=Var1,y=value, col=Var1)) + geom_jitter() + coord_flip()
ggplot(scaledMelt,aes(x=Var1,y=value, col=Var2)) + theme_bw() + geom_jitter() + theme (axis.text.x = element_text(angle = 90)) + labs(x="", y="number of reads (CPM)", col="Category")
ggplot(scaledMelt,aes(x=Var1,y=value, col=Var2)) + theme_bw() + geom_jitter(width = 0.2) + geom_boxplot(aes(col=Var1)) + theme (axis.text.x = element_text(angle = 90)) + labs(x="", y="number of reads (CPM)", col="Category")

#make it look nicer by getting rid of the long names:
levels(scaledMelt$Var2)
gsub("/scratch/course/2023w300106/BAMS/", "", scaledMelt$Var2)
scaledMelt$Var2 <- gsub("/scratch/course/2023w300106/BAMS/", "", scaledMelt$Var2)
ggplot(scaledMelt,aes(x=Var1,y=value, col=Var2)) + theme_bw() + geom_jitter(width = 0.2) + geom_boxplot(aes(col=Var1)) + theme (axis.text.x = element_text(angle = 90)) + labs(x="", y="number of reads (CPM)", col="Category")
gsub(".f.bam", "", scaledMelt$Var2)
scaledMelt$Var2 <- gsub(".f.bam", "", scaledMelt$Var2)
ggplot(scaledMelt,aes(x=Var1,y=value, col=Var2)) + theme_bw() + geom_jitter(width = 0.2) + geom_boxplot(aes(col=Var1)) + theme (axis.text.x = element_text(angle = 90)) + labs(x="", y="number of reads (CPM)", col="Category")

levels(scaledMelt$Var1)
scaledMelt$Var1 <- gsub("Unassigned_NoFeatures", "Unas.NoFreatures", scaledMelt$Var1)
scaledMelt$Var1 <- gsub("Unassigned_Ambiguity", "Unas.Ambig.", scaledMelt$Var1)
ggplot(scaledMelt,aes(x=Var1,y=value, col=Var2)) + theme_bw() + geom_jitter(width = 0.2) + geom_boxplot(aes(col=Var1)) + theme (axis.text.x = element_text(angle = 90)) + labs(x="", y="number of reads (CPM)", col="Category")
# if you now saved it in your R directory on the server how to you get it to your PC??

#---------------------------------------------------------
# read our file counts after doing feature counts 
getwd()
counts <- read_tsv("counts.tsv", comment = "#") 
counts
counts <- counts[, c(1,6:17)] #filter for information we actually want 
counts
#now normalize the redcounts to the gene length - so divide the counts by the length and multiply by 1000bp
counts[,3]/counts[,2]*1000 #for just one column
counts
### we uploaded the counts as a special table and need to convert the one column table into a vector - then it should work
rpk <- counts[,3:13] / unlist(counts[,2]) *1000 #it will aplly a functtion on each column (reads per kilobase)
head(rpk)
#now to compare between libraries we are scaling the libraries to the same size
tpm <- cpm(rpk) #doubble normalisation is called transcripts per million normalisation
head(tpm)
rownames(tpm) <- unlist(counts[,1]) #we are changing the rownames in tpm with the columns in counts, but need to unlist first for it to become a matrix
melNorm <-melt(tpm)
melNorm
ggplot(melNorm) + geom_boxplot(aes(x=Var2,y=value, col=Var2))
#remove all the genes that are not expressed
tpmFil <- tpm[rowSums(tpm)>0,]

dim (tpmFil)
dim (tpm)
melNorm <- melt(tpmFil)
ggplot(melNorm) + geom_boxplot(aes(x=Var2,y=value, col=Var2)) + scale_y_log10() #plot a boxplot using library as X and read counts as y
ggplot(melNorm, aes(x=Var2, y=value, col=Var2)) + geom_violin () +geom_boxplot(width=0.1) \ 
+ scale_y_log10() + theme_bw() + labs(y="Read counts per gene (TPM)", x="", col ="Library") \
+ theme (axis.text.x =element_blank()) # this time added the astetics to all ggplots and not only to a specific one

melNorm$Var2 <- gsub("/scratch/course/2023w300106/BAMS/", "", melNorm$Var2)
ggplot(melNorm, aes(x=Var2, y=value, col=Var2)) + geom_violin () +geom_boxplot(width=0.1) + scale_y_log10() + theme_bw() + labs(y="Read counts per gene (TPM)", x="", col ="Library") + theme (axis.text.x =element_blank())

# plot the 10 most expressed genes in total in all libraries
head(melNorm)
melNorm %>% group_by(Var2) %>% arrange(desc(value), .by_group = TRUE) %>% dplyr::filter(row_number()<=5) #can apply a function thata applies on the output of the previous one - now have the top 5 from every library, but still have it sored by library because of (TRUE)
melNorm %>% group_by(Var2) %>% arrange(desc(value), .by_group = TRUE) %>% dplyr::filter(row_number()<=5) %>% ungroup() %>% group_by(Var1) %>% summarise(count=n()) %>% arrange(desc(count)) #how many genes are there in the 55 entries from before - and how often are they inside the list, and then arrange in decreasing order

#how many genes are expressed more than a base level one 1 transcript /million
melNorm %>% filter(value>=1) %>% dim() #[1] 153326      3
dim (melNorm) #[1] 246741      3
melNorm %>% dplyr::filter(value>=1) %>% group_by(Var1) %>% summarise(count=n())
melNorm %>% dplyr::filter(value>=1) %>% group_by(Var1) %>% summarise(count=n()) %>% ggplot(aes(x=count)) + geom_histogram()
melNorm %>% dplyr::filter(value>=1) %>% group_by(Var1) %>% summarise(count=n()) %>% ggplot(aes(y=count)) + geom_boxplot() #doesnt really make sense, jet, - shows how many libraries are the significant expression of genes
melNorm %>% dplyr::filter(value>=1) %>% group_by(Var1) %>% summarise(count=n()) %>% ggplot(aes(y=count, x=1)) + geom_violin()
melNorm %>% dplyr::filter(value>=1) %>% group_by(Var1) %>% summarise(count=n()) %>% ggplot(aes(y=count, x="reads")) + geom_violin()
melNorm %>% 
  dplyr::filter(value>=1) %>% 
  ggplot(aes(x=value, col=Var2)) + 
  geom_density() + scale_y_log10() + 
  scale_x_log10() + 
  labs(y='log of frqency', x='log of gene expression')
#were seeing how the different libraries have different exp levels of different genes. you can see some that are decreasing after many genes - running out of renes
