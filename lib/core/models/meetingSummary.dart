import 'dart:convert';

import 'package:ev_homes/core/models/customer.dart';

class MeetingSummary {
  final String date;
  final String place;
  final String purpose;
  final Customer? customer;

  MeetingSummary(
      {required this.date,
      required this.place,
      required this.purpose,
      this.customer});

  factory MeetingSummary.fromMap(Map<String, dynamic> map) {
    return MeetingSummary(
      date: map["date"],
      place: map['place'],
      purpose: map['purpose'],
      customer:
          map['customer'] != null ? Customer.fromMap(map['customer']) : null,
    );
  }
  Map<String, dynamic> toMap() {
    return {
      "date": date,
      "place": place,
      "purpose": purpose,
      "customer": customer?.toMap(),
    };
  }
}
