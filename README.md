# 📚 EduTrack - Gestion Scolaire 📊

<p align="center">
  <img alt="EduTrack Logo" src="./assets/icon.png" width="124px" style="border-radius:16px"/>
</p>

<p align="center">
  <a href="https://flutter.dev/">
    <img alt="Flutter" src="https://img.shields.io/badge/Flutter-v3.16-blue.svg?style=flat-square&logo=flutter" />
  </a>
  <a href="https://firebase.google.com/">
    <img alt="Firebase" src="https://img.shields.io/badge/Firebase-12.4.6-FFCA28.svg?style=flat-square&logo=firebase" />
  </a>
  <img alt="License" src="https://img.shields.io/badge/License-MIT-green.svg?style=flat-square" />
  <img alt="Version" src="https://img.shields.io/badge/Version-1.0.0-blue.svg?style=flat-square" />
</p>

## 📖 Description
Application mobile développée avec **Flutter** et **Firebase**, dédiée à la gestion académique des établissements scolaires. Elle permet aux enseignants et administrateurs de :

- Suivre les performances des étudiants
- Gérer les évaluations et notes
- Générer des rapports détaillés
- Faciliter la communication entre les parties prenantes

## ✨ Fonctionnalités Clés

### 👨‍🎓 Gestion des Étudiants
- Création et modification de profils étudiants
- Historique académique (années/semestres)
- Classement et statistiques par promotion

### 📝 Gestion des Notes
- Interface intuitive pour saisir les notes
- Coefficients personnalisables par matière
- Calcul automatique des moyennes générales et spécifiques
- Visualisation des performances via des graphiques dynamiques

### 📊 Tableaux de Bord
- Vue enseignant : suivi des classes, notifications
- Vue administrateur : gestion globale, alertes sur données manquantes
- Exportation des données en PDF ou CSV

### 🔐 Sécurité
- Authentification Firebase (rôles : Admin / Enseignant / Étudiant)
- Protection des données (chiffrement, règles de sécurité Firestore)
- Historique et journalisation des activités sensibles

## 🖼️ Captures d'Écran
<p align="center">
  <kbd>
    <img src="./screenshots/login.png" width="200" alt="Écran de connexion"/>
    <em>Connexion sécurisée</em>
  </kbd>
  <kbd>
    <img src="./screenshots/dashboard.png" width="200" alt="Tableau de bord"/>
    <em>Tableau de bord</em>
  </kbd>
  <kbd>
    <img src="./screenshots/grades.png" width="200" alt="Saisie des notes"/>
    <em>Saisie des notes</em>
  </kbd>
</p>

## 🛠️ Architecture Technique
```mermaid
graph TD
  A[Flutter Frontend] --> B[Firebase Auth]
  A --> C[Firestore Database]
  A --> D[Firebase Storage]
  A --> E[Firebase Messaging]
  C --> F[PDF/CSV Exports]
  D --> G[Cloud Backups]
```

### 📦 Dépendances Principales
| Package Flutter | Utilisation |
|-----------------|------------|
| firebase_core | Initialisation Firebase |
| firebase_auth | Authentification utilisateur |
| cloud_firestore | Base de données temps réel |
| firebase_storage | Sauvegarde de fichiers |
| firebase_messaging | Notifications push |
| flutter_local_notifications | Notifications locales |
| file_picker | Importation de fichiers |
| path_provider | Accès fichiers locaux |
| share_plus | Partage de fichiers |
| multi_select_flutter | Sélections multiples |
| flutter_staggered_animations | Animations d’UI |
| salomon_bottom_bar | Barre de navigation personnalisée |

## 🚀 Installation

### Cloner le projet :
```bash
git clone https://github.com/votre-repo/edutrack.git
cd edutrack
```

### Installer les dépendances :
```bash
flutter pub get
```

### Configurer Firebase :
1. Créer un projet Firebase
2. Ajouter les fichiers `google-services.json` (Android) et `GoogleService-Info.plist` (iOS)
3. Vérifier que les règles Firestore sont sécurisées

### Lancer l'application :
```bash
flutter run
```

## 🤝 Contribution
1. Forker le projet
2. Créer une branche : `git checkout -b feature/ma-feature`
3. Commiter vos changements : `git commit -m "Ajout de ma feature"`
4. Pousser la branche : `git push origin feature/ma-feature`
5. Ouvrir une Pull Request

## 📄 Licence
Distribué sous licence **MIT**. Voir le fichier `LICENSE` pour plus d’informations.

## ✉️ Contact
**Dissang Kevin** - dissangfrancis@yahoo.com  
Lien du projet : [Projetc Link](https://github.com/kteken10/flutter_school_app)



