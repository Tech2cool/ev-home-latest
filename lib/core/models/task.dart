import 'package:ev_homes/core/models/employee.dart';
import 'package:ev_homes/core/models/lead.dart';

class Task {
  final String? id;
  final Employee? assignTo;
  final Employee? assignBy;
  final Lead? lead;
  final String? visit;
  final String? booking;
  final String? name;
  final String? details;
  final String? type;
  final bool completed;
  final DateTime? completedDate;
  final DateTime? deadline;

  Task({
    this.id,
    required this.assignTo,
    this.assignBy,
    this.lead,
    this.visit,
    this.booking,
    required this.name,
    required this.details,
    required this.type,
    this.completed = false,
    this.completedDate,
    this.deadline,
  });

  // Factory constructor for creating a Task object from JSON
  factory Task.fromMap(Map<String, dynamic> json) {
    return Task(
      id: json['_id'],
      assignTo:
          json['assignTo'] != null ? Employee.fromMap(json['assignTo']) : null,
      assignBy:
          json['assignBy'] != null ? Employee.fromMap(json['assignBy']) : null,
      lead: json['lead'] != null ? Lead.fromJson(json['lead']) : null,
      visit: json['visit'],
      booking: json['booking'],
      name: json['name'],
      details: json['details'],
      type: json['type'],
      completed: json['completed'] ?? false,
      completedDate: json['completedDate'] != null
          ? DateTime.parse(json['completedDate'])
          : null,
      deadline:
          json['deadline'] != null ? DateTime.parse(json['deadline']) : null,
    );
  }

  // Method for converting a Task object to JSON
  Map<String, dynamic> toMap() {
    return {
      'assignTo': assignTo,
      'assignBy': assignBy,
      'lead': lead,
      'visit': visit,
      'booking': booking,
      'name': name,
      'details': details,
      'type': type,
      'completed': completed,
      'completedDate': completedDate?.toIso8601String(),
    };
  }
}
