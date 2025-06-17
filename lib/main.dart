import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:schoop_app/screens/auth/login_screen.dart';
import 'package:schoop_app/services/auth_service.dart';
import 'services/class_service.dart';
import 'services/email_service.dart';
import 'utils.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Initialisation Firebase
  await Firebase.initializeApp();

  // Configuration de la langue
  FirebaseAuth.instance.setLanguageCode('fr');
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

  // Création de l'admin par défaut
  await createDefaultAdmin();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final emailService = EmailService(
      smtpServer: 'smtp.gmail.com',
      smtpUsername: 'patientdjappa@gmail.com',
      smtpPassword: 'bjtp uswy idke kddq',);
    return MultiProvider(
      providers: [
        Provider<AuthService>(
          create: (_) => AuthService(emailService: emailService),
          
        ),Provider<ClassService>(
          create: (_) => ClassService()
        ) 
      ],
      child: MaterialApp(
        title: 'Plateforme de résultats académiques',
        theme: ThemeData(
          primarySwatch: Colors.blue,
          visualDensity: VisualDensity.adaptivePlatformDensity,
        ),
        home: const LoginScreen(), // ou AuthWrapper() si tu veux gérer la connexion
      ),
    );
  }
}