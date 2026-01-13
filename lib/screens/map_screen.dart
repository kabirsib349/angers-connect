import "package:flutter/material.dart";
import "package:geolocator/geolocator.dart";
import "package:flutter_map/flutter_map.dart";
import 'package:latlong2/latlong.dart';

class MapScreen extends StatefulWidget{
  const MapScreen({super.key});

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen>{

  final MapController _mapController = MapController();
  String _message = "En cours de chargement...";
  Position? _currentPosition;

  @override
  void initState(){
    super.initState();
    _determinePosition();
  }

  Future<void> _determinePosition() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      setState(() {
        _message = "Le service de localisation est désactivé";
      });
      return;
    }
    permission = await Geolocator.checkPermission();
    if(permission == LocationPermission.denied){
      permission = await Geolocator.requestPermission();
      if(permission == LocationPermission.denied){
        setState(() {
          _message = "Permission refusée";
        });
        return;
      }
    }
    if(permission == LocationPermission.deniedForever){
      setState(() {
        _message = "Permission refusée definitivement, veillez la modifier dans les paramètres de votre téléphone";
      });
      return;
    }
    try {
      Position position = await Geolocator.getCurrentPosition();
      setState(() {
        _currentPosition = position;
        _message = '';
      });
    } catch(e) {
      setState(() {
        _message = "Erreur lors de la récupération de la position: $e";
      });
    }
  }

  @override
  Widget build(BuildContext context){
    return Scaffold(
      body: _currentPosition == null
          ? Center(
              child: _message.isEmpty
                  ? const CircularProgressIndicator()
                  : Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(
                            Icons.location_off,
                            size: 64,
                            color: Colors.grey,
                          ),
                          const SizedBox(height: 16),
                          Text(
                            _message,
                            textAlign: TextAlign.center,
                            style: const TextStyle(fontSize: 16),
                          ),
                          if (_message.contains("paramètres"))
                            Padding(
                              padding: const EdgeInsets.only(top: 16.0),
                              child: ElevatedButton(
                                onPressed: () => Geolocator.openLocationSettings(),
                                child: const Text("Ouvrir les paramètres"),
                              ),
                            ),
                          if (!_message.contains("definitivement") && !_message.contains("paramètres"))
                            Padding(
                              padding: const EdgeInsets.only(top: 16.0),
                              child: ElevatedButton(
                                onPressed: _determinePosition,
                                child: const Text("Réessayer"),
                              ),
                            ),
                        ],
                      ),
                    ),
            )
          : FlutterMap(
              mapController: _mapController,
              options: MapOptions(
                  initialCenter:
                    LatLng(_currentPosition!.latitude, _currentPosition!.longitude),
                  initialZoom: 14.0
              ),
              children: [
                TileLayer(
                  urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                  userAgentPackageName: 'com.example.angers_connect',
                ),
                MarkerLayer(
                  markers: [
                    Marker(
                      width: 80.0,
                      height: 80.0,
                      point: LatLng(_currentPosition!.latitude, _currentPosition!.longitude),
                      child: const Icon(
                          Icons.location_pin,
                          color: Colors.red,
                          size: 40.0
                      ),
                    )
                  ],
                ),
              ]
            ),
      floatingActionButton: _currentPosition != null
          ? FloatingActionButton(
              onPressed: () {
                _mapController.move(
                  LatLng(_currentPosition!.latitude, _currentPosition!.longitude),
                  14.0,
                );
              },
              tooltip: 'Recentrer sur ma position',
              child: const Icon(Icons.my_location),
            )
          : null,
    );
  }
}

