perf_logistic = eval_model(logistic, data_sel %>% filter(dataset == "test"), "1", "0")

score_test = data.frame("logistic" = perf_logistic$score$score,
                        "logistic2" = perf_logistic$score$score,
                        "logistic3" = perf_logistic$score$score,
                        "obs" = as.numeric(data_sel[data_sel$dataset == "test", "target"]) - 1)


roc_test = score_test %>%
  gather(key = "Method", value = "score", -obs) %>% 
  ggplot() +
  aes(d = obs,
      m = score,
      color = Method) +
  geom_roc(labels = F, pointsize = 0, size = 0.6) +
  xlab("Specificity") +
  ylab("Sensitivity") +
  ggtitle("ROC Curve", subtitle = "Validation dataset")

prcurve_test = gg_prcurve(score_test) + ggtitle("PR Curve", subtitle = "Validation dataset")

curves_test = ggarrange(roc_test, prcurve_test, 
                        common.legend = T,
                        legend = "bottom")

curves_test
