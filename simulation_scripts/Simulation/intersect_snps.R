args = commandArgs(trailingOnly = TRUE)

pop1_bim = read.delim(args[1], header=F, quote="")
pop2_bim = read.delim(args[2], header=F, quote="")
pop3_bim = read.delim(args[3], header=F, quote="")

common.snps = which(pop3_bim$V2 %in% pop2_bim$V2[which(pop2_bim$V2 %in% pop1_bim$V2)])
write.table(pop3_bim$V2[common.snps], file=args[4], sep="\t", col.names=F, row.names=F, quote=F )