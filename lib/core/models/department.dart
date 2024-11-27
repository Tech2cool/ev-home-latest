class Department {
  final String department;
  final String id;

  Department({required this.department, required this.id});

  Map<String, dynamic> toMap() {
    return {
      "department": department,
      "id": id,
    };
  }

  factory Department.fromMap(Map<String, dynamic> map) {
    return Department(
      department: map["department"],
      id: map["_id"],
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is Department && other.department == department;
  }
  // String toJson() => json.encode(toMap());

  // factory DepartmentModel.fromJson(String source) =>
  //     DepartmentModel.fromMap(json.decode(source) as Map<String, dynamic>);
}
