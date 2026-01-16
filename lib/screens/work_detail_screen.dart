import 'package:flutter/material.dart';
import '../models/work.dart';

class WorkDetailScreen extends StatelessWidget {
  final Work work;

  const WorkDetailScreen({super.key, required this.work});

  String _formatDate(DateTime date) {
    return "${date.day.toString().padLeft(2, '0')}/"
        "${date.month.toString().padLeft(2, '0')}/"
        "${date.year}";
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(work.title),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            const Icon(Icons.construction, size: 80, color: Colors.orange),
            const SizedBox(height: 16),

            Text(
              work.title,
              style: const TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 16),

            Text(
              work.description,
              style: const TextStyle(fontSize: 16),
            ),

            const Divider(height: 32),

            ListTile(
              leading: const Icon(Icons.calendar_today),
              title: const Text("Début des travaux"),
              subtitle: Text(_formatDate(work.startAt)),
            ),

            ListTile(
              leading: const Icon(Icons.event),
              title: const Text("Fin des travaux"),
              subtitle: Text(_formatDate(work.endAt)),
            ),

            if (work.latitude != null && work.longitude != null)
              ListTile(
                leading: const Icon(Icons.location_on),
                title: const Text("Localisation"),
                subtitle: Text(
                  "Lat: ${work.latitude}, Lng: ${work.longitude}",
                ),
              ),
          ],
        ),
      ),
    );
  }
}
