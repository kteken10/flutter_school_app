import 'package:schoop_app/models/session.dart';

enum GradeStatus { graded, absent, excused, pending, published }

class Grade {
  final String id;
  final String studentId;
  final String subjectId;
  final String sessionId;
  final ExamSessionType sessionType;
  final double? value;
  final GradeStatus status;
  final String? comment;
  final String teacherId;
  final DateTime dateRecorded;
  final String classId;
  final String subjectImagePath; // Nouveau: Chemin de l'image de la matière

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
    required this.subjectImagePath, // Nouveau paramètre obligatoire
  }) : assert(
          ((status == GradeStatus.graded || status == GradeStatus.published) && value != null) ||
          (!(status == GradeStatus.graded || status == GradeStatus.published) && value == null),
          'Grade must have value when status is graded or published'
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
      subjectImagePath: map['subjectImagePath'] ?? 'assets/subjects/default.png', // Valeur par défaut
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
      'subjectImagePath': subjectImagePath, // Inclus dans la sérialisation
    };
  }

  // Formatage amélioré avec emoji pour plus de clarté
  String get formattedValue {
    switch (status) {
      case GradeStatus.graded:
      case GradeStatus.published:
        return value != null ? '${value!.toStringAsFixed(1)}/20' : '–';
      case GradeStatus.absent:
        return '🚫 Absent';
      case GradeStatus.excused:
        return '⚠️ Excusé';
      case GradeStatus.pending:
        return '⏳ En attente';
    }
  }

 

  // Texte abrégé pour l'affichage compact
  String get shortStatus {
    switch (status) {
      case GradeStatus.graded:
        return 'OK';
      case GradeStatus.published:
        return 'PUB';
      case GradeStatus.absent:
        return 'ABS';
      case GradeStatus.excused:
        return 'EXC';
      case GradeStatus.pending:
        return 'PEN';
    }
  }

  // Type de session abrégé
  String get shortSessionType {
    return sessionType == ExamSessionType.controleContinu ? 'CC' : 'EX';
  }

  bool get isValidForTeacher {
    return status == GradeStatus.graded && 
           value != null && 
           value! >= 0 && 
           value! <= 20;
  }
}