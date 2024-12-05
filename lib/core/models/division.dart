class Division {
  final String id;
  final String division;
  final String? name;
  final String? location;
  final double? longitude;
  final double? latitude;
  final int? radius;

  Division({
    required this.division,
    required this.id,
    this.name,
    this.location,
    this.longitude,
    this.latitude,
    this.radius,
  });

  Map<String, dynamic> toMap() {
    return {
      "id": id,
      "division": division,
      "name": name,
      "location": location,
      "longitude": longitude,
      "latitude": latitude,
      "radius": radius,
    };
  }

  factory Division.fromMap(Map<String, dynamic> map) {
    return Division(
      id: map["_id"],
      division: map["division"],
      name: map["name"],
      location: map["location"],
      longitude: map["longitude"],
      latitude: map["latitude"],
      radius: map["radius"],
    );
  }
  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is Division && other.id == id;
  }

  @override
  int get hashCode => id.hashCode;

  // String toJson() => json.encode(toMap());

  // factory DivisionModel.fromJson(String source) =>
  //     DivisionModel.fromMap(json.decode(source) as Map<String, dynamic>);
}
