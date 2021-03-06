### Jinliang Yang
### Sept. 21th, 2016


library("farmeR")
library("data.table")

###
gt0 <- fread("largedata/GAPIT.RNAseq.hmp_438K_imputed2.csv", data.table=FALSE)

#### genotypes
gt0 <- read.table("/home/jolyang/dbcenter/HapMap/HapMap3/vcf.header", header=F)
gt <- as.data.frame(t(gt0[, -1:-9])) 
names(gt) <- "genotype"

### 
sam <- read.csv("data/SAM_cellcount.csv")
sam <- subset(sam, !is.na(Count_Cells))
id <- as.character(unique(sam$Genotype))

subset(gt, genotype %in% id)




### convert to PLINK
cmd1 <- c("cd /home/jolyang/dbcenter/HapMap/HapMap3")
cmd2 <- paste("plink -vcf merged_flt_c1.vcf.gz --biallelic-only --snps-only --set-missing-var-ids @_# --out plink_chr1", 
              "--allow-extra-chr --freq")

set_farm_job(slurmsh = "slurm-script/bcf2plink.sh",
             shcode = c(cmd1, cmd2), wd = NULL, jobid = "maf",
             email = "yangjl0930@gmail.com", runinfo = c(TRUE, "bigmemh", "3", "23000"))


#########################################
for(i in 1:10){
  shid <- paste0("slurm-script/runplink_", i, ".sh")
  cmd1 <- c("cd /home/jolyang/dbcenter/HapMap/HapMap3")
  cmd2 <- paste0("plink -vcf merged_flt_c", i, ".vcf.gz --biallelic-only --snps-only", 
                 " --set-missing-var-ids @_# --out plink_chr", i, 
                 " --allow-extra-chr --freq")
  cat(c(cmd1, cmd2), file=shid, sep="\n", append=FALSE)
}
shcode <- "sh slurm-script/runplink_$SLURM_ARRAY_TASK_ID.sh"

set_array_job(shid="slurm-script/runplink.sh", shcode=shcode,
              arrayjobs="1-10", wd=NULL, jobid="plink", email="yangjl0930@gmail.com",
              run = c(TRUE, "bigmemh", 4))

