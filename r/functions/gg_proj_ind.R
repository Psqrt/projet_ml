gg_proj_ind = function(donnees, c1, c2) {
  ###
  # Fonction permettant de projeter les individus sur deux axes choisis.
  ### 
  
  donnees %>% 
    ggplot() +
    aes(x = get(colnames(donnees)[c1]),
        y = get(colnames(donnees)[c2])) +
    geom_hline(yintercept = 0) +
    geom_vline(xintercept = 0) +
    geom_point() +
    labs(x = glue("Axe {c1}"),
         y = glue("Axe {c2}"),
         subtitle = glue("Projection sur les axes {c1} et {c2}"))
}