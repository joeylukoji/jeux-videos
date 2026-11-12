# Assets 3D et licences

## Modèles disponibles immédiatement

Le projet est jouable sans connexion : le personnage, les animaux stylisés,
les fruits, les arbres et les panneaux sont des meshes 3D générés par GDScript.
Ils ne dépendent d'aucun téléchargement. Le code original de ces modèles est
couvert par la licence MIT du projet.

## Modèles optionnels Kenney (CC0)

Le script `tools/download_cc0_assets.py` récupère des modèles GLB depuis le
catalogue public `Hidencod/tge-assets`. Le fichier LICENSE de ce catalogue
indique que les modèles ont été créés par Kenney et sont placés sous CC0 1.0 :

- Cube Pets : chien, chat, vache et éléphant.
- Food Kit : pomme, banane, carotte et orange.
- Nature Kit : arbres et rochers.

Sources :
- Catalogue et fichiers : https://github.com/Hidencod/tge-assets
- Licence du catalogue : https://github.com/Hidencod/tge-assets/blob/main/LICENSE
- Texte de la licence CC0 : https://creativecommons.org/publicdomain/zero/1.0/
- Site officiel : https://kenney.nl
- Pages des packs : https://kenney.nl/assets/cube-pets et https://kenney.nl/assets/food-kit

La licence CC0 autorise l'usage, la modification et la redistribution. Le crédit
à Kenney est apprécié mais non obligatoire. Les fichiers externes ne sont pas
nécessaires au fonctionnement du MVP.

## Télécharger les GLB facultatifs

Depuis la racine du projet, avec Python 3 et une connexion Internet :

```bash
python tools/download_cc0_assets.py
```

Rouvre ensuite le projet dans Godot afin d'importer les modèles. Le script
vérifie l'en-tête GLB avant d'écrire chaque fichier. En cas d'échec, les modèles
procéduraux restent utilisés.
