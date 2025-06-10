import 'package:schoop_app/models/session.dart';

enum GradeStatus { graded, absent, excused, pending ,published }

class Grade {
  final String id;
  final String studentId;
  final String subjectId;
  final String sessionId;
  final ExamSessionType sessionType;
  final double? value; // Nullable pour gérer les absences
  final GradeStatus status;
  final String? comment;
  final String teacherId;
  final DateTime dateRecorded;
  final String classId; // Nouveau: Classe de l'étudiant

  Grade({
    required this.id,
    required this.studentId,
    required this.subjectId,
    required this.sessionId,
    required this.sessionType,
    this.value,
    required this.status,
    this.comment,
    required this.teacherId,
    required this.dateRecorded,
    required this.classId,
  }) : assert(
          (status == GradeStatus.graded && value != null) || 
          (status != GradeStatus.graded && value == null),
          'Grade must have value when status is graded'
        );

  factory Grade.fromMap(Map<String, dynamic> map) {
    return Grade(
      id: map['id'],
      studentId: map['studentId'],
      subjectId: map['subjectId'],
      sessionId: map['sessionId'],
      sessionType: ExamSessionType.values.byName(map['sessionType']),
      value: map['value']?.toDouble(),
      status: GradeStatus.values.byName(map['status']),
      comment: map['comment'],
      teacherId: map['teacherId'],
      dateRecorded: DateTime.parse(map['dateRecorded']),
      classId: map['classId'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'studentId': studentId,
      'subjectId': subjectId,
      'sessionId': sessionId,
      'sessionType': sessionType.name,
      'value': value,
      'status': status.name,
      'comment': comment,
      'teacherId': teacherId,
      'dateRecorded': dateRecorded.toIso8601String(),
      'classId': classId,
    };
  }

  // Helper methods
  String get formattedValue {
    return status == GradeStatus.graded 
        ? value!.toStringAsFixed(2)
        : status == GradeStatus.absent
          ? 'Absent'
          : 'Excusé';
  }

  bool get isValidForTeacher {
    return status == GradeStatus.graded && value != null && value! >= 0 && value! <= 20;
  }
}