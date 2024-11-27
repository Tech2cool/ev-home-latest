class Configuration {
  final String reraId;
  final String image;
  final String carpetArea;
  final double price;
  final String configuration;

  Configuration({
    required this.reraId,
    required this.image,
    required this.carpetArea,
    required this.price,
    required this.configuration,
  });

  Map<String, dynamic> toJson() {
    return {
      "reraId": reraId,
      "image": image,
      "carpetArea": carpetArea,
      "price": price,
      "configuration": configuration,
    };
  }

  factory Configuration.fromJson(Map<String, dynamic> json) {
    return Configuration(
      reraId: json['reraId'] ?? '',
      image: json['image'] ?? '',
      carpetArea: json['carpetArea'] ?? '',
      price: double.parse(json['price'].toString()),
      configuration: json['configuration'] ?? '',
    );
  }
}
