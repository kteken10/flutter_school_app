import 'package:flutter/material.dart';
import '../../models/grade.dart';
import '../../models/subject.dart';
import '../../models/user.dart';
import '../../constants/colors.dart';
import '../models/session.dart';

class GradeCard extends StatelessWidget {
  final Grade grade;
  final Subject subject;
  final UserModel teacher;
  final DateTime publicationDate;

  const GradeCard({
    super.key,
    required this.grade,
    required this.subject,
    required this.teacher,
    required this.publicationDate,
  });

  Color _getStatusColor(GradeStatus status) {
    switch (status) {
      case GradeStatus.graded:
        return Colors.green;
      case GradeStatus.absent:
        return Colors.orange;
      case GradeStatus.excused:
        return Colors.blue;
      case GradeStatus.pending:
        return Colors.grey;
      case GradeStatus.published:
        return Colors.purple;
    }
  }

  Color _getProgressColor(double value) {
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
    final double progress = grade.value! / 20;
    final Color badgeColor = _getProgressColor(progress);

    return Card(
      elevation: 0,
      color: Colors.white,
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Row(
          children: [
            // Badge Note avec couleur dynamique selon la note
            Container(
              width: 52,
              height: 52,
              decoration: BoxDecoration(
                color: badgeColor.withOpacity(0.15),
                shape: BoxShape.circle,
              ),
              child: Center(
                child: Text(
                  grade.formattedValue+'/20',
                  style: TextStyle(
                    color: badgeColor,
                    fontWeight: FontWeight.bold,
                    fontSize: 11,
                  ),
                ),
              ),
            ),
            const SizedBox(width: 12),
            // Informations principales
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    subject.name,
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: AppColors.textprimary,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      Icon(Icons.person, size: 14, color: AppColors.textprimary),
                      const SizedBox(width: 4),
                      Expanded(
                        child: Text(
                          teacher.fullName,
                          style: const TextStyle(fontSize: 12, color: AppColors.textprimary),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      Icon(Icons.calendar_today, size: 14, color: AppColors.textprimary),
                      const SizedBox(width: 4),
                      Text(
                        DateFormatter.formatDate(publicationDate),
                        style: const TextStyle(fontSize: 12, color: AppColors.textprimary),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            // Tags
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                  decoration: BoxDecoration(
                    color: Colors.grey[200],
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    grade.sessionType == ExamSessionType.controleContinu
                        ? 'Contrôle'
                        : 'Session',
                    style: const TextStyle(fontSize: 10, fontWeight: FontWeight.w500),
                  ),
                ),
                const SizedBox(height: 4),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                  decoration: BoxDecoration(
                    color: _getStatusColor(grade.status).withOpacity(0.15),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    grade.status.name.toUpperCase(),
                    style: TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                      color: _getStatusColor(grade.status),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

// Formatage de date simple
class DateFormatter {
  static String formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year}';
  }
}
