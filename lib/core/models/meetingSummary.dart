import 'dart:convert';

import 'package:ev_homes/core/models/customer.dart';
import 'package:ev_homes/core/models/division.dart';
import 'package:ev_homes/core/models/employee.dart';
import 'package:ev_homes/core/models/lead.dart';
import 'package:ev_homes/core/models/our_project.dart';
import 'package:ev_homes/core/models/post_sale_lead.dart';

class MeetingSummary {
  final DateTime? date;
  final Division? place;
  final String? purpose;
  final Customer? customer;
  final OurProject? project;
  final Employee? meetingWith;
  final String? summary;
  final DateTime? meetingEnd;
  final Lead? lead;
  final PostSaleLead? postSaleBooking;

  MeetingSummary(
      {required this.date,
      this.place,
      this.purpose,
      this.customer,
      this.project,
      this.meetingWith,
      this.summary,
      this.meetingEnd,
      this.lead,
      this.postSaleBooking});

  factory MeetingSummary.fromMap(Map<String, dynamic> map) {
    return MeetingSummary(
      date: map["date"],
      purpose: map['purpose'],
      summary: map['summary'],
      meetingEnd: map['meetingEnd'],
      place: map['place'] != null ? Division.fromMap(map['place']) : null,
      customer:
          map['customer'] != null ? Customer.fromMap(map['customer']) : null,
      project:
          map['project'] != null ? OurProject.fromJson(map['project']) : null,
      meetingWith: map['meetingWith'] != null
          ? Employee.fromMap(map['meetingWith'])
          : null,
      lead: map['lead'] != null ? Lead.fromJson(map['lead']) : null,
      postSaleBooking: map['postSaleBooking'] != null
          ? PostSaleLead.fromJson(map['postSaleBooking'])
          : null,
    );
  }
  Map<String, dynamic> toMap() {
    return {
      "date": date?.toIso8601String(),
      "place": place?.id,
      "purpose": purpose,
      "customer": customer?.id,
      "project": project?.id,
      "summary": summary,
      "meetingWith": meetingWith?.id,
      "meetingEnd": meetingEnd?.toIso8601String(),
      "lead": lead?.id,
      "postSaleBooking": postSaleBooking?.id
    };
  }
}
