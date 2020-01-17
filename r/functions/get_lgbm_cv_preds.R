get_lgbm_cv_preds <- function(cv){
  rows <- length(cv$boosters[[1]]$booster$.__enclos_env__$private$valid_sets[[1]]$.__enclos_env__$private$used_indices) + 
    length(cv$boosters[[1]]$booster$.__enclos_env__$private$train_set$.__enclos_env__$private$used_indices)
  preds <- numeric(rows)
  for(i in 1:length(cv$boosters)){
    preds[cv$boosters[[i]]$booster$.__enclos_env__$private$valid_sets[[1]]$.__enclos_env__$private$used_indices] <- 
      cv$boosters[[i]]$booster$.__enclos_env__$private$inner_predict(2)
  }
  return(preds)
}