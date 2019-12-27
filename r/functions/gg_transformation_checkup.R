gg_transformation_checkup = function(donnees, variable) {
    donnees_clean = donnees
    if (min(donnees[donnees$dataset == "train", get("variable")]) <= 0){
        donnees[, get("variable")] = donnees[, get("variable")] + abs(min(donnees[donnees$dataset == "train", get("variable")])) + 1
        warning("LES VALEURS ONT ÉTÉ SHIFTÉES DE +(1+ABS(MIN(X)))")
    }
    
    boxcox_lambda = boxcox(get(variable) ~ 1, data = donnees %>% filter(dataset == "train")) %>% 
        data.frame() %>% 
        arrange(-y) %>%
        slice(1) %>% 
        dplyr::select(x) %>% 
        .$x
    
    
    
    log_mean = mean(log(donnees[donnees$dataset == "train", get("variable")]))
    log_std = sd(log(donnees[donnees$dataset == "train", get("variable")]))
    sqrt_mean = mean(sqrt(donnees[donnees$dataset == "train", get("variable")]))
    sqrt_std = sd(sqrt(donnees[donnees$dataset == "train", get("variable")]))
    boxcox_mean = mean(boxcox_transformation(donnees[donnees$dataset == "train", get("variable")], lambda = boxcox_lambda))
    boxcox_std = sd(boxcox_transformation(donnees[donnees$dataset == "train", get("variable")], lambda = boxcox_lambda))
    
    print(donnees_clean %>% 
              ggplot() +
              geom_density(aes(x = get(variable), color = "sans transformation")) +
              stat_function(fun = dnorm, n = 100, args = list(mean = 0, sd = 1), aes(color = "gaussian C/R")) +
              facet_grid(dataset ~ ., scales = "free_y") +
              theme(legend.position = "bottom") +
              xlab(get("variable")) +
              scale_color_discrete(name = "Distribution"))
    
    print(donnees %>% 
              ggplot() +
              geom_density(aes(x = (log(get(variable)) - log_mean)/log_std, color = "log C/R")) +
              geom_density(aes(x = (sqrt(get(variable)) - sqrt_mean)/sqrt_std, color = "sqrt C/R")) +
              geom_density(aes(x = (boxcox_transformation(get(variable), boxcox_lambda) - boxcox_mean)/boxcox_std, color = "box-cox C/R")) +
              stat_function(fun = dnorm, n = 100, args = list(mean = 0, sd = 1), aes(color = "gaussian C/R")) +
              facet_grid(dataset ~ ., scales = "free_y") +
              theme(legend.position = "bottom") +
              xlab(get("variable")) +
              scale_color_discrete(name = "Distribution"))
    
    return(list(lambda = boxcox_lambda,
                log_mean = log_mean,
                log_std = log_std,
                sqrt_mean = sqrt_mean,
                sqrt_std = sqrt_std,
                boxcox_mean = boxcox_mean,
                boxcox_std = boxcox_std))
}
