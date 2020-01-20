# Projet Machine Learning

## Structuration du répertoire

```
.
├── article                               ### Dossier contenant les fichiers pour l'article scientifique
├── data                                  ### Dossier contenant les bases (initiales ou exportées)
├── output                                ### Dossier contenant les sorties en tout genre (hors données)
├── presentation                          ### Dossier contenant les fichiers pour la présentation orale
├── python                                ### Dossier contenant les codes Python
├── r                                     ### Dossier contenant les codes R
│   ├── functions                         ### Dossier contenant les fonctions externes R
│   └── jobs                              ### Dossier contenant les scripts R à lancer comme "jobs"
└── _TRASH                                ### Corbeille
```

## Fichiers à rendre

### Programmes

Les programmes sont répartis en 7 fichiers Rmarkdown. L'ensemble des fichiers se trouvent dans le répertoire `./r` et sont numérotés de 0 à 6 :
* Le fichier `0_benchmark` correspond au code permettant d'avoir le benchmark d'ouverture
* Le fichier `1_pretraitement` correspond au code permettant de gérer les valeurs manquantes
* Le fichier `2_selection_variable` correspond au code permettant de sélectionner les variables en fonction de leur importance dans un LightGBM et dans une forêt aléatoire
* Le fichier `3_traitement` correspond au code permettant de gérer les fusions de modalités et les transformations des variables continues
* Le fichier `4_correlations_et_dependances` correspond au code permettant d'étudier les liens entre variables explicatives entre elles ou avec la variable cible
* Le fichier `5_model_tuning` gère la construction et l'hyperparamétrisation des modèles*
* Le fichier `6_model_evaluation` gère l'évaluation des performances des modèles et la sélection du meilleur modèle, avec une étude approfondie des prédictions de celui-ci.

(* : les modèles ont été hyperparamétrés grâce à des instances sur Kaggle, l'ensemble des codes exécutés sur cette plateforme se trouve dans le répertoire `./r/jobs/kaggle_job`).

Les fichiers `5_model_tuning.rmd` et `6_model_evaluation.rmd` ne peuvent être lancés car les modèles construits sur kaggle sont stockés en dehors du répertoire github parce qu'ils sont trop volumineux (13Go). Par conséquent, je vous recommande de consulter directement les sorties HTML. Si jamais vous souhaitez obtenir les modèles, n'hésitez pas à nous contacter.

D'autres fichiers de programme existent :
* Le fichier `0_packages.R` liste l'ensemble des packages utilisés dans les programmes cités plus haut
* Les fichiers se trouvant dans `./r/functions` sont les fonctions externes utilisés dans les programmes cités plus haut
* Le fichier `0_eda.ipynb` du répertoire `./python` est le code python permettant de sortir les statistiques descriptives des bases de données à partir du Pandas Profiler.

### Article Scientifique

L'article scientifique qui accompagne l'étude a été rédigé en LaTeX, l'ensemble des fichiers (images, bibliographie, code source) se trouvent dans le répertoire `./article`.

### PowerPoint

Le powerpoint dédié à la présentation orale du 27 Janvier se trouve dans le répertoire `./presentation`.