import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../constants/colors.dart';
import '../../models/subject.dart';
import '../../models/user.dart';
import '../../services/auth_service.dart';
import '../../services/database_service.dart';

import '../../ui/teacher_card.dart';
import '../../ui/teacher_card_deco.dart';
import '../../ui/grade_entry_dialog.dart';
import '../../ui/student_card.dart';
import '../../ui/search_zone.dart';
import '../../ui/year_drop.dart';
import '../../ui/tab_filter.dart';

class NoteScreen extends StatefulWidget {
  const NoteScreen({super.key});

  @override
  State<NoteScreen> createState() => _NoteScreenState();
}

class _NoteScreenState extends State<NoteScreen> {
  final DatabaseService _dbService = DatabaseService();
  final TextEditingController _searchController = TextEditingController();
  String? selectedYear;
  final List<String> availableYears = [
    '2023-2024',
    '2022-2023',
    '2021-2022',
  ];

  // Utilisation d'un ValueNotifier pour selectedTab
  final ValueNotifier<int> selectedTab = ValueNotifier<int>(0);

  @override
  void initState() {
    super.initState();
    selectedYear = availableYears.first;
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

  Future<List<String>> getSubjectsForStudent(String studentId) async {
    final grades = await _dbService.getStudentGrades(studentId).first;
    final subjectIds = grades.map((g) => g.subjectId).toSet().toList();
    final futures = subjectIds.map((id) => _dbService.getSubjectById(id));
    final subjects = await Future.wait(futures);
    return subjects.whereType<Subject>().map((s) => s.name).toList();
  }

  @override
  void dispose() {
    _searchController.dispose();
    selectedTab.dispose();
    super.dispose();
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

        return Scaffold(
          body: Column(
            children: [
              // Ligne de bienvenue + année à droite avec fond blanc
              Padding(
                padding: const EdgeInsets.fromLTRB(16.0, 40.0, 16.0, 16.0),
                child: Row(
                  children: [
                    Text(
                      "Bonjour, ${user.fullName}",
                      style: const TextStyle(
                        fontSize: 20,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    const Spacer(),
                    YearSelectorDropdown(
                      years: availableYears,
                      selectedYear: selectedYear,
                      onChanged: (String? newValue) {
                        setState(() {
                          selectedYear = newValue;
                        });
                      },
                    ),
                  ],
                ),
              ),

              // Contenu scrollable
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      const TeacherCardDeco(),
                      TeacherCard(
                        name: user.fullName,
                        email: user.email,
                        profileImageUrl: user.photoUrl ??
                            'https://www.example.com/default-profile-image.png',
                        subjectCount: 3,
                        classCount: 5,
                        subjects: ['Mathématiques', 'Physique', 'SVT'],
                        classes: ['6e A', '5e B', '4e C', '3e D', 'Terminale S'],
                        onAddPressed: _onAddNote,
                      ),

                      // Zone de recherche
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        child: SearchZone(
                          controller: _searchController,
                          hintText: "Rechercher un étudiant...",
                          showSearchIcon: true,
                        ),
                      ),

                      const SizedBox(height: 10),

                      // AcademicTabFilter avec ValueNotifier
                      AcademicTabFilter(
                        tabs: ['Sessions', 'Classes', 'Matières'],
                        onTabSelected: (index) {
                          selectedTab.value = index;
                        },
                      ),

                      // Titre dynamique selon selectedTab
                      ValueListenableBuilder<int>(
                        valueListenable: selectedTab,
                        builder: (context, index, _) {
                          return Padding(
                            padding: const EdgeInsets.fromLTRB(16, 18, 16, 6),
                            child: Row(
                              children: [
                                Text(
                                  index == 0
                                      ? "Mes étudiants"
                                      : index == 1
                                          ? "Par classe"
                                          : "Par matière",
                                  style: const TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600,
                                    color: AppColors.primary,
                                  ),
                                ),
                              ],
                            ),
                          );
                        },
                      ),

                      // Liste des étudiants (non reload à chaque tab)
                      StreamBuilder<List<UserModel>>(
                        stream: _dbService.getStudents(),
                        builder: (context, snapshot) {
                          if (!snapshot.hasData) {
                            return const Center(
                                child: CircularProgressIndicator());
                          }

                          final students = snapshot.data!;
                          if (students.isEmpty) {
                            return const Padding(
                              padding: EdgeInsets.all(16.0),
                              child: Center(
                                child: Text(
                                  'Aucun étudiant trouvé',
                                  style: TextStyle(color: AppColors.textSecondary),
                                ),
                              ),
                            );
                          }

                          return ListView.builder(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            padding: const EdgeInsets.only(bottom: 20),
                            itemCount: students.length,
                            itemBuilder: (context, index) {
                              final student = students[index];
                              return FutureBuilder<List<String>>(
                                future: getSubjectsForStudent(student.id),
                                builder: (context, subjectSnapshot) {
                                  final subjectNames = subjectSnapshot.data ?? [];
                                  return Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 16, vertical: 4),
                                    child: StudentCard(
                                      studentName: student.fullName,
                                      studentPhotoUrl: student.photoUrl ??
                                          'https://www.example.com/default-profile-image.png',
                                      subjectNames: subjectNames,
                                      onProfileTap: () {
                                        // Action pour voir le détail du profil
                                      },
                                    ),
                                  );
                                },
                              );
                            },
                          );
                        },
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
