import 'package:flutter/material.dart';
import '../../constants/colors.dart';
import '../../models/user.dart';
import '../../ui/grade_entry_dialog.dart';
import '../../ui/student_card.dart';
import '../../ui/search_zone.dart';
import '../../ui/teacher_card.dart';
import '../../ui/teacher_card_deco.dart';
import '../../ui/year_drop.dart';
import '../../ui/class_filter.dart';
import '../../ui/subject_filter.dart';
import '../../ui/session_filter.dart';

class NoteScreen extends StatefulWidget {
  const NoteScreen({super.key});

  @override
  State<NoteScreen> createState() => _NoteScreenState();
}

class _NoteScreenState extends State<NoteScreen> {
  final TextEditingController _searchController = TextEditingController();
  final ValueNotifier<int> selectedTab = ValueNotifier<int>(0);
  final int totalStudentImages = 3;

  String? selectedYear;
  String? selectedClass;
  String? selectedSubject;
  String? selectedSession;

  final List<String> availableYears = ['2023-2024', '2022-2023'];
  late List<String> _allSubjects;
  final List<String> _allSessions = ['Session 1', 'Session 2'];
  late List<String> _classes;
  late List<UserModel> _students;

  late Map<String, Map<String, Map<String, double>>> _studentGrades;

  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    selectedYear = DateTime.now().year.toString();
    _searchController.addListener(_onSearchChanged);
    _loadLocalData();
  }

  Future<void> _loadLocalData() async {
    setState(() => isLoading = true);

    _students = [
      UserModel(
        id: 'stu1',
        firstName: 'Alice',
        lastName: 'Durand',
        createdAt: DateTime(2022, 9, 1),
        email: 'alice.durand@example.com',
        role: UserRole.student,
        className: 'Classe A',
        photoUrl: '',
        assignedClassIds: ['classA'],
        taughtSubjectIds: [],
        createdBy: 'admin1',
        department: 'Sciences',
        studentId: 'S1001',
        teacherId: 'T001',
        lastAdminAction: DateTime(2024, 5, 20),
        isActive: true,
        isSuperAdmin: false,
      ),
      UserModel(
        id: 'stu2',
        firstName: 'Bob',
        lastName: 'Martin',
        createdAt: DateTime(2021, 9, 1),
        email: 'bob.martin@example.com',
        role: UserRole.student,
        className: 'Classe B',
        photoUrl: '',
        assignedClassIds: ['classB'],
        taughtSubjectIds: [],
        createdBy: 'admin2',
        department: 'Lettres',
        studentId: 'S1002',
        teacherId: 'T002',
        lastAdminAction: DateTime(2024, 4, 15),
        isActive: true,
        isSuperAdmin: false,
      ),
      UserModel(
        id: 'stu3',
        firstName: 'Clara',
        lastName: 'Lemoine',
        createdAt: DateTime(2023, 1, 15),
        email: 'clara.lemoine@example.com',
        role: UserRole.student,
        className: 'Classe A',
        photoUrl: '',
        assignedClassIds: ['classA'],
        taughtSubjectIds: [],
        createdBy: 'admin1',
        department: 'Sciences',
        studentId: 'S1003',
        teacherId: 'T001',
        lastAdminAction: DateTime(2024, 6, 1),
        isActive: true,
        isSuperAdmin: false,
      ),
    ];

    _allSubjects = ['Math', 'Physique', 'Français'];

    _classes = _students
        .map((s) => s.className ?? '')
        .where((c) => c.isNotEmpty)
        .toSet()
        .toList();

    _studentGrades = {
      'stu1': {
        'Math': {
          'Session 1': 15,
          'Session 2': 16,
        },
        'Physique': {
          'Session 1': 14,
          'Session 2': 15,
        },
      },
      'stu2': {
        'Math': {
          'Session 1': 12,
          'Session 2': 13,
        },
        'Français': {
          'Session 1': 14,
          'Session 2': 14,
        },
      },
      'stu3': {
        'Français': {
          'Session 1': 18,
          'Session 2': 17,
        },
        'Physique': {
          'Session 1': 13,
          'Session 2': 12,
        },
      },
    };

    await Future.delayed(const Duration(milliseconds: 300));
    setState(() => isLoading = false);
  }

  void _onSearchChanged() => setState(() {});

  List<UserModel> _filterStudents(String searchText) {
    List<UserModel> filtered = _students;

    if (selectedClass != null) {
      filtered = filtered.where((s) => s.className == selectedClass).toList();
    }

    if (searchText.isNotEmpty) {
      filtered = filtered.where((s) {
        final name = s.fullName.toLowerCase();
        final q = searchText.toLowerCase();
        return name.contains(q) ||
            s.firstName.toLowerCase().contains(q) ||
            s.lastName.toLowerCase().contains(q);
      }).toList();
    }

    if (selectedTab.value == 2 && selectedSubject != null) {
      filtered = filtered.where((s) {
        final gradesBySubject = _studentGrades[s.id];
        return gradesBySubject?.containsKey(selectedSubject!) ?? false;
      }).toList();
    }

    if (selectedTab.value == 0 && selectedSession != null) {
      filtered = filtered.where((s) {
        final gradesBySubject = _studentGrades[s.id];
        if (gradesBySubject == null) return false;
        return gradesBySubject.values.any((sessions) => sessions.containsKey(selectedSession));
      }).toList();
    }

    return filtered;
  }

  List<String> _getSubjectsForStudent(String studentId) {
    final gradesBySubject = _studentGrades[studentId];
    if (gradesBySubject == null) return [];
    if (selectedSubject != null) {
      return gradesBySubject.containsKey(selectedSubject!) ? [selectedSubject!] : [];
    }
    return gradesBySubject.keys.toList();
  }
 final String name = "Mme. Dupont";
  final String email = "dupont.teacher@example.com";
  final String profileImageUrl = "assets/teacher_profile.png";
  final int subjectCount = 3;
  final int classCount = 2;
  final List<String> subjects = ["Math", "Physique", "Français"];
  final List<String> classes = ["Classe A", "Classe B"];
  List<double> _getGradesForStudentAndSubjects(String studentId, List<String> subjects) {
    final gradesBySubject = _studentGrades[studentId];
    if (gradesBySubject == null) return [];

    List<double> grades = [];
    for (var subject in subjects) {
      final sessions = gradesBySubject[subject];
      if (sessions == null) continue;

      if (selectedSession != null) {
        final grade = sessions[selectedSession!];
        if (grade != null) grades.add(grade);
      } else {
        grades.addAll(sessions.values);
      }
    }
    return grades;
  }

  double _calculateAverage(String studentId) {
    final allGrades = _getGradesForStudentAndSubjects(studentId, _getSubjectsForStudent(studentId));
    if (allGrades.isEmpty) return 0.0;
    final sum = allGrades.reduce((a, b) => a + b);
    return sum / allGrades.length;
  }

  String _getStudentImageAsset(int index) {
    final imageNumber = (index % totalStudentImages) + 1;
    return 'assets/student_$imageNumber.png';
  }

  String _getNoResultsMessage() {
    if (selectedClass != null) return "Aucun étudiant dans la classe $selectedClass";
    if (selectedSubject != null) return "Aucun étudiant n'a de notes en $selectedSubject";
    if (selectedSession != null) return "Aucun étudiant dans la session $selectedSession";
    if (_searchController.text.isNotEmpty) return "Aucun étudiant trouvé";
    return "Aucun étudiant disponible";
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : Column(
              children: [
 const SizedBox(height: 50),
                TeacherCard(name: name, email: email, profileImageUrl: profileImageUrl, subjectCount: subjectCount, classCount: classCount, subjects: subjects, classes: classes, onAddPressed: (){

                }),
                 
                    
                   TeacherCardDeco(imagePaths: ['assets/registerd_school.jpg','assets/student_black.jpg']),
          const SizedBox(height: 16),
          Container(
margin: const EdgeInsets.symmetric(horizontal: 16),
 child:SearchZone(controller: _searchController),
          ),
          
                const SizedBox(height: 8),
                // YearSelectorDropdown(
                //   years: availableYears,
                //   selectedYear: selectedYear,
                //   onChanged: (val) => setState(() => selectedYear = val),
                // ),
                ClassFilter(
                  classes: _classes,
                  selectedClass: selectedClass,
                  onClassSelected: (val) => setState(() => selectedClass = val),
                ),
                SubjectFilter(
                  subjects: _allSubjects,
                  selectedSubject: selectedSubject,
                  onSubjectSelected: (val) => setState(() => selectedSubject = val),
                ),
                SessionFilter(
                  sessions: _allSessions,
                  selectedSession: selectedSession,
                  onSessionSelected: (val) => setState(() => selectedSession = val),
                ),
                const SizedBox(height: 8),
                Expanded(
                  child: ValueListenableBuilder<int>(
                    valueListenable: selectedTab,
                    builder: (context, tabIndex, _) {
                      final filteredStudents = _filterStudents(_searchController.text);

                      if (filteredStudents.isEmpty) {
                        return Center(
                          child: Text(
                            _getNoResultsMessage(),
                            style: const TextStyle(fontSize: 16),
                          ),
                        );
                      }

                      return ListView.builder(
                        padding: const EdgeInsets.all(16),
                        itemCount: filteredStudents.length,
                        itemBuilder: (context, index) {
                          final student = filteredStudents[index];
                          final avg = _calculateAverage(student.id);
                          final imageAsset = _getStudentImageAsset(index);

                          final subjects = _getSubjectsForStudent(student.id);
                          final grades = _getGradesForStudentAndSubjects(student.id, subjects);

                          return StudentCard(
                            studentName: student.fullName,
                            studentClass: student.className ?? 'N/A',
                            studentPhotoAsset: imageAsset,
                            subjectNames: subjects,
                            subjectGrades: grades,
                            progress: avg / 20.0, // Convertir en valeur entre 0 et 1
                            onProfileTap: () {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(content: Text('Profil de ${student.fullName}')),
                              );
                            },
                            
                          );
                        },
                      );
                    },
                  ),
                ),
              ],
            ),
    );
  }
}