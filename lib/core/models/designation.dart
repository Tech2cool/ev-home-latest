import 'dart:convert';

class Designation {
  final String designation;
  final String id;

  Designation({required this.designation, required this.id});

  factory Designation.fromMap(Map<String, dynamic> map) {
    return Designation(
      designation: map["designation"],
      id: map["_id"],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      "designation": designation,
      "id": id,
    };
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is Designation && other.id == id;
  }

  @override
  int get hashCode => id.hashCode;

  String toJson() => json.encode(toMap());

  factory Designation.fromJson(String source) =>
      Designation.fromMap(json.decode(source) as Map<String, dynamic>);
}
