import 'package:flutter/material.dart';
import '../models/work.dart';
import '../services/api_service.dart';
import '../constants/app_constants.dart';

class WorkProvider with ChangeNotifier {
  final ApiService _apiService = ApiService();
  
  List<Work> _works = [];
  List<Work> _filteredWorks = [];
  bool _isLoading = false;
  String? _error;
  String _searchQuery = '';
  
  // Getters
  List<Work> get works => _filteredWorks.isEmpty && _searchQuery.isEmpty ? _works : _filteredWorks;
  bool get isLoading => _isLoading;
  String? get error => _error;
  String get searchQuery => _searchQuery;
  
  // Initialisation
  Future<void> loadWorks({bool forceRefresh = false}) async {
    if (_works.isNotEmpty && !forceRefresh && _apiService.isCacheValid()) {
      return;
    }

    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      if (forceRefresh) {
        _apiService.clearCache();
      }
      
      _works = await _apiService.fetchWork();
      _applyFilter();
    } catch (e) {
      _error = e.toString().replaceAll('Exception: ', '');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // Recherche
  void setSearchQuery(String query) {
    _searchQuery = query;
    _applyFilter();
    notifyListeners();
  }

  void _applyFilter() {
    if (_searchQuery.isEmpty) {
      _filteredWorks = _works;
    } else {
      final query = _searchQuery.toLowerCase();
      _filteredWorks = _works.where((work) {
        return work.title.toLowerCase().contains(query) ||
               work.description.toLowerCase().contains(query);
      }).toList();
    }
  }

  // Utilitaires
  Work? getWorkById(int id) {
    try {
      return _works.firstWhere((work) => work.id == id);
    } catch (_) {
      return null;
    }
  }
}
