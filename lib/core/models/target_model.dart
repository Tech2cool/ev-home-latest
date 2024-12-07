class Target {
  final String id;
  final String staffId;
  final int target;
  final int achieved;
  final int extraAchieved;
  final int carryForward;
  final int month;
  final int year;
  final bool previousCarryForwardUsed;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  Target({
    required this.id,
    required this.staffId,
    required this.target,
    required this.achieved,
    this.extraAchieved = 0,
    this.carryForward = 0,
    required this.month,
    required this.year,
    this.previousCarryForwardUsed = false,
    this.createdAt,
    this.updatedAt,
  });

  // Deserialize from JSON
  factory Target.fromMap(Map<String, dynamic> json) {
    return Target(
      id: json['_id'],
      staffId: json['staffId'],
      target: json['target'],
      achieved: json['achieved'],
      extraAchieved: json['extraAchieved'] ?? 0,
      carryForward: json['carryForward'] ?? 0,
      month: json['month'],
      year: json['year'],
      previousCarryForwardUsed: json['previousCarryForwardUsed'] ?? false,
      createdAt:
          json['createdAt'] != null ? DateTime.parse(json['createdAt']) : null,
      updatedAt:
          json['updatedAt'] != null ? DateTime.parse(json['updatedAt']) : null,
    );
  }

  // Serialize to JSON
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'staffId': staffId,
      'target': target,
      'achieved': achieved,
      'extraAchieved': extraAchieved,
      'carryForward': carryForward,
      'month': month,
      'year': year,
      'previousCarryForwardUsed': previousCarryForwardUsed,
      'createdAt': createdAt?.toIso8601String(),
      'updatedAt': updatedAt?.toIso8601String(),
    };
  }
}
