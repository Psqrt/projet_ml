# Modèles testés :
    # traditionnels : RPART, GLM, GLMNET, KNN, LDA, SVM_RAD
    # bagging : RANGER
    # boosting : ADA, XGBTREE, GBM
    # stacking : GLM, RANGER

library(caret)
library(tidyverse)

source("./0_packages.R")
data("spam")
data = spam %>% 
    rename(target = type)

set.seed(1544)

# ech = sample(1:nrow(data), 3000)
# train = data[ech,]
# test = data[-ech,]

train_ind = createDataPartition(data$target, p = 0.8, list = F)

train = data[train_ind,]
test = data[-train_ind,]

table(train$target)
table(test$target)


### ARBRE DE DÉCISION ####

modelLookup("rpart")

# tune_control <- trainControl(method = "repeatedcv",
#                              number = 5,
#                              repeats = 10,
#                              summaryFunction = prSummary,
#                              classProbs = T)
tune_control <- trainControl(method = "cv",
                             number = 10,
                             summaryFunction = prSummary,
                             classProbs = T,
                             savePredictions = T)

tune_grid = expand.grid(
    cp = seq(from = 0, to = 0.4, by = 0.01)
)

rpart = train(
    target ~ .,
    data = train,
    metric = "F",
    trControl = tune_control,
    tuneGrid = tune_grid,
    method = "rpart"
)

ggplot(rpart)

toto_rpart = eval_model(rpart, "spam", "nonspam")


### RÉGRESSION LOGISTIQUE ####

modelLookup("glm")

logistic = train(
    target ~ .,
    data = train,
    metric = "F",
    trControl = tune_control,
    method = "glm",
    family = "binomial"
)

toto_logistic = eval_model(logistic, "spam", "nonspam")


### FORÊT ALÉATOIRE ####

modelLookup("ranger")

tune_grid = expand.grid(
    mtry = c(1:(floor(ncol(data) * 0.7))),
    # splitrule = c("gini", "extratrees"),
    splitrule = "gini",
    min.node.size = 1
)

foret = train(
    target ~ .,
    data = train,
    metric = "F",
    trControl = tune_control,
    tuneGrid = tune_grid,
    method = "ranger",
    importance = "impurity"
)

ggplot(foret)

toto_foret = eval_model(foret, "spam", "nonspam")


### ADA BOOST ####


modelLookup("ada")

tune_grid = expand.grid(
    iter = seq(50, 200, 50),
    maxdepth = c(1:4),
    nu = 0.1
)

ada = train(
    target ~ .,
    data = train,
    metric = "F",
    trControl = tune_control,
    tuneGrid = tune_grid,
    method = "ada",
)

ggplot(ada)


toto_ada = eval_model(ada, "spam", "nonspam")


### XGBoost tree ####

modelLookup("xgbTree")


tune_grid = expand.grid(
    nrounds = seq(200, 600, 50),
    eta = c(0.025, 0.05, 0.1, 0.3),
    max_depth = c(2, 3, 4, 5, 6),
    gamma = 0,
    colsample_bytree = 1,
    min_child_weight = 1,
    subsample = 1
)

# 1st
xgbtree = train(
    target ~ .,
    data = train,
    metric = "F",
    trControl = tune_control,
    tuneGrid = tune_grid,
    method = "xgbTree",
)

ggplot(xgbtree)

tune_grid = expand.grid(
    nrounds = seq(from = 50, to = 600, by = 50),
    eta = xgbtree$bestTune$eta,
    max_depth = ifelse(xgbtree$bestTune$max_depth == 2,
                       c(xgbtree$bestTune$max_depth:4),
                       (xgbtree$bestTune$max_depth - 1):(xgbtree$bestTune$max_depth + 1)),
    gamma = 0,
    colsample_bytree = 1,
    min_child_weight = c(1, 2, 3),
    subsample = 1
)

# 2nd
xgbtree = train(
    target ~ .,
    data = train,
    metric = "F",
    trControl = tune_control,
    tuneGrid = tune_grid,
    method = "xgbTree",
)

ggplot(xgbtree)


tune_grid = expand.grid(
    nrounds = seq(from = 50, to = 600, by = 50),
    eta = xgbtree$bestTune$eta,
    max_depth = xgbtree$bestTune$max_depth,
    gamma = 0,
    colsample_bytree = c(0.4, 0.6, 0.8, 1.0),
    min_child_weight = xgbtree$bestTune$min_child_weight,
    subsample = c(0.5, 0.75, 1.0)
)

