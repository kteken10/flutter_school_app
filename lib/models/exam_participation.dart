import 'session.dart';

class ExamParticipation {
  final String id;
  final String studentId;
  final String subjectId;
  final String sessionId;
  final ExamSessionType sessionType;
  final String academicYearId;
  final DateTime participationDate;
  final bool isApproved;

  ExamParticipation({
    required this.id,
    required this.studentId,
    required this.subjectId,
    required this.sessionId,
    required this.sessionType,
    required this.academicYearId,
    required this.participationDate,
    this.isApproved = true,
  });

  factory ExamParticipation.fromMap(Map<String, dynamic> map) {
    return ExamParticipation(
      id: map['id'],
      studentId: map['studentId'],
      subjectId: map['subjectId'],
      sessionId: map['sessionId'],
      sessionType: ExamSessionType.values.byName(map['sessionType']),
      academicYearId: map['academicYearId'],
      participationDate: DateTime.parse(map['participationDate']),
      isApproved: map['isApproved'] ?? true,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'studentId': studentId,
      'subjectId': subjectId,
      'sessionId': sessionId,
      'sessionType': sessionType.name,
      'academicYearId': academicYearId,
      'participationDate': participationDate.toIso8601String(),
      'isApproved': isApproved,
    };
  }
}