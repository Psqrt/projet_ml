# Projet Machine Learning

## Structuration du répertoire

```
.
├── data                                  ### Dossier contenant les bases (initiales ou exportées)
│   ├── Base_test.csv
│   ├── Base_train.csv
│   ├── data_imp.csv
│   ├── data_imp_type_col.rds
│   ├── data_sel.csv
│   └── data_sel_type_col.rds
├── output                                ### Dossier contenant les sorties en tout genre (hors données)
│   ├── profile_report_test.html
│   └── profile_report_train.html
├── python                                ### Dossier contenant les codes Python
│   └── 0_eda.ipynb
├── r ### Dossier contenant les codes R
│   ├── 03_traitement.Rmd
│   ├── 0_packages.R
│   ├── 1_pretraitement.html
│   ├── 1_pretraitement.Rmd
│   ├── 2_selection_variable.html
│   ├── 2_selection_variable.Rmd
│   ├── functions                         ### Dossier contenant les fonctions externes R
│   │   ├── fun_crosstable.R
│   │   ├── gg_imp_ggplot_split.R
│   │   ├── imputation_lm.R
│   │   └── imputation_rf.R
│   ├── jobs                              ### Dossier contenant les scripts R à lancer comme "jobs"
│   │   └── knn_imputation.R
│   └── r.Rproj
├── Groupes_projet_ML_VF.xlsx
├── PROJET_MACHINE_LEARNING_M2_2019.pdf
├── notes.md
├── README.md
└── _TRASH                                ### Corbeille
    └── Data.7z

```