# 3rd
xgbtree = train(
    target ~ .,
    data = train,
    metric = "F",
    trControl = tune_control,
    tuneGrid = tune_grid,
    method = "xgbTree",
)

ggplot(xgbtree)




tune_grid = expand.grid(
    nrounds = seq(from = 50, to = 600, by = 50),
    eta = xgbtree$bestTune$eta,
    max_depth = xgbtree$bestTune$max_depth,
    gamma = c(0, 0.05, 0.1, 0.5, 0.7, 0.9, 1.0),
    colsample_bytree = xgbtree$bestTune$colsample_bytree,
    min_child_weight = xgbtree$bestTune$min_child_weight,
    subsample = xgbtree$bestTune$subsample
)

# 4th
xgbtree = train(
    target ~ .,
    data = train,
    metric = "F",
    trControl = tune_control,
    tuneGrid = tune_grid,
    method = "xgbTree",
)

ggplot(xgbtree)








tune_grid = expand.grid(
    nrounds = seq(from = 100, to = 2000, by = 100),
    eta = c(0.01, 0.015, 0.025, 0.05, 0.1),
    max_depth = xgbtree$bestTune$max_depth,
    gamma = xgbtree$bestTune$gamma,
    colsample_bytree = xgbtree$bestTune$colsample_bytree,
    min_child_weight = xgbtree$bestTune$min_child_weight,
    subsample = xgbtree$bestTune$subsample
)


# 5th
xgbtree = train(
    target ~ .,
    data = train,
    metric = "F",
    trControl = tune_control,
    tuneGrid = tune_grid,
    method = "xgbTree",
)

ggplot(xgbtree)


xgbtree$bestTune

toto_xgbtree = eval_model(xgbtree, "spam", "nonspam")



### Elastic net ####

modelLookup("glmnet")

tune_grid = expand.grid(
    alpha = seq(0, 1, 0.1),
    lambda = seq(0, 3, 0.2)
)

elastic = train(
    target ~ .,
    data = train,
    metric = "F",
    trControl = tune_control,
    tuneGrid = tune_grid,
    method = "glmnet",
)

ggplot(elastic)




### naif bayes ####

modelLookup("nb")

tune_grid = expand.grid(
    fL = ,
    usekernel = ,
    adjust =
)

nbayes = train(
    target ~ .,
    data = train,
    metric = "F",
    trControl = tune_control,
    tuneGrid = tune_grid,
    method = "glmnet",
)

ggplot(nbayes)


toto_nbayes = eval_model(nbayes, "spam", "nonspam")


### KNN ####


modelLookup("knn")

tune_grid = expand.grid(
    k = seq(1, 10, 1)
)

kppv = train(
    target ~ .,
    data = train,
    metric = "F",
    trControl = tune_control,
    tuneGrid = tune_grid,
    method = "knn",
)

ggplot(kppv)


toto_kppv = eval_model(kppv, "spam", "nonspam")

### LDA ####


modelLookup("lda")

lda_model = train(
    target ~ .,
    data = train,
    metric = "F",
    trControl = tune_control,
    method = "lda",
)


toto_lda = eval_model(lda_model, "spam", "nonspam")


### QDA ####

# modelLookup("qda")
# 
# qda_model = train(
#     target ~ .,
#     data = train,
#     metric = "F",
#     trControl = tune_control,
#     method = "qda",
# )
# 
# 
# toto_qda = eval_model(qda_model, "spam", "nonspam")


### RDA ####


# modelLookup("rda")
# 
# tune_grid = expand.grid(
#     gamma = seq(0, 1, 0.1),
#     lambda = seq(0, 1, 0.1)
# )
# 
# rda_model = train(
#     target ~ .,
#     data = data,
#     metric = "F",
#     trControl = tune_control,
#     tuneGrid = tune_grid,
#     method = "rda",
# )
# 
# ggplot(rda_model)
# 
# 
# toto_rda = eval_model(rda_model, test, "spam", "nonspam")

### GBM ####



modelLookup("gbm")

tune_grid = expand.grid(
    n.trees = seq(100, 600, 100),
    interaction.depth = seq(1, 5, 1),
    shrinkage = 0.1,
    n.minobsinnode = seq(0.5, 1, 0.1)
)

