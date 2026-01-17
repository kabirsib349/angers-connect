import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import '../constants/app_constants.dart';

class LocationProvider with ChangeNotifier {
  Position? _currentPosition;
  String? _error;
  bool _isLoading = false;
  bool _serviceEnabled = false;
  LocationPermission _permission = LocationPermission.denied;

  // Getters
  Position? get currentPosition => _currentPosition;
  String? get error => _error;
  bool get isLoading => _isLoading;

  Future<void> determinePosition() async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      // 1. Vérifier si le service est activé
      _serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!_serviceEnabled) {
        _error = AppConstants.locationServiceDisabled;
        return;
      }

      // 2. Vérifier les permissions
      _permission = await Geolocator.checkPermission();
      if (_permission == LocationPermission.denied) {
        _permission = await Geolocator.requestPermission();
        if (_permission == LocationPermission.denied) {
          _error = AppConstants.locationPermissionDenied;
          return;
        }
      }

      if (_permission == LocationPermission.deniedForever) {
        _error = AppConstants.locationPermissionDeniedForever;
        return;
      }

      // 3. Récupérer la position
      _currentPosition = await Geolocator.getCurrentPosition();
      
    } catch (e) {
      _error = "${AppConstants.locationErrorPrefix}$e";
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> openSettings() async {
    await Geolocator.openLocationSettings();
  }
}
