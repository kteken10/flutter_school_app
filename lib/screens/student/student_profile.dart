import 'package:flutter/material.dart';
import '../../constants/colors.dart';

import '../../models/user.dart';
import '../teacher/profile_info.dart';

class StudentProfileScreen extends StatelessWidget {
  const StudentProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Utilisateur fictif local
    final user = UserModel(
      id: '0',
      firstName: 'Patient',
      lastName: 'Djappa',
      role: UserRole.student,
      email: 'patientdjappa@gmail.com',
      studentId: '000000',
      className: 'Classe L1',
      department: 'Informatique',
      createdAt: DateTime(2023, 1, 1),
    );

    return Scaffold(
      backgroundColor: AppColors.background,
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

            Text(
              "Informations Académiques",
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    color: AppColors.primary,
                    fontWeight: FontWeight.bold,
                  ),
            ),
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
            Text(
              "Informations Personnelles",
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    color: AppColors.primary,
                    fontWeight: FontWeight.bold,
                  ),
            ),
            const SizedBox(height: 10),
            ProfileInfoCard(
              icon: Icons.email,
              title: "Email",
              subtitle: user.email,
            ),
            ProfileInfoCard(
              icon: Icons.calendar_today,
              title: "Compte créé le",
              subtitle: '${user.createdAt.day.toString().padLeft(2, '0')}/'
                  '${user.createdAt.month.toString().padLeft(2, '0')}/'
                  '${user.createdAt.year}',
            ),

            const SizedBox(height: 30),

            // Bouton Modifier profil désactivé (ou retiré car pas de backend)
            ElevatedButton.icon(
              onPressed: null, // désactivé
              icon: const Icon(Icons.edit),
              label: const Text("Modifier le profil (désactivé)"),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.grey,
                padding: const EdgeInsets.symmetric(vertical: 14),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),

            const SizedBox(height: 16),

            // Bouton Déconnexion (désactivé ou retiré, car pas d'auth)
            ElevatedButton.icon(
              onPressed: null, // désactivé
              icon: const Icon(Icons.logout),
              label: const Text("Déconnexion (désactivé)"),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.grey,
                padding: const EdgeInsets.symmetric(vertical: 14),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),

            const SizedBox(height: 16),

            Center(
              child: Text(
                "Mode Bypass : données locales affichées, modifications désactivées",
                style: TextStyle(
                  color: Colors.grey[600],
                  fontStyle: FontStyle.italic,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
