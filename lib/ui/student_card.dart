import 'package:flutter/material.dart';
import '../constants/colors.dart';

class StudentCard extends StatelessWidget {
  final String studentName;
  final String studentClass; // Nouveau champ pour la classe
  final String? studentPhotoUrl;
  final String? studentPhotoAsset;
  final List<String> subjectNames;
  final List<double>? subjectGrades;
  final double progress;
  final VoidCallback? onProfileTap;

  const StudentCard({
    super.key,
    required this.studentName,
    required this.studentClass, // Ajout du paramètre obligatoire
    this.studentPhotoUrl,
    this.studentPhotoAsset,
    required this.subjectNames,
    this.subjectGrades,
    required this.progress,
    this.onProfileTap,
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

  Color getClassColor(String className) {
    switch (className) {
      case 'L1':
        return AppColors.secondary;
      case 'L2':
        return Colors.blue;
      case 'L3':
        return Colors.purple;
      case 'M1':
        return Colors.teal;
      case 'M2':
        return Colors.orange;
      default:
        return AppColors.textprimary;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.white,
      elevation: 0,
      margin: const EdgeInsets.symmetric(vertical: 8),
      child: InkWell(
        onTap: onProfileTap,
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Row(
            children: [
              // Photo de profil avec badge de classe
              Stack(
                alignment: Alignment.bottomCenter,
                children: [
                  CircleAvatar(
                    radius: 28,
                    backgroundImage: studentPhotoUrl != null && studentPhotoUrl!.isNotEmpty
                        ? NetworkImage(studentPhotoUrl!)
                        : AssetImage(studentPhotoAsset ?? 'assets/student_1.png') as ImageProvider,
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                    decoration: BoxDecoration(
                      color: getClassColor(studentClass),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      studentClass,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            studentName,
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: AppColors.textprimary,
                            ),
                          ),
                        ),
                        // Note moyenne si disponible
                        if (subjectGrades != null && subjectGrades!.isNotEmpty)
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                            decoration: BoxDecoration(
                              color: getProgressColor(progress).withOpacity(0.2),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Text(
                              '${(progress * 20).toStringAsFixed(1)}/20',
                              style: TextStyle(
                                color: getProgressColor(progress),
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                      ],
                    ),
                    const SizedBox(height: 6),
                    SizedBox(
                      height: 28,
                      child: ListView.separated(
                        scrollDirection: Axis.horizontal,
                        itemCount: subjectNames.length,
                        separatorBuilder: (_, __) => const SizedBox(width: 6),
                        itemBuilder: (context, index) {
                          final grade = (subjectGrades != null && index < subjectGrades!.length)
                              ? subjectGrades![index]
                              : null;
                          return Container(
                            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                            decoration: BoxDecoration(
                              color: AppColors.quaternary,
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text(
                                  subjectNames[index],
                                  style: const TextStyle(
                                    color: AppColors.secondary,
                                    fontSize: 12,
                                    fontWeight: FontWeight.w500,
                                  ),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                                if (grade != null) ...[
                                  const SizedBox(width: 6),
                                  Text(
                                    grade.toStringAsFixed(1),
                                    style: const TextStyle(
                                      color: AppColors.secondary,
                                      fontSize: 12,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ],
                              ],
                            ),
                          );
                        },
                      ),
                    ),
                    const SizedBox(height: 6),
                    LinearProgressIndicator(
                      value: progress,
                      color: getProgressColor(progress),
                      backgroundColor: getProgressColor(progress).withOpacity(0.3),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}