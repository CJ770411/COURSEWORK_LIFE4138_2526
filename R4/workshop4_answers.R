###############################################################################
#                                                                             #
#  LIFE4138: R Workshop 4 – "Have a Go" Questions                             #
#                                                                             #
#  Author: Hannah Jackson                                                     #
#  Date: 3rd Nov 2025                                                         #
#                                                                             #
#  Description:                                                               #
#  This script contains worked solutions to the "Have a Go" questions         #
#  from the fourth R workshop in LIFE4138.                                    #
#                                                                             #
###############################################################################

## Have a go:

library(vcfR)
library(adegenet)

#1.  Read the VCF file Volucella_bombylans.vcf.gz from the git into your R environment 
# (make sure you give it a different name or you will overwrite the other VCF we’ve been working with)

vcf <- read.vcfR("Volucella_bombylans.vcf.gz")

#2.  Print the dimensions of the VCF to your R console

dim(vcf)

#3.  Filter the vcf so that it contains only the three individuals: VB20001, VB20005 and VB21020 
# (remember you will also need to retain the format column)

vcf[,c("FORMAT", "VB20001", "VB20005", "VB21020")]

#4.  Query the VCF to see how many sites are biallelic, output the result as a table

table(is.biallelic(vcf))

# OR

vcf %>%
  is.biallelic() %>%
  table()

#5.  Query the VCF to see how many sites are indels, output the result as a table

table(is.indel(vcf))

#6.  Show how you would filter the VCF to contain only sites that are NOT indels

vcf[(!is.indel(vcf)),]

#7.  Convert your vcfR object to chromR format and plot some general stats on the chromR object 
# (make sure you give your new chromR object a different name too)

chrom <- create.chromR(vcf, name = "chr5")
plot(chrom)

#8.  **Brucey bonus:** Create a mask to filter your ChromR object - use plots from q7 to guide you 
# about where to set thresholds. Write your filtered vcf to a new file with a different name

chrom <- masker(chrom, mmin_QUAL = 50, min_DP = 200, max_DP = 800, min_MQ = 52, max_MQ = 60)
table(chrom@var.info$mask)
write.vcf(chrom, mask = T, file = "filtered_volucella_bombylans.vcf.gz")


