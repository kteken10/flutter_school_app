enum ExamSessionType { controleContinu, sessionNormale }

class ExamSession {
  final String id;
  final String name;
  final ExamSessionType type;
  final DateTime startDate;
  final DateTime endDate;
  final DateTime registrationDeadline;
  final String academicYearId;
  final bool resultsPublished;
  final bool isActive;

  ExamSession({
    required this.id,
    required this.name,
    required this.type,
    required this.startDate,
    required this.endDate,
    required this.registrationDeadline,
    required this.academicYearId,
    this.resultsPublished = false,
    this.isActive = true,
  });

  String get typeName {
    return type == ExamSessionType.controleContinu
        ? 'Contrôle Continu'
        : 'Session Normale';
  }

  factory ExamSession.fromMap(Map<String, dynamic> map) {
    return ExamSession(
      id: map['id'],
      name: map['name'],
      type: ExamSessionType.values.byName(map['type']),
      startDate: DateTime.parse(map['startDate']),
      endDate: DateTime.parse(map['endDate']),
      registrationDeadline: DateTime.parse(map['registrationDeadline']),
      academicYearId: map['academicYearId'],
      resultsPublished: map['resultsPublished'] ?? false,
      isActive: map['isActive'] ?? true,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'type': type.name,
      'startDate': startDate.toIso8601String(),
      'endDate': endDate.toIso8601String(),
      'registrationDeadline': registrationDeadline.toIso8601String(),
      'academicYearId': academicYearId,
      'resultsPublished': resultsPublished,
      'isActive': isActive,
    };
  }
}

class AcademicSession {
  final String id;
  final String name; // ex: "2023-2024"
  final DateTime startDate;
  final DateTime endDate;
  final ExamSessionType type; // <-- Ajouté ici
  final bool isCurrent;
  final List<String> examSessionIds;

  AcademicSession({
    required this.id,
    required this.name,
    required this.startDate,
    required this.endDate,
    required this.type, // <-- Correction ici
    required this.isCurrent,
    this.examSessionIds = const [],
  });

  String get shortName {
    final years = name.split('-');
    if (years.length != 2) return name;
    return '${years[0].substring(2)}-${years[1].substring(2)}';
  }

  factory AcademicSession.fromMap(Map<String, dynamic> map) {
    return AcademicSession(
      id: map['id'],
      name: map['name'],
      startDate: DateTime.parse(map['startDate']),
      endDate: DateTime.parse(map['endDate']),
      type: ExamSessionType.values.byName(map['type']),
      isCurrent: map['isCurrent'] ?? false,
      examSessionIds: List<String>.from(map['examSessionIds'] ?? []),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'startDate': startDate.toIso8601String(),
      'endDate': endDate.toIso8601String(),
      'type': type.name,
      'isCurrent': isCurrent,
      'examSessionIds': examSessionIds,
    };
  }
}
