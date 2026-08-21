class Trailer {
  int id;
  String name;
  String key;
  String? type;
  String? site;

  Trailer({
    required this.id,
    required this.name,
    required this.key,
    this.type,
    this.site,
  });

  factory Trailer.fromJson (Map<String, dynamic> json)
  {
    return Trailer (
      id: json['id'] as int,
      name: json['name'] as String,
      key: json['key'] as String,
      type: json['type'] as String,
      site: json['site'] as String,
    );
  }
}
