library(tidyverse)

type_col = readRDS("./../../data/data_sel_type_col.rds")
data_sel = data.table::fread(file = "./../../data/data_sel.csv", colClasses = type_col) %>% as.data.frame()
toto = FactoMineR::FAMD(data_sel %>% filter(dataset == "train") %>% select(-id, -target, -dataset), graph = FALSE)