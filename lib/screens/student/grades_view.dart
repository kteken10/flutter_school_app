import 'package:flutter/material.dart';
import '../../models/grade.dart';
import '../../models/session.dart';
import '../../models/subject.dart';
import '../../models/user.dart';
import '../../ui/grade_card.dart';
import '../../ui/teacher_card_deco.dart';

class GradesViewScreen extends StatefulWidget {
  const GradesViewScreen({super.key});

  @override
  State<GradesViewScreen> createState() => _GradesViewScreenState();
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
      value: 14.0,
      sessionType: ExamSessionType.controleContinu,
      comment: 'Bonne maîtrise des commandes de base',
      dateRecorded: DateTime.now().subtract(const Duration(days: 10)),
    ),
    Grade(
      id: 'g2',
      studentId: 's1',
      subjectId: 'sub2',
      sessionId: 'session2',
      status: GradeStatus.published,
      classId: 'class1',
      teacherId: 't2',
      value: 16.5,
      sessionType: ExamSessionType.controleContinu,
      comment: 'Requêtes SQL bien maîtrisées',
      dateRecorded: DateTime.now().subtract(const Duration(days: 12)),
    ),
    Grade(
      id: 'g3',
      studentId: 's1',
      subjectId: 'sub3',
      sessionId: 'session3',
      status: GradeStatus.published,
      classId: 'class1',
      teacherId: 't3',
      value: 18.0,
      sessionType: ExamSessionType.controleContinu,
      comment: 'Très bon projet IA',
      dateRecorded: DateTime.now().subtract(const Duration(days: 20)),
    ),
    Grade(
      id: 'g4',
      studentId: 's1',
      subjectId: 'sub4',
      sessionId: 'session4',
      status: GradeStatus.published,
      classId: 'class1',
      teacherId: 't1',
      value: 15.5,
      sessionType: ExamSessionType.sessionNormale,
      comment: 'Modèles bien entraînés',
      dateRecorded: DateTime.now().subtract(const Duration(days: 25)),
    ),
    Grade(
      id: 'g5',
      studentId: 's1',
      subjectId: 'sub5',
      sessionId: 'session5',
      status: GradeStatus.published,
      classId: 'class1',
      teacherId: 't2',
      value: 17.0,
      sessionType: ExamSessionType.controleContinu,
      comment: 'Bonne configuration des protocoles',
      dateRecorded: DateTime.now().subtract(const Duration(days: 8)),
    ),
  ];

  final Map<String, Subject> _subjects = {
    'sub1': Subject(id: 'sub1', name: 'Systèmes Linux', code: 'LINUX201', department: 'Informatique', credit: 3),
    'sub2': Subject(id: 'sub2', name: 'Bases de Données', code: 'BD202', department: 'Informatique', credit: 4),
    'sub3': Subject(id: 'sub3', name: 'Intelligence Artificielle', code: 'IA301', department: 'Informatique', credit: 5),
    'sub4': Subject(id: 'sub4', name: 'Machine Learning', code: 'ML302', department: 'Informatique', credit: 5),
    'sub5': Subject(id: 'sub5', name: 'Réseaux Informatiques', code: 'NET203', department: 'Informatique', credit: 3),
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
  String selectedYear = '2023-2024';

  String? selectedSubjectId;
  ExamSessionType? selectedSessionType;

  @override
  Widget build(BuildContext context) {
    final filteredGrades = _dummyGrades.where((grade) {
      final subjectMatch = selectedSubjectId == null || grade.subjectId == selectedSubjectId;
      final sessionMatch = selectedSessionType == null || grade.sessionType == selectedSessionType;
      return subjectMatch && sessionMatch;
    }).toList();

    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(100),
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16.0, 40.0, 16.0, 16.0),
          child: Row(
            children: [
              CircleAvatar(
                radius: 22,
                backgroundImage: AssetImage(userImageAsset),
              ),
              const Spacer(),
              DropdownButton<String>(
                value: selectedYear,
                items: availableYears
                    .map((year) => DropdownMenuItem(
                          value: year,
                          child: Text(year),
                        ))
                    .toList(),
                onChanged: (newValue) {
                  if (newValue != null) {
                    setState(() => selectedYear = newValue);
                  }
                },
              ),
            ],
          ),
        ),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 8.0),
            child: Row(
              children: [
                Expanded(
                  child: DropdownButton<String?>(
                    value: selectedSubjectId,
                    hint: const Text('Filtrer par matière'),
                    isExpanded: true,
                    items: [
                      const DropdownMenuItem(
                        value: null,
                        child: Text('Toutes les matières'),
                      ),
                      ..._subjects.entries.map(
                        (entry) => DropdownMenuItem(
                          value: entry.key,
                          child: Text(entry.value.name),
                        ),
                      ),
                    ],
                    onChanged: (value) {
                      setState(() {
                        selectedSubjectId = value;
                      });
                    },
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: DropdownButton<ExamSessionType?>(
                    value: selectedSessionType,
                    hint: const Text('Type d’évaluation'),
                    isExpanded: true,
                    items: [
                      const DropdownMenuItem(
                        value: null,
                        child: Text('Tous les types'),
                      ),
                      ...ExamSessionType.values.map(
                        (type) => DropdownMenuItem(
                          value: type,
                          child: Text(type == ExamSessionType.controleContinu
                              ? 'Contrôle Continu'
                              : 'Session Normale'),
                        ),
                      ),
                    ],
                    onChanged: (value) {
                      setState(() {
                        selectedSessionType = value;
                      });
                    },
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 8),
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 0),
            child: TeacherCardDeco(imagePath: 'assets/teacher_picture.jpg'),
          ),
          const SizedBox(height: 16),
          Expanded(
            child: ListView(
              padding: const EdgeInsets.symmetric(vertical: 12),
              children: filteredGrades.map((grade) {
                final subject = _subjects[grade.subjectId]!;
                final teacher = _teachers[grade.teacherId]!;

                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  child: GradeCard(
                    grade: grade,
                    subject: subject,
                    teacher: teacher,
                    publicationDate: grade.dateRecorded,
                  ),
                );
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }
}

