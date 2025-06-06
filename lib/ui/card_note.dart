import 'package:flutter/material.dart';
import '../constants/colors.dart';

class CardNote extends StatelessWidget {
  final String studentName;
  final String studentClass;
  final String studentPhotoUrl;
  final double note;
  final VoidCallback? onProfileTap;

  const CardNote({
    super.key,
    required this.studentName,
    required this.studentClass,
    required this.studentPhotoUrl,
    required this.note,
    this.onProfileTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.07),
            blurRadius: 8,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Row(
        children: [
          // Photo de l'étudiant
          CircleAvatar(
            radius: 24,
            backgroundImage: NetworkImage(studentPhotoUrl),
            backgroundColor: Colors.grey[200],
          ),
          const SizedBox(width: 14),
          // Infos principales
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  studentName,
                  style: const TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.bold,
                    color: AppColors.primary,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 4),
                Text(
                  studentClass,
                  style: const TextStyle(
                    fontSize: 13,
                    color: Colors.black54,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
          const SizedBox(width: 10),
          // Note de l'étudiant
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: AppColors.primary.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Text(
              note.toStringAsFixed(2),
              style: const TextStyle(
                color: AppColors.primary,
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
          ),
          const SizedBox(width: 10),
          // Icône profil/détail
          IconButton(
            icon: const Icon(Icons.arrow_forward_ios, color: AppColors.primary, size: 22),
            onPressed: onProfileTap,
            tooltip: "Voir le profil",
          ),
        ],
      ),
    );
  }
}