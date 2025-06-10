import 'package:flutter/material.dart';
import '../../constants/colors.dart';
import '../../models/user.dart';
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
  final TextEditingController _searchController = TextEditingController();
  final List<String> availableYears = ['2023-2024', '2022-2023'];
  final ValueNotifier<int> selectedTab = ValueNotifier<int>(0);
  final int totalStudentImages = 3;
  String? selectedYear;

  final List<UserModel> _students = [
    UserModel(
      id: 's1',
      firstName: 'Alice',
      lastName: 'Ngoua',
      email: 'alice@example.com',
      role: UserRole.student,
      createdAt: DateTime(2023, 9, 1),
    ),
    UserModel(
      id: 's2',
      firstName: 'Brice',
      lastName: 'Yaoundé',
      email: 'brice@example.com',
      role: UserRole.student,
      createdAt: DateTime(2023, 9, 1),
    ),
    UserModel(
      id: 's3',
      firstName: 'Chantal',
      lastName: 'Bafoussam',
      email: 'chantal@example.com',
      role: UserRole.student,
      createdAt: DateTime(2023, 9, 1),
    ),
  ];

  final Map<String, List<String>> _subjectsByStudent = {
    's1': ['Mathématiques', 'Info', 'Hacking'],
    's2': ['BD', 'ML'],
    's3': ['Linux', 'Reseaux'],
  };


  final Map<String, List<double>> _gradesByStudent = {
    's1': [12.0, 14.5, 17.0],
    's2': [8.0, 10.0],
    's3': [15.0, 13.5],
  };

  @override
  void initState() {
    super.initState();
    selectedYear = availableYears.first;
  }

  double _calculateAverage(String studentId) {
    final grades = _gradesByStudent[studentId] ?? [];
    if (grades.isEmpty) return 0.0;
    final sum = grades.reduce((a, b) => a + b);
    return (sum / grades.length / 20.0).clamp(0.0, 1.0);
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

  @override
  void dispose() {
    _searchController.dispose();
    selectedTab.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final filteredStudents = _searchController.text.isEmpty
        ? _students
        : _students
            .where((s) => s.fullName.toLowerCase().contains(_searchController.text.toLowerCase()))
            .toList();

    return Scaffold(
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16.0, 40.0, 16.0, 16.0),
            child: Row(
              children: [
                const Text(
                  "Bonjour, Emirate Caib",
                  style: TextStyle(fontSize: 20, color: AppColors.textPrimary),
                ),
                const Spacer(),
                YearSelectorDropdown(
                  years: availableYears,
                  selectedYear: selectedYear,
                  onChanged: (value) => setState(() => selectedYear = value),
                ),
              ],
            ),
          ),
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  const TeacherCardDeco(imagePath: 'assets/teacher_picture.jpg'),
                  TeacherCard(
                    name: 'Emirate Caib',
                    email: 'emirate@example.com',
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
                  ListView.builder(
                    physics: const NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    itemCount: filteredStudents.length,
                    itemBuilder: (context, index) {
                      final student = filteredStudents[index];
                      final subjects = _subjectsByStudent[student.id] ?? [];
                      final grades = _gradesByStudent[student.id] ?? [];
                      final progress = _calculateAverage(student.id);

                      return Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                        child: StudentCard(
                          studentName: student.fullName,
                          studentPhotoUrl: '',
                          studentPhotoAsset: _getStudentImageAsset(index),
                          subjectNames: subjects,
                          subjectGrades: grades,
                          progress: progress,
                          onProfileTap: () {},
                        ),
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
  }
}
