class Work {
  final int id;
  final String title;
  final String description;
  final DateTime startAt;
  final DateTime endAt;
  //Ajout coordonnées
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
    if (json['geo_point_2d'] != null && json['geo_point_2d'] is List && json['geo_point_2d'].length == 2) {
      lat = (json['geo_point_2d'][0] as num).toDouble();
      lng = (json['geo_point_2d'][1] as num).toDouble();
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