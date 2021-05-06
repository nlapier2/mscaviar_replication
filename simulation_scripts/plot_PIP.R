
PIP_c1_mean <- c(1.14220184,	1.14220184,	1.36880734,	1.37889908,	1.14954128,	1.14954128)
PIP_c1_se <- c(0.01654577,	0.01654577,	0.034511,	0.03498107,	0.01663884,	0.01684015)

PIP_c2_mean_1 <- c(1.03486239,	1.03486239,	1.21192661,	1.18440367,	1.07981651,	1.03577982)
PIP_c2_mean_2 <- c(2.2587156,	2.2587156,	3.23486239,	3.16880734,	2.39633028,	2.28440367)
PIP_c2_se_1 <- c(0.00874011,	0.00874011,	0.03950013,	0.02244397,	0.01784641,	0.00888017)
PIP_c2_se_2 <- c(0.02374103,	0.02374103,	0.11744162,	0.07281143,	0.04001652,	0.02804838)


PIP_c3_mean_1 <- c(1.020183486,	1.020183486,	1.118348624,	1.174311927,	1.033027523,	1.029357798)
PIP_c3_mean_2 <- c(2.137614679,	2.137614679,	2.610091743,	2.736697248,	2.227522936,	2.172477064)
PIP_c3_mean_3 <- c(3.455045872,	3.455045872,	5.440366972,	5.467889908,	3.811009174,	3.596330275)
PIP_c3_se_1 <- c(0.00562487,	0.00562487,	0.01335571,	0.01918467,	0.00761381,	0.0076276)
PIP_c3_se_2 <- c(0.01941334,	0.01941334,	0.04401185,	0.05459047,	0.04197681,	0.0244496)
PIP_c3_se_3 <- c(0.03789182,	0.03789182,	0.17544339,	0.13940898,	0.09127472,	0.04907194)

causal=rep(c("c=1", "c=2", "c=3"), c(6, 12, 18))
# SNP=rep(c(1, 1, 2, 1, 2, 3), rep=6)
SNP=c(1, 1, 1, 1, 1, 1,
             1, 1, 1, 1, 1, 1, 2, 2, 2, 2, 2, 2,
             1, 1, 1, 1, 1, 1, 2, 2, 2, 2, 2, 2, 3, 3, 3, 3, 3, 3)

mean <- c(PIP_c1_mean, PIP_c2_mean_1, PIP_c2_mean_2, PIP_c3_mean_1,
              PIP_c3_mean_2, PIP_c3_mean_3)
se <- c(PIP_c1_se, PIP_c2_se_1, PIP_c2_se_2, PIP_c3_se_1,
            PIP_c3_se_2, PIP_c3_se_3)

Method=rep(c("MsCAVIAR ASN+EURO", "MsCAVIARpip ASN+EURO", 
             "CAVIAR ASN", "CAVIAR EURO1","CAVIAR EURO1+2",
             "PAINTOR ASN+EURO"),each=1)
summary <- data.frame(Method, causal, SNP, mean, se)

limits <- aes(ymax = summary$mean + summary$se,
              ymin = summary$mean - summary$se)

myplot <- ggplot(data = summary, aes(x = causal, y = mean, fill=Method, alpha=SNP))

myplot + geom_bar(stat = "identity",
                  position = position_dodge(0.9)) +
  geom_errorbar(limits, position = position_dodge(0.9),
                width = 0.25) +
  scale_alpha(range = c(1, 0.5), guide = 'none') +
  labs(x = "Number of causal variants", y = "Number of SNPs until causal identified") +
  scale_fill_manual(values=c("#0E7373", "#B9D9B8", "#BF214B", "#F26D85", "#D9BEB4", "#96D2D9")) +
  theme_bw() +
  theme_minimal() +
  theme(axis.text=element_text(size=14), axis.title=element_text(size=12,face="bold"), panel.border = element_rect(colour = "grey30", fill=NA, size=1))

