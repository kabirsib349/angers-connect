import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:google_fonts/google_fonts.dart';

import 'home_screen.dart';
import 'favorites_screen.dart';
import 'map_screen.dart';
import '../providers/favorites_provider.dart';
import '../theme/theme.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _selectedIndex = 0;
  
  final List<Widget> _screens = const [
    HomeScreen(),
    MapScreen(),
    FavoritesScreen(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    // Écouter le nombre de favoris pour le badge
    final favoritesCount = context.watch<FavoritesProvider>().favoritesCount;

    return Scaffold(
      body: IndexedStack(
        index: _selectedIndex,
        children: _screens,
      ),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 10,
              offset: const Offset(0, -5),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
          child: NavigationBar(
            selectedIndex: _selectedIndex,
            onDestinationSelected: _onItemTapped,
            backgroundColor: Colors.white,
            indicatorColor: AppTheme.secondaryColor.withOpacity(0.1),
            labelBehavior: NavigationDestinationLabelBehavior.onlyShowSelected,
            destinations: [
              const NavigationDestination(
                icon: Icon(Icons.home_outlined),
                selectedIcon: Icon(Icons.home, color: AppTheme.secondaryColor),
                label: 'Accueil',
              ),
              const NavigationDestination(
                icon: Icon(Icons.map_outlined),
                selectedIcon: Icon(Icons.map, color: AppTheme.secondaryColor),
                label: 'Carte',
              ),
              NavigationDestination(
                icon: Badge(
                  label: Text('$favoritesCount'),
                  isLabelVisible: favoritesCount > 0,
                  backgroundColor: AppTheme.accentColor,
                  child: const Icon(Icons.favorite_border),
                ),
                selectedIcon: Badge(
                  label: Text('$favoritesCount'),
                  isLabelVisible: favoritesCount > 0,
                  backgroundColor: AppTheme.accentColor,
                  child: const Icon(Icons.favorite, color: AppTheme.accentColor),
                ),
                label: 'Favoris',
              ),
            ],
          ),
        ),
      ),
    );
  }
}