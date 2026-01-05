import "package:flutter/material.dart";
import "package:geolocator/geolocator.dart";
import "package:flutter_map/flutter_map.dart";
import 'package:latlong2/latlong.dart';

class MapScreen extends StatefulWidget{
  const MapScreen({super.key});

  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen>{

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
        _message =
        'Latitude: ${position.latitude}\nLongitude: ${position.longitude}';
      });
    }catch(e){

    }
  }
  Widget build(BuildContext context){
    return Scaffold(
      body: _currentPosition == null
          ? const Center(child: CircularProgressIndicator())
          : FlutterMap(
              options: MapOptions(
                  initialCenter:
                    LatLng(_currentPosition!.latitude, _currentPosition!.longitude),
                  initialZoom: 14.0
              ),
              children: [
                TileLayer(
                  urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
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
            )
    );
  }
}

