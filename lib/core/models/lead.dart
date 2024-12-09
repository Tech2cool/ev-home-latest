// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:ev_homes/core/models/channel_partner.dart';
import 'package:ev_homes/core/models/employee.dart';
import 'package:ev_homes/core/models/our_project.dart';
import 'package:ev_homes/core/models/post_sale_lead.dart';
import 'package:ev_homes/core/models/site_visit.dart';

class Lead {
  final String id;
  final String? email;
  final List<OurProject> project;
  final List<String> requirement;
  final String? firstName;
  final String? lastName;
  final String? address;
  final ChannelPartner? channelPartner;
  final Employee? dataAnalyzer;
  final Employee? teamLeader;
  final Employee? preSalesExecutive;
  final String? countryCode;
  final int? phoneNumber;
  final int? altPhoneNumber;
  final String? remark;
  final String? stage;
  final DateTime? startDate;
  final DateTime? validTill;
  final DateTime? approvalDate;
  final DateTime? previousValidTill;
  final String? status;

  final Cycle? cycle;
  final String? approvalStatus;
  final String? visitStatus;
  final String? revisitStatus;

  final String? bookingStatus;
  final String? interestedStatus;
  final SiteVisit? visitRef;
  final SiteVisit? revisitRef;
  final PostSaleLead? bookingRef;
  final List<CallHistory> callHistory;
  final List<ApprovalHistory> approvalHistory;
  final List<UpdateHistory> updateHistory;
  final List<Cycle> cycleHistory;
  final List<CallHistory> followupHistory;

  Lead({
    required this.id,
    required this.email,
    required this.project,
    required this.requirement,
    required this.firstName,
    required this.lastName,
    this.address,
    this.channelPartner,
    this.dataAnalyzer,
    this.teamLeader,
    this.preSalesExecutive,
    this.countryCode,
    required this.phoneNumber,
    this.altPhoneNumber,
    this.remark,
    this.stage,
    required this.startDate,
    this.approvalDate,
    required this.validTill,
    this.previousValidTill,
    this.status,
    this.bookingStatus,
    this.visitStatus,
    this.revisitStatus,
    this.cycle,
    this.approvalStatus,
    this.visitRef,
    this.revisitRef,
    this.bookingRef,
    this.interestedStatus,
    this.callHistory = const [],
    this.approvalHistory = const [],
    this.updateHistory = const [],
    this.cycleHistory = const [],
    this.followupHistory = const [],
  });

  factory Lead.fromJson(Map<String, dynamic> json) {
    return Lead(
      id: json['_id'],
      email: json['email'],
      project: (json['project'] as List<dynamic>?)
              ?.map((el) => OurProject?.fromJson(el))
              ?.toList() ??
          [],
      requirement: List<String>.from(json['requirement'] ?? []),
      firstName: json['firstName'],
      lastName: json['lastName'],
      address: json['address'],
      stage: json['stage'],
      channelPartner: json['channelPartner'] != null
          ? ChannelPartner.fromMap(json['channelPartner'])
          : null,
      dataAnalyzer: json['dataAnalyzer'] != null
          ? Employee.fromMap(json['dataAnalyzer'])
          : null,
      teamLeader: json['teamLeader'] != null
          ? Employee.fromMap(json['teamLeader'])
          : null,
      preSalesExecutive: json['preSalesExecutive'] != null
          ? Employee.fromMap(json['preSalesExecutive'])
          : null,
      countryCode: json['countryCode'],
      phoneNumber:
          json['phoneNumber'] != null ? json['phoneNumber']?.floor() : 0,
      altPhoneNumber: json['altPhoneNumber']?.floor() ?? 0,
      remark: json['remark'],
      startDate: json['startDate'] != null
          ? DateTime.parse(json['startDate'])
          : json['startDate'],
      approvalDate: json['approvalDate'] != null
          ? DateTime.parse(json['approvalDate'])
          : json['approvalDate'],
      validTill: json['validTill'] != null
          ? DateTime.parse(json['validTill'])
          : json['validTill'],
      previousValidTill: json['previousValidTill'] != null
          ? DateTime.parse(json['previousValidTill'])
          : null,
      cycle: json['cycle'] != null ? Cycle.fromMap(json['cycle']) : null,
      visitRef:
          (json['visitRef'] != null && json['visitRef'] is Map<String, dynamic>)
              ? SiteVisit.fromMap(json['visitRef'] as Map<String, dynamic>)
              : null,
      revisitRef: (json['revisitRef'] != null &&
              json['revisitRef'] is Map<String, dynamic>)
          ? SiteVisit.fromMap(json['revisitRef'] as Map<String, dynamic>)
          : null,
      bookingRef: (json['bookingRef'] != null &&
              json['bookingRef'] is Map<String, dynamic>)
          ? PostSaleLead.fromJson(json['bookingRef'] as Map<String, dynamic>)
          : null,
      status: json['status'],
      approvalStatus: json['approvalStatus'],
      visitStatus: json['visitStatus'],
      revisitStatus: json['revisitStatus'],
      bookingStatus: json['bookingStatus'],
      interestedStatus: json['interestedStatus'],
      callHistory: (json['callHistory'] as List)
          .map((item) => CallHistory.fromJson(item))
          .toList(),
      followupHistory: (json['followupHistory'] as List)
          .map((item) => CallHistory.fromJson(item))
          .toList(),
      approvalHistory: (json['approvalHistory'] as List)
          .map((item) => ApprovalHistory.fromJson(item))
          .toList(),
      updateHistory: (json['updateHistory'] as List)
          .map((item) => UpdateHistory.fromJson(item))
          .toList(),
      cycleHistory: (json['cycleHistory'] as List)
          .map((item) => Cycle.fromMap(item))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'email': email,
      'project': project.map((pro) => pro.id).toList(),
      'requirement': requirement,
      'firstName': firstName,
      'lastName': lastName,
      'address': address,
      'channelPartner': channelPartner,
      'dataAnalyzer': dataAnalyzer,
      'teamLeader': teamLeader,
      'preSalesExecutive': preSalesExecutive,
      'countryCode': countryCode,
      'phoneNumber': phoneNumber,
      'altPhoneNumber': altPhoneNumber,
      'remark': remark,
      'stage': stage,
      'startDate': startDate?.toIso8601String(),
      'validTill': validTill?.toIso8601String(),
      'previousValidTill': previousValidTill?.toIso8601String(),
      'status': status,
      'approvalStatus': approvalStatus,
      'visitStatus': visitStatus,
      'revisitStatus': revisitStatus,
      'bookingStatus': bookingStatus,
      'interestedStatus': interestedStatus,
      'callHistory': callHistory.map((item) => item.toJson()).toList(),
      'followupHistory': followupHistory.map((item) => item.toJson()).toList(),
      'approvalHistory': approvalHistory.map((item) => item.toJson()).toList(),
      'updateHistory': updateHistory.map((item) => item.toJson()).toList(),
      'cycleHistory': cycleHistory.map((item) => item.toMap()).toList(),
    };
  }
}

