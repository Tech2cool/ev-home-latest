class ChannelPartner {
  final String? id;
  final String? firstName;
  final String? profilePic;
  final String? lastName;
  final String email;
  final String gender;
  final String dateOfBirth;
  final String? firmName;
  final String? homeAddress;
  final String? firmAddress;
  final int? phoneNumber;
  final bool? haveReraRegistration;
  final String? reraNumber;
  final String? reraCertificate;
  final bool? isVerified;
  final bool? sameAdress;
  final String? refreshToken;
  final String? accessToken;
  final bool? isVerifiedPhone;
  final bool? isVerifiedEmail;
  final String? role;

  ChannelPartner({
    required this.id,
    required this.firstName,
    this.profilePic,
    required this.lastName,
    required this.email,
    required this.gender,
    required this.dateOfBirth,
    required this.firmName,
    required this.homeAddress,
    required this.firmAddress,
    required this.phoneNumber,
    this.haveReraRegistration,
    required this.reraNumber,
    required this.reraCertificate,
    this.isVerified,
    this.sameAdress,
    this.refreshToken,
    this.accessToken,
    this.isVerifiedPhone,
    this.isVerifiedEmail,
    this.role,
  });

  factory ChannelPartner.fromMap(Map<String, dynamic> map) {
    return ChannelPartner(
      id: map['_id'],
      firstName: map['firstName'],
      profilePic: map['profilePic'],
      lastName: map['lastName'],
      email: map['email'],
      gender: map['gender'],
      dateOfBirth: map['dateOfBirth'],
      firmName: map['firmName'],
      homeAddress: map['homeAddress'],
      firmAddress: map['firmAddress'],
      phoneNumber: map['phoneNumber'],
      haveReraRegistration: map['haveReraRegistration'],
      reraNumber: map['reraNumber'],
      reraCertificate: map['reraCertificate'],
      isVerified: map['isVerified'],
      sameAdress: map['sameAdress'],
      refreshToken: map['refreshToken'],
      accessToken: map['accessToken'],
      isVerifiedPhone: map['isVerifiedPhone'],
      isVerifiedEmail: map['isVerifiedEmail'],
      role: map['role'],
    );
  }
  Map<String, dynamic> toMap() {
    return {
      "id": id,
      "firstName": firstName,
      "lastName": lastName,
      "email": email,
      "profilePic": profilePic,
      "gender": gender,
      "dateOfBirth": dateOfBirth,
      "firmName": firmName,
      "firmAddress": firmAddress,
      "homeAddress": homeAddress,
      "phoneNumber": phoneNumber,
      "haveReraRegistration": haveReraRegistration,
      "reraNumber": reraNumber,
      "reraCertificate": reraCertificate,
      "isVerified": isVerified,
      "sameAdress": sameAdress,
      "isVerifiedPhone": isVerifiedPhone,
      "isVerifiedEmail": isVerifiedEmail,
      "role": role,
    };
  }
}
