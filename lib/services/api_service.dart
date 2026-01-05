import '../models/work.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class ApiService {

  final String apiUrl = "https://data.angers.fr/api/explore/v2.1/catalog/datasets/info-travaux/records";

  Future<List<Work>> fetchWork() async {
    try {
      final response = await http.get(Uri.parse(apiUrl));
      if (response.statusCode == 200) {
        final Map<String, dynamic> jsonResponse = jsonDecode(response.body);
        final List<dynamic> results = jsonResponse['results'];
        List<Work> works = results.map((jsonWork) => Work.fromJson(jsonWork)).toList();
        return works;
      } else {
        throw Exception('Erreur serveur: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Erreur de connexion: $e');
    }
  }
  Future<List<Work>> fetchWorkById(List<dynamic> ids) async {
    if (ids.isEmpty) {
      return [];
    }
    final String whereClause = ids.map((id) => 'id = $id').join(' OR ');
    final Uri url = Uri.parse(
        '$apiUrl?where=${Uri.encodeComponent(whereClause)}');
    final response = await http.get(url);

    if (response.statusCode == 200) {
      final Map<String, dynamic> jsonResponse = jsonDecode(response.body);
      final List<dynamic> results = jsonResponse['results'];
      List<Work> works = results
          .map((jsonWork) => Work.fromJson(jsonWork))
          .toList();
      return works;
    } else {
      throw Exception('Failed to load favorite works from API');
    }
  }
}