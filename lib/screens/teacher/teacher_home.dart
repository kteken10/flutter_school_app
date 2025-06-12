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

class _TeacherHomeScreenState extends State<TeacherHomeScreen> with SingleTickerProviderStateMixin {
  int _currentIndex = 0;
  late AnimationController _controller;

  final List<Widget> _screens = const [
    NoteScreen(),
    GradeImportScreen(),
    NotificationScreen(),
    ProfileScreen(),
  ];

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    )..repeat(reverse: true); // Cloche qui oscille en boucle
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final List<SalomonBottomBarItem> bottomNavItems = [
      SalomonBottomBarItem(
        icon: const Icon(Icons.school),
        title: const Text("Notes"),
        selectedColor: AppColors.secondary,
        unselectedColor: Colors.grey,
      ),
      SalomonBottomBarItem(
        icon: const Icon(Icons.upload_file),
        title: const Text("Import"),
        selectedColor: AppColors.secondary,
        unselectedColor: Colors.grey,
      ),
      SalomonBottomBarItem(
        icon: AnimatedBuilder(
          animation: _controller,
          builder: (_, child) {
            return Transform.rotate(
              angle: 0.2 * (1 - _controller.value * 2), // Rotation de -0.2 à 0.2 radians
              child: Stack(
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
                  ),
                ],
              ),
            );
          },
        ),
        title: const Text("Notifications"),
        selectedColor: AppColors.secondary,
        unselectedColor: Colors.grey,
      ),
      SalomonBottomBarItem(
        icon: const Icon(Icons.person),
        title: const Text("Profil"),
        selectedColor: AppColors.secondary,
        unselectedColor: Colors.grey,
      ),
    ];

    return Scaffold(
      body: IndexedStack(
        index: _currentIndex,
        children: _screens,
      ),
      bottomNavigationBar: SalomonBottomBar(
        currentIndex: _currentIndex,
        onTap: (index) => setState(() => _currentIndex = index),
        items: bottomNavItems,
      ),
    );
  }
}
