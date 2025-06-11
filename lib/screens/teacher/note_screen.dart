import 'package:flutter/material.dart';
import '../../constants/colors.dart';
import '../../models/user.dart';
import '../../services/student_service.dart';
import '../../services/grade_service.dart';
import '../../services/subject_service.dart';
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
  final UserModel teacher;
  
  const NoteScreen({super.key, required this.teacher});

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

  List<String> availableYears = [];
  List<String> _allSubjects = [];
  List<String> _allSessions = [];
  List<String> _classes = [];

  List<UserModel> _students = [];
  Map<String, Map<String, Map<String, double>>> _studentGrades = {};

  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    selectedYear = DateTime.now().year.toString();
    _searchController.addListener(_onSearchChanged);
    _loadDataFromServices();
  }

  Future<void> _loadDataFromServices() async {
    setState(() => isLoading = true);

    try {
      final studentService = StudentService();
      final gradeService = GradeService();
      final subjectService = SubjectService();

      // Charger les étudiants des classes de l'enseignant
      _students = (await studentService.getStudents())
          .where((student) => widget.teacher.assignedClassIds.contains(student.className))
          .toList();

      // Charger les notes
      _studentGrades = await gradeService.getAllGradesMap();

      // Charger les matières enseignées par l'enseignant (avec noms)
final subjectIds = widget.teacher.taughtSubjectIds;
_allSubjects = await Future.wait(
  subjectIds.map((id) async {
    return await subjectService.getSubjectName(id) ?? id; // Utilise l'ID si aucun nom trouvé
  }),
);

      // Charger les sessions
      _allSessions = await gradeService.getSessions();

      // Extraire les classes uniques des étudiants
      _classes = _students
          .map((s) => s.className ?? '')
          .where((c) => c.isNotEmpty)
          .toSet()
          .toList();

      availableYears = ['2023-2024', '2022-2023'];
    } catch (e) {
      print('Erreur lors du chargement des données: $e');
      // Vous pourriez afficher un message d'erreur ici
    } finally {
      setState(() => isLoading = false);
    }
  }

  void _onSearchChanged() => setState(() {});

  void _onAddNote() {
    showDialog(
      context: context,
      builder: (context) => GradeEntryDialog(
        
     
        onGradeSubmitted: _loadDataFromServices,
      ),
    );
  }

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
      // Trouver l'ID de la matière correspondant au nom sélectionné
      final subjectIndex = _allSubjects.indexOf(selectedSubject!);
      if (subjectIndex != -1) {
        final subjectId = widget.teacher.taughtSubjectIds[subjectIndex];
        filtered = filtered.where((s) {
          return _studentGrades[s.id]?.containsKey(subjectId) ?? false;
        }).toList();
      }
    }
    
    if (selectedTab.value == 0 && selectedSession != null) {
      filtered = filtered.where((s) {
        final g = _studentGrades[s.id];
        return g?.values.any((sessions) => sessions.containsKey(selectedSession)) ?? false;
      }).toList();
    }

    return filtered;
  }

  Future<List<String>> _getFilteredSubjects(String studentId) async {
    final g = _studentGrades[studentId];
    if (g == null) return [];
    
    final subjectService = SubjectService();
    final subjectNames = <String>[];
    
    for (final subjectId in g.keys) {
      final name = await subjectService.getSubjectName(subjectId) ?? subjectId;
      subjectNames.add(name);
    }
    
    if (selectedSubject != null) {
      return subjectNames.contains(selectedSubject) ? [selectedSubject!] : [];
    }
    
    return subjectNames;
  }

  List<double> _getGradesForStudent(String studentId) {
    final grades = _studentGrades[studentId];
    if (grades == null) return [];
    
    return grades.values
        .expand((sessionGrades) => sessionGrades.values)
        .toList();
  }

  double _calculateAverage(String studentId) {
    final allGrades = _getGradesForStudent(studentId);
    if (allGrades.isEmpty) return 0.0;
    final sum = allGrades.reduce((a, b) => a + b);
    return (sum / allGrades.length / 20.0).clamp(0.0, 1.0);
  }

  String _getStudentImageAsset(int index) {
    final imageNumber = (index % totalStudentImages) + 1;
    return 'assets/student_$imageNumber.png';
  }

  void _resetFilters() {
    setState(() {
      selectedClass = null;
      selectedSubject = null;
      selectedSession = null;
      _searchController.clear();
    });
  }

  String _getNoResultsMessage() {
    if (selectedClass != null) return "Aucun étudiant dans la classe $selectedClass";
    if (selectedSubject != null) return "Aucun étudiant n'a de notes en $selectedSubject";
    if (selectedSession != null) return "Aucun étudiant n'a de notes pour la $selectedSession";
    if (_searchController.text.isNotEmpty) return "Aucun étudiant ne correspond à '${_searchController.text}'";
    return "Aucun étudiant trouvé";
  }

  @override
  void dispose() {
    _searchController.dispose();
    selectedTab.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final filteredStudents = _filterStudents(_searchController.text);

    return Scaffold(
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : Column(
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(16.0, 40.0, 16.0, 16.0),
                  child: Row(
                    children: [
                      Text(
                        "Bonjour, ${widget.teacher.fullName}",
                        style: const TextStyle(
                          fontSize: 20, 
                          color: AppColors.textPrimary
                        ),
                      ),
                      const Spacer(),
                      // YearSelectorDropdown(
                      //   years: availableYears,
                      //   selectedYear: selectedYear,
                      //   onChanged: (value) => setState(() => selectedYear = value),
                      // ),
                    ],
                  ),
                ),
                Expanded(
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        const TeacherCardDeco(imagePath: 'assets/teacher_picture.jpg'),
                        TeacherCard(
                          name: widget.teacher.fullName,
                          email: widget.teacher.email,
                          profileImageUrl: widget.teacher.photoUrl ?? '',
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
                          tabs: const ['Sessions', 'Classes', 'Matières'],
                          onTabSelected: (index) {
                            selectedTab.value = index;
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
                                    onSessionSelected: (value) => setState(() => selectedSession = value),
                                  ),
                                if (index == 1)
                                  ClassFilter(
                                    classes: _classes,
                                    selectedClass: selectedClass,
                                    onClassSelected: (value) => setState(() => selectedClass = value),
                                  ),
                                if (index == 2)
                                  SubjectFilter(
                                    subjects: _allSubjects,
                                    selectedSubject: selectedSubject,
                                    onSubjectSelected: (value) => setState(() => selectedSubject = value),
                                  ),
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
                          FutureBuilder<List<Widget>>(
                            future: _buildStudentCards(filteredStudents),
                            builder: (context, snapshot) {
                              if (snapshot.connectionState != ConnectionState.done) {
                                return const Center(child: CircularProgressIndicator());
                              }
                              return ListView(
                                physics: const NeverScrollableScrollPhysics(),
                                shrinkWrap: true,
                                children: snapshot.data ?? [],
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

  Future<List<Widget>> _buildStudentCards(List<UserModel> students) async {
    final cards = <Widget>[];
    
    for (int i = 0; i < students.length; i++) {
      final student = students[i];
      final subjects = await _getFilteredSubjects(student.id);
      final grades = _getGradesForStudent(student.id);
      
      cards.add(
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
          child: StudentCard(
            studentName: student.fullName,
            studentClass: student.className ?? 'N/A',
            studentPhotoUrl: student.photoUrl ?? '',
            studentPhotoAsset: _getStudentImageAsset(i),
            subjectNames: subjects,
            subjectGrades: grades,
            progress: _calculateAverage(student.id),
            onProfileTap: () {},
          ),
        ),
      );
    }
    
    return cards;
  }
}