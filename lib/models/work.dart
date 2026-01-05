class Work {
  final int id;
  final String title;
  final String description;
  final DateTime startAt;
  final DateTime endAt;

  Work({
    required this.id,
    required this.title,
    required this.description,
    required this.startAt,
    required this.endAt
  });

  factory Work.fromJson(Map<String, dynamic> json) {
    Work work = Work(
      id: json['id'],
      title: json['title'],
      description: json['description'],
      startAt: DateTime.parse(json['startat']),
      endAt: DateTime.parse(json['endat'])
    );
    return work;
  }
}