import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:salomon_bottom_bar/salomon_bottom_bar.dart';
import '../../constants/colors.dart';
import '../../models/user.dart';
import '../../services/auth_service.dart';
import 'notification.dart';
import 'profile.dart';
import 'student_show.dart';
import 'teacher_show.dart';


class AdminHomeScreen extends StatefulWidget {
  const AdminHomeScreen({super.key});

  @override
  State<AdminHomeScreen> createState() => _AdminHomeScreenState();
}

class _AdminHomeScreenState extends State<AdminHomeScreen> {
  int _currentIndex = 0;
  late List<Widget> _children;

  @override
  void initState() {
    super.initState();
    _children = [
      const AdminStudentsScreen(),
      const AdminTeachersScreen(),
      const AdminNotificationsScreen(),
      const AdminProfileScreen(),
    ];
  }

  @override
  Widget build(BuildContext context) {
    final authService = Provider.of<AuthService>(context);

    return StreamBuilder<UserModel?>(
      stream: authService.currentUser,
      builder: (context, snapshot) {
        if (!snapshot.hasData || snapshot.data == null) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }

        final user = snapshot.data!;
        
        return Scaffold(
          appBar: AppBar(
            title: Text(_getAppBarTitle(_currentIndex)),
            actions: [
              IconButton(
                icon: const Icon(Icons.logout),
                onPressed: () async {
                  await authService.signOut();
                },
              ),
            ],
          ),
          body: IndexedStack(
            index: _currentIndex,
            children: _children,
          ),
          bottomNavigationBar: SalomonBottomBar(
            currentIndex: _currentIndex,
            onTap: (index) => setState(() => _currentIndex = index),
            items: [
              SalomonBottomBarItem(
                icon: const Icon(Icons.school),
                title: const Text('Étudiants'),
                selectedColor: AppColors.secondary,
                unselectedColor: Colors.grey,
              ),
              SalomonBottomBarItem(
                icon: const Icon(Icons.person_outline),
                title: const Text('Enseignants'),
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
                title: const Text('Profil'),
                selectedColor: AppColors.secondary,
                unselectedColor: Colors.grey,
              ),
            ],
          ),
        );
      },
    );
  }

  String _getAppBarTitle(int index) {
    switch (index) {
      case 0:
        return 'Gestion des étudiants';
      case 1:
        return 'Gestion des enseignants';
      case 2:
        return 'Notifications';
      case 3:
        return 'Profil administrateur';
      default:
        return 'Tableau de bord';
    }
  }
}