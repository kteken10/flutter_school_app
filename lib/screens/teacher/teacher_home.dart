import 'package:flutter/material.dart';
import 'package:salomon_bottom_bar/salomon_bottom_bar.dart';
import '../../constants/colors.dart';
import 'grade_import.dart';
import 'note_screen.dart';
import 'notification.dart';

import 'profile_screen.dart';

class TeacherHomeScreen extends StatefulWidget {
  const TeacherHomeScreen({super.key});

  @override
  State<TeacherHomeScreen> createState() => _TeacherHomeScreenState();
}

class _TeacherHomeScreenState extends State<TeacherHomeScreen> {
  int _currentIndex = 0;

  // Liste des écrans accessibles via la barre de navigation
  final List<Widget> _screens = const [
    NoteScreen(),
    GradeImportScreen(),
    NotificationScreen(),
    ProfileScreen(),
  ];

  // Configuration des éléments de la barre de navigation
  final List<SalomonBottomBarItem> _bottomNavItems =  [
    SalomonBottomBarItem(
      icon: Icon(Icons.school),
      title: Text("Notes"),
      selectedColor: AppColors.secondary,
      unselectedColor: Colors.grey,
    ),
    SalomonBottomBarItem(
      icon: Icon(Icons.upload_file),
      title: Text("Import"),
      selectedColor: AppColors.secondary,
      unselectedColor: Colors.grey,
    ),
    SalomonBottomBarItem(
  icon: Stack(
    children: [
      const Icon(Icons.notifications),
      Positioned(
        right: 0,
        top: 0,
        child: Container(
          padding: const EdgeInsets.all(2),
          decoration: BoxDecoration(
            color: Colors.red,
            borderRadius: BorderRadius.circular(10),
          ),
          constraints: const BoxConstraints(
            minWidth: 16,
            minHeight: 16,
          ),
          child: const Text(
            '3', 
            style: TextStyle(
              color: Colors.white,
              fontSize: 10,
              fontWeight: FontWeight.bold,
            ),
            textAlign: TextAlign.center,
          ),
        ),
      )
    ],
  ),
  title: const Text("Notifications"),
  selectedColor: AppColors.secondary,
  unselectedColor: Colors.grey,
),

    SalomonBottomBarItem(
      icon: Icon(Icons.person),
      title: Text("Profil"),
      selectedColor: AppColors.secondary,
      unselectedColor: Colors.grey,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _currentIndex,
        children: _screens,
      ),
      bottomNavigationBar: SalomonBottomBar(
        currentIndex: _currentIndex,
        onTap: (index) => setState(() => _currentIndex = index),
        items: _bottomNavItems,
      ),
    );
  }
}