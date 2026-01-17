import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:provider/provider.dart';
import 'package:google_fonts/google_fonts.dart';

import '../providers/work_provider.dart';
import '../providers/location_provider.dart';
import '../models/work.dart';
import '../theme/theme.dart';
import 'work_detail_screen.dart';

class MapScreen extends StatefulWidget {
  const MapScreen({super.key});

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  final MapController _mapController = MapController();
  List<Marker> _workMarkers = [];

  @override
  void initState() {
    super.initState();
    // Charger la position et les travaux
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<LocationProvider>().determinePosition();
      // On s'assure que les travaux sont chargés aussi pour la carte
      context.read<WorkProvider>().loadWorks();
    });
  }

  @override
  Widget build(BuildContext context) {
    // Écouter les changements de travaux et de position
    final workProvider = context.watch<WorkProvider>();
    final locationProvider = context.watch<LocationProvider>();

    // Générer les marqueurs
    _workMarkers = workProvider.works
        .where((w) => w.latitude != null && w.longitude != null)
        .map((w) => _buildCustomMarker(w))
        .toList();

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(80),
        child: Container(
          decoration: BoxDecoration(
            gradient: AppTheme.primaryGradient.scale(0.9), // Légèrement transparent
            borderRadius: const BorderRadius.vertical(bottom: Radius.circular(20)),
             boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                blurRadius: 10,
                offset: const Offset(0, 5),
              ),
            ],
          ),
          child: SafeArea(
            child: Center(
              child: Text(
                'Carte des Travaux',
                style: GoogleFonts.poppins(
                  color: Colors.white,
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ),
      ),
      body: Stack(
        children: [
          FlutterMap(
            mapController: _mapController,
            options: MapOptions(
              initialCenter: const LatLng(47.47, -0.55), // Angers par défaut
              initialZoom: 13.0,
              interactionOptions: const InteractionOptions(
                flags: InteractiveFlag.all & ~InteractiveFlag.rotate,
              ),
            ),
            children: [
              TileLayer(
                urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                userAgentPackageName: 'com.example.angers_connect',
              ),
              MarkerLayer(
                markers: [
                  // Position utilisateur
                   if (locationProvider.currentPosition != null)
                    Marker(
                      width: 80.0,
                      height: 80.0,
                      point: LatLng(
                        locationProvider.currentPosition!.latitude,
                        locationProvider.currentPosition!.longitude,
                      ),
                      child: Container(
                         decoration: BoxDecoration(
                          color: AppTheme.accentColor.withOpacity(0.3),
                          shape: BoxShape.circle,
                         ),
                         child: Center(
                           child: Container(
                            width: 20,
                            height: 20,
                            decoration: BoxDecoration(
                              color: AppTheme.accentColor,
                              shape: BoxShape.circle,
                              border: Border.all(color: Colors.white, width: 3),
                              boxShadow: const [
                                BoxShadow(
                                  color: Colors.black26, 
                                  blurRadius: 5
                                )
                              ]
                            ),
                           ),
                         ),
                      ),
                    ),
                  
                  // Marqueurs des travaux
                  ..._workMarkers,
                ],
              ),
            ],
          ),

          // Indicateur de chargement ou erreur de localisation
          if (locationProvider.isLoading)
            Positioned(
              top: 100,
              right: 16,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: const [BoxShadow(color: Colors.black12, blurRadius: 4)],
                ),
                child: Row(
                  children: [
                    const SizedBox(width: 12, height: 12, child: CircularProgressIndicator(strokeWidth: 2)),
                    const SizedBox(width: 8),
                    Text("Localisation...", style: GoogleFonts.inter(fontSize: 12)),
                  ],
                ),
              ),
            ),
            
           if (locationProvider.error != null)
             Positioned(
              top: 100,
               right: 16,
               left: 16,
              child: Container(
                padding: const EdgeInsets.all(12),
                 decoration: BoxDecoration(
                  color: Colors.red[50],
                  borderRadius: BorderRadius.circular(12),
                   border: Border.all(color: Colors.red[200]!),
                 ),
                 child: Row(
                   children: [
                     const Icon(Icons.warning_amber, color: Colors.red),
                     const SizedBox(width: 8),
                     Expanded(child: Text(locationProvider.error!, style: TextStyle(color: Colors.red[800], fontSize: 12))),
                     IconButton(
                       icon: const Icon(Icons.refresh, color: Colors.red),
                       padding: EdgeInsets.zero,
                       constraints: const BoxConstraints(),
                       onPressed: () => context.read<LocationProvider>().determinePosition(),
                     )
                   ],
                 ),
              ),
             )
        ],
      ),
      floatingActionButton: locationProvider.currentPosition != null
          ? Container(
            decoration: const BoxDecoration(
              gradient: AppTheme.primaryGradient,
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: Colors.black26,
                  blurRadius: 8,
                  offset: Offset(0, 4),
                ),
              ],
            ),
            child: FloatingActionButton(
                backgroundColor: Colors.transparent,
                elevation: 0,
                onPressed: () {
                  _mapController.move(
                    LatLng(
                      locationProvider.currentPosition!.latitude,
                      locationProvider.currentPosition!.longitude,
                    ),
                    15.0,
                  );
                },
                tooltip: 'Recentrer sur ma position',
                child: const Icon(Icons.my_location),
              ),
          )
          : null,
    );
  }

  Marker _buildCustomMarker(Work work) {
    return Marker(
      width: 45,
      height: 45,
      point: LatLng(work.latitude!, work.longitude!),
      child: GestureDetector(
        onTap: () {
          // Afficher un bottom sheet custom au clic
          showModalBottomSheet(
            context: context,
            backgroundColor: Colors.transparent,
            builder: (context) => Container(
              margin: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
                boxShadow: const [BoxShadow(color: Colors.black26, blurRadius: 10)],
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    height: 5,
                    width: 40,
                    margin: const EdgeInsets.only(top: 10, bottom: 5),
                    decoration: BoxDecoration(
                      color: Colors.grey[300],
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  ListTile(
                    leading: Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: AppTheme.secondaryColor.withOpacity(0.1),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(Icons.construction, color: AppTheme.secondaryColor),
                    ),
                    title: Text(
                      work.title,
                      style: GoogleFonts.poppins(fontWeight: FontWeight.bold),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    subtitle: Text(
                      work.description,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    trailing: const Icon(Icons.chevron_right),
                    onTap: () {
                      Navigator.pop(context); // Fermer le bottom sheet
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (_) => WorkDetailScreen(work: work)),
                      );
                    },
                  ),
                  const SizedBox(height: 10),
                ],
              ),
            ),
          );
        },
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            shape: BoxShape.circle,
            boxShadow: const [BoxShadow(color: Colors.black26, blurRadius: 4)],
            border: Border.all(color: AppTheme.secondaryColor, width: 2),
          ),
          child: const Center(
            child: Icon(
              Icons.construction,
              color: AppTheme.secondaryColor,
              size: 24,
            ),
          ),
        ),
      ),
    );
  }
}
