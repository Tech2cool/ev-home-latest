// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:ev_homes/core/models/employee.dart';

class SiteVisit {
  final DateTime? date;
  final String? firstName;
  final String? lastName;
  final int? phoneNumber;
  final String? countryCode;
  final String? email;
  final String? residence;
  final List<String> projects;
  final String? visitType;
  final List<String> choiceApt;
  final Employee? closingManager;
  final Employee? attendedBy;
  final Employee? dataEntryBy;
  final String? gender;
  final String? feedback;
  final String? namePrefix;
  final String? source;

  SiteVisit({
    this.visitType,
    this.date,
    this.firstName,
    this.lastName,
    this.phoneNumber,
    this.countryCode,
    this.email,
    this.residence,
    this.namePrefix,
    required this.projects,
    required this.choiceApt,
    this.closingManager,
    this.attendedBy,
    this.dataEntryBy,
    this.gender,
    this.feedback,
    this.source,
  });

  Map<String, dynamic> toMap() {
    return {
      'date': date.toString(),
      'firstName': firstName,
      'lastName': lastName,
      'phoneNumber': phoneNumber,
      'countryCode': countryCode,
      'email': email,
      'feedback': feedback,
      'residence': residence,
      'projects': projects,
      'visitType': visitType,
      'choiceApt': choiceApt,
      'gender': gender,
      'namePrefix': namePrefix,
      'source': source,
      'closingManager': closingManager?.toMap(),
      'attendedBy': attendedBy?.toMap(),
      'dataEntryBy': dataEntryBy?.toMap(),
    };
  }

  factory SiteVisit.fromMap(Map<String, dynamic> map) {
    return SiteVisit(
      date: map['createdAt'] != null
          ? DateTime.parse(map['date'])
          : DateTime.parse(map['createdAt']),
      firstName: map['firstName'],
      lastName: map['lastName'],
      phoneNumber: map['phoneNumber'],
      countryCode: map['countryCode'],
      email: map['email'],
      gender: map['gender'],
      residence: map['residence'],
      feedback: map['feedback'],
      namePrefix: map['namePrefix'],
      source: map['source'],
      projects: List<String>.from((map['projects'] ?? [])),
      visitType: (map['visitType']),
      choiceApt: List<String>.from((map['choiceApt'] ?? [])),
      closingManager: map['closingManager'] != null
          ? Employee.fromMap(map['closingManager'])
          : null,
      attendedBy: map['attendedBy'] != null
          ? Employee.fromMap(map['attendedBy'])
          : null,
      dataEntryBy: map['dataEntryBy'] != null
          ? Employee.fromMap(map['dataEntryBy'])
          : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory SiteVisit.fromJson(String source) =>
      SiteVisit.fromMap(json.decode(source) as Map<String, dynamic>);
}
