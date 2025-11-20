GESTION DE VENTE - version avec verrou PIN (4 chiffres)

Cette version inclut un écran de verrouillage par code PIN (4 chiffres).
Par défaut le PIN initial est `1234` et l'app demandera de le changer au premier lancement.

Déploiement sur GitHub (depuis téléphone):
1. Crée un repo et upload les fichiers (Create new file) dans GitHub.
2. Après push, Actions (workflow fourni précédemment) pourra builder l'APK.
3. L'app fonctionne offline.

Fonctionnalités PIN:
- PIN stocké de façon sécurisée avec flutter_secure_storage (chiffré).
- Écran de verrouillage avant d'accéder à l'app.
- Option pour changer le PIN dans paramètres (non implémentée dans ce scaffold, mais le stockage est prêt).
- Si PIN oublié, on peut réinitialiser en réinstallant l'app (option future: question secrète ou email).

