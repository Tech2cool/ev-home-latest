import 'package:ev_homes/core/models/employee.dart';

class Customer {
  final String id;
  final String firstName;
  final String lastName;
  final String email;
  final String gender;
  final int phoneNumber;
  final String? address;
  final List<String>? projects;
  final List<String>? choiceApt;
  final Employee? closingManager;
  final bool? isVerifiedPhone;
  final bool? isVerifiedEmail;
  final int? altPhoneNumber;

  final String? role;

  Customer({
    required this.id,
    required this.firstName,
    required this.lastName,
    required this.email,
    required this.gender,
    required this.phoneNumber,
    required this.address,
    required this.projects,
    required this.choiceApt,
    required this.closingManager,
    this.isVerifiedPhone,
    this.isVerifiedEmail,
    this.altPhoneNumber,
    this.role,
  });
  factory Customer.fromMap(Map<String, dynamic> map) {
    return Customer(
      id: map['_id'],
      firstName: map['firstName'] ?? '',
      lastName: map['lastName'] ?? '',
      email: map['email'] ?? '',
      gender: map['gender'] ?? '',
      phoneNumber: map['phoneNumber'],
      address: map['address'],
      isVerifiedEmail: map['isVerifiedEmail'] ?? false,
      isVerifiedPhone: map['isVerifiedPhone'] ?? false,
      altPhoneNumber: map['altPhoneNumber'],
      projects: List<String>.from(map['projects'] ?? []),
      choiceApt: List<String>.from(map['choiceApt'] ?? []),
      // closingManager: null,
      closingManager: map['closingManager'] != null
          ? Employee.fromMap(map['closingManager'])
          : null,
    );
  }
  Map<String, dynamic> toMap() {
    return {
      // "id": id,
      "firstName": firstName,
      "lastName": lastName,
      "email": email,
      "gender": gender,
      "phoneNumber": phoneNumber,
      "address": address,
      "isVerifiedEmail": isVerifiedEmail,
      "isVerifiedPhone": isVerifiedPhone,
      "altPhoneNumber": altPhoneNumber,
      "projects": projects,
      "closingManager": closingManager?.toMap(),
      "choiceApt": choiceApt,
    };
  }
}
