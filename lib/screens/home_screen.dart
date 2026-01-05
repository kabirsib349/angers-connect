import "package:flutter/material.dart";
import "package:hive_flutter/hive_flutter.dart";
import "../models/work.dart";
import "../services/api_service.dart";

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late Future<List<Work>> _works;
  ApiService apiService = ApiService();

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
            valueListenable: Hive.box('favorites').listenable(),
            builder: (context, box, widget) {
              return ListView.builder(
                itemCount: works.length,
                itemBuilder: (context, index) {
                  Work work = works[index];
                  final bool isFavorite = box.containsKey(work.id);
                  return ListTile(
                    leading: const Icon(Icons.construction, color: Colors.orange),
                    title: Text(work.title),
                    subtitle: Text(work.description),
                    isThreeLine: true,
                    trailing: IconButton(
                      icon: Icon(
                        isFavorite ? Icons.favorite : Icons.favorite_border,
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
              );
            },
          );
        }
        return const Center(child: Text("Aucun travail à afficher."));
      },
    );
  }
}
