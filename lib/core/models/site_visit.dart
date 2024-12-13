// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:ev_homes/core/models/employee.dart';
import 'package:ev_homes/core/models/our_project.dart';

class SiteVisit {
  final DateTime? date;
  final String? firstName;
  final String? lastName;
  final int? phoneNumber;
  final String? countryCode;
  final String? email;
  final String? residence;
  final String? visitType;
  final List<OurProject> projects;
  final OurProject? location;
  final List<String> choiceApt;
  final Employee? closingManager;
  List<Employee> closingTeam;
  final Employee? attendedBy;
  final Employee? dataEntryBy;
  final String? gender;
  final String? feedback;
  final String? namePrefix;
  final String? source;
  final bool verified;

  SiteVisit({
    this.visitType,
    this.date,
    this.firstName,
    this.lastName,
    this.phoneNumber,
    this.countryCode = "+91",
    this.email,
    this.residence,
    this.namePrefix,
    required this.projects,
    required this.choiceApt,
    this.verified = false,
    this.closingManager,
    this.closingTeam = const [],
    this.attendedBy,
    this.dataEntryBy,
    this.gender,
    this.feedback,
    this.source,
    this.location,
  });

  Map<String, dynamic> toMap() {
    return {
      'date': date?.toIso8601String(),
      'firstName': firstName,
      'lastName': lastName,
      'phoneNumber': phoneNumber,
      'countryCode': countryCode,
      'email': email,
      'feedback': feedback,
      'residence': residence,
      'projects': projects.map((ele) => ele.id).toList(),
      'visitType': visitType,
      'location': location?.id,
      'choiceApt': choiceApt,
      'gender': gender,
      'namePrefix': namePrefix,
      'source': source,
      'verified': verified,
      'closingManager': closingManager?.id,
      'closingTeam': closingTeam.map((e) => e.id).toList(),
      'attendedBy': attendedBy?.id,
      'dataEntryBy': dataEntryBy?.id,
    };
  }

  factory SiteVisit.fromMap(Map<String, dynamic> map) {
    return SiteVisit(
      date: map['date'] != null
          ? DateTime.parse(map['date'])
          : DateTime.parse(map['createdAt']),
      firstName: map['firstName'],
      lastName: map['lastName'],
      phoneNumber: map['phoneNumber'],
      countryCode: map['countryCode'] ?? "+91",
      email: map['email'],
      gender: map['gender'],
      residence: map['residence'],
      verified: map['verified'],
      feedback: map['feedback'],
      namePrefix: map['namePrefix'],
      source: map['source'],
      visitType: map['visitType'],
      projects: map['projects'] != null
          ? List<OurProject>.from(
              (map['projects'] as List).map(
                (e) => OurProject.fromJson(e),
              ),
            )
          : [],
      choiceApt: List<String>.from((map['choiceApt'] ?? [])),
      closingManager: map['closingManager'] != null
          ? Employee.fromMap(map['closingManager'])
          : null,
      closingTeam: map['closingTeam'] != null
          ? List<Employee>.from(
              (map['closingTeam'] as List).map((e) => Employee.fromMap(e)))
          : [],
      attendedBy: map['attendedBy'] != null
          ? Employee.fromMap(map['attendedBy'])
          : null,
      dataEntryBy: map['dataEntryBy'] != null
          ? Employee.fromMap(map['dataEntryBy'])
          : null,
      location:
          map['location'] != null ? OurProject.fromJson(map['location']) : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory SiteVisit.fromJson(String source) =>
      SiteVisit.fromMap(json.decode(source) as Map<String, dynamic>);
}
