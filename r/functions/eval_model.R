eval_model = function(modele, test_data, modalite_pos, modalite_neg) {
    
    # (1) : importance
    imp = fun_imp_ggplot_split(modele)
    
    # (2) : score
    if (class(modele)[1] == "ranger"){
        scores = predict(object = modele,
                         data = test_data)$predictions %>% 
            data.frame("target_pred" = .)
        test_data = test_data %>% 
            bind_cols(target_pred = scores)
    } else {
        scores = predict(object = modele, 
                         newdata = test_data,
                         type = "response") %>%
            data.frame("score" = .)
        test_data = test_data %>% 
            bind_cols(score = scores) %>% 
            mutate(target_pred = factor(if_else(score > 0.5, modalite_pos, modalite_neg)))
    }
    
    # (3) : confusion matrix
    conf = caret::confusionMatrix(data = test_data$target_pred, 
                                  reference = test_data$target, 
                                  positive = modalite_pos, 
                                  mode = "everything")
    
    # (4) : AUC
    valeur_auc = auc(predicted = test_data$target_pred, actual = test_data$target)
    
    # (5) : AUPR
    valeur_aupr = aucpr(test_data$target, test_data$target_pred)
    
    return(list(importance = imp,
                score = scores,
                pred = test_data$target_pred,
                confusion_matrix = conf,
                auc = valeur_auc,
                valeur_aupr = valeur_aupr))
}