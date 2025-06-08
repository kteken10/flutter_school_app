enum UserRole { admin, teacher, student }

class UserModel {
  final String id;
  final String firstName;
  final String lastName;
  final String email;
  final UserRole role;
  final String? studentId; // Pour les étudiants
  final String? teacherId; // Nouveau champ pour les enseignants
  final String? department; // Pour les enseignants
  final String? className; // Pour la classe de l'étudiant
  final String? photoUrl; // Pour la photo de profil
  final DateTime createdAt;

  UserModel({
    required this.id,
    required this.firstName,
    required this.lastName,
    required this.email,
    required this.role,
    this.studentId,
    this.teacherId, // Nouveau champ ajouté
    this.department,
    this.className,
    this.photoUrl,
    required this.createdAt,
  });

  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      id: map['id'],
      firstName: map['firstName'],
      lastName: map['lastName'],
      email: map['email'],
      role: UserRole.values.firstWhere((e) => e.toString() == 'UserRole.${map['role']}'),
      studentId: map['studentId'],
      teacherId: map['teacherId'], // Nouveau champ ajouté
      department: map['department'],
      className: map['className'],
      photoUrl: map['photoUrl'],
      createdAt: DateTime.parse(map['createdAt']),
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
      'teacherId': teacherId, // Nouveau champ ajouté
      'department': department,
      'className': className,
      'photoUrl': photoUrl,
      'createdAt': createdAt.toIso8601String(),
    };
  }

  String get fullName => '$firstName $lastName';
}