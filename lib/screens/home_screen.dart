import "package:flutter/material.dart";
import "package:hive_flutter/hive_flutter.dart";
import "../models/work.dart";
import "../services/api_service.dart";
import 'work_detail_screen.dart';


class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late Future<List<Work>> _works;
  ApiService apiService = ApiService();
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';


  @override
  void initState() {
    super.initState();
    _loadWorks();
  }

  void _loadWorks() {
    setState(() {
      _works = apiService.fetchWork();
    });
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Work>>(
      future: _works,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.error_outline, color: Colors.red, size: 60),
                const SizedBox(height: 16),
                const Text(
                  'Oups ! Problème de connexion.',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                const Text('Vérifiez votre internet et réessayez.'),
                const SizedBox(height: 16),
                ElevatedButton.icon(
                  onPressed: _loadWorks,
                  icon: const Icon(Icons.refresh),
                  label: const Text('Réessayer'),
                ),
              ],
            ),
          );
        } else if (snapshot.hasData) {
          List<Work> works = snapshot.data!;
          if (works.isEmpty) {
            return const Center(child: Text('Aucun travail à afficher'));
          }
          return ValueListenableBuilder(
            //  Écoute les changements dans la box Hive "favorites"
            valueListenable: Hive.box('favorites').listenable(),
            builder: (context, box, widget) {

              //  FILTRAGE DES CHANTIERS SELON LA RECHERCHE
              final filteredWorks = works.where((work) {
                final query = _searchQuery.toLowerCase();

                // Recherche dans le titre OU la description
                return work.title.toLowerCase().contains(query) ||
                    work.description.toLowerCase().contains(query);
              }).toList();

              return Column(
                children: [

                  //  BARRE DE RECHERCHE
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: TextField(
                      controller: _searchController,
                      decoration: InputDecoration(
                        hintText: 'Rechercher un chantier...',
                        prefixIcon: const Icon(Icons.search),

                        //  Bouton pour effacer la recherche
                        suffixIcon: _searchQuery.isNotEmpty
                            ? IconButton(
                          icon: const Icon(Icons.clear),
                          onPressed: () {
                            _searchController.clear();
                            setState(() {
                              _searchQuery = '';
                            });
                          },
                        )
                            : null,

                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),

                      //  Mise à jour de la recherche en temps réel
                      onChanged: (value) {
                        setState(() {
                          _searchQuery = value;
                        });
                      },
                    ),
                  ),


                  Expanded(
                    child: filteredWorks.isEmpty

                        ? const Center(
                      child: Text("Aucun chantier trouvé."),
                    )


                        : ListView.builder(
                      itemCount: filteredWorks.length,
                      itemBuilder: (context, index) {
                        final work = filteredWorks[index];


                        final bool isFavorite = box.containsKey(work.id);

                        return ListTile(
                          leading: const Icon(
                            Icons.construction,
                            color: Colors.orange,
                          ),

                          title: Text(work.title),
                          subtitle: Text(work.description),
                          isThreeLine: true,

                          //  Navigation vers le détail du chantier
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) =>
                                    WorkDetailScreen(work: work),
                              ),
                            );
                          },


                          trailing: IconButton(
                            icon: Icon(
                              isFavorite
                                  ? Icons.favorite
                                  : Icons.favorite_border,
                              color: isFavorite ? Colors.red : null,
                            ),
                            onPressed: () {

                              if (isFavorite) {
                                box.delete(work.id);
                              } else {
                                box.put(work.id, true);
                              }
                            },
                          ),
                        );
                      },
                    ),
                  ),
                ],
              );
            },
          );

        }
        return const Center(child: Text("Aucun travail à afficher."));
      },
    );
  }
}