class CallHistory {
  final Employee? caller; // employee ID
  final DateTime? callDate;
  final String? stage;
  final String? status;
  final String? siteVisit;
  final String? remark;
  final String? feedback;
  final String? document;
  final String? recording;

  CallHistory({
    required this.caller,
    required this.callDate,
    required this.stage,
    required this.status,
    required this.siteVisit,
    this.remark,
    this.feedback,
    this.document,
    this.recording,
  });

  factory CallHistory.fromJson(Map<String, dynamic> json) {
    return CallHistory(
      caller: json['caller'] != null ? Employee.fromMap(json['caller']) : null,
      callDate:
          json['callDate'] != null ? DateTime.parse(json['callDate']) : null,
      remark: json['remark'],
      feedback: json['feedback'],
      document: json['document'],
      recording: json['recording'],
      stage: json['stage'],
      status: json['status'],
      siteVisit: json['siteVisit'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'caller': caller?.toMap(),
      'callDate': callDate,
      'remark': remark,
      'feedback': feedback,
      'document': document,
      'recording': recording,
      'stage': stage,
      'status': status,
      'siteVisit': siteVisit,
    };
  }
}

class ViewedBy {
  final Employee? employee;
  final DateTime? viewedAt;

  ViewedBy({
    required this.employee,
    required this.viewedAt,
  });

  factory ViewedBy.fromJson(Map<String, dynamic> json) {
    return ViewedBy(
      employee:
          json['employee'] != null ? Employee.fromMap(json['employee']) : null,
      viewedAt:
          json['viewedAt'] != null ? DateTime.parse(json['viewedAt']) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'employee': employee?.toMap(),
      'viewedAt': viewedAt,
    };
  }
}

class ApprovalHistory {
  final Employee? employee;
  final DateTime? approvedAt;
  final String? remark;

  ApprovalHistory({
    required this.employee,
    required this.approvedAt,
    this.remark,
  });

  factory ApprovalHistory.fromJson(Map<String, dynamic> json) {
    return ApprovalHistory(
      employee:
          json['employee'] != null ? Employee.fromMap(json['employee']) : null,
      approvedAt: json['approvedAt'] != null
          ? DateTime.parse(json['approvedAt'])
          : null,
      remark: json['remark'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'employee': employee?.toMap(),
      'approvedAt': approvedAt,
      'remark': remark,
    };
  }
}

class UpdateHistory {
  final Employee? employee;
  final DateTime? updatedAt;
  final String? changes;

