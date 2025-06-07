import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:salomon_bottom_bar/salomon_bottom_bar.dart';

import '../../constants/colors.dart';
import '../../models/user.dart';
import '../../services/auth_service.dart';
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
  late List<Widget> _children;

  @override
  void initState() {
    super.initState();
    _children = [
      const NoteScreen(),
      GradeImportScreen(),
      NotificationScreen(),
      ProfileScreen(),
    ];
  }

  // void _showNotifications(BuildContext context) {
  //   ScaffoldMessenger.of(context).showSnackBar(
  //     const SnackBar(content: Text('Notifications à venir...')),
  //   );
  // }

  @override
  Widget build(BuildContext context) {
    final authService = Provider.of<AuthService>(context);

    return StreamBuilder<UserModel?>(
      stream: authService.currentUser,
      builder: (context, snapshot) {
      
        if (!snapshot.hasData || snapshot.data == null) {
          return const Scaffold(
            body: Center(child: Text('Utilisateur non connecté')),
          );
        }

        return Scaffold(
          body: IndexedStack(
            index: _currentIndex,
            children: _children,
          ),
          bottomNavigationBar: SalomonBottomBar(
            currentIndex: _currentIndex,
            onTap: (index) {
              // if (index == 2) {
              //   _showNotifications(context);
              //   return;
              // }
              setState(() => _currentIndex = index);
            },
            items: [
              SalomonBottomBarItem(
                icon: const Icon(Icons.grading),
                title: const Text('Notes'),
                selectedColor: AppColors.secondary,
                unselectedColor: Colors.grey,
              ),
              SalomonBottomBarItem(
                icon: const Icon(Icons.upload),
                title: const Text('Importer'),
               selectedColor: AppColors.secondary,
                unselectedColor: Colors.grey,
              ),
              SalomonBottomBarItem(
                icon: const Icon(Icons.notifications),
                title: const Text('Notifications'),
                selectedColor: AppColors.secondary,
                unselectedColor: Colors.grey,
              ),
              SalomonBottomBarItem(
                icon: const Icon(Icons.person),
                title: const Text('Profile'),
                 selectedColor: AppColors.secondary,
                unselectedColor: Colors.grey,
              ),
            ],
          ),
        );
      },
    );
  }
}