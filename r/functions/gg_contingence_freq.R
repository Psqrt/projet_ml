gg_contingence_freq = function(var_etudiee){
    
    df1 = data_sel %>% 
        filter(dataset == "train") %>% 
        group_by(target, var = get(var_etudiee)) %>% 
        summarise(n = n()) %>% 
        complete(var) %>% 
        replace_na(list(n = 0))
    
    df2 = data_sel %>% 
        filter(dataset == "train") %>% 
        group_by(var = get(var_etudiee)) %>% 
        summarise(ncol = n()) %>% 
        complete(var) %>% 
        replace_na(list(ncol = 0))
    
    nb_levels = nrow(df2)
    breaks = sort(as.numeric(levels(df2$var)))
    
    df_tot = df1 %>% 
        inner_join(df2, by = "var") %>% 
        mutate(pct_col = round(n/ncol, 4),
               pct_tot = round(ncol/sum(ncol, na.rm = T), 4)) %>% 
        # select(-n, -ncol) %>%
        ungroup() %>% 
        replace_na(list(pct_col = 0, pct_tot = 0))
    
    val_nudge = c(rep(c(0, 1), floor(nb_levels/2)), rep(0, nb_levels %% 2))
    
    gg = df_tot %>% 
        mutate(target = as.numeric(as.character(target)),
               var = as.numeric(as.character(var))) %>% 
        dplyr::arrange(target, var) %>% 
        ggplot() +
        aes(x = var, y = target) +
        geom_hline(yintercept = c(0, 1), color = "gray90") +
        geom_point(aes(size = pct_col, color = (pct_tot > 0.05))) +
        geom_text(aes(label = scales::percent(pct_col), vjust = 3, size = 0.15), nudge_y = 0.35 * val_nudge) +
        geom_label(aes(label = scales::percent(pct_tot), y = -0.8, color = (pct_tot > 0.05)), nudge_y = 2.6 * val_nudge) +
        ylim(c(-0.8, 1.8)) +
        xlab(get("var_etudiee")) +
        theme(panel.grid.minor.y = element_blank(),
              panel.grid.major.y = element_blank(),
              panel.grid.minor.x = element_blank(),
              axis.ticks.y = element_blank(),
              legend.position = "none") +
        scale_x_continuous(breaks = breaks) +
        scale_color_manual(values = c("TRUE" = "blue", "FALSE" = "red")) +
        ggtitle(paste("Fréquences marginales par modalité (", var_etudiee, ")", sep = ""), 
                subtitle = "Les modalités en rouge ont une fréquence inférieure à 5%")

    return(gg)
}