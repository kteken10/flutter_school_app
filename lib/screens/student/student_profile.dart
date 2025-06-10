import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../constants/colors.dart';
import '../../services/auth_service.dart';
import '../../models/user.dart';

import '../teacher/profile_info.dart';

class StudentProfileScreen extends StatelessWidget {
  const StudentProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final authService = Provider.of<AuthService>(context);

    return StreamBuilder<UserModel?>(
      stream: authService.currentUser,
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return const Center(child: CircularProgressIndicator());
        }

        final user = snapshot.data!;

        return Scaffold(
          appBar: AppBar(
            title: const Text("Profil Étudiant"),
            backgroundColor: AppColors.primary,
            foregroundColor: Colors.white,
          ),
          body: SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Center(
                  child: CircleAvatar(
                    radius: 45,
                    backgroundColor: AppColors.primary.withOpacity(0.1),
                    child: const Icon(Icons.person, size: 45, color: AppColors.primary),
                  ),
                ),
                const SizedBox(height: 16),
                Center(
                  child: Text(
                    user.fullName,
                    style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                  ),
                ),
                const SizedBox(height: 4),
                Center(
                  child: Text(
                    user.email,
                    style: const TextStyle(color: Colors.grey),
                  ),
                ),
                const SizedBox(height: 30),

                Text("Informations Académiques",
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          color: AppColors.primary,
                          fontWeight: FontWeight.bold,
                        )),
                const SizedBox(height: 10),
                ProfileInfoCard(
                  icon: Icons.badge,
                  title: "Numéro étudiant",
                  subtitle: user.studentId ?? 'N/A',
                ),
                ProfileInfoCard(
                  icon: Icons.school,
                  title: "Classe",
                  subtitle: user.className ?? 'N/A',
                ),
                ProfileInfoCard(
                  icon: Icons.apartment,
                  title: "Département",
                  subtitle: user.department ?? 'N/A',
                ),

                const SizedBox(height: 30),
                Text("Informations Personnelles",
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          color: AppColors.primary,
                          fontWeight: FontWeight.bold,
                        )),
                const SizedBox(height: 10),
                ProfileInfoCard(
                  icon: Icons.email,
                  title: "Email",
                  subtitle: user.email,
                ),
                ProfileInfoCard(
                  icon: Icons.calendar_today,
                  title: "Compte créé le",
                  subtitle: user.createdAt != null
                      ? '${user.createdAt.day}/${user.createdAt!.month}/${user.createdAt!.year}'
                      : 'Date inconnue',
                ),

                const SizedBox(height: 30),
                ElevatedButton.icon(
                  onPressed: () async {
                    await authService.signOut();
                  },
                  icon: const Icon(Icons.logout),
                  label: const Text("Déconnexion"),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                )
              ],
            ),
          ),
        );
      },
    );
  }
}
