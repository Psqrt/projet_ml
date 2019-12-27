# Fonction permettant d'évaluer les performances d'un modèle sur de nouvelles données :
# Les inputs sont :
#   - modele_caret : objet `train` issu d'un apprentissage par caret
#   - test_data : df des nouvelles observations
#   - modalite_pos : modalité de la classe positive (chaîne de caractères)
#   - modalite_neg : modalité de la classe négative (chaîne de caractères)
#   - stacking : le modèle entraîné est-il un modèle de stacking ? (booléen)
# Les outputs sont :
#   - Graphique de l'importance des variables
#   - Table des prédictions (identifiant, score, prédiction, ...)
#   - Matrice de confusion
#   - Représentation visuelle de la matrice de confusion
#   - Métriques de performance
#   - Aires sous les courbes (ROC, PR)
#   - Courbes ROC et PR

test_model = function(modele_caret, test_data, modalite_pos, modalite_neg, stacking = F) {
    
    if (stacking == TRUE){
        learner = paste("stacking_", modele_caret$method, sep = "")
    } else {
        learner = modele_caret$method
    }
    
    # (1) : importance
    imp = fun_imp_ggplot_split(modele_caret)
    
    # (2) : scores
    scores = predict(object = modele_caret, 
                     newdata = test_data,
                     type = "prob") %>% 
        dplyr::select(score = modalite_pos)
    
    test_data = test_data %>% 
        bind_cols(score = scores) %>% 
        mutate(target_pred = factor(if_else(score > 0.5, modalite_pos, modalite_neg)))
    
    zz = test_data %>% 
        select(target, target_pred, score)
    
    # (3) : confusion matrix
    conf = caret::confusionMatrix(data = test_data$target_pred, 
                                  reference = test_data$target, 
                                  positive = modalite_pos, 
                                  mode = "everything")
    
    # (4) : confusion matrix important metrics
    conf_metrics = data.frame(model = learner,
                              accuracy = conf$overall["Accuracy"][[1]],
                              sensitivity = conf$byClass["Sensitivity"][[1]],
                              specificity = conf$byClass["Specificity"][[1]],
                              precision = conf$byClass["Precision"][[1]],
                              recall = conf$byClass["Recall"][[1]],
                              f1 = conf$byClass["F1"][[1]])
    
    # (5) : confusion matrix viz
    par(mar = c(1, 1, 1, 1), mfrow = c(1, 1))
    fourfoldplot(conf$table,
                 color = c("#B22222", "#2E8B57"),
                 conf.level = 0,
                 margin = 1,
                 std = "margin",
                 main = learner) +
        text(1.2, 1.3, colnames(conf_metrics)[2], cex = 1, adj = 0) +
        text(1.2, 1.2, colnames(conf_metrics)[3], cex = 1, adj = 0) +
        text(1.2, 1.1, colnames(conf_metrics)[4], cex = 1, adj = 0) +
        text(1.2, 1.0, colnames(conf_metrics)[5], cex = 1, adj = 0) +
        text(1.2, 0.9, colnames(conf_metrics)[6], cex = 1, adj = 0) +
        text(1.2, 0.8, colnames(conf_metrics)[7], cex = 1, adj = 0) +
        text(1.7, 1.3, round(conf_metrics[1, 2], 2), cex = 1, adj = 0) +
        text(1.7, 1.2, round(conf_metrics[1, 3], 2), cex = 1, adj = 0) +
        text(1.7, 1.1, round(conf_metrics[1, 4], 2), cex = 1, adj = 0) +
        text(1.7, 1.0, round(conf_metrics[1, 5], 2), cex = 1, adj = 0) +
        text(1.7, 0.9, round(conf_metrics[1, 6], 2), cex = 1, adj = 0) +
        text(1.7, 0.8, round(conf_metrics[1, 7], 2), cex = 1, adj = 0)
    conf_viz = recordPlot()
    
    
    # (6) areas
    fg = scores$score[test_data$target == modalite_pos]
    bg = scores$score[test_data$target == modalite_neg]
    
    roc = PRROC::roc.curve(scores.class0 = fg,
                           scores.class1 = bg,
                           curve = T)
    auc_roc = roc$auc
    
    pr = PRROC::pr.curve(scores.class0 = fg,
                         scores.class1 = bg,
                         curve = T)
    auc_pr = pr$auc.davis.goadrich
    
    # (7) curves
    roc_curve = roc$curve %>% 
        data.frame() %>% 
        rename(FPR = X1, TPR = X2, threshold = X3) %>% 
        ggplot() +
        aes(x = FPR, y = TPR, color = threshold) +
        geom_line(size = 1.5) +
        xlab("1 - Specificity") +
        ylab("Sensitivity") +
        ggtitle("ROC Curve") +
        scale_color_gradient2(mid = "orange", high = "red")
    
    pr_curve = pr$curve %>% 
        data.frame() %>% 
        rename(Recall = X1, Precision = X2, threshold = X3) %>% 
        ggplot() +
        aes(x = Recall, y = Precision, color = threshold) +
        geom_line(size = 1.5) +
        ggtitle("PR Curve") +
        scale_color_gradient2(mid = "orange", high = "red")
    
    curves = ggarrange(roc_curve, pr_curve,
                       nrow = 1, 
                       common.legend = T, 
                       legend = "bottom")
    
    
    return(list(importance = imp,
                score = scores$score,
                pred = test_data$target_pred,
                zz = zz,
                confusion_matrix = conf,
                confusion_viz = conf_viz,
                conf_metrics = conf_metrics,
                auc_roc = auc_roc,
                auc_pr = auc_pr,
                curves = curves))
}
