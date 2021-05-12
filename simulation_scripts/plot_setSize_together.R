library(ggplot2)

# c=1
setwd("/Users/xinhuang/Documents/1st Year PhD/Zarlab/New MsCAVIAR simulation/c=1")
caviar_ASN_c1 <- read.table("R_caviar_ASN_config_size.txt", header = F)
caviar_EURO1_c1 <- read.table("R_caviar_EURO1_config_size.txt", header = F)
caviar_EURO2_c1 <- read.table("R_caviar_EURO2_config_size.txt", header = F)
caviar_EUROs_c1 <- read.table("R_caviar_EUROs_config_size.txt", header = F)
susie_ASN_c1 <- read.table("R_susie_ASN_config_size.txt", header = F)
susie_EURO1_c1 <- read.table("R_susie_EURO1_config_size.txt", header = F)
mscaviar_c1 <- read.table("R_mscaviar_config_size.txt", header = F)
mscaviar_EUROs_c1 <- read.table("R_mscaviar_EUROs_config_size.txt", header = F)
mscaviarPIP_c1 <- read.table("R_mscaviarPIP_config_size.txt", header = F)
mscaviarPIP_EUROs_c1 <- read.table("R_mscaviarPIP_EUROs_config_size.txt", header = F)
paintor_c1 <- read.table("R_paintor_config_size.txt", header = F)

# c=2
setwd("/Users/xinhuang/Documents/1st Year PhD/Zarlab/New MsCAVIAR simulation/c=2")
caviar_ASN_c2 <- read.table("R_caviar_ASN_config_size.txt", header = F)
caviar_EURO1_c2 <- read.table("R_caviar_EURO1_config_size.txt", header = F)
caviar_EURO2_c2 <- read.table("R_caviar_EURO2_config_size.txt", header = F)
caviar_EUROs_c2 <- read.table("R_caviar_EUROs_config_size.txt", header = F)
susie_ASN_c2 <- read.table("R_susie_ASN_config_size.txt", header = F)
susie_EURO1_c2 <- read.table("R_susie_EURO1_config_size.txt", header = F)
mscaviar_c2 <- read.table("R_mscaviar_config_size.txt", header = F)
mscaviar_EUROs_c2 <- read.table("R_mscaviar_EUROs_config_size.txt", header = F)
mscaviarPIP_c2 <- read.table("R_mscaviarPIP_config_size.txt", header = F)
mscaviarPIP_EUROs_c2 <- read.table("R_mscaviarPIP_EUROs_config_size.txt", header = F)
paintor_c2 <- read.table("R_paintor_config_size.txt", header = F)


plotName <- "config_size.png"
tau <- 0.5
causal <- 1
tau_info <- paste("Tau^2 =", tau)
causal_info <- paste("Causal =", causal)
title <- paste(tau_info)

set_size <- c(caviar_ASN_c1$V1, caviar_ASN_c2$V1,
              caviar_EURO1_c1$V1, caviar_EURO1_c2$V1,
              caviar_EURO2_c1$V1,caviar_EURO2_c2$V1,
              caviar_EUROs_c1$V1,caviar_EUROs_c2$V1,
              mscaviar_c1$V1, mscaviar_c2$V1, 
              mscaviar_EUROs_c1$V1, mscaviar_EUROs_c2$V1,
              mscaviarPIP_c1$V1, mscaviarPIP_c2$V1,
              mscaviarPIP_EUROs_c1$V1, mscaviarPIP_EUROs_c2$V1,
              paintor_c1$V1, paintor_c2$V1,
              susie_ASN_c1$V1, susie_ASN_c2$V1,
              susie_EURO1_c1$V1, susie_EURO1_c2$V1)
Method=rep(c("CAVIAR ASN", "CAVIAR EURO1","CAVIAR EURO2", "CAVIAR EURO1+2", 
             "MsCAVIAR ASN+EURO", "MsCAVIAR EURO1+2", "MsCAVIARpip ASN+EURO", "MsCAVIARpip EURO1+2",
             "PAINTOR ASN+EURO", "SuSiE ASN", "SuSiE EURO1"), each=2180)
# causal=rep(c("c=1"),each=1000)
# Method=rep(c("CAVIAR Asian", "CAVIAR European", "MsCAVIAR", "PAINTOR"),each=3000)
causal=rep(c("c=1", "c=2"),each=1090)
data=data.frame(causal, Method,  set_size)

myplot <- ggplot(data, aes(x = causal, y = set_size, fill=Method))

myplot + geom_boxplot(outlier.size = 0.2) +
  labs(x = "Number of causal variants", y = "Set Size") + 
  # scale_fill_manual(values=c("#58508d", "#bc5090", "#ff6361", "#ffa600")) + 
  # scale_fill_manual(values=c("#003f5c","#444e86", "#955196", "#dd5182", "#ff6e54", "#ffa600")) +
  # scale_fill_manual(values=c("#024959","#027373", "#B80B00", "#F2B999", "#F29F05", "#F2B705")) +
  # scale_fill_manual(values=c("#0E7373", "#B9D9B8", "#BF214B", "#F26D85", "#D9BEB4", "#96D2D9")) +
  ylim(0, 25) +
  theme_bw() +
  theme_minimal() + 
  theme(axis.text=element_text(size=14), axis.title=element_text(size=16,face="bold"), panel.border = element_rect(colour = "grey30", fill=NA, size=1))


ggsave(plotName)