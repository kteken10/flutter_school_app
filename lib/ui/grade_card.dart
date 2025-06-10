import 'package:flutter/material.dart';
import '../constants/colors.dart';
import '../models/grade.dart';
import '../models/session.dart';

class GradeCard extends StatelessWidget {
  final Grade grade;
  final String subjectName;
  final String teacherName;

  const GradeCard({
    super.key,
    required this.grade,
    required this.subjectName,
    required this.teacherName,
  });

   Color getProgressColor(double value) {
    if (value >= 0.8) {
      return Colors.green;
    } else if (value >= 0.5) {
      return Colors.orange;
    } else {
      return Colors.red;
    }
  }

  @override
  Widget build(BuildContext context) {
    const maxValue = 20.0;
    final percentage = (grade.value / maxValue) * 100;
    final gradeColor = getProgressColor(percentage);

    return Card(
      color: Colors.white,
      elevation: 0,
      margin: const EdgeInsets.symmetric(vertical: 8),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Ligne: Matière + Note
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    subjectName,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: AppColors.textPrimary,
                    ),
                  ),
                ),
                Chip(
                  label: Text(
                    '${grade.value.toStringAsFixed(1)}/$maxValue',
                    style: const TextStyle(color: Colors.white),
                  ),
                  backgroundColor: AppColors.secondary.withOpacity(0.3),
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 0),
                ),
              ],
            ),
            const SizedBox(height: 4),

            // Ligne: Session + Prof
            Row(
              children: [
                Expanded(
                  child: Text(
                    'Type : ${_formatSessionType(grade.sessionType)}',
                    style: TextStyle(color: AppColors.textSecondary, fontSize: 13),
                  ),
                ),
                if (teacherName.trim().isNotEmpty)
                  Expanded(
                    child: Text(
                      'Prof : $teacherName',
                      style: const TextStyle(
                        color: AppColors.secondary,
                        fontSize: 13,
                        fontStyle: FontStyle.italic,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
              ],
            ),

            // Commentaire (en une ligne maximum)
            if (grade.comment != null && grade.comment!.trim().isNotEmpty)
              Padding(
                padding: const EdgeInsets.only(top: 4),
                child: Text(
                  'Commentaire : ${grade.comment}',
                  style: const TextStyle(
                    color: AppColors.textPrimary,
                    fontSize: 13,
                  ),
                  overflow: TextOverflow.ellipsis,
                  maxLines: 1,
                ),
              ),

            const SizedBox(height: 6),

            // Barre de progression
            LinearProgressIndicator(
              value: grade.value / maxValue,
              color: gradeColor,
              backgroundColor: gradeColor.withOpacity(0.3),
              minHeight: 6,
            ),

            const SizedBox(height: 6),

            // Date publication
            Align(
              alignment: Alignment.centerRight,
              child: Text(
                'Publiée le ${_formatDate(grade.dateRecorded)}',
                style: TextStyle(
                  color: AppColors.textSecondary,
                  fontSize: 11,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _formatSessionType(ExamSessionType type) {
    return type.toString().split('.').last;
  }

  String _formatDate(DateTime date) {
    return '${date.day.toString().padLeft(2, '0')}/${date.month.toString().padLeft(2, '0')}/${date.year}';
  }
}
