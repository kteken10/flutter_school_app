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
      value: 15.5,
      sessionType: ExamSessionType.controleContinu,
      comment: 'Bon travail',
      dateRecorded: DateTime.now().subtract(const Duration(days: 10)),
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
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: GradeCard(
                grade: grade,
                subject: subject,
                teacher: teacher,
                publicationDate: grade.dateRecorded,
              ),
            );
          }).toList(),
        ],
      ),
    );
  }
}