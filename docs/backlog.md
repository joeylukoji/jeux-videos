# Product Backlog — English Quest 3D

## Vision
Aider un enfant francophone de 6 à 10 ans à acquérir du vocabulaire anglais
simple en explorant un monde 3D. Les interactions sont courtes, répétables,
bienveillantes et utilisables hors ligne.

| ID | Epic | User story | Priorité | Estimation | Critère d'acceptation |
|---|---|---|---|---:|---|
| E01 | Monde 3D | Explorer une île en troisième personne. | Must | 5 pts | Déplacement fluide, caméra, limites du terrain. |
| E02 | Interaction | Approcher un objet et interagir. | Must | 3 pts | Invite de proximité et touche E. |
| E03 | Vocabulaire | Apprendre un mot associé à un modèle 3D. | Must | 5 pts | Consigne française, terme anglais et traduction correcte. |
| E04 | Quiz | Choisir une traduction parmi trois réponses. | Must | 5 pts | Validation correcte, nouvelle tentative en cas d'erreur. |
| E05 | Prononciation | Écouter le mot anglais. | Must | 3 pts | TTS du système si disponible; fallback texte sinon. |
| E06 | Progression | Retrouver les mots appris après fermeture. | Must | 3 pts | Sauvegarde JSON locale restaurée au lancement. |
| E07 | Récompenses | Gagner une étoile par nouveau mot. | Should | 2 pts | Compteur de récompenses persistant. |
| E08 | Contrôles tactiles | Jouer sur téléphone ou tablette. | Should | 5 pts | Joystick virtuel, bouton d'interaction et UI adaptée. |
| E09 | Contenu | Apprendre couleurs, nombres, objets et salutations. | Should | 5 pts | Leçons décrites dans les données, sans réécrire la logique. |
| E10 | Accessibilité | Régler vitesse, volume et taille du texte. | Should | 3 pts | Options lisibles et sauvegardées localement. |
| E11 | Espace adulte | Consulter la progression de l'enfant. | Could | 5 pts | Résumé local sans compte ni publicité. |
| E12 | Validation pédagogique | Tester les leçons avec enfants et enseignants. | Must before release | 8 pts | Séances supervisées, feedback documenté, niveau ajusté. |
| E13 | Publication | Distribuer Windows et Android. | Could | 5 pts | Exports reproductibles et testés sur appareils cibles. |

## Règles pour le jeune public
- Une consigne principale à la fois.
- Trois choix maximum dans un quiz.
- Pas de pénalité, de publicité ou d'achat intégré dans le parcours enfant.
- Une mauvaise réponse ouvre une nouvelle tentative.
- Les progrès restent sur l'appareil.

## Définition de "Done"
- Scène et scripts importés sans erreur sur la version cible de Godot.
- Le critère d'acceptation est vérifié et le cas de test correspondant passe.
- Aucun asset sans licence ou provenance claire n'est ajouté.
- Les changements de contenu restent séparés de la logique de jeu.
