import 'package:flutter/foundation.dart';

class Attendance {
  final String? id;
  final String userId;
  final int day;
  final int month;
  final int year;
  final String status;
  final DateTime? checkInTime;
  final double? checkInLatitude;
  final double? checkInLongitude;
  final String? checkInPhoto;
  final DateTime? checkOutTime;
  final double? checkOutLatitude;
  final double? checkOutLongitude;
  final String? checkOutPhoto;
  final int totalActiveSeconds;
  final int totalBreakSeconds;
  final int overtimeSeconds;
  final DateTime? breakStartTime;
  final DateTime? breakEndTime;
  final List<AttendanceTimeline> timeline;

  Attendance({
    this.id,
    required this.userId,
    required this.day,
    required this.month,
    required this.year,
    required this.status,
    this.checkInTime,
    this.checkInLatitude,
    this.checkInLongitude,
    this.checkInPhoto,
    this.checkOutTime,
    this.checkOutLatitude,
    this.checkOutLongitude,
    this.checkOutPhoto,
    this.totalActiveSeconds = 0,
    this.totalBreakSeconds = 0,
    this.overtimeSeconds = 0,
    this.breakStartTime,
    this.breakEndTime,
    this.timeline = const [],
  });

  factory Attendance.fromJson(Map<String, dynamic> json) {
    return Attendance(
      id: json['_id'],
      userId: json['userId'],
      day: json['day'],
      month: json['month'],
      year: json['year'],
      status: json['status'],
      checkInTime: json['checkInTime'] != null
          ? DateTime.parse(json['checkInTime'])
          : null,
      checkInLatitude: json['checkInLatitude']?.toDouble(),
      checkInLongitude: json['checkInLongitude']?.toDouble(),
      checkInPhoto: json['checkInPhoto'],
      checkOutTime: json['checkOutTime'] != null
          ? DateTime.parse(json['checkOutTime'])
          : null,
      checkOutLatitude: json['checkOutLatitude']?.toDouble(),
      checkOutLongitude: json['checkOutLongitude']?.toDouble(),
      checkOutPhoto: json['checkOutPhoto'],
      totalActiveSeconds: json['totalActiveSeconds'] ?? 0,
      totalBreakSeconds: json['totalBreakSeconds'] ?? 0,
      overtimeSeconds: json['overtimeSeconds'] ?? 0,
      breakStartTime: json['breakStartTime'] != null
          ? DateTime.parse(json['breakStartTime'])
          : null,
      breakEndTime: json['breakEndTime'] != null
          ? DateTime.parse(json['breakEndTime'])
          : null,
      timeline: (json['timeline'] as List<dynamic>?)
              ?.map((e) => AttendanceTimeline.fromJson(e))
              .toList() ??
          [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'userId': userId,
      'day': day,
      'month': month,
      'year': year,
      'status': status,
      'checkInTime': checkInTime?.toIso8601String(),
      'checkInLatitude': checkInLatitude,
      'checkInLongitude': checkInLongitude,
      'checkInPhoto': checkInPhoto,
      'checkOutTime': checkOutTime?.toIso8601String(),
      'checkOutLatitude': checkOutLatitude,
      'checkOutLongitude': checkOutLongitude,
      'checkOutPhoto': checkOutPhoto,
      'totalActiveSeconds': totalActiveSeconds,
      'totalBreakSeconds': totalBreakSeconds,
      'overtimeSeconds': overtimeSeconds,
      'breakStartTime': breakStartTime?.toIso8601String(),
      'breakEndTime': breakEndTime?.toIso8601String(),
      'timeline': timeline.map((e) => e.toJson()).toList(),
    };
  }
}

class AttendanceTimeline {
  final String event;
  final DateTime timestamp;
  final int? durationSeconds;
  final String? remark;
  final String? photo;
  final double? latitude;
  final double? longitude;

  AttendanceTimeline({
    required this.event,
    required this.timestamp,
    this.durationSeconds,
    this.remark,
    this.photo,
    this.latitude,
    this.longitude,
  });

  factory AttendanceTimeline.fromJson(Map<String, dynamic> json) {
    return AttendanceTimeline(
      event: json['event'],
      timestamp: DateTime.parse(json['timestamp']),
      durationSeconds: json['durationSeconds'],
      remark: json['remark'],
      photo: json['photo'],
      latitude: json['latitude']?.toDouble(),
      longitude: json['longitude']?.toDouble(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'event': event,
      'timestamp': timestamp.toIso8601String(),
      'durationSeconds': durationSeconds,
      'remark': remark,
      'photo': photo,
      'latitude': latitude,
      'longitude': longitude,
    };
  }
}
