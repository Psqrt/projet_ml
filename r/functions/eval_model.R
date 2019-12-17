data(BreastCancer, package = "mlbench")

toto = BreastCancer


glimpse(toto)

toto_train = toto[1:200,]
toto_test = toto[201:nrow(toto),]

# (0) : model
logistic = glm(Class ~ Mitoses,
               data = toto_train,
               family = "binomial")
summary(logistic)

ma_function = function(modele, test_data, modalite_yes, modalite_no) {
    
    # (1) : importance
    imp = fun_imp_ggplot_split(modele)
    
    # (2) : score
    scores = predict(object = modele, 
                     newdata = test_data,
                     type = "response") %>%
        data.frame("score" = ., "id" = names(.))
    test_data = test_data %>% 
        bind_cols(score = scores) %>% 
        mutate(target_pred = factor(if_else(score > 0.5, modalite_yes, modalite_no)))
    
    # (3) : confusion matrix
    conf = confusionMatrix(test_data$target_pred, test_data$target, positive = "malignant", mode = 'everything')
    
    # (4) : AUC
    library(ModelMetrics)
    library(PRROC)
    valeur_auc = auc(toto_test$target_pred, toto_test$Class)
    valeur_auc
    
    # (5) : AUPR
    # computing AUPR
    aucpr = function(obs, score){
        # obs: real classes
        # score: predicted scores
        
        df = data.frame("pred" = score,
                        "obs" = obs)
        
        prc = pr.curve(df[df$obs == "malignant", ]$pred,
                       df[df$obs == "benign", ]$pred)
        
        return(prc$auc.davis.goadrich)
    }
    
    valeur_aupr = aucpr(toto_test$Class, toto_test$target_pred)
}

