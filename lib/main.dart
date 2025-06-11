import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:schoop_app/services/grade_service.dart';
import 'services/email_service.dart'; 
import 'services/class_service.dart';
import 'services/auth_service.dart';
import 'services/notification_service.dart';
import 'services/database_service.dart';
import 'services/subject_service.dart';
import 'utils.dart';
import 'wrappers/auth_wrapper.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Initialisation Firebase sans App Check
  await Firebase.initializeApp();

  // Configuration de la langue
  FirebaseAuth.instance.setLanguageCode('fr');

  // Initialisation du EmailService
  final emailService = EmailService(
    smtpServer: 'smtp.gmail.com',
    smtpUsername: 'patientdjappa@gmail.com',
    smtpPassword: 'bjtp uswy idke kddq',
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
  const MyApp({super.key, required this.emailService});
  final EmailService emailService;

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        Provider<AuthService>(create: (_) => AuthService(emailService: emailService)),
        Provider<NotificationService>(create: (_) => NotificationService()),
        Provider<DatabaseService>(create: (_) => DatabaseService()),
        Provider<ClassService>(create: (_) => ClassService()),
        Provider<GradeService>(create: (_) => GradeService()),
        Provider<SubjectService>(create: (_) => SubjectService()),

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

