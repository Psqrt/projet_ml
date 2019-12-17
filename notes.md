## Séance 1

Données déséquilibrées => algorithmes non performants :
	- rééquilibrage par échantillonnage (autant de 1 et de 0 : plus de 30%)
		- varier les poids selon le groupe (par défaut 1/N_{app}) : on peut avoir un ratio 30:1 puis renormaliser.
		- rééchantillonnage : on tire au hasard avec remise 80% parmis les 1 et on complète avec 0.8 x N_1 tirés parmis les 0 (sous-échantillonnage du groupe majoritaire : 0).
		Sinon on tire 80% parmis les 0 et on suréchantillonne les 1.
		- faire un clustering avec beaucoup de classes et on tire dans les classes (ou centres de classes).
		- SMOTE : tirer avec remise le groupe minoritaire puis interpoler pour construire des individus fictifs.
		
L'ensemble de test doit être proche de la réalité (donc la base de test doit être déséquilibrée).

Les transformations de données doivent être faites sur chaque base mais doivent être identiques. Par exemple, si on retranche la moyenne issue du jeu d'apprentissage sur le jeu d'apprentissage, il faut retrancher cette même moyenne sur le jeu de test.

Pour les différentes méthodes de rééquilibrage, on peut comparer les différentes approches avec des moyennes et écart-types / boxplots (observations : performances des modèles).

ACM pour identifier les modalités à rassembler
Traitement sur données initiales puis rééchantillonnage
Régression logistique pénalisée : cross validation pour choisir le poids de la pénalisation

Rééchantillonnage > Ajuster forêt aléatoire > Identifier les variables non importantes pour les jetter directement pour ne pas perdre du temps dessus.

Gestion NA
	- supprimer les variables avec un fort ratio NA
			- vérifier que la dépendance n'est pas trop élevée avec la target
	- supprimer les individus
			- s'assurer qu'ils n'appartiennent pas trop de target = 1
	- imputation par knn, acp
	
Construire des fonctions pour extraire toutes les performances des modèles de façon automatique
Réfléchir à la méthode de validation

## Séance 2

Hyperparamétrisation des modèles

Pour paramétrer les modèles, on passe par la validation K-folds. Dans la base d'apprentissage, on va prendre un échantillon (A) pour ajuster le modèle et l'autre (B) pour choisir le meilleur modèle.

Par exemple, une forêt aléatoire prend en paramètre le nombre d'arbres et le nombre de variables pour chaque noeud. On peut construire une grille à deux dimensions : une première qui fait varier le nombre d'arbres et l'autre pour le nombre de variables pour chaque noeud.
On ajuste une forêt aléatoire sur l'échantillon A pour chaque couple d'hyperparamètres et avec B, on calcule un critère de validation (exemple : précision). On retiendra alors le couple donnant les meilleurs résultats. Sur Python, des fonctions existent avec le module scikit-learn (grid.search).

## Séance 3

Le ratio de target == 1 dans dapp doit être le même que le ratio dans dtest

Le rapport scientifique doit insister sur les initiatives et innovations, pas sur les méthodes standards.