class Subject {
  final String id;
  final String name;
  final String code;
  final String department;
  final int credit;
  final String? teacherId;

  Subject({
    required this.id,
    required this.name,
    required this.code,
    required this.department,
    required this.credit,
    this.teacherId,
  });

  factory Subject.fromMap(Map<String, dynamic> map) {
    return Subject(
      id: map['id'],
      name: map['name'],
      code: map['code'],
      department: map['department'],
      credit: map['credit'],
      teacherId: map['teacherId'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'code': code,
      'department': department,
      'credit': credit,
      'teacherId': teacherId,
    };
  }
}