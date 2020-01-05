caret_eval_gini = function(model, trainX, testX, trainY, testY) {
    train_preds = predict(model, trainX, type = "prob")
    test_preds = predict(model, testX, type = "prob")
    train_gini = normalizedGini(trainY, train_preds[, "yes"])
    valid_gini = max(model[["results"]][["NormalizedGini"]])
    test_gini = normalizedGini(testY, test_preds[, "yes"])
    df = data.frame("Method" = model$method,
                    "Sampling" = if (is.null(model$control$sampling$name)) {"none"} else {model$control$sampling$name},
                    "Train" = train_gini,
                    "Validation" = valid_gini,
                    "Test" = test_gini,
                    stringsAsFactors = F)
    
    return(df)
}