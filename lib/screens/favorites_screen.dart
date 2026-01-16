import 'package:angers_connect/services/api_service.dart';
import 'package:flutter/material.dart';
import "package:hive_flutter/hive_flutter.dart";

import '../models/work.dart';
import 'work_detail_screen.dart';


class FavoritesScreen extends StatefulWidget {
  const FavoritesScreen({super.key});
  
  @override
  State<FavoritesScreen> createState() => _FavoritesScreenState();
}

class _FavoritesScreenState extends State<FavoritesScreen> {
  final ApiService apiService = ApiService();
  Future<List<Work>>? _favoritesFuture;
  List<dynamic> _lastFavoriteIds = [];

  @override
  void initState() {
    super.initState();
    _loadFavorites();
  }

  void _loadFavorites() {
    final box = Hive.box('favorites');
    final favoriteIds = box.keys.toList();
    
    // Ne recharger que si les IDs ont changé
    if (!_listsEqual(_lastFavoriteIds, favoriteIds)) {
      setState(() {
        _lastFavoriteIds = List.from(favoriteIds);
        _favoritesFuture = apiService.fetchWorkById(favoriteIds);
      });
    }
  }

  bool _listsEqual(List a, List b) {
    if (a.length != b.length) return false;
    final sortedA = List.from(a)..sort();
    final sortedB = List.from(b)..sort();
    for (int i = 0; i < sortedA.length; i++) {
      if (sortedA[i] != sortedB[i]) return false;
    }
    return true;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ValueListenableBuilder(
        valueListenable: Hive.box('favorites').listenable(),
        builder: (context, box, child) {
          // Différer le rechargement après la phase de build
          WidgetsBinding.instance.addPostFrameCallback((_) {
            _loadFavorites();
          });

          return FutureBuilder<List<Work>>(
            future: _favoritesFuture,
            builder: (context, snapshot) {
              if(snapshot.connectionState == ConnectionState.waiting){
                return const Center(child: CircularProgressIndicator());
              }else if(snapshot.hasError){
                return Center(
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(Icons.error_outline, color: Colors.red, size: 60),
                        const SizedBox(height: 16),
                        Text(
                          'Erreur: ${snapshot.error}',
                          textAlign: TextAlign.center,
                          style: const TextStyle(fontSize: 16),
                        ),
                        const SizedBox(height: 16),
                        ElevatedButton.icon(
                          onPressed: () {
                            setState(() {
                              _favoritesFuture = apiService.fetchWorkById(_lastFavoriteIds);
                            });
                          },
                          icon: const Icon(Icons.refresh),
                          label: const Text('Réessayer'),
                        ),
                      ],
                    ),
                  ),
                );
              }else if(snapshot.hasData){
                final List<Work> works = snapshot.data!;
                if(works.isEmpty){
                  return const Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.favorite_border, size: 64, color: Colors.grey),
                        SizedBox(height: 16),
                        Text(
                          "Vous n'avez aucun favori.",
                          style: TextStyle(fontSize: 18),
                        ),
                        SizedBox(height: 8),
                        Text(
                          "Ajoutez des travaux en favoris depuis l'accueil",
                          style: TextStyle(fontSize: 14, color: Colors.grey),
                        ),
                      ],
                    ),
                  );
                }
                return ListView.builder(
                  itemCount: works.length,
                  itemBuilder: (context, index){
                    final Work work = works[index];
                    return ListTile(
                      leading: const Icon(Icons.construction, color: Colors.orange),
                      title: Text(work.title),
                      subtitle: Text(work.description),
                      isThreeLine: true,
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => WorkDetailScreen(work: work),
                          ),
                        );
                      },
                      trailing: IconButton(
                        icon: const Icon(Icons.favorite, color: Colors.red),
                        onPressed: () {
                          box.delete(work.id);
                        },
                      ),
                    );

                  },
                );
              }
              return const Center(child: Text("Aucun favori."));
            },
          );
        },
      ),
    );
  }
}


