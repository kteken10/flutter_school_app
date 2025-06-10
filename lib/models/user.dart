enum UserRole { admin, teacher, student }

class UserModel {
  final String id;
  final String firstName;
  final String lastName;
  final String email;
  final UserRole role;
  final String? studentId;
  final String? teacherId;
  final String? department;
  final String? className;
  final List<String> taughtSubjectIds; // Nouveau: Liste des IDs des matières enseignées
  final List<String> assignedClassIds; // Nouveau: Liste des IDs des classes assignées
  final String? photoUrl;
  final DateTime createdAt;
  final bool isSuperAdmin;
  final List<String> adminPermissions;
  final DateTime? lastAdminAction;
  final bool isActive;
  final String? createdBy;

  UserModel({
    required this.id,
    required this.firstName,
    required this.lastName,
    required this.email,
    required this.role,
    this.studentId,
    this.teacherId,
    this.department,
    this.className,
    this.taughtSubjectIds = const [],
    this.assignedClassIds = const [],
    this.photoUrl,
    required this.createdAt,
    this.isSuperAdmin = false,
    this.adminPermissions = const [],
    this.lastAdminAction,
    this.isActive = true,
    this.createdBy,
  });

  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      id: map['id'],
      firstName: map['firstName'],
      lastName: map['lastName'],
      email: map['email'],
      role: UserRole.values.firstWhere((e) => e.toString() == 'UserRole.${map['role']}'),
      studentId: map['studentId'],
      teacherId: map['teacherId'],
      department: map['department'],
      className: map['className'],
      taughtSubjectIds: List<String>.from(map['taughtSubjectIds'] ?? []),
      assignedClassIds: List<String>.from(map['assignedClassIds'] ?? []),
      photoUrl: map['photoUrl'],
      createdAt: DateTime.parse(map['createdAt']),
      isSuperAdmin: map['isSuperAdmin'] ?? false,
      adminPermissions: List<String>.from(map['adminPermissions'] ?? []),
      lastAdminAction: map['lastAdminAction'] != null 
          ? DateTime.parse(map['lastAdminAction']) 
          : null,
      isActive: map['isActive'] ?? true,
      createdBy: map['createdBy'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'firstName': firstName,
      'lastName': lastName,
      'email': email,
      'role': role.toString().split('.').last,
      'studentId': studentId,
      'teacherId': teacherId,
      'department': department,
      'className': className,
      'taughtSubjectIds': taughtSubjectIds,
      'assignedClassIds': assignedClassIds,
      'photoUrl': photoUrl,
      'createdAt': createdAt.toIso8601String(),
      'isSuperAdmin': isSuperAdmin,
      'adminPermissions': adminPermissions,
      'lastAdminAction': lastAdminAction?.toIso8601String(),
      'isActive': isActive,
      'createdBy': createdBy,
    };
  }

  String get fullName => '$firstName $lastName';

  // ============ NOUVELLES METHODES ============

  /// Vérifie si l'utilisateur est un enseignant
  bool get isTeacher => role == UserRole.teacher;

  /// Vérifie si l'utilisateur est un étudiant
  bool get isStudent => role == UserRole.student;

  /// Vérifie si l'enseignant dispense une matière spécifique
  bool teachesSubject(String subjectId) {
    return isTeacher && taughtSubjectIds.contains(subjectId);
  }

  /// Vérifie si l'enseignant est assigné à une classe spécifique
  bool isAssignedToClass(String classId) {
    return isTeacher && assignedClassIds.contains(classId);
  }

  /// Vérifie si l'enseignant peut noter un étudiant dans une matière
  bool canGradeStudentForSubject(String subjectId, String classId) {
    return isTeacher && 
           teachesSubject(subjectId) && 
           isAssignedToClass(classId);
  }

  // ============ METHODES ADMIN ============

  bool canCreateUsers() {
    return role == UserRole.admin && 
           (isSuperAdmin || adminPermissions.contains('create_users'));
  }

  bool canVerifyAdminActions() {
    return role == UserRole.admin && 
           (isSuperAdmin || adminPermissions.contains('verify_actions'));
  }

  Map<String, dynamic> toAdminLog() {
    return {
      'adminId': id,
      'adminName': fullName,
      'lastAction': DateTime.now().toIso8601String(),
      'permissions': adminPermissions,
      'createdBy': createdBy,
    };
  }

  // ============ METHODES UTILITAIRES ============

  /// Retourne les informations essentielles pour le frontend
  Map<String, dynamic> toCompactMap() {
    return {
      'id': id,
      'fullName': fullName,
      'email': email,
      'role': role.toString().split('.').last,
      'className': className,
      'photoUrl': photoUrl,
      if (isTeacher) 'taughtSubjects': taughtSubjectIds,
      if (isTeacher) 'assignedClasses': assignedClassIds,
    };
  }
}