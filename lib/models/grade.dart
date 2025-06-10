import 'package:schoop_app/models/session.dart';

class Grade {
  final String id;
  final String studentId;
  final String subjectId;
  final String sessionId;
  final ExamSessionType sessionType;
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
    required this.sessionType,
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
      sessionType: ExamSessionType.values.byName(map['sessionType']),
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
      'sessionType': sessionType.name,
      'value': value,
      'comment': comment,
      'teacherId': teacherId,
      'dateRecorded': dateRecorded.toIso8601String(),
      'isFinal': isFinal,
      
    };
  }
}
