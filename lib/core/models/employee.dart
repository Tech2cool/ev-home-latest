import 'package:ev_homes/core/models/department.dart';
import 'package:ev_homes/core/models/designation.dart';
import 'package:ev_homes/core/models/division.dart';

class Employee {
  final String? id;
  final String? profilePic;
  final String? employeeId;
  final String? firstName;
  final String? lastName;
  final String? email;
  final int? phoneNumber;
  final String? dateOfBirth;
  final String? gender;
  final String? address;
  final String? status;
  final String? role;
  final bool? isVerified;
  final bool? isVerifiedPhone;
  final bool? isVerifiedEmail;
  final Designation? designation;
  final Department? department;
  final Division? division;
  final Employee? reportingTo;

  Employee({
    required this.id,
    required this.employeeId,
    required this.firstName,
    required this.lastName,
    required this.email,
    required this.status,
    required this.phoneNumber,
    required this.dateOfBirth,
    required this.gender,
    required this.address,
    this.role,
    this.profilePic,
    required this.isVerified,
    this.isVerifiedPhone,
    this.isVerifiedEmail,
    this.designation,
    this.department,
    this.division,
    this.reportingTo,
  });
  factory Employee.fromMap(Map<String, dynamic> map) {
    return Employee(
      id: map['_id'],
      email: map['email'],
      employeeId: map['employeeId'],
      profilePic: map['profilePic'],
      firstName: map['firstName'],
      lastName: map['lastName'],
      phoneNumber: map['phoneNumber'],
      dateOfBirth: map['dateOfBirth'],
      gender: map['gender'],
      status: map['status'],
      address: map['address'],
      role: map['role'],
      isVerified: map['isVerified'],
      isVerifiedPhone: map['isVerifiedPhone'],
      isVerifiedEmail: map['isVerifiedEmail'],
      designation: map['designation'] != null
          ? Designation.fromMap(map['designation'])
          : null,
      department: map['department'] != null
          ? Department.fromMap(map['department'])
          : null,
      division:
          map['division'] != null ? Division.fromMap(map['division']) : null,
      reportingTo: (map['reportingTo'] != null &&
              map['reportingTo'] is Map<String, dynamic>)
          ? Employee.fromMap(map['reportingTo'] as Map<String, dynamic>)
          : null,
    );
  }
  Map<String, dynamic> toMap() {
    return {
      "id": id,
      "email": email,
      "employeeId": employeeId,
      "profilePic": profilePic,
      "firstName": firstName,
      "lastName": lastName,
      "phoneNumber": phoneNumber,
      "dateOfBirth": dateOfBirth,
      "gender": gender,
      "status": status,
      "address": address,
      "role": role,
      "isVerified": isVerified,
      "isVerifiedPhone": isVerifiedPhone,
      "isVerifiedEmail": isVerifiedEmail,
      "designation": designation?.toMap(),
      "department": department?.toMap(),
      "division": division?.toMap(),
      "reportingTo": reportingTo?.toMap,
    };
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is Employee && other.employeeId == employeeId;
  }

  @override
  int get hashCode => employeeId.hashCode;
}