gbm_model = train(
    target ~ .,
    data = train,
    metric = "F",
    trControl = tune_control,
    tuneGrid = tune_grid,
    method = "gbm",
)

ggplot(gbm_model)


toto_gbm = eval_model(gbm_model, "spam", "nonspam")

### SVM avec radial kernel ####


modelLookup("svmRadial")

tune_grid = expand.grid(
    sigma = c(0.1, 1, 10, 100, 1000),
    C = c(0.1, 1, 10, 100, 1000)
)

svm_rad = train(
    target ~ .,
    data = train,
    metric = "F",
    trControl = tune_control,
    tuneGrid = tune_grid,
    method = "svmRadial",
)

ggplot(svm_rad)


toto_svm_rad = eval_model(svm_rad, "spam", "nonspam")


###### stacking GLM ####

stacking_train = toto_rpart$df_recap %>% 
    dplyr::select(rowIndex, target = obs, rpart_learner = pred) %>% 
    left_join(toto_logistic$df_recap %>% dplyr::select(rowIndex, glm_learner = pred)) %>% 
    left_join(toto_foret$df_recap %>% dplyr::select(rowIndex, rf_learner = pred)) %>% 
    left_join(toto_ada$df_recap %>% dplyr::select(rowIndex, ada_learner = pred)) %>% 
    left_join(toto_xgbtree$df_recap %>% dplyr::select(rowIndex, xgbtree_learner = pred)) %>% 
    left_join(toto_elastic$df_recap %>% dplyr::select(rowIndex, glmnet_learner = pred)) %>% 
    left_join(toto_kppv$df_recap %>% dplyr::select(rowIndex, knn_learner = pred)) %>% 
    left_join(toto_lda$df_recap %>% dplyr::select(rowIndex, lda_learner = pred)) %>% 
    left_join(toto_gbm$df_recap %>% dplyr::select(rowIndex, gbm_learner = pred)) %>% 
    left_join(toto_svm_rad$df_recap %>% dplyr::select(rowIndex, svm_rad_learner = pred))



stacking_glm = train(
    target ~ . - rowIndex,
    data = stacking_train,
    metric = "F",
    trControl = tune_control,
    method = "glm",
    family = "binomial"
)

toto_stacking_glm = eval_model(stacking_glm, "spam", "nonspam", T)

#### Stacking RF ####

tune_grid = expand.grid(
    mtry = c(1:(floor(ncol(stacking_train) * 0.7))),
    # splitrule = c("gini", "extratrees"),
    splitrule = "gini",
    min.node.size = 1
)

stacking_rf = train(
    target ~ . - rowIndex,
    data = stacking_train,
    metric = "F",
    trControl = tune_control,
    tuneGrid = tune_grid,
    method = "ranger",
    importance = "impurity"
)

ggplot(stacking_rf)

toto_stacking_rf = eval_model(stacking_rf, "spam", "nonspam", T)















#### recap ####

save(rpart, logistic, foret, ada, xgbtree, elastic, kppv, lda_model, gbm_model, svm_rad, stacking_glm, stacking_rf,
     toto_rpart, toto_logistic, toto_foret, toto_ada, toto_xgbtree, toto_elastic, toto_kppv, 
     toto_lda, toto_gbm, toto_svm_rad, toto_stacking_glm, toto_stacking_rf,
     file = "./jobs/modeles_et_perf.RData")

load(file = "./jobs/modeles_et_perf.RData")



# faire une fonction qui, pour une liste de caret train donnée, on plot toutes les ffp

par(mfrow = c(3, 4))
ffp_default(toto_rpart)
ffp_default(toto_logistic)
ffp_default(toto_foret)
ffp_default(toto_ada)
ffp_default(toto_xgbtree)
ffp_default(toto_elastic)
ffp_default(toto_kppv)
ffp_default(toto_lda)
ffp_default(toto_gbm)
ffp_default(toto_svm_rad)
ffp_default(toto_stacking_glm)
ffp_default(toto_stacking_rf)
par(mfrow = c(1, 1))




