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
      lat = json['geo_point_2d']['lat'];
      lng = json['geo_point_2d']['lon'];
    }

    //  Fallback geo_shape
    else if (json['geo_shape'] != null &&
        json['geo_shape']['geometry'] != null &&
        json['geo_shape']['geometry']['coordinates'] != null) {
      final coords = json['geo_shape']['geometry']['coordinates'];
      if (coords is List && coords.length >= 2) {
        lng = coords[0];
        lat = coords[1];
      }
    }

    Work work = Work(
      id: json['id'],
      title: json['title'],
      description: json['description'],
      startAt: DateTime.parse(json['startat']),
      endAt: DateTime.parse(json['endat']),
      latitude: lat,
      longitude: lng,
    );
    return work;
  }
}