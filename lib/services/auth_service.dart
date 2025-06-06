import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/user.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Connexion
  Future<User?> signInWithEmailAndPassword(String email, String password) async {
    try {
      UserCredential result = await _auth.signInWithEmailAndPassword(
          email: email, password: password);
      return result.user;
    } catch (e) {
      print(e.toString());
      return null;
    }
  }

  // Inscription
  Future<UserModel?> registerWithEmailAndPassword(
      String email, String password, String firstName, String lastName, UserRole role,
      {String? studentId, String? department}) async {
    try {
      UserCredential result = await _auth.createUserWithEmailAndPassword(
          email: email, password: password);
      
      UserModel user = UserModel(
        id: result.user!.uid,
        firstName: firstName,
        lastName: lastName,
        email: email,
        role: role,
        studentId: studentId,
        department: department,
        createdAt: DateTime.now(),
      );

      await _firestore.collection('users').doc(user.id).set(user.toMap());
      
      return user;
    } catch (e) {
      print(e.toString());
      return null;
    }
  }

  // Déconnexion
  Future signOut() async {
    try {
      return await _auth.signOut();
    } catch (e) {
      print(e.toString());
      return null;
    }
  }

  // Récupérer l'utilisateur actuel (Stream)
  Stream<UserModel?> get currentUser {
    return _auth.authStateChanges().asyncMap((user) async {
      if (user != null) {
        DocumentSnapshot doc = await _firestore.collection('users').doc(user.uid).get();
        return UserModel.fromMap(doc.data() as Map<String, dynamic>);
      }
      return null;
    });
  }

  // Nouvelle méthode pour récupérer le UserModel actuel (Future)
  Future<UserModel?> getCurrentUserModel() async {
    final user = _auth.currentUser;
    if (user != null) {
      DocumentSnapshot doc = await _firestore.collection('users').doc(user.uid).get();
      return doc.exists ? UserModel.fromMap(doc.data() as Map<String, dynamic>) : null;
    }
    return null;
  }
}