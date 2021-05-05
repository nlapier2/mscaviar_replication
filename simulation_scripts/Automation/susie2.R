library(susieR)
set.seed(1)
args = commandArgs(trailingOnly = TRUE)
# [1] is summary statistics,[2] is LD matrix, [3] is the true causal file, [4] is number of causal snps,
# [5] is output subsets file name, [6] is output set file name, [7] is accuracy (sensitivity) file name, 
# [8] is set size file name, [9] is the number of credible sets file name.
# z reports line 1 did not have 10 elements
z <- read.table(args[1], header = FALSE)
R <- read.table(args[2], header = FALSE)
causal <- read.table(args[3], header = FALSE)
num_causal <- as.numeric(args[4])

R <- data.matrix(R)
snp_list <- z[["V1"]]
fitted <- susie_rss(z[,2], R,
                L = 10,
                estimate_residual_variance = TRUE,
                estimate_prior_variance = TRUE,
                verbose = TRUE, check_R = FALSE)

# number of causal sets (CS)
num_cs <- length(fitted$sets$cs)

if (num_cs == 0) {
  # when susie does not converge
  write.table(0, args[6], append = TRUE, col.names = FALSE, row.names = FALSE, quote = FALSE)
  write.table(0, args[7], append = TRUE, col.names = FALSE, row.names = FALSE, quote = FALSE)
  write.table(0, args[8], append = TRUE, col.names = FALSE, row.names = FALSE, quote = FALSE)
} else {
  for (each in 1:num_cs) {
    subset <- fitted$sets$cs[[each]] # the n-th causal set among all causal sets
    subset <- c(subset)
    snp_subset <- c()
    for (i in 1:length(subset)) {
      snp_subset <-c(snp_subset, as.character(snp_list[subset[i]]))
    }
    print(snp_subset)
    write.table(paste("cs", each, sep=""), args[5], append = TRUE, col.names = FALSE, row.names = FALSE, quote = FALSE)
    write.table(snp_subset, args[5], append = TRUE, col.names = FALSE, row.names = FALSE, quote = FALSE)
  }
  set <- do.call(c, fitted$sets$cs)
  count <- length(set)
  
  snp_set <- c()
  for (i in 1:count) {
    snp_set <-c(snp_set, as.character(snp_list[set[i]]))
  }
  
  write.table(snp_set, args[6], append = TRUE, col.names = FALSE, row.names = FALSE, quote = FALSE)
  # sensitivity
  write.table(length(which(causal$V1 %in% snp_set))/length(causal$V1), args[7], append = TRUE, 
              col.names = FALSE, row.names = FALSE, quote = FALSE)
  # set size
  write.table(count, args[8], append = TRUE, col.names = FALSE, row.names = FALSE, quote = FALSE)
}

write.table(num_cs, args[9], append = TRUE, col.names = FALSE, row.names = FALSE, quote = FALSE)