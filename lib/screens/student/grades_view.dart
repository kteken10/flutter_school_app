import 'package:flutter/material.dart';
import '../../models/grade.dart';
import '../../models/session.dart';
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
      isFinal: false,
      teacherId: 't1',
      value: 15.5,
      sessionType: ExamSessionType.controleContinu,
      comment: 'Bon travail',
      dateRecorded: DateTime.now().subtract(const Duration(days: 10)),
    ),
    Grade(
      id: 'g2',
      studentId: 's1',
      subjectId: 'sub2',
      teacherId: 't2',
      sessionId: 'session1',
      isFinal: true,
      value: 5.0,
      sessionType: ExamSessionType.sessionNormale,
      comment: '',
      dateRecorded: DateTime.now().subtract(const Duration(days: 20)),
    ),
    
    Grade(
      id: 'g3',
      studentId: 's1',
      subjectId: 'sub3',
      sessionId: 'session1',
      teacherId: 't3',
      isFinal: false,
      value: 18.0,
      sessionType: ExamSessionType.controleContinu,
      comment: 'Excellent',
      dateRecorded: DateTime.now().subtract(const Duration(days: 5)),
    ),
  ];

  final Map<String, String> _subjectNames = {
    'sub1': 'Mathématiques',
    'sub2': 'Physique',
    'sub3': 'Informatique',
  };

  final Map<String, String> _teacherNames = {
    't1': 'Mme Dupont',
    't2': 'M. Martin',
    't3': 'Mme Bernard',
  };

  final String userImageAsset = 'assets/student_1.png'; // Remplace par ton image
  final List<String> availableYears = ['2023-2024', '2022-2023', '2021-2022'];
  String selectedYear = '2023-2024';

  @override
  Widget build(BuildContext context) {
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
      body: ListView(
        padding: const EdgeInsets.symmetric(vertical: 12),
        children: [
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 16),
            child: TeacherCardDeco(imagePath: 'assets/teacher_picture.jpg'),
          ),
          const SizedBox(height: 16),
          ..._dummyGrades.map((grade) {
            final subjectName = _subjectNames[grade.subjectId] ?? "Matière inconnue";
            final teacherName = _teacherNames[grade.teacherId] ?? "Professeur inconnu";

            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: GradeCard(
                grade: grade,
                subjectName: subjectName,
                teacherName: teacherName,
              ),
            );
          }).toList(),
        ],
      ),
    );
  }
}
