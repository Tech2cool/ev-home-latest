class Amenity {
  final String name;
  final String image;

  Amenity({
    required this.name,
    required this.image,
  });

  Map<String, dynamic> toJson() {
    return {
      "name": name,
      "image": image,
    };
  }

  factory Amenity.fromJson(Map<String, dynamic> json) {
    return Amenity(
      name: json['name'] ?? '',
      image: json['image'] ?? '',
    );
  }
}
