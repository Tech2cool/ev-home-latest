class Division {
  final String division;
  final String id;

  Division({required this.division, required this.id});

  Map<String, dynamic> toMap() {
    return {
      "division": division,
      "id": id,
    };
  }

  factory Division.fromMap(Map<String, dynamic> map) {
    return Division(
      division: map["division"],
      id: map["_id"],
    );
  }
  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is Division && other.division == division;
  }

  // String toJson() => json.encode(toMap());

  // factory DivisionModel.fromJson(String source) =>
  //     DivisionModel.fromMap(json.decode(source) as Map<String, dynamic>);
}
