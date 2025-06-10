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

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // En-tête avec la note et le statut
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // Affichage de la note ou du statut
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  decoration: BoxDecoration(
                    color: _getStatusColor(grade.status),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    grade.formattedValue,
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                ),
                // Type de session
                Chip(
                  label: Text(
                    grade.sessionType == ExamSessionType.controleContinu
                        ? 'Contrôle Continu'
                        : 'Session Normale',
                    style: const TextStyle(fontSize: 12),
                  ),
                  backgroundColor: Colors.grey[200],
                ),
              ],
            ),

            const SizedBox(height: 16),

            // Détails de la matière
            _buildDetailRow(
              icon: Icons.book,
              label: 'Matière',
              value: subject.name,
            ),

            // Enseignant
            _buildDetailRow(
              icon: Icons.person,
              label: 'Enseignant',
              value: teacher.fullName,
            ),

            // Date d'attribution
            _buildDetailRow(
              icon: Icons.calendar_today,
              label: 'Attribuée le',
              value: DateFormatter.formatDate(grade.dateRecorded),
            ),

            // Date de publication
            _buildDetailRow(
              icon: Icons.publish,
              label: 'Publiée le',
              value: DateFormatter.formatDate(publicationDate),
            ),

            // Commentaire (si existant)
            if (grade.comment != null && grade.comment!.isNotEmpty) ...[
              const SizedBox(height: 12),
              Text(
                'Commentaire: ${grade.comment}',
                style: TextStyle(
                  color: AppColors.textSecondary,
                  fontStyle: FontStyle.italic,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildDetailRow({
    required IconData icon,
    required String label,
    required String value,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        children: [
          Icon(icon, size: 18, color: AppColors.primary),
          const SizedBox(width: 8),
          Text(
            '$label: ',
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
          Text(value),
        ],
      ),
    );
  }

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
       
        throw UnimplementedError();
    }
  }
}

// Exemple d'utilitaire de formatage de date (date_formatter.dart)
class DateFormatter {
  static String formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year} à ${date.hour}h${date.minute.toString().padLeft(2, '0')}';
  }
}