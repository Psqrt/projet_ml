library(tidyverse) # data
library(DMwR) # knn imputation

train = read_csv(file = "./../../data/Base_train.csv") %>% as.data.frame()
test = read_csv(file = "./../../data/Base_test.csv") %>% as.data.frame()

variables = colnames(train)[2:length(colnames(train))]
variables_quanti = c("ps_reg_03", "ps_car_12", "ps_car_13", "ps_car_14", "ps_car_15")
variables_quali = variables[!(variables %in% variables_quanti)]

data = bind_rows("train" = train, "test" = test, .id = "dataset") %>% 
    mutate_at(variables_quali, as.factor)

data = data %>% 
    select(-ps_car_03_cat, -ps_car_05_cat)

set.seed(1234)
indices_var_quali = (colnames(data) %in% variables_quali) * c(1:length(colnames(data)))

start = Sys.time()

output_job = knnImputation(data[, -c(1:3)],
                           k = 5,
                           scale = T,
                           meth = "median",
                           distData = data[data$dataset == "train", -c(1:3)])

end = Sys.time()
imputation_time = end - start

capture.output(print(imputation_time), file = "./knn_imputation_time.txt")
write_csv(output_job, path = "./knn_imputation_output.csv")