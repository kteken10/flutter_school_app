class Subject {
  final String id;
  final String name;
  final String code;
  final String department;
  final int credit;
  final List<String> teacherIds; // Modifié: Plusieurs enseignants possibles
  final List<String> classIds; // Nouveau: Classes concernées

  Subject({
    required this.id,
    required this.name,
    required this.code,
    required this.department,
    required this.credit,
    this.teacherIds = const [],
    this.classIds = const [],
  });

  factory Subject.fromMap(Map<String, dynamic> map) {
    return Subject(
      id: map['id'],
      name: map['name'],
      code: map['code'],
      department: map['department'],
      credit: map['credit'],
      teacherIds: List<String>.from(map['teacherIds'] ?? []),
      classIds: List<String>.from(map['classIds'] ?? []),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'code': code,
      'department': department,
      'credit': credit,
      'teacherIds': teacherIds,
      'classIds': classIds,
    };
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Subject && runtimeType == other.runtimeType && id == other.id;

  @override
  int get hashCode => id.hashCode;
}