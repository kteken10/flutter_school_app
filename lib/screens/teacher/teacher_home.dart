import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:salomon_bottom_bar/salomon_bottom_bar.dart';

import '../../constants/colors.dart';
import '../../models/user.dart';
import '../../services/auth_service.dart';
import 'grade_import.dart';
import 'note_screenn.dart';
import 'notification.dart';
import 'profile_screen.dart';
class TeacherHomeScreen extends StatefulWidget {
  const TeacherHomeScreen({super.key});

  @override
  State<TeacherHomeScreen> createState() => _TeacherHomeScreenState();
}

class _TeacherHomeScreenState extends State<TeacherHomeScreen> {
  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    final authService = Provider.of<AuthService>(context, listen: false);

    return StreamBuilder<UserModel?>(
      stream: authService.currentUser,
      builder: (context, snapshot) {
        final user = snapshot.data;

        final List<Widget> _children = [
          NoteScreen(), // tu peux adapter pour passer user si besoin
          GradeImportScreen(),
          NotificationScreen(),
          ProfileScreen(), // Affiche la page profile même si user null, adapte l’affichage dans ce widget si besoin
        ];

        return Scaffold(
          body: IndexedStack(
            index: _currentIndex,
            children: _children,
          ),
          bottomNavigationBar: SalomonBottomBar(
            currentIndex: _currentIndex,
            onTap: (index) {
              setState(() {
                _currentIndex = index;
              });
            },
            items: [
              SalomonBottomBarItem(
                icon: const Icon(Icons.school),
                title: const Text("Notes"),
                selectedColor: AppColors.primary,
                unselectedColor: Colors.grey,
              ),
              SalomonBottomBarItem(
                icon: const Icon(Icons.upload_file),
                title: const Text("Import"),
                selectedColor: AppColors.primary,
                unselectedColor: Colors.grey,
              ),
              SalomonBottomBarItem(
                icon: const Icon(Icons.notifications),
                title: const Text("Notifications"),
                selectedColor: AppColors.primary,
                unselectedColor: Colors.grey,
              ),
              SalomonBottomBarItem(
                icon: const Icon(Icons.person),
                title: Text(user != null ? "Profil" : "Connexion"),
                selectedColor: AppColors.primary,
                unselectedColor: Colors.grey,
              ),
            ],
          ),
        );
      },
    );
  }
}
