class TeacherAssignment {
  final String id;
  final String teacherId;
  final String classId;
  final List<String> subjectIds;
  final String academicYearId;

  TeacherAssignment({
    required this.id,
    required this.teacherId,
    required this.classId,
    required this.subjectIds,
    required this.academicYearId,
  });

  factory TeacherAssignment.fromMap(Map<String, dynamic> map) {
    return TeacherAssignment(
      id: map['id'],
      teacherId: map['teacherId'],
      classId: map['classId'],
      subjectIds: List<String>.from(map['subjectIds']),
      academicYearId: map['academicYearId'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'teacherId': teacherId,
      'classId': classId,
      'subjectIds': subjectIds,
      'academicYearId': academicYearId,
    };
  }

  bool teachesSubject(String subjectId) {
    return subjectIds.contains(subjectId);
  }
}