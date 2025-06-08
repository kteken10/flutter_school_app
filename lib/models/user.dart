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
  final String? photoUrl;
  final DateTime createdAt;
  final bool isSuperAdmin;
  final List<String> adminPermissions;
  final DateTime? lastAdminAction;
  final bool isActive; // Nouveau champ ajouté
  final String? createdBy; // Nouveau champ ajouté

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
    this.photoUrl,
    required this.createdAt,
    this.isSuperAdmin = false,
    this.adminPermissions = const [],
    this.lastAdminAction,
    this.isActive = true, // Valeur par défaut
    this.createdBy, // Peut être null pour les comptes créés sans admin
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
      photoUrl: map['photoUrl'],
      createdAt: DateTime.parse(map['createdAt']),
      isSuperAdmin: map['isSuperAdmin'] ?? false,
      adminPermissions: List<String>.from(map['adminPermissions'] ?? []),
      lastAdminAction: map['lastAdminAction'] != null 
          ? DateTime.parse(map['lastAdminAction']) 
          : null,
      isActive: map['isActive'] ?? true, // Lecture avec valeur par défaut
      createdBy: map['createdBy'], // Lecture du champ créé par
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
      'photoUrl': photoUrl,
      'createdAt': createdAt.toIso8601String(),
      'isSuperAdmin': isSuperAdmin,
      'adminPermissions': adminPermissions,
      'lastAdminAction': lastAdminAction?.toIso8601String(),
      'isActive': isActive, // Ajout au mapping
      'createdBy': createdBy, // Ajout au mapping
    };
  }

  String get fullName => '$firstName $lastName';

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
      'createdBy': createdBy, // Ajout pour le tracking
    };
  }
}