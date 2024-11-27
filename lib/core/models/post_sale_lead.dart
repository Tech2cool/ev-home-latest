// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:ev_homes/core/models/employee.dart';
import 'package:ev_homes/core/models/our_project.dart';

class Applicant {
  final String? firstName;
  final String? lastName;
  final String? countryCode;
  final int? phoneNumber;
  final String? address;
  final String? email;
  final Kyc kyc;

  Applicant({
    this.firstName,
    this.lastName,
    this.countryCode = "+91",
    this.phoneNumber,
    this.address,
    this.email,
    required this.kyc,
  });

  // Map<String, dynamic> toJson() {
  //   return {
  //     'firstName': firstName,
  //     'lastName': lastName,
  //   };
  // }

  Map<String, dynamic> toMap() {
    return {
      'firstName': firstName,
      'lastName': lastName,
      'countryCode': countryCode,
      'phoneNumber': phoneNumber,
      'address': address,
      'email': email,
      'kyc': kyc.toJson(),
    };
  }

  factory Applicant.fromMap(Map<String, dynamic> map) {
    return Applicant(
      firstName: map['firstName'],
      lastName: map['lastName'],
      countryCode: map['countryCode'],
      phoneNumber: map['phoneNumber'],
      address: map['address'],
      email: map['email'],
      kyc: Kyc.fromJson(map['kyc']),
    );
  }

  String toJson() => json.encode(toMap());

  factory Applicant.fromJson(String source) =>
      Applicant.fromMap(json.decode(source) as Map<String, dynamic>);
}

class PreRegistrationChecklist {
  final ChecklistItem tenPercentRecieved;
  final ChecklistItem stampDuty;
  final ChecklistItem gst;
  final ChecklistItem noc;
  final ChecklistItem tds;
  final ChecklistItem legalCharges;
  final ChecklistItem kyc;
  final Agreement agreement;

  PreRegistrationChecklist({
    required this.tenPercentRecieved,
    required this.stampDuty,
    required this.gst,
    required this.noc,
    required this.tds,
    required this.legalCharges,
    required this.kyc,
    required this.agreement,
  });

  factory PreRegistrationChecklist.fromJson(Map<String, dynamic> json) {
    return PreRegistrationChecklist(
      tenPercentRecieved: ChecklistItem.fromJson(json['tenPercentRecieved']),
      stampDuty: ChecklistItem.fromJson(json['stampDuty']),
      gst: ChecklistItem.fromJson(json['gst']),
      noc: ChecklistItem.fromJson(json['noc']),
      tds: ChecklistItem.fromJson(json['tds']),
      legalCharges: ChecklistItem.fromJson(json['legalCharges']),
      kyc: ChecklistItem.fromJson(json['kyc']),
      agreement: Agreement.fromJson(json['agreement']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'tenPercentRecieved': tenPercentRecieved.toJson(),
      'stampDuty': stampDuty.toJson(),
      'gst': gst.toJson(),
      'noc': noc.toJson(),
      'tds': tds.toJson(),
      'legalCharges': legalCharges.toJson(),
      'kyc': kyc.toJson(),
      'agreement': agreement.toJson(),
    };
  }
}

class ChecklistItem {
  final String recieved;
  final int? value;
  final int? percent;
  final String remark;

  ChecklistItem(
      {this.recieved = 'no', this.value, this.percent, this.remark = ''});

  factory ChecklistItem.fromJson(Map<String, dynamic> json) {
    return ChecklistItem(
      recieved: json['recieved'],
      value: json['value'],
      percent: json['percent'],
      remark: json['remark'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'recieved': recieved,
      'value': value,
      'percent': percent,
      'remark': remark,
    };
  }
}

class Kyc {
  final KycDocument addhar;
  final KycDocument pan;
  final KycDocument other;

  Kyc({required this.addhar, required this.pan, required this.other});

  factory Kyc.fromJson(Map<String, dynamic> json) {
    return Kyc(
      addhar: KycDocument.fromJson(json['addhar']),
      pan: KycDocument.fromJson(json['pan']),
      other: KycDocument.fromJson(json['other']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'addhar': addhar.toJson(),
      'pan': pan.toJson(),
      'other': other.toJson(),
    };
  }
}

class KycDocument {
  final bool verified;
  final String? document;
  final String remark;
  final String type;

  KycDocument({
    this.verified = false,
    this.document,
    this.remark = '',
    this.type = '',
  });

  factory KycDocument.fromJson(Map<String, dynamic> json) {
    return KycDocument(
      verified: json['verified'],
      document: json['document'],
      remark: json['remark'],
      type: json['type'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'verified': verified,
      'document': document,
      'remark': remark,
      'type': type,
    };
  }
}

class Agreement {
  final bool prepared;
  final HandOver handOver;
  final Document document;

  Agreement({
    this.prepared = false,
    required this.handOver,
    required this.document,
  });

  factory Agreement.fromJson(Map<String, dynamic> json) {
    return Agreement(
      prepared: json['prepared'],
      handOver: HandOver.fromJson(json['handOver']),
      document: Document.fromJson(json['document']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'prepared': prepared,
      'handOver': handOver.toJson(),
      'document': document.toJson(),
    };
  }
}

class HandOver {
  final String status;
  final String? document;
  final String remark;

  HandOver({this.status = 'no', this.document, this.remark = ''});

  factory HandOver.fromJson(Map<String, dynamic> json) {
    return HandOver(
      status: json['status'],
      document: json['document'],
      remark: json['remark'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'status': status,
      'document': document,
      'remark': remark,
    };
  }
}

class Document {
  final bool verified;
  final String? document;
  final String remark;

