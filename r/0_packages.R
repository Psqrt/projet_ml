# packages ######################################
# Manipulation de données
library(data.table)     # importation des données avec fread()
library(tidyverse)      # data manipulation + ggplot (viz)
library(glue)           # strings manipulation
library(stringr)        # strings manipulation
library(doMC)           # calcul parallèle

# Machine Learning
library(caret)          # couteau suisse
library(ranger)         # random forest
library(randomForest)   # random forest
library(FactoMineR)     # analyses factorielles
library(factoextra)     # analyses factorielles
library(ModelMetrics)   # métriques de performance
library(PRROC)          # courbe ROC et AUC
library(DMwR)           # resampling
library(klaR)           # analyse discriminante régularisée
library(gbm)            # gradient boosting machine
library(kernlab)        # support vector machine
library(MLmetrics)      # métriques de performance
library(mlbench)        # datasets
library(rpart)          # decision tree
library(ada)            # adaboost
library(xgboost)        # xgboost
library(lightgbm)       # light gbm

# Visualisations
library(ggpubr)         # ggplot panel
library(cowplot)        # ggplot panel
library(naniar)         # NA viz
library(ggrepel)        # annotations ggplot
library(plotROC)        # courbe ROC
library(corrplot)       # matrice des corrélations

# Stats
library(gmodels)        # CrossTable
library(dgof)           # ks test
library(vip)            # variance inflation
library(oddsratio)      # odds ratio

select = dplyr::select  # clash de nom de fonction
slice = dplyr::slice    # clash de de fonction

theme_set(theme_light()) # theme ggplot par défaut

# fonctions externes ############################
scripts = paste("./functions/", list.files("./functions/"), sep = "") # récupération de la liste des scripts R contenant les fonctions
sapply(scripts, source) # sourcing de l'ensemble de ces scripts
