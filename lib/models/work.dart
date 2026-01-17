class Work {
  final int id;
  final String title;
  final String description;
  final DateTime startAt;
  final DateTime endAt;
  final double? latitude;
  final double? longitude;


  Work({
    required this.id,
    required this.title,
    required this.description,
    required this.startAt,
    required this.endAt,
    this.latitude,
    this.longitude,
  });

  factory Work.fromJson(Map<String, dynamic> json) {
    double? lat;
    double? lng;
    
    // Cas geo_point_2d
    if (json['geo_point_2d'] != null) {
      lat = (json['geo_point_2d']['lat'] as num).toDouble();
      lng = (json['geo_point_2d']['lon'] as num).toDouble();
    }
    //  Fallback geo_shape
    else if (json['geo_shape']?['geometry']?['coordinates'] != null) {
      final coords = json['geo_shape']['geometry']['coordinates'];
      if (coords is List && coords.length >= 2) {
        lng = (coords[0] as num).toDouble();
        lat = (coords[1] as num).toDouble();
      }
    }

    return Work(
      id: json['id'] as int? ?? 0,
      title: json['title'] as String? ?? 'Sans titre',
      description: json['description'] as String? ?? 'Aucune description',
      startAt: DateTime.tryParse(json['startat'] ?? '') ?? DateTime.now(),
      endAt: DateTime.tryParse(json['endat'] ?? '') ?? DateTime.now(),
      latitude: lat,
      longitude: lng,
    );
  }
}