  Document({this.verified = false, this.document, this.remark = ''});

  factory Document.fromJson(Map<String, dynamic> json) {
    return Document(
      verified: json['verified'],
      document: json['document'],
      remark: json['remark'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'verified': verified,
      'document': document,
      'remark': remark,
    };
  }
}

class DisbursementRecord {
  final int? value;
  final int? percent;
  final int? recievedAmount;
  final int? gst;
  final String remark;

  DisbursementRecord({
    this.value,
    this.percent,
    this.recievedAmount,
    this.gst,
    this.remark = '',
  });

  factory DisbursementRecord.fromJson(Map<String, dynamic> json) {
    return DisbursementRecord(
      value: json['value'],
      percent: json['percent'],
      recievedAmount: json['recievedAmount'],
      gst: json['gst'],
      remark: json['remark'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'value': value,
      'percent': percent,
      'recievedAmount': recievedAmount,
      'gst': gst,
      'remark': remark,
    };
  }
}

class PostSaleLead {
  final String id;
  final String unitNo;
  final int? floor;
  final int? number;
  final OurProject? project;
  final String firstName;
  final String lastName;
  final String? requirement;
  final String? countryCode;
  final int? phoneNumber;
  final String? address;
  final String? email;
  final String date;
  final int? carpetArea;
  final int? sellableCarpetArea;
  final int? flatCost;
  final Employee? closingManager;
  final Employee? postSaleExecutive;
  final List<Employee> closingManagerTeam;
  final BookingStatus? bookingStatus;
  final List<Applicant> applicants;
  final PreRegistrationChecklist preRegistrationCheckList;
  final List<DisbursementRecord> disbursementRecord;

  PostSaleLead({
    required this.id,
    required this.unitNo,
    required this.floor,
    required this.number,
    required this.project,
    required this.date,
    required this.firstName,
    required this.lastName,
    this.requirement,
    this.countryCode = '+91',
    required this.phoneNumber,
    required this.address,
    required this.email,
    this.carpetArea,
    this.sellableCarpetArea,
    this.flatCost,
    this.closingManager,
    this.postSaleExecutive,
    this.closingManagerTeam = const [],
    this.bookingStatus,
    this.applicants = const [],
    required this.preRegistrationCheckList,
    this.disbursementRecord = const [],
  });

  factory PostSaleLead.fromJson(Map<String, dynamic> json) {
    return PostSaleLead(
      id: json['_id'],
      unitNo: json['unitNo'],
      floor: json['floor'],
      number: json['number'],
      project: json['project'] != null
          ? OurProject.fromJson(json['project'])
          : json['project'],
      date: json['date'],
      firstName: json['firstName'],
      lastName: json['lastName'],
      requirement: json['requirement'],
      countryCode: json['countryCode'] ?? '+91',
      phoneNumber: json['phoneNumber'],
      address: json['address'],
      email: json['email'],
      carpetArea: json['carpetArea'],
      sellableCarpetArea: json['sellableCarpetArea'],
      flatCost: json['flatCost'],
      closingManager: json['closingManager'] != null
          ? Employee.fromMap(json['closingManager'])
          : null,
      postSaleExecutive: json['postSaleExecutive'] != null
          ? Employee.fromMap(json['postSaleExecutive'])
          : null,
      closingManagerTeam: List<Employee>.from(json['closingManagerTeam'] ?? []),
      bookingStatus: json['bookingStatus'] != null
          ? BookingStatus.fromMap(json['bookingStatus'])
          : null,
      // applicants: [],
      applicants: (json['applicants'] as List<dynamic>?)
              ?.map((e) => Applicant.fromMap(e))
              .toList() ??
          [],

      preRegistrationCheckList:
          PreRegistrationChecklist.fromJson(json['preRegistrationCheckList']),
      disbursementRecord: (json['disbursementRecord'] as List<dynamic>?)
              ?.map((e) => DisbursementRecord.fromJson(e))
              .toList() ??
          [],
    );
  }

  int? get revenue => null;

  int? get contactedCount => null;

  int? get assignedCount => null;

  int? get totalItems => null;

  int? get registrationDone => null;

  int? get eoiRecieved => null;

  int? get cancelled => null;

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'unitNo': unitNo,
      'floor': floor,
      'number': number,
      'project': project?.toJson(),
      'date': date,
      'firstName': firstName,
      'lastName': lastName,
      'requirement': requirement,
      'countryCode': countryCode,
      'phoneNumber': phoneNumber,
      'address': address,
      'email': email,
      'carpetArea': carpetArea,
      'sellableCarpetArea': sellableCarpetArea,
      'flatCost': flatCost,
      'closingManager': closingManager?.toMap(),
      'postSaleExecutive': postSaleExecutive?.toMap(),
      'applicants': applicants.map((e) => e.toMap()).toList(),
      'closingManagerTeam': closingManagerTeam.map((e) => e.toMap()).toList(),
      'bookingStatus': bookingStatus?.toMap,
    };
  }
}

class BookingStatus {
  final String? type;
  final String? account;
  final String? amount;

  BookingStatus({
    this.type,
    this.account,
    this.amount,
  });

  Map<String, dynamic> toMap() {
    return {
      'type': type,
      'account': account,
      'amount': amount,
    };
  }

  factory BookingStatus.fromMap(Map<String, dynamic> map) {
    return BookingStatus(
      type: map['type'],
      account: map['account'],
      amount: map['amount'],
    );
  }

  String toJson() => json.encode(toMap());

  factory BookingStatus.fromJson(String source) =>
      BookingStatus.fromMap(json.decode(source) as Map<String, dynamic>);
}