toto_rpart$conf_metrics %>% 
    bind_rows(toto_logistic$conf_metrics) %>% 
    bind_rows(toto_foret$conf_metrics) %>% 
    bind_rows(toto_ada$conf_metrics) %>% 
    bind_rows(toto_xgbtree$conf_metrics) %>% 
    bind_rows(toto_elastic$conf_metrics) %>% 
    bind_rows(toto_kppv$conf_metrics) %>% 
    bind_rows(toto_lda$conf_metrics) %>% 
    bind_rows(toto_gbm$conf_metrics) %>% 
    bind_rows(toto_svm_rad$conf_metrics) %>% 
    bind_rows(toto_stacking_glm$conf_metrics) %>% 
    bind_rows(toto_stacking_rf$conf_metrics)

toto_rpart$df_roc %>% 
    bind_rows(toto_logistic$df_roc) %>% 
    bind_rows(toto_foret$df_roc) %>% 
    bind_rows(toto_ada$df_roc) %>% 
    bind_rows(toto_xgbtree$df_roc) %>% 
    bind_rows(toto_elastic$df_roc) %>% 
    bind_rows(toto_kppv$df_roc) %>% 
    bind_rows(toto_lda$df_roc) %>% 
    bind_rows(toto_gbm$df_roc) %>% 
    bind_rows(toto_svm_rad$df_roc) %>% 
    bind_rows(toto_stacking_glm$df_roc) %>% 
    bind_rows(toto_stacking_rf$df_roc) %>% 
    ggplot() +
    aes(x = FPR, y = TPR, color = methode) +
    geom_line(size = 0.5) +
    xlab("1 - Specificity") +
    ylab("Sensitivity") +
    ggtitle("ROC Curve")


toto_rpart$df_pr %>% 
    bind_rows(toto_logistic$df_pr) %>% 
    bind_rows(toto_foret$df_pr) %>% 
    bind_rows(toto_ada$df_pr) %>% 
    bind_rows(toto_xgbtree$df_pr) %>% 
    bind_rows(toto_elastic$df_pr) %>% 
    bind_rows(toto_kppv$df_pr) %>% 
    bind_rows(toto_lda$df_pr) %>% 
    bind_rows(toto_gbm$df_pr) %>% 
    bind_rows(toto_svm_rad$df_pr) %>% 
    bind_rows(toto_stacking_glm$df_pr) %>% 
    bind_rows(toto_stacking_rf$df_pr) %>% 
    ggplot() +
    aes(x = Recall, y = Precision, color = methode) +
    geom_line(size = 0.5) +
    ggtitle("PR Curve")



# # gbm best
# 
# gbm_model$bestTune
# 
# 
# tune_grid = expand.grid(
#     n.trees = gbm_model$bestTune$n.trees,
#     interaction.depth = gbm_model$bestTune$interaction.depth,
#     shrinkage = gbm_model$bestTune$shrinkage,
#     n.minobsinnode = gbm_model$bestTune$n.minobsinnode
# )
# 
# tune_control <- trainControl(method = "none",
#                              summaryFunction = prSummary,
#                              classProbs = T,
#                              savePredictions = T)
# 
# gbm_model_final = train(
#     target ~ .,
#     data = train,
#     metric = "F",
#     trControl = tune_control,
#     tuneGrid = tune_grid,
#     method = "gbm",
# )
# 
# test_res = test_model(gbm_model_final, test, "spam", "nonspam")



# stacking_ranger best

stacking_test = data.frame(target = test$target,
                           rpart_learner = predict(rpart, test),
                           glm_learner = predict(logistic, test),
                           rf_learner = predict(foret, test),
                           ada_learner = predict(ada, test),
                           xgbtree_learner = predict(xgbtree, test),
                           glmnet_learner = predict(elastic, test),
                           knn_learner = predict(kppv, test),
                           lda_learner = predict(lda_model, test),
                           gbm_learner = predict(gbm_model, test),
                           svm_rad_learner = predict(svm_rad, test))

tune_grid = expand.grid(
    mtry = stacking_rf$bestTune$mtry,
    # splitrule = c("gini", "extratrees"),
    splitrule = stacking_rf$bestTune$splitrule,
    min.node.size = stacking_rf$bestTune$min.node.size
)

tune_control <- trainControl(method = "none",
                             summaryFunction = prSummary,
                             classProbs = T,
                             savePredictions = T)

stacking_rf_final = train(
    target ~ .,
    data = stacking_train %>% dplyr::select(-rowIndex),
    metric = "F",
    trControl = tune_control,
    tuneGrid = tune_grid,
    method = "ranger",
    importance = "impurity"
)

test_res2 = test_model(stacking_rf_final, stacking_test, "spam", "nonspam", T)






