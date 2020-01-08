# Inputs : le model (objet issu caret) et la mesure d'importance (gain, frequence, cover par exemple)
# Output : un ggplot split en deux pour que les noms des variables soient plus lisibles
# Intérêt : lorsqu'il y a trop de variables, le graphique des importances est trop compact,
# d'ou l'intérêt de diviser en deux.

fun_imp_ggplot_split_boosting = function(model, metric) {
    if (class(model)[1] == "lgb.Booster"){
        df = lgb.importance(model) %>% as.data.frame() %>% select(Feature, get("metric"))
    } else {
        df = xgb.importance(model = model) %>% as.data.frame() %>% select(Feature, get("metric"))
    }
    colnames(df) = c("Feature", "Importance")
    
    gg1 = df %>% 
        arrange(-Importance) %>% 
        slice(1:(floor(nrow(df)/2))) %>% 
        ggplot() +
        aes(x = reorder(Feature, Importance), weight = Importance, fill = -Importance) +
        geom_bar() +
        coord_flip() + xlab("Variables") + ylab(metric) + theme(legend.position = "none")
    
    imp_range = ggplot_build(gg1)[["layout"]][["panel_params"]][[1]][["x.range"]]
    imp_gradient = scale_fill_gradient(limits = c(-imp_range[2], -imp_range[1]),
                                       low = "#132B43", 
                                       high = "#56B1F7")
    
    gg2 = df %>% 
        arrange(-Importance) %>% 
        slice((floor(nrow(df)/2)+1):nrow(df)) %>% 
        ggplot() +
        aes(x = reorder(Feature, Importance), weight = Importance, fill = -Importance) +
        geom_bar() +
        coord_flip() + xlab("Variables") + ylab(metric) + theme(legend.position = "none") +
        ylim(imp_range) +
        imp_gradient
    
    return(plot_grid(gg1 + imp_gradient, gg2))
}
