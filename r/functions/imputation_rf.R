# Imputation des NA par forêt aléatoire
imputation_rf = function(data, variable_impute, id_join) {
    var_a_retirer = c(colnames(data)[colSums(is.na(data)) > 0])
    ind = var_a_retirer %in% variable_impute
    var_a_retirer = var_a_retirer[!ind]
    formule = formula(paste(get("variable_impute"), "~ . -dataset -id -target", sep = ""))
    rf_model = ranger(formula = formule,
                data = data[complete.cases(data) & data$dataset == "train",] %>% select(-var_a_retirer),
                num.trees = 200)
    
    lignes_a_imputer = data[is.na(data[get("variable_impute")]),] %>% data.frame()
    
    predictions = predict(rf_model, lignes_a_imputer)
    
    lignes_a_imputer[get("variable_impute")] = predictions$predictions
    
    col1 = paste(variable_impute, ".x", sep = "")
    col2 = paste(variable_impute, ".y", sep = "")
    
    output = data %>% 
        left_join(lignes_a_imputer[c(id_join, variable_impute)], by = id_join) %>% 
        mutate(fusion = if_else(is.na(get(col1)), get(col2), get(col1))) %>% 
        select(-col1, -col2)
    
    colnames(output)[ncol(output)] = get("variable_impute")
    
    return(output)
}