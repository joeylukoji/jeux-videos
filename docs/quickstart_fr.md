# Démarrer le jeu dans Godot

## 1. Récupérer le projet

Télécharge la branche `feature/english-quest-3d` depuis GitHub ou clone-la :

```bash
git clone --branch feature/english-quest-3d https://github.com/joeylukoji/jeux-videos.git
```

## 2. Importer dans Godot

1. Ouvre Godot 4.x.
2. Dans le gestionnaire de projets, clique sur **Importer**.
3. Choisis le fichier `project.godot` à la racine du dépôt.
4. Valide l'import, puis clique sur **Lancer le projet**.

Aucun plugin, serveur ou compte n'est nécessaire.

## 3. Jouer

- Déplace-toi avec WASD (ou ZQSD selon la disposition du clavier).
- Approche-toi de l'objet correspondant à l'objectif en français.
- Appuie sur **E**.
- Choisis le mot anglais correct.
- Clique sur **Écouter le mot** pour utiliser une voix anglaise du système si disponible.
- Après les huit mots, appuie sur **R** pour recommencer.

## 4. Où modifier le jeu ?

- Ajouter ou modifier des mots : `data/words.json`.
- Modifier le monde : `scripts/main.gd`.
- Modifier les modèles générés : `scripts/procedural_assets.gd`.
- Modifier le personnage et la caméra : `scripts/player_controller.gd`.
- Modifier les règles de sauvegarde : `scripts/game_state.gd`.
- Lire les tâches : `docs/backlog.md` et `docs/sprints.md`.

## 5. Installer les modèles Kenney (facultatif)

Python 3 et Internet sont nécessaires uniquement pour cette étape :

```bash
python tools/download_cc0_assets.py
```

Rouvre Godot pour qu'il importe les GLB. Si le téléchargement n'est pas fait,
les modèles 3D procéduraux intégrés restent disponibles.

## 6. Vérifier le vocabulaire

```bash
python tools/validate_lesson.py
```

Ce contrôle valide le JSON, les champs obligatoires, les identifiants uniques
et les coordonnées 3D. Il ne remplace pas un lancement et un test dans Godot.
