import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/user.dart';
import '../screens/admin/admin_home.dart';
import '../screens/auth/login_screen.dart';
import '../screens/student/student_home.dart';
import '../screens/teacher/teacher_home.dart';
import '../services/auth_service.dart';
import '../services/notification_service.dart';
class AuthWrapper extends StatelessWidget {
  const AuthWrapper({super.key});

  @override
  Widget build(BuildContext context) {
    final authService = Provider.of<AuthService>(context);
    final notificationService = Provider.of<NotificationService>(context);

    return StreamBuilder<UserModel?>(
      stream: authService.currentUser,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }

        final user = snapshot.data;

        if (user == null) {
          return LoginScreen();
        }

        notificationService.initialize();

        switch (user.role) {
          case UserRole.admin:
            return AdminHomeScreen();
          case UserRole.teacher:
            return TeacherHomeScreen();
          case UserRole.student:
            return StudentHomeScreen();
          default:
            return const Scaffold(
              body: Center(child: Text("Rôle utilisateur inconnu")),
            );
        }
      },
    );
  }
}
