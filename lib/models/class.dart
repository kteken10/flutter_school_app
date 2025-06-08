class ClasseModel {
  final String id;
  final String name;
  final String department;
  final DateTime createdAt;

  ClasseModel({
    required this.id,
    required this.name,
    required this.department,
    required this.createdAt,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'department': department,
      'createdAt': createdAt.toIso8601String(),
    };
  }

  factory ClasseModel.fromMap(Map<String, dynamic> map) {
    return ClasseModel(
      id: map['id'],
      name: map['name'],
      department: map['department'],
      createdAt: DateTime.parse(map['createdAt']),
    );
  }
}
