class ClasseModel {
  final String id;
  final String name;
  final String department;
  final List<String> subjectIds; // Nouveau: Matières de la classe
  final List<String> teacherIds; // Nouveau: Enseignants de la classe
  final DateTime createdAt;

  ClasseModel({
    required this.id,
    required this.name,
    required this.department,
    this.subjectIds = const [],
    this.teacherIds = const [],
    required this.createdAt,
  });

  factory ClasseModel.fromMap(Map<String, dynamic> map) {
    return ClasseModel(
      id: map['id'],
      name: map['name'],
      department: map['department'],
      subjectIds: List<String>.from(map['subjectIds'] ?? []),
      teacherIds: List<String>.from(map['teacherIds'] ?? []),
      createdAt: DateTime.parse(map['createdAt']),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'department': department,
      'subjectIds': subjectIds,
      'teacherIds': teacherIds,
      'createdAt': createdAt.toIso8601String(),
    };
  }

  // Helper method
  bool hasSubject(String subjectId) => subjectIds.contains(subjectId);
}