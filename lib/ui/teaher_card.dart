import 'package:flutter/material.dart';
import '../constants/colors.dart';

class TeacherCard extends StatelessWidget {
  final String teacherName;
  final String department;
  final String? teacherPhotoUrl;
  final List<String> subjectsTaught;
  final int yearsOfExperience;
  final VoidCallback? onProfileTap;
  final String email;
  final int classCount;
  final VoidCallback onAddPressed;

  const TeacherCard({
    super.key,
    required this.teacherName,
    required this.department,
    this.teacherPhotoUrl,
    required this.subjectsTaught,
    this.yearsOfExperience = 0,
    this.onProfileTap,
    required this.email,
    required this.classCount,
    required this.onAddPressed,
  });

  Color getDepartmentColor(String dept) {
    switch (dept.toLowerCase()) {
      case 'mathématiques':
        return Colors.blue;
      case 'physique':
        return Colors.red;
      case 'chimie':
        return Colors.green;
      case 'informatique':
        return Colors.purple;
      case 'biologie':
        return Colors.teal;
      default:
        return AppColors.secondary;
    }
  }

  Widget _buildInfoBadge(String label, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
      decoration: BoxDecoration(
        color: color.withOpacity(0.2),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        label,
        style: TextStyle(
          color: color,
          fontSize: 12,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget _buildCompactChip(String label, Color color) {
    return Chip(
      label: Text(
        label,
        style: const TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w500,
        ),
      ),
      backgroundColor: color.withOpacity(0.2),
      visualDensity: VisualDensity.compact,
      materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
      padding: const EdgeInsets.symmetric(horizontal: 4),
      labelPadding: const EdgeInsets.symmetric(horizontal: 4),
    );
  }

  @override
  Widget build(BuildContext context) {
    final departmentColor = getDepartmentColor(department);

    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: InkWell(
        onTap: onProfileTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Photo de profil avec badge de département
                  Stack(
                    alignment: Alignment.bottomCenter,
                    children: [
                      CircleAvatar(
                        radius: 28,
                        backgroundImage: teacherPhotoUrl != null
                            ? NetworkImage(teacherPhotoUrl!)
                            : const AssetImage('assets/default_teacher.png')
                                as ImageProvider,
                      ),
                      Container(
                        padding:
                            const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                        decoration: BoxDecoration(
                          color: departmentColor,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          department.substring(0, 3).toUpperCase(),
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
                          teacherName,
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Row(
                          children: [
                            const Icon(Icons.email, size: 16),
                            const SizedBox(width: 4),
                            Expanded(
                              child: Text(
                                email,
                                style: const TextStyle(fontSize: 14),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        Row(
                          children: [
                            _buildInfoBadge(
                                '$yearsOfExperience ans exp', departmentColor),
                            const SizedBox(width: 8),
                            _buildInfoBadge(
                                '$classCount classes', departmentColor),
                          ],
                        ),
                      ],
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.add_circle_outline,
                        color: AppColors.secondary),
                    onPressed: onAddPressed,
                  ),
                ],
              ),
              const SizedBox(height: 12),
              const Text(
                'Matières enseignées:',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              Wrap(
                spacing: 8,
                runSpacing: 4,
                children: subjectsTaught
                    .map((subject) => _buildCompactChip(subject, departmentColor))
                    .toList(),
              ),
            ],
          ),
        ),
      ),
    );
  }
}