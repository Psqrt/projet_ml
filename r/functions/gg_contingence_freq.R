gg_contingence_freq = function(var_etudiee){
    
    df1 = data_sel %>% 
        group_by(target, var = get(var_etudiee)) %>% 
        summarise(n = n())
    
    df2 = data_sel %>% 
        group_by(var = get(var_etudiee)) %>% 
        summarise(ncol = n())
    
    nb_levels = nrow(df2)
    
    df_tot = df1 %>% 
        inner_join(df2, by = "var") %>% 
        mutate(pct_col = round(n/ncol, 4),
               pct_tot = round(ncol/sum(ncol), 4)) %>% 
        select(-n, -ncol) %>% 
        ungroup()
    
    gg = df_tot %>% 
        mutate(target = as.numeric(target) - 1,
               var = as.numeric(var) - 1) %>% 
        ggplot() +
        aes(x = var, y = target) +
        geom_hline(yintercept = c(0, 1), color = "gray90") +
        geom_point(aes(size = pct_col, color = (pct_tot > 0.05))) +
        geom_text(aes(label = scales::percent(pct_col), vjust = 3, size = 0.15), nudge_y = c(0, 0.35)) +
        geom_label(aes(label = scales::percent(pct_tot), y = -0.8, color = (pct_tot > 0.05)), nudge_y = c(0, 2.6)) +
        ylim(c(-0.8, 1.8)) +
        xlab(get("var_etudiee")) +
        theme(panel.grid.minor.y = element_blank(),
              panel.grid.major.y = element_blank(),
              panel.grid.minor.x = element_blank(),
              axis.ticks.y = element_blank(),
              legend.position = "none") +
        scale_x_continuous(breaks = 0:nb_levels) +
        ggtitle(paste("Fréquences marginales par modalité (", var_etudiee, ")", sep = ""), 
                subtitle = "Les modalités en rouge ont une fréquence inférieure à 5%")
    
    return(gg)
}