# computing AUPR
aucpr = function(obs, score){
    # obs: real classes
    # score: predicted scores
    
    df = data.frame("pred" = score,
                    "obs" = obs)
    
    prc = pr.curve(df[df$obs == "malignant", ]$pred,
                   df[df$obs == "benign", ]$pred)
    
    return(prc$auc.davis.goadrich)
}