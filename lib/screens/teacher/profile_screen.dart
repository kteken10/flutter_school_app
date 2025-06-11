import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../services/auth_service.dart';
import '../../models/user.dart';
import '../../ui/profile_action_bar.dart';
import '../../ui/profile_avatar.dart';
import 'profile_info.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final authService = Provider.of<AuthService>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Mon Profil'),
        centerTitle: true,
      ),
      backgroundColor: Colors.grey[100],
      body: StreamBuilder<UserModel?>(
        stream: authService.currentUser,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          // Création d'un user fictif si données absentes (Bypass)
          final user = snapshot.data ??
              UserModel(
                id: '0',
                firstName: 'Utilisateur Bypass',
                lastName: "Armand",
                role: UserRole.teacher,
                email: 'bypass@exemple.com',
                department: 'Département fictif',
                createdAt: DateTime.now(),
              );

          final bool isRealUser = snapshot.hasData && snapshot.data != null;

          return SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 30),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                ProfileAvatar(fullName: user.fullName),
                const SizedBox(height: 20),
                Text(
                  user.fullName,
                  style: const TextStyle(
                    fontSize: 26,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  user.email,
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.grey[700],
                  ),
                ),
                const SizedBox(height: 30),

                ProfileInfoCard(
                  icon: Icons.school,
                  title: 'Département',
                  subtitle: user.department ?? 'Non spécifié',
                ),
                ProfileInfoCard(
                  icon: Icons.calendar_today,
                  title: 'Membre depuis',
                  subtitle:
                      '${user.createdAt.day.toString().padLeft(2, '0')}/${user.createdAt.month.toString().padLeft(2, '0')}/${user.createdAt.year}',
                ),

                const SizedBox(height: 40),

                // Affiche le bouton Modifier le profil seulement si utilisateur réel
                if (isRealUser)
                  ProfileActionButton(
                    text: 'Modifier le profil',
                    onPressed: () {
                      Navigator.pushNamed(context, '/editProfile');
                    },
                  ),

                if (isRealUser) const SizedBox(height: 16),

                // Le bouton Déconnexion est toujours affiché et actif
                ProfileActionButton(
                  text: 'Déconnexion',
                  color: Colors.redAccent,
                  onPressed: () async {
                    await authService.signOut();
                    Navigator.pushReplacementNamed(context, '/login');
                  },
                ),

                if (!isRealUser)
                  Padding(
                    padding: const EdgeInsets.only(top: 16),
                    child: Text(
                      "Mode Bypass : modifications désactivées",
                      style: TextStyle(
                        color: Colors.grey[600],
                        fontStyle: FontStyle.italic,
                      ),
                    ),
                  ),
              ],
            ),
          );
        },
      ),
    );
  }
}
