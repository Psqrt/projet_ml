# packages ######################################
library(tidyverse) # data
library(caret) # ml
library(ranger) # rf
library(randomForest) # rf
# library(missRanger) # NA imputation
# library(mice) # NA imputation
library(ggpubr) # ggplot
library(cowplot) # ggplot
library(naniar) # NA treatment
library(gmodels) # CrossTable
library(dgof) # ks test
library(data.table) # import
library(FactoMineR) 
library(factoextra)
library(glue)
library(ggrepel)
library(ModelMetrics)
library(PRROC)
library(DMwR)
library(plotROC)
library(klaR)
library(gbm)
library(vip) #useless I think
library(oddsratio)
library(kernlab)
library(MLmetrics)
library(mlbench)
library(rpart)
library(ada)
library(corrplot)
library(xgboost)
library(doMC)
library(lightgbm)
select = dplyr::select
slice = dplyr::slice

theme_set(theme_light())

# fonctions externes ############################
scripts = paste("./functions/", list.files("./functions/"), sep = "")
sapply(scripts, source)
