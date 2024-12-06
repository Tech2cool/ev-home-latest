import 'dart:async';
import 'package:ev_homes/core/models/attendance.dart';
import 'package:ev_homes/core/services/api_service.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert'; // For JSON encoding/decoding

class AttendanceProvider with ChangeNotifier {
  final ApiService _apiService = ApiService();
  Attendance? _attendance;
  int activeSeconds = 0;
  int breakSeconds = 0;
  int meetingSeconds = 0;
  String status = 'not-present';
  Timer? _timer;

  List<AttendanceTimeline> timeline = [];
  Attendance? get attendance => _attendance;

  Duration get currentTimerDuration {
    if (status == 'present') {
      return Duration(seconds: activeSeconds);
    } else if (status == 'in-break') {
      return Duration(seconds: breakSeconds);
    } else if (status == 'in-meeting') {
      return Duration(seconds: meetingSeconds);
    }
    return Duration.zero;
  }

  void startTimer({
    required String event,
    String? remark,
    String? photo,
    double? latitude,
    double? longitude,
  }) {
    // Stop any existing timer
    _timer?.cancel();

    // Add event to the timeline
    timeline.add(
      AttendanceTimeline(
        event: event,
        timestamp: DateTime.now(),
        remark: remark,
        photo: photo,
        latitude: latitude,
        longitude: longitude,
      ),
    );

    // Update status based on event
    if (event == "check-in") {
      status = 'present';
    } else if (event == "break-start") {
      status = 'in-break';
    } else if (event == "meeting") {
      status = 'in-meeting';
    }

    // Start the timer
    _timer = Timer.periodic(Duration(seconds: 1), (_) {
      if (status == 'present') {
        activeSeconds++;
      } else if (status == 'in-break') {
        breakSeconds++;
      } else if (status == 'in-meeting') {
        meetingSeconds++;
      }
      notifyListeners();
    });
  }

  void stopTimer({
    required String event,
    String? remark,
    String? photo,
    double? latitude,
    double? longitude,
  }) {
    _timer?.cancel();

    // Update the last event with duration and optional fields
    if (timeline.isNotEmpty) {
      final lastEvent = timeline.last;
      if (lastEvent.durationSeconds == null) {
        lastEvent.durationSeconds =
            DateTime.now().difference(lastEvent.timestamp!).inSeconds;
        lastEvent.remark = remark;
        lastEvent.photo = photo;
        lastEvent.latitude = latitude;
        lastEvent.longitude = longitude;
      }
    }

    // Update status
    if (event == "check-out") {
      status = 'completed';
    } else if (event == "break-end") {
      status = 'present';
    }

    notifyListeners();
  }

  void resetTimer() {
    activeSeconds = 0;
    breakSeconds = 0;
    meetingSeconds = 0;
    status = 'not-present';
    _timer?.cancel();
    timeline.clear();
    notifyListeners();
  }

  Future<void> checkIn(Map<String, dynamic> data) async {
    print('pass 0');
    final resp = await _apiService.checkInAttendance(data);
    print('pass 1');
    if (resp == null) {
      notifyListeners();
      return;
    }
    print('pass 2');
    _attendance = resp;
    // status = resp.status;
    startTimer(
      event: 'check-in',
      latitude: data['checkInLatitude'],
      longitude: data['checkInLongitude'],
      photo: data['checkInPhoto'],
    );
    print('pass timer');
    notifyListeners();
  }

  Future<void> saveTimeline() async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setStringList(
      'timeline',
      timeline.map((e) => jsonEncode(e.toJson())).toList(),
    );
  }

  Future<void> loadTimeline() async {
    final prefs = await SharedPreferences.getInstance();
    final storedTimeline = prefs.getStringList('timeline');
    if (storedTimeline != null) {
      timeline = storedTimeline
          .map((e) => AttendanceTimeline.fromJson(jsonDecode(e)))
          .toList();
    }
    notifyListeners();
  }
}
