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
  final String subjectImagePath;

  const GradeCard({
    super.key,
    required this.grade,
    required this.subject,
    required this.teacher,
    required this.publicationDate,
    required this.subjectImagePath,
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
          // Image de la matière
          Container(
            width: 52,
            height: 52,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              image: DecorationImage(
                image: AssetImage(subjectImagePath),
                fit: BoxFit.cover,
              ),
              border: Border.all(
                color: AppColors.primary.withOpacity(0.2),
                width: 1.5,
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
                    fontSize: 12,
                   
                    color: AppColors.textprimary,
                           fontWeight: FontWeight.w500,
                          fontFamily: 'Montserrat',
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
                        style: const TextStyle(
                           
                          fontFamily: 'Montserrat',
                          fontWeight: FontWeight.w500,
                          fontSize: 10, 
                          color: AppColors.textprimary),
                        overflow: TextOverflow.ellipsis,
                        
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    Icon(Icons.calendar_today, size: 14, color: AppColors.textprimary.withOpacity(0.6)),
                    const SizedBox(width: 4),
                    Text(
                      DateFormatter.formatDate(publicationDate),
                      style: const TextStyle(
                       
                         fontFamily: 'Montserrat',
                          fontWeight: FontWeight.w500,
                          fontSize: 11, 
                        color: AppColors.textprimary),
                    ),
                  ],
                ),
              ],
            ),
          ),
          // Colonne à droite pour note, statut et session
     Column(
  crossAxisAlignment: CrossAxisAlignment.start, // Alignement à gauche
  children: [
    // Note
    Container(
      constraints: BoxConstraints(minWidth: 50), // Largeur minimale
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: badgeColor.withOpacity(0.15),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        grade.formattedValue,
        style: TextStyle(
          color: badgeColor,
          fontSize: 10,
          fontFamily: 'Montserrat',
          fontWeight: FontWeight.w400,
        ),
      ),
    ),
    const SizedBox(height: 4),
    // Session
    Container(
      constraints: BoxConstraints(minWidth: 100), // Même largeur minimale
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
      decoration: BoxDecoration(
        color: AppColors.textprimary.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        grade.sessionType == ExamSessionType.controleContinu 
            ? 'Controle continu' : 'Session Normal',
        style: const TextStyle(
          fontSize: 10,
          fontFamily: 'Montserrat',
          fontWeight: FontWeight.w400,
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
class DateFormatter {
  static String formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year}';
  }
}
