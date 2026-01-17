# Angers Connect

**Angers Connect** est une application mobile moderne développée avec **Flutter** permettant de consulter en temps réel les travaux de voirie dans la ville d'Angers. Elle se distingue par son design soigné, ses animations fluides et sa gestion robuste des données.

---

## Stack Technique

- **Framework** : Flutter 3.38.3 (Stable)
- **Langage** : Dart 3.10.1
- **Architecture** : MVVM (Model-View-ViewModel) avec Provider
- **State Management** : `Provider` (MultiProvider à la racine)
- **Persistance** : `Hive` (Base de données NoSQL locale)
- **API** : REST (http)

---

## Écrans et Fonctionnalités

### 1. Accueil (Home)
- **Liste animée** : Les chantiers s'affichent avec des animations fluides (staggered animations).
- **Recherche temps réel** : Filtrage instantané des travaux par titre ou description.
- **Pull-to-refresh** : Actualisation manuelle des données.
- **Indicateurs visuels** : Badges pour les travaux en cours/à venir.
- **Gestion d'état** : Loading, Error (avec retry), Empty states.

### 2. Carte (Map)
- **Carte interactive** : Basée sur **OpenStreetMap** (via `flutter_map`).
- **Géolocalisation** : Centrage automatique sur la position de l'utilisateur.
- **Marqueurs custom** : Points d'intérêt cliquables affichant les détails essentiels.
- **Clustering** : Gestion optimisée de l'affichage de nombreux points.

### 3. Favoris
- **Persistance locale** : Les favoris sont stockés sur l'appareil via **Hive**.
- **Gestion complète** : Ajout/Suppression depuis la liste ou les détails.
- **Bouton "Tout supprimer"** : Pour vider la liste rapidement.
- **Swipe-to-dismiss** : Suppression intuitive par glissement.

### 4. Détails (WorkDetail)
- **Hero Animations** : Transitions visuelles fluides depuis la liste.
- **Informations complètes** : Dates, description, localisation.
- **Header immersif** : Design moderne avec dégradés.

---

## API Utilisée

L'application exploite l'Open Data de la ville d'Angers :

- **Source** : [Données Ouvertes Angers Loire Métropole](https://data.angers.fr/explore/dataset/info-travaux/information/)
- **Endpoint** : `https://data.angers.fr/api/explore/v2.1/catalog/datasets/info-travaux/records`
- **Authentification** : Aucune clé API requise (Accès public).

---

## Autorisations Requises

Pour fonctionner pleinement, l'application nécessite les permissions suivantes sur le téléphone :

| Permission | Usage | Obligatoire ? |
|------------|-------|---------------|
| **INTERNET** | Récupération des données travaux depuis l'API. | OUI |
| **ACCESS_FINE_LOCATION** | Affichage de votre position précise sur la carte. |  NON (Fonctionne sans) |
| **ACCESS_COARSE_LOCATION** | Alternative moins précise pour la géolocalisation. |  NON (Fonctionne sans) |

---

## Installation et Exécution

### Prérequis
- Flutter SDK installé
- Émulateur Android/iOS ou appareil physique connecté

### Commandes
1. **Cloner le projet**
   ```bash
   git clone <votre-repo-git>
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

---

## Packages Principaux

- `provider`: Gestion d'état.
- `http`: Requêtes réseau.
- `geolocator`: Services GPS.
- `flutter_map` & `latlong2`: Cartographie.
- `hive` & `hive_flutter`: Base de données locale.
- `google_fonts`: Typographie moderne.
- `flutter_staggered_animations`: Animations de liste.
- `shimmer`: Effets de chargement.

---


