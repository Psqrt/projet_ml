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
# library(DMwR) # knn imputation
theme_set(theme_light())

# fonctions externes ############################
scripts = paste("./functions/", list.files("./functions/"), sep = "")
sapply(scripts, source)
