import '../models/work.dart';
import '../constants/app_constants.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:async';

class ApiService {

  final String apiUrl = AppConstants.worksEndpoint;
  
  // Cache pour les travaux
  List<Work>? _cachedWorks;
  DateTime? _cacheTimestamp;
  static const Duration _cacheDuration = Duration(minutes: AppConstants.cacheDurationMinutes);
  
  // Cache pour les favoris (clé = IDs triés, valeur = résultats)
  final Map<String, List<Work>> _favoritesCache = {};
  final Map<String, DateTime> _favoritesCacheTimestamp = {};

  Future<List<Work>> fetchWork() async {
    // Vérifier si le cache est valide
    if (_cachedWorks != null && _cacheTimestamp != null) {
      final age = DateTime.now().difference(_cacheTimestamp!);
      if (age < _cacheDuration) {
        return _cachedWorks!;
      }
    }

    try {
      final response = await http.get(
        Uri.parse(apiUrl),
        headers: {'Content-Type': 'application/json'},
      ).timeout(const Duration(seconds: AppConstants.timeoutSeconds));
      
      if (response.statusCode == 200) {
        final Map<String, dynamic> jsonResponse = jsonDecode(response.body);
        final results = jsonResponse['results'] as List<dynamic>;
        List<Work> works = results.map((jsonWork) => Work.fromJson(jsonWork)).toList();
        
        // Mettre en cache
        _cachedWorks = works;
        _cacheTimestamp = DateTime.now();
        
        return works;
      } else {
        throw Exception('${AppConstants.errorServer} (Code: ${response.statusCode})');
      }
    } on TimeoutException {
      throw Exception(AppConstants.errorTimeout);
    } on FormatException {
      throw Exception(AppConstants.errorGeneral);
    } catch (e) {
      throw Exception('${AppConstants.errorConnection}: $e');
    }
  }

  Future<List<Work>> fetchWorkById(List<dynamic> ids) async {
    if (ids.isEmpty) {
      return [];
    }

    // Créer une clé de cache basée sur les IDs triés
    final sortedIds = List.from(ids)..sort();
    final cacheKey = sortedIds.join(',');

    // Vérifier le cache
    if (_favoritesCache.containsKey(cacheKey) && 
        _favoritesCacheTimestamp.containsKey(cacheKey)) {
      final age = DateTime.now().difference(_favoritesCacheTimestamp[cacheKey]!);
      if (age < _cacheDuration) {
        return _favoritesCache[cacheKey]!;
      }
    }

    try {
      final String whereClause = ids.map((id) => 'id = $id').join(' OR ');
      final Uri url = Uri.parse('$apiUrl?where=${Uri.encodeComponent(whereClause)}');
      
      final response = await http.get(
        url,
        headers: {'Content-Type': 'application/json'},
      ).timeout(const Duration(seconds: AppConstants.timeoutSeconds));

      if (response.statusCode == 200) {
        final Map<String, dynamic> jsonResponse = jsonDecode(response.body);
        final results = jsonResponse['results'] as List<dynamic>;
        List<Work> works = results
            .map((jsonWork) => Work.fromJson(jsonWork))
            .toList();
        
        // Mettre en cache
        _favoritesCache[cacheKey] = works;
        _favoritesCacheTimestamp[cacheKey] = DateTime.now();
        
        return works;
      } else {
        throw Exception('${AppConstants.errorServer} (Code: ${response.statusCode})');
      }
    } on TimeoutException {
      throw Exception(AppConstants.errorTimeout);
    } on FormatException {
      throw Exception(AppConstants.errorGeneral);
    } catch (e) {
      throw Exception('${AppConstants.errorConnection}: $e');
    }
  }

  // Méthode pour vider le cache manuellement
  void clearCache() {
    _cachedWorks = null;
    _cacheTimestamp = null;
    _favoritesCache.clear();
    _favoritesCacheTimestamp.clear();
  }

  // Méthode pour vérifier si le cache est valide
  bool isCacheValid() {
    if (_cacheTimestamp == null) return false;
    final age = DateTime.now().difference(_cacheTimestamp!);
    return age < _cacheDuration;
  }
}
