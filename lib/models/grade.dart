class Grade {
  final String id;
  final String studentId;
  final String subjectId;
  final String sessionId;
  final double value;
  final String? comment;
  final String teacherId;
  final DateTime dateRecorded;
  final bool isFinal;

  Grade({
    required this.id,
    required this.studentId,
    required this.subjectId,
    required this.sessionId,
    required this.value,
    this.comment,
    required this.teacherId,
    required this.dateRecorded,
    required this.isFinal,
  });

  factory Grade.fromMap(Map<String, dynamic> map) {
    return Grade(
      id: map['id'],
      studentId: map['studentId'],
      subjectId: map['subjectId'],
      sessionId: map['sessionId'],
      value: map['value'].toDouble(),
      comment: map['comment'],
      teacherId: map['teacherId'],
      dateRecorded: DateTime.parse(map['dateRecorded']),
      isFinal: map['isFinal'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'studentId': studentId,
      'subjectId': subjectId,
      'sessionId': sessionId,
      'value': value,
      'comment': comment,
      'teacherId': teacherId,
      'dateRecorded': dateRecorded.toIso8601String(),
      'isFinal': isFinal,
    };
  }
}