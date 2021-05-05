library(ggplot2)
args = commandArgs(trailingOnly = TRUE)
caviar_union <- read.table(args[1], header = F)
caviar_intersect <- read.table(args[2], header = F)
mscaviar <- read.table(args[3], header = F)
paintor <- read.table(args[4], header = F)
plotName <- args[5]
tau <- args[6]
causal <- args[7]

# caviar_union <- read.table("R_caviar_t=2_c=3_union_recall_rate.txt", header = F)
# caviar_intersect <- read.table("R_caviar_t=2_c=3_intersect_recall_rate.txt", header = F)
# mscaviar <- read.table("R_mscaviar_t=2_c=3_recall_rate.txt", header = F)
# paintor <- read.table("R_paintor_t=2_c=3_recall_rate.txt", header = F)
# plotName <- "t=2_c=3_recall_rate.png"
# tau <- 0
# causal <- 1
tau_info <- paste("Tau^2 =", tau)
causal_info <- paste("Causal =", causal)
title <- paste(tau_info, causal_info)

all <- list(caviar_union$V1, caviar_intersect$V1, mscaviar$V1, paintor$V1)
# all <- do.call(data.frame, all)
summary <- data.frame(I(lapply(all, mean)), I(lapply(all, sd)), I(lapply(all, length)))
colnames(summary) <- c("mean", "sd", "n")
summary$mean <- as.numeric(summary$mean)
summary$sd <- as.numeric(summary$sd)
summary$n <- as.numeric(summary$n)

# summary$se <- with(summary, sd / sqrt(n))

limits <- aes(ymax = summary$mean + summary$sd,
              ymin = summary$mean - summary$sd)

x_axis <- c("CAVIAR union", "CAVIAR intersect", "MsCAVIAR", "PAINTOR")

myplot <- ggplot(data = summary, aes(x = x_axis, y = mean, fill=x_axis))

myplot + geom_bar(stat = "identity",
             position = position_dodge(0.9)) +
  geom_errorbar(limits, position = position_dodge(0.9),
                width = 0.25) +
  labs(x = "Software", y = "Accuracy") +
  ggtitle(title) +
  scale_y_continuous(breaks = seq(0, 1, by = 0.1), labels = scales::percent) +
  scale_fill_manual(values=c("grey50", "grey50", "red", "grey50")) + 
  theme_bw() +
  theme_minimal() +
  theme(legend.title = element_blank()) +
  theme(legend.position = "none")

ggsave(plotName)