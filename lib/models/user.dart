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
  final List<String> taughtSubjectIds;
  final List<String> assignedClassIds;
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
      role: UserRole.values.firstWhere(
        (e) => e.toString() == 'UserRole.${map['role']}',
        orElse: () => UserRole.student,
      ),
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

  // ============ PROPRIETES CALCULEES ============
  String get fullName => '$firstName $lastName';

  bool get isTeacher => role == UserRole.teacher;
  bool get isStudent => role == UserRole.student;
  bool get isAdmin => role == UserRole.admin;

  // Formatage pour l'affichage
  String get roleDisplay {
    switch (role) {
      case UserRole.admin:
        return 'Administrateur';
      case UserRole.teacher:
        return 'Enseignant';
      case UserRole.student:
        return 'Étudiant';
    }
  }

  String get departmentDisplay => department ?? 'Non spécifié';
  String get statusDisplay => isActive ? 'Actif' : 'Inactif';

  // ============ METHODES D'AFFICHAGE ============
  List<String> get subjectsDisplay => taughtSubjectIds.map((id) => 'Matière $id').toList();
  List<String> get classesDisplay => assignedClassIds.map((id) => 'Classe $id').toList();

  int get yearsOfExperience {
    final now = DateTime.now();
    return now.difference(createdAt).inDays ~/ 365;
  }

  // ============ METHODES METIERS ============
  bool teachesSubject(String subjectId) => isTeacher && taughtSubjectIds.contains(subjectId);
  bool isAssignedToClass(String classId) => isTeacher && assignedClassIds.contains(classId);

  bool canGradeStudentForSubject(String subjectId, String classId) {
    return isTeacher && teachesSubject(subjectId) && isAssignedToClass(classId);
  }

  bool canCreateUsers() {
    return isAdmin && (isSuperAdmin || adminPermissions.contains('create_users'));
  }

  bool canVerifyAdminActions() {
    return isAdmin && (isSuperAdmin || adminPermissions.contains('verify_actions'));
  }

  // ============ METHODES UTILITAIRES ============
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

  Map<String, dynamic> toAdminLog() {
    return {
      'adminId': id,
      'adminName': fullName,
      'lastAction': DateTime.now().toIso8601String(),
      'permissions': adminPermissions,
      'createdBy': createdBy,
    };
  }

  // ============ METHODES DE COMPARAISON ============
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is UserModel &&
          runtimeType == other.runtimeType &&
          id == other.id;

  @override
  int get hashCode => id.hashCode;

  @override
  String toString() {
    return 'UserModel{id: $id, fullName: $fullName, role: $role, email: $email}';
  }
}