#  Angers Connect

Application mobile Flutter permettant de consulter les travaux en cours dans la ville d'Angers en temps réel via l'API Open Data.

##  Fonctionnalités

-  **Liste des travaux** : Affichage de tous les travaux en cours à Angers
-  **Système de favoris** : Sauvegarde locale des travaux favoris avec Hive
-  **Carte interactive** : Visualisation de votre position sur une carte OpenStreetMap
-  **Écran favoris** : En cours de développement

##  Technologies utilisées

- **Flutter** : Framework de développement mobile cross-platform
- **Dart** : Langage de programmation
- **HTTP** : Requêtes API REST
- **Hive** : Base de données locale NoSQL pour le stockage des favoris
- **Flutter Map** : Affichage de cartes interactives avec OpenStreetMap
- **Geolocator** : Géolocalisation de l'utilisateur

##  Dépendances

```yaml
dependencies:
  flutter:
    sdk: flutter
  http: ^1.2.1
  geolocator: ^12.0.0
  flutter_map: ^6.1.0
  hive: ^2.2.3
  hive_flutter: ^1.1.0
  path_provider: ^2.0.11
  cupertino_icons: ^1.0.8
```

##  Installation

### Prérequis

- Flutter SDK (version 3.10.1 ou supérieure)
- Dart SDK
- Android Studio / Xcode (pour les émulateurs)
- Un éditeur de code (VS Code, Android Studio, etc.)

### Étapes d'installation

1. **Cloner le repository**
```bash
git clone <url-du-repo>
cd angers_connect
```

2. **Installer les dépendances**
```bash
flutter pub get
```

3. **Lancer l'application**
```bash
flutter run
```

##  Structure du projet

```
lib/
├── main.dart                 # Point d'entrée de l'application
├── models/
│   └── work.dart            # Modèle de données pour les travaux
├── screens/
│   ├── main_screen.dart     # Écran principal avec navigation
│   ├── home_screen.dart     # Liste des travaux
│   ├── map_screen.dart      # Carte interactive
│   └── favorites_screen.dart # Écran des favoris (à implémenter)
└── services/
    └── api_service.dart     # Service pour les appels API
```

##  API utilisée

L'application utilise l'API Open Data d'Angers :
- **Endpoint** : `https://data.angers.fr/api/explore/v2.1/catalog/datasets/info-travaux/records`
- **Documentation** : [Open Data Angers](https://data.angers.fr)

### Modèle de données

```dart
class Work {
  final int id;
  final String title;
  final String description;
  final DateTime startAt;
  final DateTime endAt;
}
```

##  Fonctionnalités à venir

- [ ] Afficher les travaux sur la carte avec des marqueurs
- [ ] Filtrer les travaux par date/statut
- [ ] Notifications pour les nouveaux travaux
- [ ] Mode sombre
- [ ] Recherche de travaux
- [ ] Détails complets d'un travail

