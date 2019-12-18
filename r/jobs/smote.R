
library(data.table)
library(tidyverse)
library(DMwR)
type_col = readRDS("./../../data/type_col.rds")
train = data.table::fread(file = "./../../data/train.csv", colClasses = type_col) %>% as.data.frame()
test = data.table::fread(file = "./../../data/test.csv", colClasses = type_col) %>% as.data.frame()


toto = SMOTE(target ~ ., train, perc.over = 100, perc.under = 200)







df = data.frame(target = c(rep("1", 5), rep("0", 95)),
                x = 0)


SMOTE(target ~ x, df, perc.over = 0.5, perc.under = )
