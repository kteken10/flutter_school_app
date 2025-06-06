class AcademicSession {
  final String id;
  final String name;
  final DateTime startDate;
  final DateTime endDate;
  final bool isCurrent;

  AcademicSession({
    required this.id,
    required this.name,
    required this.startDate,
    required this.endDate,
    required this.isCurrent,
  });

  factory AcademicSession.fromMap(Map<String, dynamic> map) {
    return AcademicSession(
      id: map['id'],
      name: map['name'],
      startDate: DateTime.parse(map['startDate']),
      endDate: DateTime.parse(map['endDate']),
      isCurrent: map['isCurrent'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'startDate': startDate.toIso8601String(),
      'endDate': endDate.toIso8601String(),
      'isCurrent': isCurrent,
    };
  }
}