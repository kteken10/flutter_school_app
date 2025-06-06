import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../constants/colors.dart';
import '../../models/subject.dart';
import '../../models/user.dart';
import '../../services/auth_service.dart';
import '../../services/database_service.dart';

import '../../ui/teacher_card.dart';
import '../../ui/teacher_card_deco.dart';
import '../../ui/add_icons.dart';
import '../../ui/grade_entry_dialog.dart';
import '../../ui/student_card.dart';
import '../../ui/tab_filter.dart';
import '../../ui/search_zone.dart';

class NoteScreen extends StatefulWidget {
  const NoteScreen({super.key});

  @override
  State<NoteScreen> createState() => _NoteScreenState();
}

class _NoteScreenState extends State<NoteScreen> {
  final DatabaseService _dbService = DatabaseService();
  int selectedTab = 0;
  final TextEditingController _searchController = TextEditingController();

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

  // Récupère les matières pour un étudiant donné
  Future<List<String>> getSubjectsForStudent(String studentId) async {
    final grades = await _dbService.getStudentGrades(studentId).first;
    final subjectIds = grades.map((g) => g.subjectId).toSet().toList();
    final futures = subjectIds.map((id) => _dbService.getSubjectById(id));
    final subjects = await Future.wait(futures);
    return subjects.whereType<Subject>().map((s) => s.name).toList();
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
            // Affiche le nom de l'enseignant en entête
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 20.0),
              child: Row(
                children: [
                  Text(
                    "Hi,${user.fullName}",
                    style: const TextStyle(
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
            // Carte décorative
          
        const TeacherCardDeco(),
                    TeacherCard(
              name: user.fullName,
              email: user.email,
              profileImageUrl: user.photoUrl ?? 'https://www.example.com/default-profile-image.png',
              subjectCount: 3,
              classCount: 5,
              subjects: ['Mathématiques', 'Physique', 'SVT'], // À remplacer par la vraie liste
              classes: ['6e A', '5e B', '4e C', '3e D', 'Terminale S'], // À remplacer par la vraie liste
            ),
              
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: SearchZone(
                controller: _searchController,
                hintText: "Rechercher un étudiant...",
                showSearchIcon: true,
              ),
            ),
            const SizedBox(height: 10),
            AcademicTabFilter(
              tabs: ['Sessions', 'Classes', 'Matières'],
              onTabSelected: (index) {
                // Laisse vide si tu ne veux pas filtrer la liste
              },
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 18, 16, 6),
              child: Row(
                children: [
                  const Text(
                    "Mes étudiants",
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: AppColors.primary,
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: StreamBuilder<List<UserModel>>(
                stream: _dbService.getStudents(),
                builder: (context, snapshot) {
                  if (!snapshot.hasData) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  final students = snapshot.data!;
                  if (students.isEmpty) {
                    return const Center(child: Text('Aucun étudiant trouvé.'));
                  }

                  return ListView.builder(
                    itemCount: students.length,
                    itemBuilder: (context, index) {
                      final student = students[index];
                      return FutureBuilder<List<String>>(
                        future: getSubjectsForStudent(student.id),
                        builder: (context, subjectSnapshot) {
                          final subjectNames = subjectSnapshot.data ?? [];
                          return StudentCard(
                            studentName: student.fullName,
                            studentPhotoUrl: student.photoUrl ?? 'https://www.example.com/default-profile-image.png',
                            subjectNames: subjectNames,
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