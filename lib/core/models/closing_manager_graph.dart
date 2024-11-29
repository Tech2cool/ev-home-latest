// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class ClosingManagerGraph {
  final double leadCount;
  final double bookingCount;
  final double visitCount;
  final double revisitCount;

  ClosingManagerGraph({
    this.leadCount = 0.0,
    this.bookingCount = 0.0,
    this.visitCount = 0.0,
    this.revisitCount = 0.0,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'leadCount': leadCount,
      'bookingCount': bookingCount,
      'visitCount': visitCount,
      'revisitCount': revisitCount,
    };
  }

  factory ClosingManagerGraph.fromMap(Map<String, dynamic> map) {
    return ClosingManagerGraph(
      leadCount: map['leadCount'] != null
          ? double.parse(map['leadCount'].toString())
          : 0.0,
      bookingCount: map['bookingCount'] != null
          ? double.parse(map['bookingCount'].toString())
          : 0.0,
      visitCount: map['visitCount'] != null
          ? double.parse(map['visitCount'].toString())
          : 0.0,
      revisitCount: map['revisitCount'] != null
          ? double.parse(map['revisitCount'].toString())
          : 0.0,
    );
  }

  String toJson() => json.encode(toMap());

  factory ClosingManagerGraph.fromJson(String source) =>
      ClosingManagerGraph.fromMap(json.decode(source) as Map<String, dynamic>);
}
