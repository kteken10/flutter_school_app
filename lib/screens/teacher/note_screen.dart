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
  final List<String> availableYears = ['2023-2024', '2022-2023', '2021-2022'];
  final ValueNotifier<int> selectedTab = ValueNotifier<int>(0);
  final int totalStudentImages = 3;

  @override
  void initState() {
    super.initState();
    selectedYear = availableYears.first;
  }

  String _getStudentImageAsset(int index) {
    final imageNumber = (index % totalStudentImages) + 1;
    return 'assets/student_$imageNumber.png';
  }

  void _onAddNote() {
    showDialog(
      context: context,
      builder: (context) => GradeEntryDialog(
        onGradeSubmitted: () => setState(() {}),
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

  Future<double> getAverageGrade(String studentId) async {
    final grades = await _dbService.getStudentGrades(studentId).first;
    if (grades.isEmpty) return 0.0;
    final sum = grades.fold(0.0, (prev, g) => prev + g.value);
    return (sum / grades.length / 20.0).clamp(0.0, 1.0);
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

        if (!userSnapshot.hasData) {
          return const Center(child: Text("Utilisateur non connecté"));
        }

        final user = userSnapshot.data!;

        return Scaffold(
          body: Column(
            children: [
              // En-tête fixe
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
                      onChanged: (newValue) => setState(() => selectedYear = newValue),
                    ),
                  ],
                ),
              ),

              // Contenu scrollable
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      const TeacherCardDeco(imagePath: 'assets/teacher_picture.jpg'),
                      TeacherCard(
                        name: user.fullName,
                        email: user.email,
                        profileImageUrl: '',
                        subjectCount: 3,
                        classCount: 5,
                        subjects: ['Mathématiques', 'Physique', 'SVT'],
                        classes: ['6e A', '5e B', '4e C', '3e D', 'Terminale S'],
                        onAddPressed: _onAddNote,
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
                        onTabSelected: (index) => selectedTab.value = index,
                      ),
                      ValueListenableBuilder<int>(
                        valueListenable: selectedTab,
                        builder: (context, index, _) {
                          return Padding(
                            padding: const EdgeInsets.fromLTRB(16, 8, 16, 4),
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
                      StreamBuilder<List<UserModel>>(
                        stream: _dbService.getStudents(),
                        builder: (context, snapshot) {
                          if (!snapshot.hasData) {
                            return const Center(child: CircularProgressIndicator());
                          }

                          final students = snapshot.data!;
                          final filteredStudents = _searchController.text.isEmpty
                              ? students
                              : students
                                  .where((s) => s.fullName
                                      .toLowerCase()
                                      .contains(_searchController.text.toLowerCase()))
                                  .toList();

                          if (filteredStudents.isEmpty) {
                            return const Padding(
                              padding: EdgeInsets.all(20),
                              child: Text("Aucun étudiant trouvé."),
                            );
                          }

                          return ListView.builder(
                            physics: const NeverScrollableScrollPhysics(),
                            padding: const EdgeInsets.only(bottom: 4),
                            shrinkWrap: true,
                            itemCount: filteredStudents.length,
                            itemBuilder: (context, index) {
                              final student = filteredStudents[index];
                              return FutureBuilder(
                                future: Future.wait([
                                  getSubjectsForStudent(student.id),
                                  getAverageGrade(student.id),
                                ]),
                                builder: (context, snapshot) {
                                  if (!snapshot.hasData) {
                                    return const SizedBox(height: 10);
                                  }

                                  final subjectNames = snapshot.data![0] as List<String>;
                                  final progress = snapshot.data![1] as double;

                                  return Padding(
                                    padding: const EdgeInsets.symmetric(horizontal: 16),
                                    child: StudentCard(
                                      studentName: student.fullName,
                                      studentPhotoUrl: student.photoUrl,
                                      studentPhotoAsset: _getStudentImageAsset(index),
                                      subjectNames: subjectNames,
                                      progress: progress,
                                      onProfileTap: () {
                                        // Action sur le profil de l’étudiant
                                      },
                                    ),
                                  );
                                },
                              );
                            },
                          );
                        },
                      ),
                      const SizedBox(height: 12),
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
