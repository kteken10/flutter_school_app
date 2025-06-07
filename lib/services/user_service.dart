import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/user.dart';

class UserService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  /// Récupère en temps réel la liste des utilisateurs ayant le rôle "student"
  Stream<List<UserModel>> getStudents() {
    return _firestore
        .collection('users')
        .where('role', isEqualTo: 'student')
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => UserModel.fromMap({
                  ...doc.data(),
                  'id': doc.id, // Ajoute manuellement l'ID du document
                }))
            .toList());
  }

  /// Récupère un utilisateur spécifique à partir de son ID
  Future<UserModel?> getUserById(String userId) async {
    try {
      final doc = await _firestore.collection('users').doc(userId).get();
      if (doc.exists) {
        return UserModel.fromMap({
          ...doc.data()!,
          'id': doc.id,
        });
      }
      return null;
    } catch (e) {
      print('Erreur lors de la récupération de l\'utilisateur: $e');
      return null;
    }
  }

  /// (Optionnel) Récupère tous les utilisateurs (si besoin dans d'autres contextes)
  Stream<List<UserModel>> getAllUsers() {
    return _firestore.collection('users').snapshots().map((snapshot) =>
        snapshot.docs
            .map((doc) => UserModel.fromMap({
                  ...doc.data(),
                  'id': doc.id,
                }))
            .toList());
  }
}
