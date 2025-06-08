import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../models/user.dart';
import 'email_service.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final EmailService _emailService;
  final String _encryptedAdminPassphrase = "keyce admin";

  AuthService({required EmailService emailService}) : _emailService = emailService;

  // Connexion sécurisée
  Future<User?> signInWithEmailAndPassword(String email, String password) async {
    try {
      UserCredential result = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      // Vérification supplémentaire du rôle dans Firestore
      final userDoc = await _firestore.collection('users').doc(result.user?.uid).get();
      if (!userDoc.exists) {
        await result.user?.delete();
        throw Exception('User document not found');
      }

      return result.user;
    } catch (e) {
      print('Connexion échouée: ${e.toString()}');
      rethrow;
    }
  }

  Future<UserModel?> registerWithEmailAndPassword({
    required String email,
    required String password,
    required String firstName,
    required String lastName,
    required UserRole role,
    String? studentId,
    String? teacherId,
    String? department,
    String? className,
    String? adminEmail,
    String? adminPassphrase,
  }) async {
    try {
      UserModel? adminUser;

      // Vérification renforcée pour les créations non-admin
      if (role != UserRole.admin) {
        if (adminEmail == null || adminPassphrase == null) {
          throw _AuthException('Validation admin requise');
        }

        // Vérification du compte admin
        adminUser = await getUserByEmail(adminEmail);
        if (adminUser?.role != UserRole.admin || 
            !verifyAdminPassphrase(adminPassphrase)) {
          throw _AuthException('Échec de la validation admin');
        }

        // Vérification des permissions admin
        if (!(adminUser?.canCreateUsers() ?? false)) {
          throw _AuthException('Permissions insuffisantes');
        }
      }

      // Création de l'utilisateur Firebase
      final userCredential = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      // Création du modèle utilisateur
      final user = UserModel(
        id: userCredential.user!.uid,
        firstName: firstName,
        lastName: lastName,
        email: email,
        role: role,
        studentId: studentId,
        teacherId: teacherId,
        department: department,
        className: className,
        createdAt: DateTime.now(),
        createdBy: adminEmail,
      );

      // Sauvegarde dans Firestore avec transaction
      await _firestore.runTransaction((transaction) async {
        transaction.set(
          _firestore.collection('users').doc(user.id),
          user.toMap(),
        );

        // Journalisation de la création
        if (role != UserRole.admin) {
          transaction.set(
            _firestore.collection('admin_logs').doc(),
            {
              'action': 'user_creation',
              'adminId': adminUser?.id,
              'targetUserId': user.id,
              'timestamp': FieldValue.serverTimestamp(),
              'details': {
                'role': role.toString(),
                'email': email,
              },
            },
          );
        }
      });

      // Envoi de l'email de notification
      await _emailService.sendAccountCreationEmail(
        recipientEmail: email,
        password: password,
        firstName: firstName,
        lastName: lastName,
        userId: user.id,
        roleName: _getRoleName(role),
      );

      return user;
    } on FirebaseAuthException catch (e) {
      throw _AuthException(_getFirebaseAuthErrorMessage(e));
    } catch (e) {
      throw _AuthException('Erreur lors de l\'inscription: ${e.toString()}');
    }
  }

  // Vérification de la passphrase admin
  bool verifyAdminPassphrase(String inputPassphrase) {
    try {
      return inputPassphrase == _encryptedAdminPassphrase;
    } catch (e) {
      return false;
    }
  }

  // Méthode rendue publique
  Future<UserModel?> getUserByEmail(String email) async {
    final query = await _firestore.collection('users')
        .where('email', isEqualTo: email)
        .limit(1)
        .get();
    return query.docs.isNotEmpty ? UserModel.fromMap(query.docs.first.data()) : null;
  }

  Future<bool> isCurrentUserAdmin() async {
    final user = await getCurrentUserModel();
    return user?.role == UserRole.admin && (user?.isActive ?? false);
  }

  String _getFirebaseAuthErrorMessage(FirebaseAuthException e) {
    switch (e.code) {
      case 'email-already-in-use':
        return 'Cet email est déjà utilisé';
      case 'invalid-email':
        return 'Email invalide';
      case 'operation-not-allowed':
        return 'Opération non autorisée';
      case 'weak-password':
        return 'Mot de passe trop faible';
      default:
        return 'Erreur d\'authentification';
    }
  }

  String _getRoleName(UserRole role) {
    switch (role) {
      case UserRole.admin:
        return 'Administrateur';
      case UserRole.teacher:
        return 'Enseignant';
      case UserRole.student:
        return 'Étudiant';
      default:
        return 'Utilisateur';
    }
  }

  Future<void> signOut() async {
    await _auth.signOut();
  }

  Stream<UserModel?> get currentUser {
    return _auth.authStateChanges().asyncMap((user) async {
      if (user != null) {
        final doc = await _firestore.collection('users').doc(user.uid).get();
        if (doc.exists) {
          final userModel = UserModel.fromMap(doc.data()!);
          return userModel.isActive ? userModel : null;
        }
      }
      return null;
    });
  }

  Future<UserModel?> getCurrentUserModel({bool forceRefresh = false}) async {
    final user = _auth.currentUser;
    if (user != null) {
      final doc = await _firestore.collection('users').doc(user.uid).get();
      return doc.exists ? UserModel.fromMap(doc.data()!) : null;
    }
    return null;
  }
}

// Exception personnalisée
class _AuthException implements Exception {
  final String message;
  _AuthException(this.message);

  @override
  String toString() => message;
}