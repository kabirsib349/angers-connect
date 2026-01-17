import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import '../models/work.dart';
import '../services/api_service.dart';
import '../constants/app_constants.dart';

class FavoritesProvider with ChangeNotifier {
  final ApiService _apiService = ApiService();
  final Box _box = Hive.box(AppConstants.favoritesBoxName);
  
  List<Work> _favoriteWorks = [];
  bool _isLoading = false;
  String? _error;
  
  // Getters
  List<Work> get favoriteWorks => _favoriteWorks;
  bool get isLoading => _isLoading;
  String? get error => _error;
  int get favoritesCount => _box.length;

  // Actions
  bool isFavorite(int workId) {
    return _box.containsKey(workId);
  }

  Future<void> toggleFavorite(Work work) async {
    if (isFavorite(work.id)) {
      await _box.delete(work.id);
      _favoriteWorks.removeWhere((w) => w.id == work.id);
    } else {
      await _box.put(work.id, true);
      // On l'ajoute localement pour mise à jour immédiate
      if (!_favoriteWorks.any((w) => w.id == work.id)) {
        _favoriteWorks.add(work);
      }
    }
    notifyListeners();
  }

  Future<void> removeAllFavorites() async {
    await _box.clear();
    _favoriteWorks.clear();
    notifyListeners();
  }

  // Chargement des favoris depuis l'API
  Future<void> loadFavorites() async {
    final favoriteIds = _box.keys.toList();
    
    if (favoriteIds.isEmpty) {
      _favoriteWorks = [];
      notifyListeners();
      return;
    }

    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      _favoriteWorks = await _apiService.fetchWorkById(favoriteIds);
    } catch (e) {
      _error = e.toString().replaceAll('Exception: ', '');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
  
  // Écouter les changements Hive
  void initHiveListener() {
    _box.listenable().addListener(() {
      notifyListeners();
    });
  }
}
