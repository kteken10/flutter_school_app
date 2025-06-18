import 'package:flutter/material.dart';
import 'package:schoop_app/constants/colors.dart';
import '../../data/dummy_grade.dart';
import '../../models/session.dart';
import '../../ui/grade_card.dart';
import '../../ui/pulsing_avatar.dart';
import '../../ui/teacher_card_deco.dart';
import '../../ui/year_drop.dart';

class GradesViewScreen extends StatefulWidget {
  const GradesViewScreen({super.key});

  @override
  State<GradesViewScreen> createState() => _GradesViewScreenState();
}

class _GradesViewScreenState extends State<GradesViewScreen> {
  final String userImageAsset = 'assets/student_1.png';
  final List<String> availableYears = ['2023-2024', '2022-2023', '2021-2022'];
  String selectedYear = '2023-2024';

  String? selectedSubjectId;
  ExamSessionType? selectedSessionType;

  @override
  Widget build(BuildContext context) {
    final filteredGrades = dummyGrades.where((grade) {
      final subjectMatch = selectedSubjectId == null || grade.subjectId == selectedSubjectId;
      final sessionMatch = selectedSessionType == null || grade.sessionType == selectedSessionType;
      return subjectMatch && sessionMatch;
    }).toList();

    return Scaffold(
      backgroundColor: AppColors.background,
      body: Column(
        children: [
          // Section fixe (non défilante)
          Padding(
            padding: const EdgeInsets.symmetric( vertical: 8),
            child: SizedBox(
              height: 80,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(
                    width: 80,
                    child: PulsingAvatar(imagePath: userImageAsset),
                  ),
                  const Expanded(child: SizedBox()),
                  SizedBox(
                    width: 150,
                    child: YearSelectorDropdown(
                      years: availableYears,
                      selectedYear: selectedYear,
                      onChanged: (value) => setState(() => selectedYear = value!),
                    ),
                  ),
                ],
              ),
            ),
          ),
          
          // Section défilante
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  TeacherCardDeco(
                    imagePaths: ['assets/student_black.jpg'],
                  ),
                  const SizedBox(height: 16),
                  Column(
                    children: filteredGrades.map((grade) {
                      final subject = dummySubjects[grade.subjectId]!;
                      final teacher = dummyTeachers[grade.teacherId]!;

                      return GradeCard(
                        grade: grade,
                        subject: subject,
                        teacher: teacher,
                        publicationDate: grade.dateRecorded,
                        subjectImagePath: grade.subjectImagePath
                      );
                    }).toList(),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}