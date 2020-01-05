# packages ######################################
library(tidyverse) # data
library(caret) # ml
library(ranger) # rf
library(randomForest) # rf
library(gmodels) # CrossTable
library(data.table) # import
library(FactoMineR) 
library(factoextra)
library(ModelMetrics)
library(PRROC)
library(DMwR)
library(plotROC)
library(klaR)
library(gbm)
library(kernlab)
library(MLmetrics)
library(mlbench)
library(rpart)
library(ada)
library(xgboost)
select = dplyr::select

normalizedGini <- function(aa, pp) {
    Gini <- function(a, p) {
        if (length(a) !=  length(p)) stop("Actual and Predicted need to be equal lengths!")
        temp.df <- data.frame(actual = a, pred = p, range=c(1:length(a)))
        temp.df <- temp.df[order(-temp.df$pred, temp.df$range),]
        population.delta <- 1 / length(a)
        total.losses <- sum(a)
        null.losses <- rep(population.delta, length(a)) # Hopefully is similar to accumulatedPopulationPercentageSum
        accum.losses <- temp.df$actual / total.losses # Hopefully is similar to accumulatedLossPercentageSum
        gini.sum <- cumsum(accum.losses - null.losses) # Not sure if this is having the same effect or not
        sum(gini.sum) / length(a)
    }
    Gini(aa,pp) / Gini(aa,aa)
}

giniSummary <- function (data, lev = "Yes", model = NULL) {
    levels(data$obs) <- c('0', '1')
    out <- normalizedGini(as.numeric(levels(data$obs))[data$obs], data[, lev[2]])  
    names(out) <- "NormalizedGini"
    out
}

path_exportation = file.path("/media/psqrt/DATA/save_models_2020")
load("./../data/bases_11var_pour_modelisation.RData")

train_id = train$id
# train_X = train %>% select(-id, -target)
# train_Y = train$target
train_XY = train %>% select(-id)

test_id = test$id
test_X = test %>% select(-id, -target)
test_Y = test$target %>% as.numeric()
test_Y = test_Y - 1

set.seed(1234)

tune_control <- trainControl(method = "cv", number = 2, summaryFunction = giniSummary, classProbs = T, savePredictions = T, verboseIter = T)

tune_grid = expand.grid(
    alpha = seq(0, 1, 0.1),
    lambda = seq(0, 3, 0.2)
)

glmnet_model = train(
    target ~ .,
    data = train_XY,
    metric = "NormalizedGini",
    trControl = tune_control,
    tuneGrid = tune_grid,
    method = "glmnet",
)

save(glmnet_model, file = file.path(path_exportation, "glmnet_model.RData"))