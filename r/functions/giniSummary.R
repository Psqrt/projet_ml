# Calcul du coefficient de Gini normalisé (identique à MLmetrics::NormalizedGini)
# soruce : kaggle + ens.data.challenge
normalizedGini <- function(aa, pp) {
    Gini <- function(a, p) {
        if (length(a) !=  length(p)) stop("Actual and Predicted need to be equal lengths!")
        temp.df <- data.frame(actual = a, pred = p, range=c(1:length(a)))
        temp.df <- temp.df[order(-temp.df$pred, temp.df$range),]
        population.delta <- 1 / length(a)
        total.losses <- sum(a)
        null.losses <- rep(population.delta, length(a)) # Hopefully is similar to accumulatedPopulationPercentageSum
        accum.losses <- temp.df$actual / total.losses # Hopefully is similar to accumulatedLossPercentageSum
        gini.sum <- cumsum(accum.losses - null.losses) # Not sure if this is having the same effect or not
        sum(gini.sum) / length(a)
    }
    Gini(aa,pp) / Gini(aa,aa)
}

# Summary pour caret
giniSummary <- function (data, lev = "Yes", model = NULL) {
    levels(data$obs) <- c('0', '1')
    out <- normalizedGini(as.numeric(levels(data$obs))[data$obs], data[, lev[2]])  
    names(out) <- "NormalizedGini"
    out
}

# Métrique pour LGBM
lgb.normalizedgini = function(preds, dtrain){
    actual = lightgbm::getinfo(dtrain, "label")
    score  = NormalizedGini(preds,actual)
    return(list(name = "Norm-gini", value = score, higher_better = TRUE))
}