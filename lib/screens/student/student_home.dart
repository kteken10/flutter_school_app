import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:salomon_bottom_bar/salomon_bottom_bar.dart';
import '../../constants/colors.dart';
import '../../models/user.dart';
import '../../services/auth_service.dart';
import 'grades_view.dart';
import 'student_transcript.dart';
import 'student_notifications.dart';
import 'student_profile.dart';

class StudentHomeScreen extends StatefulWidget {
  const StudentHomeScreen({super.key});

  @override
  State<StudentHomeScreen> createState() => _StudentHomeScreenState();
}

class _StudentHomeScreenState extends State<StudentHomeScreen> {
  int _currentIndex = 0;
  late List<Widget> _children;

  @override
  void initState() {
    super.initState();
    _children = [
      const GradesViewScreen(),
      const StudentTranscriptScreen(),
      const StudentNotificationsScreen(),
      const StudentProfileScreen(),
    ];
  }

  @override
  Widget build(BuildContext context) {
    final authService = Provider.of<AuthService>(context, listen: false);

    return StreamBuilder<UserModel?>(
      stream: authService.currentUser,
      builder: (context, snapshot) {
        final user = snapshot.data;

        return Scaffold(
          body: IndexedStack(
            index: _currentIndex,
            children: _children,
          ),
          bottomNavigationBar: SalomonBottomBar(
            currentIndex: _currentIndex,
            onTap: (index) => setState(() => _currentIndex = index),
            items: [
              SalomonBottomBarItem(
                icon: const Icon(Icons.grade),
                title: const Text('Mes Notes'),
                selectedColor: AppColors.secondary,
                unselectedColor: Colors.grey,
              ),
              SalomonBottomBarItem(
                icon: const Icon(Icons.list_alt),
                title: const Text('Relevé'),
                selectedColor: AppColors.secondary,
                unselectedColor: Colors.grey,
              ),
              SalomonBottomBarItem(
                icon: const Icon(Icons.notifications),
                title: const Text('Alertes'),
                selectedColor: AppColors.secondary,
                unselectedColor: Colors.grey,
              ),
              SalomonBottomBarItem(
                icon: const Icon(Icons.person),
                title: Text(user != null ? 'Profil' : 'Connexion'),
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
