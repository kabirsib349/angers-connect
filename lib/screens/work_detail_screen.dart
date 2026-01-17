import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import '../models/work.dart';
import '../theme/theme.dart';
import '../providers/favorites_provider.dart';

class WorkDetailScreen extends StatelessWidget {
  final Work work;

  const WorkDetailScreen({super.key, required this.work});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: Container(
          margin: const EdgeInsets.only(left: 8, top: 8),
          decoration: BoxDecoration(
            color: Colors.black.withValues(alpha: 0.3),
            shape: BoxShape.circle,
          ),
          child: IconButton(
            icon: const Icon(Icons.arrow_back, color: Colors.white),
            onPressed: () => Navigator.pop(context),
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.zero,
        child: Column(
          children: [
            // Header stylisé
            Container(
              height: 250,
              width: double.infinity,
              decoration: const BoxDecoration(
                gradient: AppTheme.primaryGradient,
                borderRadius: BorderRadius.vertical(bottom: Radius.circular(30)),
              ),
              child: Stack(
                children: [
                   // Décoration de fond
                  Positioned(
                    right: -50,
                    top: -50,
                    child: Icon(
                      Icons.construction, 
                      size: 300, 
                      color: Colors.white.withValues(alpha: 0.1)
                    ),
                  ),
                  
                  // Contenu du header
                  Padding(
                    padding: const EdgeInsets.all(24.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Consumer<FavoritesProvider>(
                          builder: (context, favoritesProvider, _) {
                            final isFavorite = favoritesProvider.isFavorite(work.id);
                            return Align(
                              alignment: Alignment.centerRight,
                              child: FloatingActionButton(
                                backgroundColor: Colors.white,
                                onPressed: () => favoritesProvider.toggleFavorite(work),
                                child: Icon(
                                  isFavorite ? Icons.favorite : Icons.favorite_border,
                                  color: isFavorite ? AppTheme.accentColor : Colors.grey,
                                ),
                              ),
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            
            Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                   // Titre
                  Text(
                    work.title,
                    style: GoogleFonts.poppins(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: AppTheme.textDark,
                    ),
                  ),
                  
                  const SizedBox(height: 16),
                  
                  // Dates
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.05),
                          blurRadius: 10,
                          offset: const Offset(0, 5),
                        ),
                      ],
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        _buildDateItem("Début", work.startAt),
                        Container(width: 1, height: 40, color: Colors.grey[300]),
                        _buildDateItem("Fin", work.endAt),
                      ],
                    ),
                  ),
                  
                  const SizedBox(height: 24),
                  
                  // Description
                  Text(
                    "Description",
                    style: GoogleFonts.poppins(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      color: AppTheme.textDark,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    work.description.isNotEmpty ? work.description : "Aucune description disponible",
                    style: GoogleFonts.inter(
                      fontSize: 16,
                      color: AppTheme.textLight,
                      height: 1.5,
                    ),
                  ),
                  
                  const SizedBox(height: 24),
                  
                  if (work.latitude != null && work.longitude != null)
                   _buildLocationCard(work.latitude!, work.longitude!),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDateItem(String label, DateTime date) {
    return Column(
      children: [
        Text(
          label.toUpperCase(),
          style: GoogleFonts.inter(
            fontSize: 12,
            fontWeight: FontWeight.bold,
            color: AppTheme.textLight,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          "${date.day}/${date.month}/${date.year}",
          style: GoogleFonts.poppins(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: AppTheme.primaryColor,
          ),
        ),
      ],
    );
  }
  
  Widget _buildLocationCard(double lat, double lng) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppTheme.secondaryColor.withValues(alpha: 0.05),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppTheme.secondaryColor.withValues(alpha: 0.1)),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: const BoxDecoration(
              color: Colors.white,
              shape: BoxShape.circle,
            ),
            child: const Icon(Icons.location_on, color: AppTheme.secondaryColor),
          ),
          const SizedBox(width: 16),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Localisation",
                style: GoogleFonts.poppins(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: AppTheme.textDark,
                ),
              ),
              Text(
                "Lat: $lat, Lng: $lng",
                style: GoogleFonts.inter(
                  fontSize: 12,
                  color: AppTheme.textLight,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
