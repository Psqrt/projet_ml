source("./0_packages.R")
select = dplyr::select

beepr::beep("coin")
# Importation des données

df_train = read_csv(file = "./../data/Base_train.csv") %>% as.data.frame()
df_test = read_csv(file = "./../data/Base_test.csv") %>% as.data.frame()


# Préparation ML

train_id = df_train %>% select(id)
train_X = df_train %>% select(-target, -id)
train_Y = factor(df_train$target)
levels(train_Y) = c("no", "yes")

test_id = df_test %>% select(id)
test_X = df_test %>% select(-target)
test_Y = df_test$target
# levels(test_Y) = c("no", "yes")

rm(df_train)
rm(df_test)
gc()



library(doMC)
registerDoMC(cores = 8)

set.seed(1234)

modelLookup("xgbTree")

tune_control <- trainControl(method = "cv",
                             number = 2,
                             summaryFunction = giniSummary,
                             classProbs = T,
                             savePredictions = T,
                             verboseIter = T)

tune_grid = expand.grid(
    nrounds = seq(100, 500, 100),
    eta = c(0.05, 0.1),
    max_depth = c(4, 5, 6),
    gamma = 0,
    colsample_bytree = 0.7,
    min_child_weight = 0,
    subsample = 0.7
)

xgbtree = train(
  x = train_X,
  y = train_Y,
  metric = "NormalizedGini",
  trControl = tune_control,
  tuneGrid = tune_grid,
  method = "xgbTree",
)

save(xgbtree, file = "/media/psqrt/SquareX/SAVE_MODELS/save_2020/XGBTREE_BENCHMARK.RData")

beepr::beep("fanfare")




# load(file = "/media/psqrt/SquareX/SAVE_MODELS/save_2020/XGBTREE_BENCHMARK.RData")
# 
# ggplot(xgbtree)
# 
# test_preds = predict(xgbtree, test_X, type = "prob")
# 
# normalizedGini(test_Y, test_preds[, 2])
