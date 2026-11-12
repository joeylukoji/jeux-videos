# English Quest 3D — Little Explorers

Jeu d'aventure en 3D pour aider les enfants francophones de 6 à 10 ans à apprendre leurs premiers mots anglais.

- Moteur : Godot 4.x
- Langage : GDScript
- Vue : troisième personne, univers low-poly 3D
- Langues : consignes en français, vocabulaire en anglais
- Sauvegarde : progression locale dans user://english_quest_progress.json
- Réseau : aucun compte ni connexion requis

## Ouvrir dans Godot

1. Installe Godot 4.x.
2. Clone ou télécharge ce dépôt sur la branche feature/english-quest-3d.
3. Dans le Project Manager, clique sur Import.
4. Sélectionne project.godot à la racine.
5. Clique sur Run Project.

Le MVP est jouable immédiatement grâce aux modèles 3D procéduraux générés par GDScript.

## Commandes

| Action | Touche |
|---|---|
| Avancer / reculer | W / S |
| Gauche / droite | A / D |
| Interagir à proximité | E |
| Rejouer après la mission | R |

## Boucle de jeu

- Explorer une île 3D avec deux zones : ANIMALS / ANIMAUX et FOOD / NOURRITURE.
- Retrouver un objet depuis son nom français.
- Interagir avec le modèle 3D et choisir la traduction anglaise parmi trois propositions.
- Réessayer sans pénalité en cas d'erreur.
- Écouter le mot anglais grâce au TTS du système si une voix compatible est installée.
- Retrouver les mots appris et les étoiles après redémarrage.

Le premier parcours contient huit mots : dog, cat, cow, elephant, apple, banana, carrot et orange.

## Assets 3D

Le jeu dispose de modèles low-poly originaux en GDScript pour fonctionner sans téléchargement. Un script facultatif récupère les modèles Kenney CC0 (GLB) depuis le catalogue Hidencod/tge-assets. Voir ASSET_CREDITS.md.

## Documents

Le backlog, le plan de sprints, les cas d'utilisation, l'architecture et le plan de tests se trouvent dans docs/.

## État du MVP

Livré : exploration 3D, huit mots, mini-quiz, feedback bienveillant, TTS système si disponible et sauvegarde locale.

À faire : contrôles tactiles, nouvelles leçons, voix enregistrées, options d'accessibilité, espace parent et tests pédagogiques.
