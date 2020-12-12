require(ggplot2)
load("deviance_results.rData")

p1 <- ggplot(results, aes(x=deviance, y=avg_pairs)) + 
  geom_boxplot(aes(fill=deviance)) + 
  geom_dotplot(binaxis='y', stackdir='center',position=position_dodge(1), fill="black") + 
  theme(legend.position = "none") + labs(title="Average number of recalled pairs vs Semantic deviance", x = "Semantic Deviance", y = "Average number of recalled pairs")


rec <- c(results$t1_pairs, results$t2_pairs, results$t3_pairs)
tr <- c(rep("Trial 1", 12), rep("Trial 2", 12), rep("Trial 3", 12))
dev <- rep(results$deviance, 3)
df <- data.frame(rec, tr, dev)
names(df) <- c("rec", "tr", "Semantic Deviance")

p2 <- ggplot(df, aes(x=tr, y=rec)) + 
  geom_boxplot(aes(fill=`Semantic Deviance`)) + 
  labs(title="Number of recalled pairs vs Per Trial", x = "Trial", y = "Number of recalled pairs") + 
  theme(
  legend.position = c(.95, .05),
  legend.justification = c("right", "bottom"),
  legend.box.just = "right",
  legend.margin = margin(6, 6, 6, 6)
)