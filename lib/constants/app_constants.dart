class AppConstants {
  // API URLs
  static const String baseApiUrl = "https://data.angers.fr/api/explore/v2.1";
  static const String worksEndpoint = "$baseApiUrl/catalog/datasets/info-travaux/records";
  
  // Cache Configuration
  static const int cacheDurationMinutes = 5;
  static const int timeoutSeconds = 10;
  
  // Storage Keys
  static const String favoritesBoxName = 'favorites';
  
  // Asset Paths
  static const String logoPath = 'assets/images/logo.png'; // À ajouter si nécessaire
  
  // Messages d'erreur
  static const String errorConnection = "Problème de connexion internet.";
  static const String errorServer = "Le serveur ne répond pas.";
  static const String errorTimeout = "Le délai d'attente est dépassé.";
  static const String errorGeneral = "Une erreur est survenue.";
  
  // Location Errors
  static const String locationServiceDisabled = "Le service de localisation est désactivé.";
  static const String locationPermissionDenied = "Permission de localisation refusée.";
  static const String locationPermissionDeniedForever = "Permission refusée définitivement. Veuillez l'activer dans les paramètres.";
  static const String locationErrorPrefix = "Erreur lors de la localisation: ";
  
  // Textes UI
  static const String appTitle = "Angers Connect";
  static const String searchHint = "Rechercher un chantier...";
  static const String noWorksFound = "Aucun chantier trouvé.";
  static const String noFavorites = "Vous n'avez aucun favori.";
  static const String addFavoritesHint = "Ajoutez des travaux en favoris depuis l'accueil";
  static const String retryLabel = "Réessayer";
}
