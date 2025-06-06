import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../models/grade.dart';
import '../../models/user.dart';
import '../../services/auth_service.dart';
import '../../services/database_service.dart';

import '../../ui/teacher_card.dart';

class NoteScreen extends StatefulWidget {
  const NoteScreen({super.key});

  @override
  State<NoteScreen> createState() => _NoteScreenState();
}

class _NoteScreenState extends State<NoteScreen> {
  final DatabaseService _dbService = DatabaseService();

  @override
  Widget build(BuildContext context) {
    final authService = Provider.of<AuthService>(context);

    return StreamBuilder<UserModel?>(
      stream: authService.currentUser,
      builder: (context, userSnapshot) {
        if (userSnapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        if (!userSnapshot.hasData || userSnapshot.data == null) {
          return const Center(child: Text("Utilisateur non connecté"));
        }

        final user = userSnapshot.data!;

        return Column(
          children: [
            TeacherCard(
              name: user.fullName,
              email: user.email,
              profileImageUrl: 'https://www.example.com/default-profile-image.png',
              subjectCount: 3,
            ),
            Expanded(
              child: StreamBuilder<List<Grade>>(
                stream: _dbService.getAllGrades(),
                builder: (context, snapshot) {
                  if (!snapshot.hasData) return const Center(child: CircularProgressIndicator());

                  final grades = snapshot.data!;
                  if (grades.isEmpty) return const Center(child: Text('Aucune note enregistrée.'));

                  return ListView.builder(
                    itemCount: grades.length,
                    itemBuilder: (context, index) {
                      final grade = grades[index];
                      return ListTile(
                        title: Text('Note: ${grade.value}/20'),
                        subtitle: Text('Étudiant ID: ${grade.studentId} | Matière ID: ${grade.subjectId}'),
                        trailing: Text(grade.dateRecorded.toLocal().toString().split(' ')[0]),
                      );
                    },
                  );
                },
              ),
            ),
          ],
        );
      },
    );
  }
}
