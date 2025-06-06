import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_app_check/firebase_app_check.dart';
import 'package:schoop_app/services/database_service.dart';

import 'models/user.dart';
import 'services/auth_service.dart';
import 'services/notification_service.dart';
import 'screens/auth/login_screen.dart';


import 'screens/student/student_home.dart';
import 'screens/teacher/teacher_home.dart';
import 'screens/admin/admin_home.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  await FirebaseAppCheck.instance.activate(
    // You can also use a `ReCaptchaEnterpriseProvider` provider instance as an
   
    // Default provider for Android is the Play Integrity provider. You can use the "AndroidProvider" enum to choose
    // your preferred provider. Choose from:
    // 1. Debug provider
    // 2. Safety Net provider
    // 3. Play Integrity provider
    androidProvider: AndroidProvider.debug,
    // Default provider for iOS/macOS is the Device Check provider. You can use the "AppleProvider" enum to choose
        // your preferred provider. Choose from:
        // 1. Debug provider
        // 2. Device Check provider
        // 3. App Attest provider
        // 4. App Attest provider with fallback to Device Check provider (App Attest provider is only available on iOS 14.0+, macOS 14.0+)
    appleProvider: AppleProvider.appAttest,
  );

  // Définir la langue utilisée par Firebase Auth
  FirebaseAuth.instance.setLanguageCode('fr');

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        Provider<AuthService>(create: (_) => AuthService()),
        Provider<NotificationService>(create: (_) => NotificationService()),
        Provider<DatabaseService>(create:(_) => DatabaseService()),
      ],
      child: MaterialApp(
        title: 'Plateforme de résultats académiques',
        theme: ThemeData(
          primarySwatch: Colors.blue,
          visualDensity: VisualDensity.adaptivePlatformDensity,
        ),
        home: AuthWrapper(),
      ),
    );
  }
}

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
          return Scaffold(body: Center(child: CircularProgressIndicator()));
        }

        final user = snapshot.data;

        if (user == null) {
          return LoginScreen();
        }

        // Initialiser les notifications
        notificationService.initialize();

        // Rediriger selon le rôle de l'utilisateur
        switch (user.role) {
          case UserRole.admin:
            return AdminHomeScreen();
          case UserRole.teacher:
            return TeacherHomeScreen();
          case UserRole.student:
            return StudentHomeScreen();
          }
      },
    );
  }
}
