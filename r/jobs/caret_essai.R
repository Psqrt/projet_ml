library(caret)
library(tidyverse)
library(MLmetrics)
library(mlbench)
library(rpart)
data(Sonar)

data = Sonar


set.seed(1234)

modelLookup("rpart")

tune_control <- trainControl(method = "repeatedcv",
                             number = 5,
                             repeats = 10,
                             summaryFunction = prSummary,
                             classProbs = T)

tune_grid = expand.grid(
    cp = seq(from = 0, to = 0.7, by = 0.05)
)

rpart = train(
    Class ~ .,
    data = data,
    metric = "F",
    trControl = tune_control,
    tuneGrid = tune_grid,
    method = "rpart"
)

View(rpart)

rpart_best = rpart$modelInfo
rpart_best$

rpart_best = prune(rpart, cp = rpart$bestTune)

rpart$bestTune
