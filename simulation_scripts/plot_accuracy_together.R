library(ggplot2)

# c=1
setwd("/Users/xinhuang/Documents/1st Year PhD/Zarlab/New MsCAVIAR simulation/c=1")
caviar_ASN_c1 <- read.table("R_caviar_ASN_recall_rate.txt", header = F)
caviar_EURO1_c1 <- read.table("R_caviar_EURO1_recall_rate.txt", header = F)
caviar_EURO2_c1 <- read.table("R_caviar_EURO2_recall_rate.txt", header = F)
caviar_EUROs_c1 <- read.table("R_caviar_EUROs_recall_rate.txt", header = F)
susie_ASN_c1 <- read.table("R_susie_ASN_recall_rate.txt", header = F)
susie_EURO1_c1 <- read.table("R_susie_EURO1_recall_rate.txt", header = F)
mscaviar_c1 <- read.table("R_mscaviar_recall_rate.txt", header = F)
mscaviar_EUROs_c1 <- read.table("R_mscaviar_EUROs_recall_rate.txt", header = F)
mscaviarPIP_c1 <- read.table("R_mscaviar_cutoff_recall_rate.txt", header = F)
mscaviarPIP_EUROs_c1 <- read.table("R_mscaviar_EUROs_cutoff_recall_rate.txt", header = F)
paintor_c1 <- read.table("R_paintor_recall_rate.txt", header = F)
# significance_c1 <- read.table("R_significance.txt", header = F)

# c=2
setwd("/Users/xinhuang/Documents/1st Year PhD/Zarlab/New MsCAVIAR simulation/c=2")
caviar_ASN_c2 <- read.table("R_caviar_ASN_recall_rate.txt", header = F)
caviar_EURO1_c2 <- read.table("R_caviar_EURO1_recall_rate.txt", header = F)
caviar_EURO2_c2 <- read.table("R_caviar_EURO2_recall_rate.txt", header = F)
caviar_EUROs_c2 <- read.table("R_caviar_EUROs_recall_rate.txt", header = F)
susie_ASN_c2 <- read.table("R_susie_ASN_recall_rate.txt", header = F)
susie_EURO1_c2 <- read.table("R_susie_EURO1_recall_rate.txt", header = F)
mscaviar_c2 <- read.table("R_mscaviar_recall_rate.txt", header = F)
mscaviar_EUROs_c2 <- read.table("R_mscaviar_EUROs_recall_rate.txt", header = F)
mscaviarPIP_c2 <- read.table("R_mscaviar_cutoff_recall_rate.txt", header = F)
mscaviarPIP_EUROs_c2 <- read.table("R_mscaviar_EUROs_cutoff_recall_rate.txt", header = F)
paintor_c2 <- read.table("R_paintor_recall_rate.txt", header = F)
# significance_c2 <- read.table("R_significance.txt", header = F)

# c=3
setwd("/Users/xinhuang/Documents/1st Year PhD/Zarlab/New MsCAVIAR simulation/c=3")
caviar_ASN_c3 <- read.table("R_caviar_ASN_recall_rate.txt", header = F)
caviar_EURO1_c3 <- read.table("R_caviar_EURO1_recall_rate.txt", header = F)
caviar_EURO2_c3 <- read.table("R_caviar_EURO2_recall_rate.txt", header = F)
caviar_EUROs_c3 <- read.table("R_caviar_EUROs_recall_rate.txt", header = F)
susie_ASN_c3 <- read.table("R_susie_ASN_recall_rate.txt", header = F)
susie_EURO1_c3 <- read.table("R_susie_EURO1_recall_rate.txt", header = F)
mscaviar_c3 <- read.table("R_mscaviar_recall_rate.txt", header = F)
mscaviar_EUROs_c3 <- read.table("R_mscaviar_EUROs_recall_rate.txt", header = F)
mscaviarPIP_c3 <- read.table("R_mscaviar_cutoff_recall_rate.txt", header = F)
mscaviarPIP_EUROs_c3 <- read.table("R_mscaviar_EUROs_cutoff_recall_rate.txt", header = F)
paintor_c3 <- read.table("R_paintor_recall_rate.txt", header = F)
# significance_c3 <- read.table("R_significance.txt", header = F)

