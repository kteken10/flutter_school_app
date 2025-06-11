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
  final List<String> availableYears = ['2023-2024', '2022-2023'];
  final ValueNotifier<int> selectedTab = ValueNotifier<int>(0);
  final int totalStudentImages = 3;
  String? selectedYear;
  String? selectedClass;
  String? selectedSubject;
  String? selectedSession;

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

  // Structure de données plus complète pour gérer les notes par matière et session
  final Map<String, Map<String, Map<String, double>>> _studentGrades = {
    's1': {
      'Mathématiques': {'Session 1': 12.0, 'Session 2': 14.0},
      'Informatique': {'Session 1': 15.5, 'Session 2': 16.0},
    },
    's2': {
      'Base de données': {'Session 1': 8.0, 'Session 2': 10.5},
      'Machine Learning': {'Session 1': 14.0},
    },
    's3': {
      'Linux': {'Session 1': 15.0, 'Session 2': 13.5},
      'Réseaux': {'Session 1': 17.0},
    },
    's4': {
      'IA': {'Session 1': 16.0, 'Session 2': 18.0},
      'Big Data': {'Session 1': 14.0},
    },
    's5': {
      'Cloud Computing': {'Session 1': 18.0, 'Session 2': 19.5},
      'DevOps': {'Session 1': 17.5},
    },
  };

  final List<String> _allSubjects = [
    'Mathématiques',
    'Informatique',
    'Base de données',
    'Machine Learning',
    'Linux',
    'Réseaux',
    'IA',
    'Big Data',
    'Cloud Computing',
    'DevOps'
  ];

  final List<String> _allSessions = ['Session 1', 'Session 2'];
  final List<String> _classes = ['L1', 'L2', 'L3', 'M1', 'M2'];

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
    final grades = _getAllGradesForStudent(studentId);
    if (grades.isEmpty) return 0.0;
    final sum = grades.reduce((a, b) => a + b);
    return (sum / grades.length / 20.0).clamp(0.0, 1.0);
  }

  List<double> _getAllGradesForStudent(String studentId) {
    final studentData = _studentGrades[studentId];
    if (studentData == null) return [];
    
    return studentData.values
        .expand((sessionGrades) => sessionGrades.values)
        .toList();
  }

  List<String> _getFilteredSubjects(String studentId) {
    final studentData = _studentGrades[studentId];
    if (studentData == null) return [];
    
    if (selectedSubject != null) {
      return studentData.containsKey(selectedSubject) 
          ? [selectedSubject!] 
          : [];
    }
    
    return studentData.keys.toList();
  }

  Map<String, double> _getGradesForSubject(String studentId, String subject) {
    return _studentGrades[studentId]?[subject] ?? {};
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
    
    // Filtre par classe
    if (selectedClass != null) {
      filtered = filtered.where((student) => student.className == selectedClass).toList();
    }
    
    // Filtre par recherche textuelle
    if (searchText.isNotEmpty) {
      filtered = filtered.where((student) {
        final fullName = student.fullName.toLowerCase();
        final searchLower = searchText.toLowerCase();
        return fullName.contains(searchLower) ||
            student.firstName.toLowerCase().contains(searchLower) ||
            student.lastName.toLowerCase().contains(searchLower);
      }).toList();
    }
    
    // Filtre par matière (si activé)
    if (selectedTab.value == 2 && selectedSubject != null) {
      filtered = filtered.where((student) {
        return _studentGrades[student.id]?.containsKey(selectedSubject) ?? false;
      }).toList();
    }
    
    // Filtre par session (si activé)
    if (selectedTab.value == 0 && selectedSession != null) {
      filtered = filtered.where((student) {
        final studentData = _studentGrades[student.id];
        if (studentData == null) return false;
        
        return studentData.values.any((sessionGrades) => 
            sessionGrades.containsKey(selectedSession));
      }).toList();
    }
    
    return filtered;
  }

  void _onClassSelected(String? className) {
    setState(() {
      selectedClass = className;
    });
  }

  void _onSubjectSelected(String? subject) {
    setState(() {
      selectedSubject = subject;
    });
  }

  void _onSessionSelected(String? session) {
    setState(() {
      selectedSession = session;
    });
  }

  void _resetFilters() {
    setState(() {
      selectedClass = null;
      selectedSubject = null;
      selectedSession = null;
      _searchController.clear();
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
                    subjectCount: _allSubjects.length,
                    classCount: _classes.length,
                    subjects: _allSubjects,
                    classes: _classes,
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
                      // Réinitialiser les filtres spécifiques quand on change d'onglet
                      if (index != 1) selectedClass = null;
                      if (index != 2) selectedSubject = null;
                      if (index != 0) selectedSession = null;
                    },
                  ),
                  ValueListenableBuilder<int>(
                    valueListenable: selectedTab,
                    builder: (context, index, _) {
                      return Column(
                        children: [
                          if (index == 0) 
                            SessionFilter(
                              sessions: _allSessions,
                              selectedSession: selectedSession,
                              onSessionSelected: _onSessionSelected,
                            ),
                          if (index == 1)
                            ClassFilter(
                              classes: _classes,
                              selectedClass: selectedClass,
                              onClassSelected: _onClassSelected,
                            ),
                          if (index == 2)
                            SubjectFilter(
                              subjects: _allSubjects,
                              selectedSubject: selectedSubject,
                              onSubjectSelected: _onSubjectSelected,
                            ),
                          // Bouton de réinitialisation
                          if (selectedClass != null || 
                              selectedSubject != null || 
                              selectedSession != null ||
                              _searchController.text.isNotEmpty)
                            Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 16),
                              child: Align(
                                alignment: Alignment.centerRight,
                                child: TextButton(
                                  onPressed: _resetFilters,
                                  child: const Text(
                                    'Réinitialiser les filtres',
                                    style: TextStyle(color: AppColors.primary),
                                  ),
                                ),
                              ),
                            ),
                        ],
                      );
                    },
                  ),
                  if (filteredStudents.isEmpty)
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Text(
                        _getNoResultsMessage(),
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
    final subjects = _getFilteredSubjects(student.id);
    final progress = _calculateAverage(student.id);

    // Convertir les notes en List<double>
    final grades = subjects.expand((subject) {
      final subjectGrades = _getGradesForSubject(student.id, subject);
      if (selectedSession != null) {
        return subjectGrades.containsKey(selectedSession) 
            ? [subjectGrades[selectedSession]!] 
            : [];
      }
      return subjectGrades.values;
    }).toList();

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      child: StudentCard(
        studentName: student.fullName,
        studentClass: student.className ?? 'N/A',
        studentPhotoUrl: '',
        studentPhotoAsset: _getStudentImageAsset(index),
        subjectNames: subjects,
        subjectGrades: grades.cast<double>(), // Conversion explicite en List<double>
        progress: progress,
        onProfileTap: () {},
        // showSession: selectedTab.value == 0,
        // sessionName: selectedSession,
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

  String _getNoResultsMessage() {
    if (selectedClass != null) {
      return "Aucun étudiant dans la classe $selectedClass";
    }
    if (selectedSubject != null) {
      return "Aucun étudiant n'a de notes en $selectedSubject";
    }
    if (selectedSession != null) {
      return "Aucun étudiant n'a de notes pour la $selectedSession";
    }
    if (_searchController.text.isNotEmpty) {
      return "Aucun étudiant ne correspond à '${_searchController.text}'";
    }
    return "Aucun étudiant trouvé";
  }
}