import 'package:flutter/material.dart';
import '../../constants/colors.dart';

import '../../models/user.dart';
import '../../ui/profile_info_card.dart';

class StudentProfileScreen extends StatelessWidget {
  const StudentProfileScreen({super.key});

  void _onEditProfile(BuildContext context) {
    // TODO: Implémenter la logique de modification de profil
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Modifier le profil - fonctionnalité à implémenter")),
    );
  }

  void _onLogout(BuildContext context) {
    // TODO: Implémenter la logique de déconnexion
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Déconnexion - fonctionnalité à implémenter")),
    );
  }

  @override
  Widget build(BuildContext context) {
    // Utilisateur fictif local
    final user = UserModel(
      id: '0',
      firstName: 'Patient',
      lastName: 'Djappa',
      role: UserRole.student,
      email: 'patientdjappa@gmail.com',
      studentId: 'ETD 129873',
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
                backgroundColor: AppColors.secondary.withOpacity(0.1),
                child: const Icon(Icons.person, size: 45, color: AppColors.secondary),
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

            ProfileInfoCard(
              icon: Icons.school,
              title: "Informations Académiques",
              infos: [
                InfoItem(label: "Numéro étudiant", value: user.studentId ?? 'N/A'),
                InfoItem(label: "Classe", value: user.className ?? 'N/A'),
                InfoItem(label: "Département", value: user.department ?? 'N/A'),
              ],
            ),

            const SizedBox(height: 30),

            ProfileInfoCard(
              icon: Icons.person,
              title: "Informations Personnelles",
              infos: [
                InfoItem(label: "Email", value: user.email),
                InfoItem(
                  label: "Compte créé le",
                  value:
                      '${user.createdAt.day.toString().padLeft(2, '0')}/'
                      '${user.createdAt.month.toString().padLeft(2, '0')}/'
                      '${user.createdAt.year}',
                ),
              ],
            ),

            const SizedBox(height: 30),

          Row(
  children: [
    Expanded(
      child: ElevatedButton.icon(
        onPressed: () => _onEditProfile(context),
        icon: const Icon(Icons.edit, color: Colors.white),
        label: const Text(
          "Modifier le profil",
          style: TextStyle(color: Colors.white),
        ),
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.secondary,
          padding: const EdgeInsets.symmetric(vertical: 14),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(50),
          ),
        ),
      ),
    ),
    const SizedBox(width: 16),
    Expanded(
      child: ElevatedButton.icon(
        onPressed: () => _onLogout(context),
        icon: const Icon(Icons.logout, color: AppColors.secondary),
        label: Text(
          "Déconnexion",
          style: TextStyle(color: AppColors.secondary),
        ),
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.white,
          padding: const EdgeInsets.symmetric(vertical: 14),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(50),
            side: BorderSide(color: AppColors.secondary,width: 0.1),
          ),
        ),
      ),
    ),
  ],
),
          ],
        ),
      ),
    );
  }
}
