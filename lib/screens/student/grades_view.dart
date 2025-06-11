import 'package:flutter/material.dart';
import '../../models/grade.dart';
import '../../models/session.dart';
import '../../models/subject.dart';
import '../../models/user.dart';
import '../../services/auth_service.dart';
import '../../services/email_service.dart';
import '../../services/grade_service.dart';
import '../../ui/grade_card.dart';
import '../../ui/teacher_card_deco.dart';
import '../../ui/year_drop.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class GradesViewScreen extends StatefulWidget {
  const GradesViewScreen({super.key});

  @override
  State<GradesViewScreen> createState() => _GradesViewScreenState();
}

enum SortOption {
  byGradeValue,
  bySubjectName,
  byTeacherName,
  byDateRecorded,
}

class _GradesViewScreenState extends State<GradesViewScreen> {
  late Stream<List<Grade>> _gradesStream;
   final List<String> availableYears = ['2023-2024', '2022-2023'];
  UserModel? currentUser;
  final GradeService _gradeService = GradeService();
  final AuthService _authService = AuthService(
    emailService: EmailService(
      smtpServer: 'smtp.gmail.com',
      smtpUsername: 'patientdjappa@gmail.com',
      smtpPassword: 'bjtp uswy idke kddq',
    ),
  );

  String selectedYear = '2023-2024';
  String _searchQuery = '';

  // ✅ Ajout des maps pour matières et enseignants
  Map<String, Subject> _subjects = {};
  Map<String, UserModel> _teachers = {};

  @override
  void initState() {
    super.initState();
    _loadUserAndGrades();
  }

  void _loadUserAndGrades() async {
    currentUser = await _authService.getCurrentUserModel();

    if (currentUser != null) {
      // Charger matières et profs
      final subjects = await _loadSubjects();
      final teachers = await _loadTeachers();

      setState(() {
        _subjects = subjects;
        _teachers = teachers;
        _gradesStream = _gradeService.getStudentGrades(currentUser!.id, selectedYear);
      });
    }
  }

  Future<Map<String, Subject>> _loadSubjects() async {
    final snapshot = await FirebaseFirestore.instance.collection('subjects').get();
    final map = <String, Subject>{};
    for (var doc in snapshot.docs) {
      map[doc.id] = Subject.fromMap(doc.data());
    }
    return map;
  }

  Future<Map<String, UserModel>> _loadTeachers() async {
    final snapshot = await FirebaseFirestore.instance.collection('users').where('role', isEqualTo: 'teacher').get();
    final map = <String, UserModel>{};
    for (var doc in snapshot.docs) {
      map[doc.id] = UserModel.fromMap(doc.data());
    }
    return map;
  }

  void _onYearChanged(String? year) {
    if (year != null && currentUser != null) {
      setState(() {
        selectedYear = year;
        _gradesStream = _gradeService.getStudentGrades(currentUser!.id, selectedYear);
      });
    }
  }

  List<Grade> _filterGrades(List<Grade> grades) {
    if (_searchQuery.isEmpty) return grades;
    final query = _searchQuery.toLowerCase();
    return grades.where((grade) {
      final subject = _subjects[grade.subjectId]?.name.toLowerCase() ?? '';
      final teacher = _teachers[grade.teacherId];
      final teacherName = '${teacher?.firstName.toLowerCase() ?? ''} ${teacher?.lastName.toLowerCase() ?? ''}';
      final comment = grade.comment?.toLowerCase() ?? '';
      return subject.contains(query) || teacherName.contains(query) || comment.contains(query);
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(160),
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16.0, 40.0, 16.0, 16.0),
          child: Column(
            children: [
              YearSelectorDropdown(
                years: availableYears,
                selectedYear: selectedYear,
                onChanged: _onYearChanged,
              ),
              TextField(
                decoration: InputDecoration(
                  prefixIcon: const Icon(Icons.search),
                  hintText: 'Rechercher par matière, professeur ou commentaire',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  contentPadding: const EdgeInsets.symmetric(horizontal: 12),
                ),
                onChanged: (value) {
                  setState(() {
                    _searchQuery = value;
                  });
                },
              ),
            ],
          ),
        ),
      ),
      body: StreamBuilder<List<Grade>>(
        stream: _gradesStream,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text('Erreur : ${snapshot.error}'));
          }
          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('Aucune note trouvée.'));
          }

          final filteredGrades = _filterGrades(snapshot.data!);

          return ListView(
            padding: const EdgeInsets.symmetric(vertical: 12),
            children: [
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 0),
                child: TeacherCardDeco(imagePath: 'assets/teacher_picture.jpg'),
              ),
              const SizedBox(height: 16),
              ...filteredGrades.map((grade) {
                final subject = _subjects[grade.subjectId] ?? Subject(
                  id: 'unknown',
                  name: 'Matière inconnue',
                  code: 'UNKN000',
                  department: 'Inconnu',
                  credit: 0,
                );

                final teacher = _teachers[grade.teacherId] ?? UserModel(
                  id: 'unknown',
                  firstName: 'Professeur',
                  lastName: 'Inconnu',
                  email: '',
                  role: UserRole.teacher,
                  createdAt: DateTime.now(),
                );

                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 0, vertical: 8),
                  child: GradeCard(
                    grade: grade,
                    subject: subject,
                    teacher: teacher,
                    publicationDate: grade.dateRecorded,
                  ),
                );
              }),
            ],
          );
        },
      ),
    );
  }
}
