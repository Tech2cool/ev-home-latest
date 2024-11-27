// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:ev_homes/core/models/designation.dart';

class TeamSection {
  final String id;
  final String section;
  final List<Designation> designations;

  TeamSection({
    required this.id,
    required this.section,
    required this.designations,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'section': section,
      'designations': designations.map((x) => x.toMap()).toList(),
    };
  }

  factory TeamSection.fromMap(Map<String, dynamic> map) {
    return TeamSection(
      id: map['_id'],
      section: map['section'],
      designations: map['designations'] != null
          ? (map['designations'] as List<dynamic>)
              .map((ele) => Designation.fromMap(ele))
              .toList()
          : [],
    );
  }

  String toJson() => json.encode(toMap());

  factory TeamSection.fromJson(String source) =>
      TeamSection.fromMap(json.decode(source) as Map<String, dynamic>);
}
