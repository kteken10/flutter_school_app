enum UserRole { admin, teacher, student }

class UserModel {
  final String id;
  final String firstName;
  final String lastName;
  final String email;
  final UserRole role;
  final String? studentId; // Pour les étudiants
  final String? department; // Pour les enseignants
  final String? className; // Ajouté pour la classe de l'étudiant
  final String? photoUrl; // Ajouté pour la photo de profil
  final DateTime createdAt;

  UserModel({
    required this.id,
    required this.firstName,
    required this.lastName,
    required this.email,
    required this.role,
    this.studentId,
    this.department,
    this.className, // Ajouté
    this.photoUrl, // Ajouté
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
      department: map['department'],
      className: map['className'], // Ajouté
      photoUrl: map['photoUrl'], // Ajouté
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
      'department': department,
      'className': className, // Ajouté
      'photoUrl': photoUrl, // Ajouté
      'createdAt': createdAt.toIso8601String(),
    };
  }

  String get fullName => '$firstName $lastName';
}