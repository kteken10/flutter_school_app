import 'package:flutter/material.dart';
import '../constants/colors.dart';
class InfoItem {
  final String label;
  final String value;

  InfoItem({required this.label, required this.value});
}

class ProfileInfoCard extends StatelessWidget {
  final IconData icon;
  final String title;

  final List<InfoItem> infos;

  const ProfileInfoCard({
    super.key,
    required this.icon,
    required this.title,
    required this.infos,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 6),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // En-tête avec icône + titre
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: AppColors.secondary.withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
                child: Icon(icon, color: AppColors.secondary, size: 24),
              ),
              const SizedBox(width: 12),
              Text(
                title,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                  color: AppColors.textprimary,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),

          // Liste des infos
          ...infos.map((info) => Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      flex: 3,
                      child: Text(
                        info.label,
                        style: const TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 13,
                          color: AppColors.textprimary,
                        ),
                      ),
                    ),
                    Expanded(
                      flex: 5,
                      child: Text(
                        info.value,
                        style: const TextStyle(
                          fontSize: 13,
                          color: AppColors.textprimary,
                        ),
                      ),
                    ),
                  ],
                ),
              )),
        ],
      ),
    );
  }
}
