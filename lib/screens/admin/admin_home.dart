import 'package:flutter/material.dart';
import 'package:salomon_bottom_bar/salomon_bottom_bar.dart';
import '../../constants/colors.dart';
import 'notification.dart';
import 'profile.dart';
import 'student_show.dart';
import 'teacher_show.dart';

class AdminHomeScreen extends StatefulWidget {
  const AdminHomeScreen({super.key});

  @override
  State<AdminHomeScreen> createState() => _AdminHomeScreenState();
}

class _AdminHomeScreenState extends State<AdminHomeScreen> with SingleTickerProviderStateMixin {
  int _currentIndex = 0;
  late AnimationController _controller;

  final List<Widget> _children = const [
    AdminStudentsScreen(),
    AdminTeachersScreen(),
    AdminNotificationsScreen(),
    AdminProfileScreen(),
  ];

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Widget animatedIcon(IconData iconData, {bool showBadge = false}) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (_, child) {
        double angle = 0.3 * (1 - _controller.value * 2);
        return Transform.rotate(
          angle: angle,
          child: Stack(
            children: [
              Icon(iconData, size: 28),
              if (showBadge)
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
    );
  }

  @override
  Widget build(BuildContext context) {
    final List<SalomonBottomBarItem> bottomNavItems = [
      SalomonBottomBarItem(
        icon: animatedIcon(Icons.school),
        title: const Text("Étudiants"),
        selectedColor: AppColors.secondary,
        unselectedColor: Colors.grey,
      ),
      SalomonBottomBarItem(
        icon: animatedIcon(Icons.person_outline),
        title: const Text("Enseignants"),
        selectedColor: AppColors.secondary,
        unselectedColor: Colors.grey,
      ),
      SalomonBottomBarItem(
        icon: animatedIcon(Icons.notifications, showBadge: true),
        title: const Text("Alertes"),
        selectedColor: AppColors.secondary,
        unselectedColor: Colors.grey,
      ),
      SalomonBottomBarItem(
        icon: animatedIcon(Icons.person),
        title: const Text("Profil"),
        selectedColor: AppColors.secondary,
        unselectedColor: Colors.grey,
      ),
    ];

    return Scaffold(
      appBar: AppBar(
        title: Text(_getAppBarTitle(_currentIndex)),
      ),
      body: IndexedStack(
        index: _currentIndex,
        children: _children,
      ),
      bottomNavigationBar: SalomonBottomBar(
        currentIndex: _currentIndex,
        onTap: (index) => setState(() => _currentIndex = index),
        items: bottomNavItems,
      ),
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
