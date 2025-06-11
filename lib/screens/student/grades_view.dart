import 'package:flutter/material.dart';
import '../../models/grade.dart';
import '../../models/session.dart';
import '../../models/subject.dart';
import '../../models/user.dart';
import '../../ui/grade_card.dart';
import '../../ui/teacher_card_deco.dart';
import '../../ui/year_drop.dart';

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
  final List<Grade> _dummyGrades = [
    Grade(
      id: 'g1',
      studentId: 's1',
      subjectId: 'sub1',
      sessionId: 'session1',
      status: GradeStatus.published,
      classId: 'class1',
      teacherId: 't1',
      value: 15.5,
      sessionType: ExamSessionType.controleContinu,
      comment: 'Bon travail',
      dateRecorded: DateTime.now().subtract(const Duration(days: 10)),
    ),
    Grade(
      id: 'g2',
      studentId: 's2',
      subjectId: 'sub3',
      sessionId: 'session2',
      status: GradeStatus.published,
      classId: 'class1',
      teacherId: 't3',
      value: 12.0,
      sessionType: ExamSessionType.sessionNormale,
      comment: 'Peut mieux faire',
      dateRecorded: DateTime.now().subtract(const Duration(days: 5)),
    ),
    Grade(
      id: 'g3',
      studentId: 's3',
      subjectId: 'sub2',
      sessionId: 'session1',
      status: GradeStatus.published,
      classId: 'class1',
      teacherId: 't2',
      value: 18.0,
      sessionType: ExamSessionType.controleContinu,
      comment: 'Excellent',
      dateRecorded: DateTime.now().subtract(const Duration(days: 20)),
    ),
    // ... autres notes
  ];

  final Map<String, Subject> _subjects = {
    'sub1': Subject(
      id: 'sub1',
      name: 'Mathématiques',
      code: 'MATH101',
      department: 'Sciences',
      credit: 4,
    ),
    'sub2': Subject(
      id: 'sub2',
      name: 'Physique',
      code: 'PHYS101',
      department: 'Sciences',
      credit: 3,
    ),
    'sub3': Subject(
      id: 'sub3',
      name: 'Informatique',
      code: 'INFO101',
      department: 'Technologie',
      credit: 5,
    ),
  };

  final Map<String, UserModel> _teachers = {
    't1': UserModel(
      id: 't1',
      firstName: 'Mme',
      lastName: 'Dupont',
      email: 'dupont@ecole.com',
      role: UserRole.teacher,
      createdAt: DateTime.now().subtract(const Duration(days: 365)),
    ),
    't2': UserModel(
      id: 't2',
      firstName: 'M.',
      lastName: 'Martin',
      email: 'martin@ecole.com',
      role: UserRole.teacher,
      createdAt: DateTime.now().subtract(const Duration(days: 365)),
    ),
    't3': UserModel(
      id: 't3',
      firstName: 'Mme',
      lastName: 'Bernard',
      email: 'bernard@ecole.com',
      role: UserRole.teacher,
      createdAt: DateTime.now().subtract(const Duration(days: 365)),
    ),
  };

  final String userImageAsset = 'assets/student_1.png';
  final List<String> availableYears = ['2023-2024', '2022-2023', '2021-2022'];
  late String selectedYear;

  SortOption _currentSortOption = SortOption.byDateRecorded;

  String _searchQuery = '';

  @override
  void initState() {
    super.initState();
    selectedYear = availableYears.first;
  }

  List<Grade> getSortedGrades() {
    // Pour le moment on ignore le tri et on ne garde que le filtrage par recherche textuelle

    if (_searchQuery.isEmpty) {
      return List.from(_dummyGrades);
    }

    final query = _searchQuery.toLowerCase();

    return _dummyGrades.where((grade) {
      final subject = _subjects[grade.subjectId];
      final teacher = _teachers[grade.teacherId];

      final subjectName = subject?.name.toLowerCase() ?? '';
      final teacherName =
          '${teacher?.firstName.toLowerCase() ?? ''} ${teacher?.lastName.toLowerCase() ?? ''}';
      final comment = grade.comment?.toLowerCase();

      return subjectName.contains(query) ||
          teacherName.contains(query) ||
          comment!.contains(query);
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    final filteredGrades = getSortedGrades();

    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(160),
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16.0, 40.0, 16.0, 16.0),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  CircleAvatar(
                    radius: 22,
                    backgroundImage: AssetImage(userImageAsset),
                  ),
                  YearSelectorDropdown(
                    years: availableYears,
                    selectedYear: selectedYear,
                    onChanged: (value) {
                      if (value != null) {
                        setState(() {
                          selectedYear = value;
                        });
                      }
                    },
                  ),
                ],
              ),
              const SizedBox(height: 8),
              // Champ de recherche
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 0),
                child: TextField(
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
              ),
              const SizedBox(height: 8),
            ],
          ),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.symmetric(vertical: 12),
        children: [
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 0),
            child: TeacherCardDeco(imagePath: 'assets/teacher_picture.jpg'),
          ),
          const SizedBox(height: 16),
          ...filteredGrades.map((grade) {
            final subject = _subjects[grade.subjectId] ??
                Subject(
                  id: 'unknown',
                  name: 'Matière inconnue',
                  code: 'UNKN000',
                  department: 'Inconnu',
                  credit: 0,
                );

            final teacher = _teachers[grade.teacherId] ??
                UserModel(
                  id: 'unknown',
                  firstName: 'Professeur',
                  lastName: 'inconnu',
                  email: 'inconnu@ecole.com',
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
      ),
    );
  }
}
 