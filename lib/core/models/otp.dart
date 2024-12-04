// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class Otp {
  final String id;
  final String docId;
  final String otp;
  final String? phoneNumber;
  final String? email;
  final String type;
  final String message;

  Otp({
    required this.id,
    required this.docId,
    required this.otp,
    required this.phoneNumber,
    required this.email,
    required this.type,
    required this.message,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'docId': docId,
      'otp': otp,
      'phoneNumber': phoneNumber,
      'email': email,
      'type': type,
      'message': message,
    };
  }

  factory Otp.fromMap(Map<String, dynamic> map) {
    return Otp(
      id: map['_id'] as String,
      docId: map['docId'] as String,
      otp: map['otp'] as String,
      phoneNumber:
          map['phoneNumber'] != null ? map['phoneNumber'] as String : null,
      email: map['email'] != null ? map['email'] as String : null,
      type: map['type'] as String,
      message: map['message'] as String,
    );
  }

  String toJson() => json.encode(toMap());

  factory Otp.fromJson(String source) =>
      Otp.fromMap(json.decode(source) as Map<String, dynamic>);
}
