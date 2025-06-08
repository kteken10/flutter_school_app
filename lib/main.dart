import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_app_check/firebase_app_check.dart';

import 'services/class_service.dart';
import 'services/auth_service.dart';
import 'services/notification_service.dart';
import 'services/database_service.dart';


import 'models/user.dart';

import 'screens/auth/login_screen.dart';
import 'screens/student/student_home.dart';
import 'screens/teacher/teacher_home.dart';
import 'screens/admin/admin_home.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  await FirebaseAppCheck.instance.activate(
    androidProvider: AndroidProvider.debug,
    appleProvider: AppleProvider.appAttest,
  );

  FirebaseAuth.instance.setLanguageCode('fr');

  // Création automatique des classes
  final classService = ClassService();
  final classesToCreate = [
    {'name': 'L1', 'department': 'Niveau 1'},
    {'name': 'L2', 'department': 'Niveau 2'},
    {'name': 'L3', 'department': 'Niveau 3'},
    {'name': 'M1', 'department': 'Niveau Master 1'},
    {'name': 'M2', 'department': 'Niveau Master 2'},
  ];

  for (var classe in classesToCreate) {
    bool exists = await classService.classExists(classe['name']!);
    if (!exists) {
      await classService.createClass(classe['name']!, classe['department']!);
      print('Classe créée : ${classe['name']}');
    } else {
      print('La classe ${classe['name']} existe déjà.');
    }
  }
  

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        Provider<AuthService>(create: (_) => AuthService()),
        Provider<NotificationService>(create: (_) => NotificationService()),
        Provider<DatabaseService>(create: (_) => DatabaseService()),
        Provider<ClassService>(create: (_) => ClassService()),
      ],
      child: MaterialApp(
        title: 'Plateforme de résultats académiques',
        theme: ThemeData(
          primarySwatch: Colors.blue,
          visualDensity: VisualDensity.adaptivePlatformDensity,
        ),
        home: const AuthWrapper(),
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
