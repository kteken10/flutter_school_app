import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'models/user.dart';

Future<void> createDefaultAdmin() async {
  final email = "admin@demo.com";
  final password = "admin123"; // À changer pour production

  try {
    final existingMethods = await FirebaseAuth.instance.fetchSignInMethodsForEmail(email);
    if (existingMethods.isNotEmpty) {
      print("Admin déjà créé.");
      return;
    }

    // Créer l'utilisateur dans FirebaseAuth
    UserCredential credential = await FirebaseAuth.instance.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );

    // Créer le document Firestore correspondant
    final userModel = UserModel(
      id: credential.user!.uid,
      firstName: 'Admin',
      lastName: 'Principal',
      email: email,
      role: UserRole.admin,
      createdAt: DateTime.now(),
      isSuperAdmin: true,
      adminPermissions: ['create_users', 'verify_actions'],
      isActive: true,
      createdBy: null,
    );

    await FirebaseFirestore.instance
        .collection('users')
        .doc(userModel.id)
        .set(userModel.toMap());

    print("Admin par défaut créé avec succès !");
  } catch (e) {
    print("Erreur lors de la création de l'admin : $e");
  }
}
