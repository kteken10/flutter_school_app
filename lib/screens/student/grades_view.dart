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
          // Ligne contenant l'avatar et le dropdown
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: SizedBox(
              height: 80, // Hauteur fixe pour aligner verticalement
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center, // Centrage vertical
                children: [
                  // Avatar avec une largeur fixe pour maintenir l'alignement
                  SizedBox(
                    width: 80, // Même largeur que le PulsingAvatar
                    child: PulsingAvatar(imagePath: userImageAsset),
                  ),
                  // Espace flexible entre les deux éléments
                  const Expanded(child: SizedBox()),
                  // Dropdown avec une largeur fixe
                  SizedBox(
                    width: 150, // Ajustez selon vos besoins
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
          
          TeacherCardDeco(
            imagePaths: ['assets/student_black.jpg'],
          ),
          const SizedBox(height: 16),
          Expanded(
            child: ListView(
              children: filteredGrades.map((grade) {
                final subject = dummySubjects[grade.subjectId]!;
                final teacher = dummyTeachers[grade.teacherId]!;

                return GradeCard(
                  grade: grade,
                  subject: subject,
                  teacher: teacher,
                  publicationDate: grade.dateRecorded,
                );
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }
}