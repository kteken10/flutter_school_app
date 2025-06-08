import 'dart:math';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_app_check/firebase_app_check.dart';
import 'services/email_service.dart'; 
import 'services/class_service.dart';
import 'services/auth_service.dart';
import 'services/notification_service.dart';
import 'services/database_service.dart';
import 'utils.dart';
import 'wrappers/auth_wrapper.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  await FirebaseAppCheck.instance.activate(
    androidProvider: AndroidProvider.debug,
    appleProvider: AppleProvider.appAttest,
  );

  FirebaseAuth.instance.setLanguageCode('fr');
// Initialisation du EmailService
  final emailService = EmailService(
    smtpServer: 'smtp.example.com', // Remplacez par vos infos SMTP
    smtpUsername: 'dissangfrancis3@gmail.com',
    smtpPassword: 'uuzb ayvd hczf szee',
  );
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
    }
  }

  // Créer l'admin par défaut
  await createDefaultAdmin();

  runApp(MyApp(emailService: emailService));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key,required this.emailService});
  final EmailService emailService;

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        Provider<AuthService>(create: (_) => AuthService(emailService: emailService)),
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
