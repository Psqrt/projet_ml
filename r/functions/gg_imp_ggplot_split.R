# plotting importance from predictive models into two panels
fun_imp_ggplot_split = function(model){
  # model: model used to plot variable importances
  
  # if (class(model)[1] == "ranger"){
  #   imp_df = model$variable.importance %>% 
  #     data.frame("Overall" = .) %>% 
  #     rownames_to_column() %>% 
  #     rename(variable = rowname) %>% 
  #     arrange(-Overall)
  # } else {
  #   imp_df = varImp(model) %>%
  #     rownames_to_column() %>% 
  #     rename(variable = rowname) %>% 
  #     arrange(-Overall)
  # }
  
  if (model$method == "gbm"){
    pdf(file = NULL)
    imp_df = summary(model)
    dev.off()
    colnames(imp_df) = c("variable", "Overall")
  } else {
    imp_df = varImp(model)$importance[1] %>% 
      rownames_to_column(var = "variable")
    
    colnames(imp_df)[2] = "Overall"
    
    imp_df = imp_df %>% 
      arrange(-Overall)
  }
  
  # first panel (half most important variables)
  gg1 = imp_df %>% 
    slice(1:floor(nrow(.)/2)) %>% 
    ggplot() +
    aes(x = reorder(variable, Overall), weight = Overall, fill = -Overall) +
    geom_bar() +
    coord_flip() +
    xlab("Variables") +
    ylab("Importance") +
    theme(legend.position = "none")
  
  imp_range = ggplot_build(gg1)[["layout"]][["panel_params"]][[1]][["x.range"]]
  imp_gradient = scale_fill_gradient(limits = c(-imp_range[2], -imp_range[1]),
                                     low = "#132B43", 
                                     high = "#56B1F7")
  
  # second panel (less important variables)
  gg2 = imp_df %>% 
    slice(floor(nrow(.)/2)+1:nrow(.)) %>% 
    ggplot() +
    aes(x = reorder(variable, Overall), weight = Overall, fill = -Overall) +
    geom_bar() +
    coord_flip() +
    xlab("") +
    ylab("Importance") +
    theme(legend.position = "none") +
    ylim(imp_range) +
    imp_gradient
  
  # arranging together
  gg_both = plot_grid(gg1 + imp_gradient,
                      gg2)
  
  return(gg_both)
}