# imputation des NA par régression linéaire
imputation_lm = function(data, variable_impute, variable_removed, id_join) {
    formule = formula(paste(get("variable_impute"), "~ .", sep = ""))
    lm_model = lm(formule,
                  data = data %>% 
                      filter(dataset == "train") %>% 
                      select(-!!variable_removed))
    
    lignes_a_imputer = data %>% 
        filter(is.na(get(variable_impute)))
    
    predictions = predict(lm_model, lignes_a_imputer)
    
    lignes_a_imputer[get("variable_impute")] = predictions
    
    col1 = paste(variable_impute, ".x", sep = "")
    col2 = paste(variable_impute, ".y", sep = "")
    
    output = data %>% 
        left_join(lignes_a_imputer[c(id_join, variable_impute)], by = id_join) %>% 
        mutate(fusion = if_else(is.na(get(col1)), get(col2), get(col1))) %>% 
        select(-col1, -col2)
    
    colnames(output)[ncol(output)] = get("variable_impute")
    
    return(output)
}