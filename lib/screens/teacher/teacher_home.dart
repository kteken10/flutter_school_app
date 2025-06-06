import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../models/user.dart';
import '../../services/auth_service.dart';
import 'grade_import.dart';
import 'note_screen.dart';
import 'notification.dart';
import 'profile_screen.dart';

class TeacherHomeScreen extends StatefulWidget {
  const TeacherHomeScreen({Key? key}) : super(key: key);

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

  

  void _showNotifications(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Notifications à venir...')),
    );
  }

  @override
  Widget build(BuildContext context) {
    final authService = Provider.of<AuthService>(context);

    return StreamBuilder<UserModel?>(
      stream: authService.currentUser,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }

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
          bottomNavigationBar: BottomNavigationBar(
            type: BottomNavigationBarType.fixed,
            currentIndex: _currentIndex,
            selectedItemColor: Theme.of(context).primaryColor,
            unselectedItemColor: Colors.grey,
            onTap: (index) {
              if (index == 2) {
                _showNotifications(context);
                return;
              }
              setState(() => _currentIndex = index);
            },
            items: [
              const BottomNavigationBarItem(
                  icon: Icon(Icons.grading), label: 'Notes'),
              const BottomNavigationBarItem(
                  icon: Icon(Icons.upload), label: 'Importer'),
              BottomNavigationBarItem(
                icon: Icon(
                  Icons.notifications, ),
                label: 'Notifications',
              ),
            BottomNavigationBarItem(
                icon: Icon(
                  Icons.person, ),
                label: 'Profile',
              ),
            ],
          ),
        );
      },
    );
  }
}