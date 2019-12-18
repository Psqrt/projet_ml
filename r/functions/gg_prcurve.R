gg_prcurve = function(df) {
  # df: df containing models scores by columns and the last column must be
  #     nammed "obs" and must contain real classes.
  
  # init
  df_gg = data.frame("v1" = numeric(), 
                     "v2" = numeric(), 
                     "v3" = numeric(), 
                     "model" = character(),
                     stringsAsFactors = F)
  
  # individual pr curves
  for (i in c(1:(ncol(df)-1))) {
    x1 = df[df$obs == 1, i]
    x2 = df[df$obs == 0, i]
    prc = pr.curve(x1, x2, curve = T)
    
    df_prc = as.data.frame(prc$curve, stringsAsFactors = F) %>% 
      mutate(model = colnames(df)[i])
    
    # combining pr curves
    df_gg = bind_rows(df_gg,
                      df_prc)
    
  }
  
  gg = df_gg %>% 
    ggplot() +
    aes(x = V1, y = V2, colour = model) +
    geom_line() +
    xlab("Recall") +
    ylab("Precision")
  
  return(gg)
}