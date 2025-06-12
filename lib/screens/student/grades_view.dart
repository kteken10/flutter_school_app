import 'package:flutter/material.dart';
import 'package:schoop_app/constants/colors.dart';
import '../../data/dummy_grade.dart';
import '../../models/grade.dart';
import '../../models/session.dart';
import '../../models/subject.dart';
import '../../models/user.dart';
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
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(100),
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16.0, 40.0, 16.0, 16.0),
          child: Row(
            children: [
              // PulsingAvatar(imagePath: userImageAsset),
              const Spacer(),
                YearSelectorDropdown(
                        years: availableYears,
                        selectedYear: selectedYear,
                        onChanged: (value) => setState(() => selectedYear = value!),
                      ),
            ],
          ),
        ),
      ),
      body: Column(
        children: [
        
        
          TeacherCardDeco(imagePaths: ['assets/registerd_school.jpg','student_black.jpg'],),
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
