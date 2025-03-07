# Crédits

Réaliser par Nicolas LEIRITZ dans le cadre d'un apprentissage Flutter au CESI de Vandoeuvre

# pokemon_project

Création d'un pokédex avec un système de composition d'équipe, composition aléatoire de l'équipe adverse et système de combat. L'api utilisée est https://tyradex.vercel.app/

# Combat

Les combats sont la somme de toutes les bases des pokémon composant chaque équipe. La valeur total la plus haute gagne.

# Filtres

Il est possible de rechercher un pokemon par son nom (Français pour l'instant) ou par son type (en cours de dev).

# Captures

Au lancement de l'application :
![ListPKM](./Screenshot/ListPKM.png)

On peut mettre les pokémons en favoris :
![ListPKMFav](./Screenshot/ListPKMFav.png)

On peut les retrouver dans une liste en cliquant sur le coeur présent dans l'AppBar :
![ListFav](./Screenshot/ListFav.png)

On peut les trier par le nom ou par le type via le champ de recherche ou la seconde icone de l'AppBar :
![TriNamet](./Screenshot/TriName.png)
![TriTypes](./Screenshot/TriTypes.png)

On a une description avec les stats, les faiblesses, forces et immunités :
![DetailsPKM](./Screenshot/DetailsPKM.png)
![DetailsPKM2](./Screenshot/DetailsPKM2.png)

On peut ajouter 6 pokemon dans une équipe. Si cette dernière est pleine :
![FullTeam](./Screenshot/FullTeam.png)

On peut accéder à la page du combat via la première icone dans l'AppBar. L'équipe adverse peut être généré aléatoirement via l'icone du dé :
![Combat](./Screenshot/Combat.png)

On lance le combat avec la seconde icone. Le combat est une simple somme des base stats de chaque pokemon composant l'équipe.
![CombatResult](./Screenshot/CombatResult.png)