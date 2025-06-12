import 'package:flutter/material.dart';
import '../../constants/colors.dart';
import '../../models/user.dart';

class StudentCardInfo extends StatelessWidget {
  final UserModel student;
  final int subjectCount;
  final double? progress;
  final VoidCallback? onTap;

  const StudentCardInfo({
    super.key,
    required this.student,
    required this.subjectCount,
    this.progress,
    this.onTap,
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
    final photoUrl = student.photoUrl;
    final level = student.className ?? "N/A";

    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
      elevation: 1,
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Row(
            children: [
              Stack(
                alignment: Alignment.bottomCenter,
                children: [
                  CircleAvatar(
                    radius: 28,
                    backgroundImage: (photoUrl != null && photoUrl.isNotEmpty)
                        ? NetworkImage(photoUrl)
                        : const AssetImage('assets/student_1.png') as ImageProvider,
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                    decoration: BoxDecoration(
                      color: getClassColor(level),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Text(
                      level,
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
                    Text(
                      student.fullName,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                        color: AppColors.textprimary,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      "$subjectCount matières suivies",
                      style: const TextStyle(
                        fontSize: 12,
                        color: AppColors.textprimary,
                      ),
                    ),
                    const SizedBox(height: 6),
                    LinearProgressIndicator(
                      value: progress,
                      color: getProgressColor(progress!),
                      backgroundColor: getProgressColor(progress!).withOpacity(0.3),
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
