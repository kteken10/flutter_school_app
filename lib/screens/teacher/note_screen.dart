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
import '../../ui/class_filter.dart'; // Nouvel import

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
  String? selectedClass;

  final List<UserModel> _students = [
    UserModel(
      id: 's1',
      firstName: 'Alice',
      lastName: 'Ngoua',
      email: 'alice@example.com',
      role: UserRole.student,
      className: 'L1',
      createdAt: DateTime(2023, 9, 1),
    ),
    UserModel(
      id: 's2',
      firstName: 'Brice',
      lastName: 'Yaoundé',
      email: 'brice@example.com',
      role: UserRole.student,
      className: 'L2',
      createdAt: DateTime(2023, 9, 1),
    ),
    UserModel(
      id: 's3',
      firstName: 'Chantal',
      lastName: 'Bafoussam',
      email: 'chantal@example.com',
      role: UserRole.student,
      className: 'L3',
      createdAt: DateTime(2023, 9, 1),
    ),
    UserModel(
      id: 's4',
      firstName: 'David',
      lastName: 'Douala',
      email: 'david@example.com',
      role: UserRole.student,
      className: 'M1',
      createdAt: DateTime(2023, 9, 1),
    ),
    UserModel(
      id: 's5',
      firstName: 'Eva',
      lastName: 'Garoua',
      email: 'eva@example.com',
      role: UserRole.student,
      className: 'M2',
      createdAt: DateTime(2023, 9, 1),
    ),
  ];

  final Map<String, List<String>> _subjectsByStudent = {
    's1': ['Mathématiques', 'Info', 'Hacking'],
    's2': ['BD', 'ML'],
    's3': ['Linux', 'Reseaux'],
    's4': ['IA', 'Big Data'],
    's5': ['Cloud Computing', 'DevOps'],
  };

  final Map<String, List<double>> _gradesByStudent = {
    's1': [12.0, 14.5, 17.0],
    's2': [8.0, 10.0],
    's3': [15.0, 13.5],
    's4': [16.0, 14.0],
    's5': [18.0, 19.5],
  };

  @override
  void initState() {
    super.initState();
    selectedYear = availableYears.first;
    _searchController.addListener(_onSearchChanged);
  }

  void _onSearchChanged() {
    setState(() {});
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

  List<UserModel> _filterStudents(String searchText) {
    List<UserModel> filtered = _students;
    
    if (selectedClass != null) {
      filtered = filtered.where((student) => student.className == selectedClass).toList();
    }
    
    if (searchText.isNotEmpty) {
      filtered = filtered.where((student) {
        final fullName = student.fullName.toLowerCase();
        final searchLower = searchText.toLowerCase();
        return fullName.contains(searchLower) ||
            student.firstName.toLowerCase().contains(searchLower) ||
            student.lastName.toLowerCase().contains(searchLower);
      }).toList();
    }
    
    return filtered;
  }

  void _onClassSelected(String? className) {
    setState(() {
      selectedClass = className;
    });
  }

  @override
  void dispose() {
    _searchController.removeListener(_onSearchChanged);
    _searchController.dispose();
    selectedTab.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final filteredStudents = _filterStudents(_searchController.text);
    final classes = ['L1', 'L2', 'L3', 'M1', 'M2'];

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
                    name: 'Aziz Deboule',
                    email: 'emirate@example.com',
                    profileImageUrl: '',
                    subjectCount: 3,
                    classCount: 5,
                    subjects: ['Linux', 'Big Data', 'Machine Learning'],
                    classes: classes,
                    onAddPressed: _onAddNote,
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: SearchZone(
                      controller: _searchController,
                      hintText: "Rechercher un étudiant...",
                      showSearchIcon: true,
                      onChanged: (value) => setState(() {}), 
                    ),
                  ),
                  const SizedBox(height: 10),
                  AcademicTabFilter(
                    tabs: ['Sessions', 'Classes', 'Matières'],
                    onTabSelected: (index) {
                      selectedTab.value = index;
                      if (index == 1) {
                        selectedClass = null;
                      }
                    },
                  ),
                  ValueListenableBuilder<int>(
                    valueListenable: selectedTab,
                    builder: (context, index, _) {
                      if (index == 1) {
                        return ClassFilter(
                          classes: classes,
                          selectedClass: selectedClass,
                          onClassSelected: _onClassSelected,
                        );
                      }
                      
                      return Padding(
                        padding: const EdgeInsets.fromLTRB(16, 8, 16, 4),
                        child: Row(
                          children: [
                            Text(
                              index == 0 ? "Mes étudiants" : "Par matière",
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                                color: AppColors.primary,
                              ),
                            ),
                            if (filteredStudents.isEmpty && _searchController.text.isNotEmpty)
                              Padding(
                                padding: const EdgeInsets.only(left: 8.0),
                                child: Text(
                                  "Aucun résultat pour '${_searchController.text}'",
                                  style: const TextStyle(
                                    fontSize: 14,
                                    color: AppColors.textSecondary,
                                  ),
                                ),
                              ),
                          ],
                        ),
                      );
                    },
                  ),
                  if (filteredStudents.isEmpty)
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Text(
                        selectedClass != null
                            ? "Aucun étudiant dans la classe $selectedClass"
                            : "Aucun étudiant ne correspond à votre recherche",
                        style: TextStyle(
                          color: AppColors.textSecondary.withOpacity(0.7),
                        ),
                      ),
                    )
                  else
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
                            studentClass: student.className ?? 'N/A',
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