import 'package:ev_homes/core/models/our_project.dart';

class Payment {
  final OurProject projects;
  final String customerName;
  final int phoneNumber;
  final String dateOfAmtReceive;
  final String receiptNo;
  final String? account;
  final String? paymentMode;
  final String? transactionId;
  final String flatNo;
  final String carpetArea;
  final String? address1;
  final String? address2;
  final String? city;
  final int? pincode;
  final int allinclusiveamt;
  final int amtReceived;
  final int bookingAmt;
  final int stampDuty;
  final int tds;
  final int cgst;

  Payment({
    required this.projects,
    required this.customerName,
    required this.carpetArea,
    this.address1,
    this.address2,
    this.city,
    required this.phoneNumber,
    required this.dateOfAmtReceive,
    required this.receiptNo,
    this.account,
    this.paymentMode,
    this.transactionId,
    required this.flatNo,
    required this.amtReceived,
    required this.allinclusiveamt,
    this.pincode,
    required this.bookingAmt,
    required this.stampDuty,
    required this.tds,
    required this.cgst,
  });

  factory Payment.fromMap(Map<String, dynamic> map) {
    // if (map['projects'] == null) {
    //   print("it is");
    // }
    return Payment(
      projects: map['projects'] != null
          ? OurProject.fromJson(map['projects'])
          : map['projects'],
      customerName: map['customerName'],
      phoneNumber: map['phoneNumber'],
      dateOfAmtReceive: map['dateOfAmtReceive'],
      receiptNo: map['receiptNo'],
      account: map['account'],
      paymentMode: map['paymentMode'],
      transactionId: map['transactionId'],
      flatNo: map['flatNo'],
      carpetArea: map['carpetArea'],
      address1: map['address1'],
      address2: map['address2'],
      city: map['city'],
      pincode: map['pincode'],
      amtReceived: map['amtReceived'],
      allinclusiveamt: map['allinclusiveamt'],
      bookingAmt: map['bookingAmt'],
      stampDuty: map['stampDuty'],
      tds: map['tds'],
      cgst: map['cgst'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      "projects": projects.toJson(),
      "customerName": customerName,
      "phoneNumber": phoneNumber,
      "dateOfAmtReceive": dateOfAmtReceive,
      "receiptNo": receiptNo,
      "account": account,
      "paymentMode": paymentMode,
      "transactionId": transactionId,
      "flatNo": flatNo,
      "carpetArea": carpetArea,
      "address1": address1,
      "address2": address2,
      "city": city,
      "pincode": pincode,
      "amtReceived": amtReceived,
      "allinclusiveamt": allinclusiveamt,
      "bookingAmt": bookingAmt,
      "stampDuty": stampDuty,
      "tds": tds,
      "cgst": cgst
    };
  }
}
