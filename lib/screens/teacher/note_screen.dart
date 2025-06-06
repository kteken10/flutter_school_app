import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../models/grade.dart';
import '../../models/user.dart';
import '../../services/auth_service.dart';
import '../../services/database_service.dart';

import '../../ui/teacher_card.dart';
import '../../ui/card_note.dart';
import '../../ui/add_icons.dart';
import '../../ui/grade_entry_dialog.dart'; // <-- Ajoute cet import

class NoteScreen extends StatefulWidget {
  const NoteScreen({super.key});

  @override
  State<NoteScreen> createState() => _NoteScreenState();
}

class _NoteScreenState extends State<NoteScreen> {
  final DatabaseService _dbService = DatabaseService();

  Future<UserModel?> getStudentById(String studentId) async {
    return await _dbService.getUserById(studentId);
  }

  void _onAddNote() {
    showDialog(
      context: context,
      builder: (context) => GradeEntryDialog(
        onGradeSubmitted: () {
          setState(() {}); // Rafraîchir la liste après ajout
        },
      ),
    );
  }

  

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
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 20.0),
              child: Row(
                children: [
                  const Text(
                    "Notes",
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const Spacer(),
                  AddIcon(
                    onTap: _onAddNote,
                  ),
                ],
              ),
            ),
            // TeacherCard(
            //   name: user.fullName,
            //   email: user.email,
            //   profileImageUrl: user.photoUrl ?? 'https://www.example.com/default-profile-image.png',
            //   subjectCount: 3,
            // ),
            Expanded(
              child: StreamBuilder<List<Grade>>(
                stream: _dbService.getAllGrades(),
                builder: (context, snapshot) {
                  if (!snapshot.hasData) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  final grades = snapshot.data!;
                  if (grades.isEmpty) {
                    return const Center(child: Text('Aucune note enregistrée.'));
                  }

                  return ListView.builder(
                    itemCount: grades.length,
                    itemBuilder: (context, index) {
                      final grade = grades[index];
                      return FutureBuilder<UserModel?>(
                        future: getStudentById(grade.studentId),
                        builder: (context, studentSnapshot) {
                          if (!studentSnapshot.hasData) {
                            return const SizedBox(height: 80);
                          }
                          final student = studentSnapshot.data!;
                          return CardNote(
                            studentName: student.fullName,
                            studentClass: student.className ?? 'Classe',
                            studentPhotoUrl: student.photoUrl ?? 'https://www.example.com/default-profile-image.png',
                            note: grade.value,
                            onProfileTap: () {
                              // Action pour voir le détail du profil
                            },
                          );
                        },
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