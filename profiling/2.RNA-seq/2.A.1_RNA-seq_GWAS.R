# Jinliang Yang
# 01-31-2017
# purpose: compute the gene expression complementation for the bybrids

### reformat the data
gene <- read.delim("largedata/maize_503genotypes_raw_expression_values_FPKM.txt", header=TRUE)
names(gene) <- c(names(gene)[-1], "N")
gene <- gene[, 1:506]

idx <- grepl("joint", row.names(gene))
sum(idx) #[1] 8681

### Note: NA indicating the absent of the gene
### 0 denotes the presence of the gene, but without expression

gene[is.na(gene)] <- 0.00001

### write the data
write.table(gene, "largedata/1.gc/maize_gene_503lines.csv", sep=",", row.names=TRUE, quote=FALSE)


### checking one random gene
hist(-log10(t(gene[6, 4:506])), main="GRMZM2G125201", xlab="-log10(FPKM)")

range(gene$Mo17)
