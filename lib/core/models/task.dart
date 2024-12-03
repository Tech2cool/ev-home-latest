class Task {
  final String? id;
  final String? assignTo;
  final String? assignBy;
  final String? lead;
  final String? visit;
  final String? booking;
  final String? name;
  final String? details;
  final String? type;
  final bool completed;
  final DateTime? completedDate;

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
  });

  // Factory constructor for creating a Task object from JSON
  factory Task.fromMap(Map<String, dynamic> json) {
    return Task(
      assignTo: json['assignTo'],
      assignBy: json['assignBy'],
      lead: json['lead'],
      visit: json['visit'],
      booking: json['booking'],
      name: json['name'],
      details: json['details'],
      type: json['type'],
      completed: json['completed'] ?? false,
      completedDate: json['completedDate'] != null
          ? DateTime.parse(json['completedDate'])
          : null,
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
