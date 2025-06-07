import 'package:flutter/material.dart';
import '../constants/colors.dart';

class StudentCard extends StatelessWidget {
  final String studentName;
  final String? studentPhotoUrl;  // Pour les images réseau
  final String? studentPhotoAsset;  // Pour les images locales
  final List<String> subjectNames;
  final double progress;  // Valeur entre 0.0 et 1.0
  final VoidCallback? onProfileTap;

  const StudentCard({
    super.key,
    required this.studentName,
    this.studentPhotoUrl,
    this.studentPhotoAsset,
    required this.subjectNames,
    required this.progress,
    this.onProfileTap,
  }) : assert(
          studentPhotoUrl == null || studentPhotoAsset == null,
          'Ne fournissez qu\'une seule source d\'image (URL ou asset)',
        );

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 6),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            children: [
              // Avatar avec gestion des différentes sources d'image
              _buildStudentAvatar(context),
              
              const SizedBox(width: 12),
              
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Nom de l'étudiant et bouton de profil
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            studentName,
                            style: const TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w600,
                              color: AppColors.textPrimary,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        IconButton(
                          icon: const Icon(
                            Icons.arrow_forward_ios,
                            color: AppColors.primary,
                            size: 18,
                          ),
                          onPressed: onProfileTap,
                          padding: EdgeInsets.zero,
                          constraints: const BoxConstraints(),
                        ),
                      ],
                    ),
                    
                    const SizedBox(height: 8),
                    
                    // Liste des matières
                    SizedBox(
                      height: 28,
                      child: ListView.separated(
                        scrollDirection: Axis.horizontal,
                        itemCount: subjectNames.length,
                        separatorBuilder: (_, __) => const SizedBox(width: 6),
                        itemBuilder: (context, index) {
                          return Container(
                            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                            decoration: BoxDecoration(
                              color: AppColors.quaternary,
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Text(
                              subjectNames[index],
                              style: const TextStyle(
                                color: AppColors.primary,
                                fontSize: 12,
                                fontWeight: FontWeight.w500,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          
          const SizedBox(height: 10),
          
          // Barre de progression
          Row(
            children: [
              Expanded(
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: LinearProgressIndicator(
                    value: progress.clamp(0.0, 1.0),
                    minHeight: 6,
                    backgroundColor: Colors.grey.shade200,
                    color: AppColors.secondary,
                    valueColor: AlwaysStoppedAnimation<Color>(
                      _getProgressColor(progress),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 10),
              Text(
                "${(progress * 100).toStringAsFixed(0)}%",
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: AppColors.textSecondary,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStudentAvatar(BuildContext context) {
    if (studentPhotoAsset != null) {
      return CircleAvatar(
        radius: 24,
        backgroundImage: AssetImage(studentPhotoAsset!),
        backgroundColor: Colors.grey.shade300,
        onBackgroundImageError: (exception, stackTrace) => _buildPlaceholder(),
      );
    } else if (studentPhotoUrl != null && studentPhotoUrl!.isNotEmpty) {
      return CircleAvatar(
        radius: 24,
        backgroundImage: NetworkImage(studentPhotoUrl!),
        backgroundColor: Colors.grey.shade300,
        onBackgroundImageError: (exception, stackTrace) => _buildPlaceholder(),
      );
    } else {
      return _buildPlaceholder();
    }
  }

  Widget _buildPlaceholder() {
    return CircleAvatar(
      radius: 24,
      backgroundColor: Colors.grey.shade300,
      child: Icon(
        Icons.person,
        size: 24,
        color: Colors.grey.shade600,
      ),
    );
  }

  Color _getProgressColor(double progress) {
    if (progress >= 0.8) return Colors.green.shade400;
    if (progress >= 0.5) return Colors.orange.shade400;
    return Colors.red.shade400;
  }
}