  UpdateHistory({
    required this.employee,
    required this.updatedAt,
    required this.changes,
  });

  factory UpdateHistory.fromJson(Map<String, dynamic> json) {
    return UpdateHistory(
      employee:
          json['employee'] != null ? Employee.fromMap(json['employee']) : null,
      updatedAt:
          json['updatedAt'] != null ? DateTime.parse(json['updatedAt']) : null,
      changes: json['changes'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'employee': employee?.toMap(),
      'updatedAt': updatedAt,
      'changes': changes,
    };
  }
}

class ApprovalStage {
  final String? status;
  final DateTime? date;
  final String? remark;

  ApprovalStage({
    required this.status,
    required this.date,
    required this.remark,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'status': status,
      'date': date,
      'remark': remark,
    };
  }

  factory ApprovalStage.fromMap(Map<String, dynamic> map) {
    return ApprovalStage(
      status: map['status'],
      date: map['date'] != null ? DateTime.parse(map['date']) : null,
      remark: map['remark'],
    );
  }

  String toJson() => json.encode(toMap());

  factory ApprovalStage.fromJson(String source) => ApprovalStage.fromMap(
        json.decode(source) as Map<String, dynamic>,
      );
}

class Cycle {
  final String? stage;
  final int? currentOrder;
  final Employee? teamLeader;
  final DateTime? startDate;
  final DateTime? validTill;

  Cycle({
    required this.stage,
    required this.currentOrder,
    required this.teamLeader,
    required this.startDate,
    required this.validTill,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'stage': stage,
      'currentOrder': currentOrder,
      'teamLeader': teamLeader?.toMap(),
      'startDate': startDate?.toIso8601String(),
      'validTill': validTill?.toIso8601String(),
    };
  }

  factory Cycle.fromMap(Map<String, dynamic> map) {
    return Cycle(
      stage: map['stage'],
      currentOrder: map['currentOrder'],
      teamLeader: map['teamLeader'] != null
          ? Employee.fromMap(map['teamLeader'] as Map<String, dynamic>)
          : null,
      startDate:
          map['startDate'] != null ? DateTime.parse(map['startDate']) : null,
      validTill:
          map['validTill'] != null ? DateTime.parse(map['validTill']) : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory Cycle.fromJson(String source) => Cycle.fromMap(
        json.decode(source) as Map<String, dynamic>,
      );
}

class VisitStage {
  final String? status;
  final DateTime? date;
  final String? remark;
  final Employee? attendedBy;

  VisitStage({
    required this.status,
    required this.date,
    required this.remark,
    required this.attendedBy,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'status': status,
      'date': date,
      'remark': remark,
      "attendedBy": attendedBy?.toMap(),
    };
  }

  factory VisitStage.fromMap(Map<String, dynamic> map) {
    return VisitStage(
      status: map['status'],
      date: map['date'] != null ? DateTime.parse(map['date']) : null,
      attendedBy: map['attendedBy'] != null
          ? Employee.fromMap(map['attendedBy'])
          : null,
      remark: map['remark'],
    );
  }

  String toJson() => json.encode(toMap());

  factory VisitStage.fromJson(String source) => VisitStage.fromMap(
        json.decode(source) as Map<String, dynamic>,
      );
}

class RevisitStage {
  final String? status;
  final DateTime? date;
  final String? remark;
  final Employee? attendedBy;

  RevisitStage({
    required this.status,
    required this.date,
    required this.remark,
    required this.attendedBy,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'status': status,
      'date': date,
      'remark': remark,
      "attendedBy": attendedBy?.toMap(),
    };
  }

  factory RevisitStage.fromMap(Map<String, dynamic> map) {
    return RevisitStage(
      status: map['status'],
      date: map['date'] != null ? DateTime.parse(map['date']) : null,
      attendedBy: map['attendedBy'] != null
          ? Employee.fromMap(map['attendedBy'])
          : null,
      remark: map['remark'],
    );
  }

  String toJson() => json.encode(toMap());

  factory RevisitStage.fromJson(String source) => RevisitStage.fromMap(
        json.decode(source) as Map<String, dynamic>,
      );
}

class TaggingOverStage {
  final String? status;
  final DateTime? date;
  final String? remark;

  TaggingOverStage({
    required this.status,
    required this.date,
    required this.remark,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'status': status,
      'date': date,
      'remark': remark,
    };
  }

  factory TaggingOverStage.fromMap(Map<String, dynamic> map) {
    return TaggingOverStage(
      status: map['status'],
      date: map['date'] != null ? DateTime.parse(map['date']) : null,
      remark: map['remark'],
    );
  }

  String toJson() => json.encode(toMap());

  factory TaggingOverStage.fromJson(String source) => TaggingOverStage.fromMap(
        json.decode(source) as Map<String, dynamic>,
      );
}
