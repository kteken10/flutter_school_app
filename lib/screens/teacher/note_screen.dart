import 'package:flutter/material.dart';
import '../../constants/colors.dart';
import '../../models/user.dart';
import '../../ui/grade_entry_dialog.dart';
import '../../ui/student_card.dart';
import '../../ui/search_zone.dart';
import '../../ui/teacher_card.dart';
import '../../ui/teacher_card_deco.dart';
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
  final List<String> _allSessions = ['Contrôle Continu', 'Session Normale'];
  late List<String> _classes = ['L1', 'L2', 'L3'];
  
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

  void _onAddNote() {
    showDialog(
      context: context,
      builder: (context) => GradeEntryDialog(
        onGradeSubmitted: () => setState(() {}),
        students: _students,
        classes: _classes,
        subjects: _allSubjects,
        onSubmit: (student, subject, sessionType, grade, comment) {
          setState(() {
            if (!_studentGrades.containsKey(student.id)) {
              _studentGrades[student.id] = {};
            }
            if (!_studentGrades[student.id]!.containsKey(subject)) {
              _studentGrades[student.id]![subject] = {};
            }
            _studentGrades[student.id]![subject]![sessionType] = grade;
            
            // Afficher un message de confirmation
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('Note ajoutée pour ${student.fullName}'),
                duration: const Duration(seconds: 2),
              ),
            );
          });
        },
      ),
    );
  }

  Future<void> _loadLocalData() async {
    setState(() => isLoading = true);

    _students = [
      UserModel(
        id: 'stu1',
        firstName: 'Jean',
        lastName: 'Dupont',
        createdAt: DateTime.parse('2022-09-01T00:00:00'),
        email: 'jean.dupont@univ-example.com',
        role: UserRole.student,
        className: 'L1',
        photoUrl: '',
        assignedClassIds: [],
        taughtSubjectIds: [],
        createdBy: 'admin1',
        department: 'Informatique',
        studentId: 'S1001',
        teacherId: 'T001',
        lastAdminAction: DateTime.parse('2025-01-15T00:00:00'),
        isActive: true,
        isSuperAdmin: false,
      ),
      UserModel(
        id: 'stu2',
        firstName: 'Marie',
        lastName: 'Martin',
        createdAt: DateTime.parse('2022-09-01T00:00:00'),
        email: 'marie.martin@univ-example.com',
        role: UserRole.student,
        className: 'L2',
        photoUrl: '',
        assignedClassIds: [],
        taughtSubjectIds: [],
        createdBy: 'admin1',
        department: 'Informatique',
        studentId: 'S1002',
        teacherId: 'T001',
        lastAdminAction: DateTime.parse('2025-01-15T00:00:00'),
        isActive: true,
        isSuperAdmin: false,
      ),
      UserModel(
        id: 'stu20',
        firstName: 'Julie',
        lastName: 'Morel',
        createdAt: DateTime.parse('2022-02-16T00:00:00'),
        email: 'julie.morel@univ-example.com',
        role: UserRole.student,
        className: 'L3',
        photoUrl: '',
        assignedClassIds: [],
        taughtSubjectIds: [],
        createdBy: 'admin3',
        department: 'Informatique',
        studentId: 'S1020',
        teacherId: 'T001',
        lastAdminAction: DateTime.parse('2025-03-18T00:00:00'),
        isActive: true,
        isSuperAdmin: false,
      ),
    ];

    _allSubjects = [
      'Linux',
      'Base de données',
      'Algorithmique',
      'Développement Web',
      'Développement Mobile',
      'Réseaux',
      'Cloud Computing',
      'DevOps',
      'Intelligence Artificielle',
      'Machine Learning',
    ];

    _studentGrades = {
      'stu1': {
        'Algorithmique': {'Contrôle Continu': 17, 'Session Normale': 12},
        'Cloud Computing': {'Contrôle Continu': 11, 'Session Normale': 14},
        'DevOps': {'Contrôle Continu': 12, 'Session Normale': 12},
        'Linux': {'Contrôle Continu': 10, 'Session Normale': 18},
        'Machine Learning': {'Contrôle Continu': 17, 'Session Normale': 17}
      },
      'stu20': {
        'Base de données': {'Session Normale': 14},
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

    if (selectedSubject != null) {
      filtered = filtered.where((s) {
        final gradesBySubject = _studentGrades[s.id];
        return gradesBySubject?.containsKey(selectedSubject!) ?? false;
      }).toList();
    }

    if (selectedSession != null) {
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
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: AppColors.background,
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              padding: const EdgeInsets.symmetric(vertical: 50),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  TeacherCard(
                    name: "Prof. Smith",
                    email: "prof.smith@univ.com",
                    profileImageUrl: "",
                    subjectCount: _allSubjects.length,
                    classCount: _classes.length,
                    subjects: _allSubjects,
                    classes: _classes,
                    onAddPressed: _onAddNote,
                  ),
                  const SizedBox(height: 16),
                  TeacherCardDeco(imagePaths: ['assets/registerd_school.jpg', 'assets/student_black.jpg']),
                  const SizedBox(height: 16),
                  SearchZone(controller: _searchController),
                  const SizedBox(height: 8),
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
                  SizedBox(
                    height: screenHeight * 0.5,
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
                          padding: const EdgeInsets.symmetric(horizontal: 16),
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
                              progress: avg / 20.0,
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
            ),
    );
  }
}