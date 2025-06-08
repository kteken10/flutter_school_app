import 'package:flutter/material.dart';
import '../constants/colors.dart';

class StudentCard extends StatelessWidget {
  final String studentName;
  final String? studentPhotoUrl;
  final String? studentPhotoAsset;
  final List<String> subjectNames;
  final List<double>? subjectGrades;
  final double progress;
  final VoidCallback? onProfileTap;

  const StudentCard({
    super.key,
    required this.studentName,
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

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.white,  // <-- ici on définit la couleur de fond blanche
      elevation: 0.5,
      margin: const EdgeInsets.symmetric(vertical: 8),
      child: InkWell(
        onTap: onProfileTap,
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Row(
            children: [
              CircleAvatar(
                radius: 28,
                backgroundImage: studentPhotoUrl != null && studentPhotoUrl!.isNotEmpty
                    ? NetworkImage(studentPhotoUrl!)
                    : AssetImage(studentPhotoAsset ?? 'assets/student_1.png') as ImageProvider,
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      studentName,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: AppColors.textPrimary,
                      ),
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
                                    color: AppColors.primary,
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
                                      color: AppColors.primary,
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
