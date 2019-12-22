# Fonction qui trace le FFP avec des paramètres voulus par défaut

ffp_default = function(perf_validation) {
    
    fourfoldplot(perf_validation$confusion_matrix$table,
                 color = c("#B22222", "#2E8B57"),
                 conf.level = 0,
                 margin = 1,
                 std = "margin",
                 main = perf_validation$conf_metrics$model)
}