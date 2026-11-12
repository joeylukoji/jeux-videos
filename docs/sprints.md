# Plan de livraison par sprints

Estimation indicative pour un développeur seul. Chaque sprint doit produire
une version exécutable et testable.

## Sprint 0 — Cadrage et socle (1–2 jours)
**Objectif :** créer un projet Godot 4 importable.
- Définir cible (6–10 ans), langue de consigne et boucle pédagogique.
- Créer la structure Godot, la scène de démarrage et les conventions.
- Définir les formats de données de vocabulaire et la licence des assets.
**Livrables :** `project.godot`, scène principale, README, architecture.
**Done :** Godot importe le projet et lance une scène 3D.

## Sprint 1 — Monde 3D et déplacement (3–4 jours)
**Objectif :** rendre l'exploration stable et plaisante.
- Construire le terrain, l'éclairage, les chemins et les deux zones.
- Créer le personnage jouable low-poly et sa caméra.
- Ajouter les modèles 3D d'animaux et de fruits.
- Détecter la proximité et afficher l'invite d'interaction.
**Livrables :** île 3D navigable et huit objets de vocabulaire.
**Done :** l'enfant peut parcourir les zones et approcher les objets.

## Sprint 2 — Apprentissage et progression (3–4 jours)
**Objectif :** livrer la boucle pédagogique complète.
- Charger le vocabulaire depuis `data/words.json`.
- Afficher une consigne française.
- Afficher trois réponses anglaises après interaction.
- Ajouter feedback non punitif, prononciation TTS et progression locale.
**Livrables :** première leçon de huit mots, étoiles et sauvegarde.
**Done :** partie complète jouable et progression persistante après redémarrage.

## Sprint 3 — Mobile, accessibilité et contenu (4–6 jours)
**Objectif :** élargir les appareils et les situations d'apprentissage.
- Ajouter joystick virtuel et bouton tactile d'interaction.
- Adapter l'interface aux petits écrans.
- Ajouter réglage de vitesse et de volume.
- Ajouter couleurs, nombres et salutations.
- Ajouter des voix enregistrées avec droits vérifiés et fallback TTS.
**Livrables :** prototype tactile Android et nouvelles leçons.
**Done :** session de dix minutes jouable sans clavier.

## Sprint 4 — Tests et release (3–5 jours)
**Objectif :** vérifier l'expérience et préparer la distribution.
- Tester collisions, limites, quiz, sauvegarde et reprise.
- Faire valider le vocabulaire par un enseignant d'anglais.
- Faire tester le jeu en séance supervisée par quelques enfants.
- Optimiser le rendu et tester les exports Windows/Android.
**Livrables :** build de test, rapport d'essais, checklist de publication.
**Done :** aucun blocage connu dans le parcours principal, limites documentées.

## Dépendances et critères de passage
- Sprint 1 dépend de la validation du contrôle joueur et des scènes 3D du Sprint 0.
- Sprint 2 dépend des objets interactifs et du format JSON du Sprint 1.
- Sprint 3 dépend du parcours clavier stable du Sprint 2.
- Sprint 4 doit inclure les essais sur appareils réels avant de taguer une release.

## Risques
| Risque | Réponse |
|---|---|
| Pas de voix TTS sur l'appareil | Conserver l'affichage et ajouter des audios enregistrés ensuite. |
| Assets externes non accessibles | Garder les modèles procéduraux jouables. |
| Clavier peu adapté aux enfants | Prioriser les contrôles tactiles au Sprint 3. |
| Niveau linguistique inadapté | Valider les mots et consignes avec un enseignant. |
| Téléphone peu puissant | Modèles low-poly, ombres limitées et portée réduite. |
