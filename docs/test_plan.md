# Plan de tests du MVP

| ID | Vérification | Résultat attendu |
|---|---|---|
| T01 | Importer `project.godot` avec Godot 4.x | Import sans plugin externe. |
| T02 | Lancer la scène principale | Monde, personnage et objets visibles en 3D. |
| T03 | Déplacer avec WASD | Déplacement et caméra fonctionnels. |
| T04 | Approcher un objet | Invite d'interaction visible. |
| T05 | Appuyer sur E près d'un objet incorrect | Rappel du mot français demandé. |
| T06 | Répondre `dog` pour chien | Validation et objectif suivant. |
| T07 | Réponse incorrecte | Quiz reste ouvert, nouvelle tentative possible. |
| T08 | Terminer les huit mots | Message de fin et touche R pour rejouer. |
| T09 | Relancer après avoir appris des mots | Progression locale restaurée. |
| T10 | Aucun TTS anglais installé | Le jeu reste utilisable sans crash. |
| T11 | Aucun fichier GLB téléchargé | Les modèles procéduraux restent affichés. |
| T12 | Installer les GLB Kenney puis réimporter | GLB utilisés lorsqu'ils sont disponibles. |

Ces tests doivent être exécutés dans Godot sur une machine réelle avant toute
annonce de compatibilité ou de release stable.