plotName <- "recall_rate.png"
tau <- 0.5
causal <- 1
tau_info <- paste("Tau^2 =", tau)
causal_info <- paste("Causal =", causal)
title <- paste(tau_info)

all <- list(caviar_ASN_c1$V1, caviar_ASN_c2$V1,caviar_ASN_c3$V1,
            caviar_EURO1_c1$V1, caviar_EURO1_c2$V1,caviar_EURO1_c3$V1,
            caviar_EURO2_c1$V1,caviar_EURO2_c2$V1,caviar_EURO2_c3$V1,
            caviar_EUROs_c1$V1,caviar_EUROs_c2$V1,caviar_EUROs_c3$V1,
            mscaviar_c1$V1, mscaviar_c2$V1, mscaviar_c3$V1, 
            mscaviar_EUROs_c1$V1, mscaviar_EUROs_c2$V1,mscaviar_EUROs_c3$V1,
            mscaviarPIP_c1$V1, mscaviarPIP_c2$V1,mscaviarPIP_c3$V1,
            mscaviarPIP_EUROs_c1$V1, mscaviarPIP_EUROs_c2$V1,mscaviarPIP_EUROs_c3$V1,
            paintor_c1$V1, paintor_c2$V1,paintor_c3$V1)
Method=rep(c("CAVIAR ASN", "CAVIAR EURO1","CAVIAR EURO2", "CAVIAR EURO1+2", 
             "MsCAVIAR ASN+EURO", "MsCAVIAR EURO1+2", "MsCAVIARpip ASN+EURO", "MsCAVIARpip EURO1+2",
             "PAINTOR ASN+EURO"),each=3)
causal=rep(c("c=1", "c=2", "c=3"),each=1)
# all <- do.call(data.frame, all)
summary <- data.frame(causal, Method, I(lapply(all, mean)), I(lapply(all, sd)), I(lapply(all, length)))
colnames(summary) <- c("causal", "Method","mean", "sd", "n")
summary$mean <- as.numeric(summary$mean)
summary$sd <- as.numeric(summary$sd)
summary$n <- as.numeric(summary$n)

summary$se <- with(summary, sd / sqrt(n))

limits <- aes(ymax = summary$mean + summary$se,
              ymin = summary$mean - summary$se)

myplot <- ggplot(data = summary, aes(x = causal, y = mean, fill=Method))

myplot + geom_bar(stat = "identity",
                  position = position_dodge(0.9)) +
  geom_errorbar(limits, position = position_dodge(0.9),
                width = 0.25) +
  labs(x = "Number of causal variants", y = "Sensitivity") +
  geom_hline(yintercept=0.95, linetype="dashed", color = "black") +
  scale_y_continuous(breaks = seq(0, 1, by = 0.2), labels = scales::percent) +
  # coord_cartesian(ylim=c(0.5, 1)) +
  # scale_fill_manual(values=c("grey50", "grey50", "red", "grey50")) + 
  # scale_fill_manual(values=c("#58508d", "#bc5090", "#ff6361", "#ffa600")) +
  #scale_fill_manual(values=c("#003f5c","#444e86", "#955196", "#dd5182", "#ff6e54", "#ffa600")) +
  #scale_fill_manual(values=c("#024959","#027373", "#B80B00", "#F05640", "#FF9900", "#F2B705")) +
  # scale_fill_manual(values=c("#0E7373", "#B9D9B8", "#BF214B", "#F26D85", "#D9BEB4", "#96D2D9")) +
  theme_bw() +
  theme_minimal() +
  # theme(legend.title = element_blank()) +
  # theme(legend.position = "none") 
  theme(axis.text=element_text(size=14), axis.title=element_text(size=16,face="bold"), panel.border = element_rect(colour = "grey30", fill=NA, size=1))

ggsave(plotName)