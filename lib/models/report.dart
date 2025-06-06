class Report {
  final String id;
  final String sessionId;
  final String subjectId;
  final String teacherId;
  final DateTime generationDate;
  final String fileUrl;
  final bool isApproved;

  Report({
    required this.id,
    required this.sessionId,
    required this.subjectId,
    required this.teacherId,
    required this.generationDate,
    required this.fileUrl,
    required this.isApproved,
  });

  factory Report.fromMap(Map<String, dynamic> map) {
    return Report(
      id: map['id'],
      sessionId: map['sessionId'],
      subjectId: map['subjectId'],
      teacherId: map['teacherId'],
      generationDate: DateTime.parse(map['generationDate']),
      fileUrl: map['fileUrl'],
      isApproved: map['isApproved'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'sessionId': sessionId,
      'subjectId': subjectId,
      'teacherId': teacherId,
      'generationDate': generationDate.toIso8601String(),
      'fileUrl': fileUrl,
      'isApproved': isApproved,
    };
  }
}