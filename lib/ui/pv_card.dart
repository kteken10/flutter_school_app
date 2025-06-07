import 'package:flutter/material.dart';
import '../constants/colors.dart';

class PvCard extends StatelessWidget {
  final String fileName;
  final DateTime importDate;
  final VoidCallback? onTap;
  final VoidCallback? onDelete;

  const PvCard({
    super.key,
    required this.fileName,
    required this.importDate,
    this.onTap,
    this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 6, horizontal: 16),
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
        child: Row(
          children: [
            const Icon(Icons.description, color: AppColors.primary, size: 32),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    fileName,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: AppColors.textPrimary,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Importé le ${_formatDate(importDate)}',
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey.shade600,
                    ),
                  ),
                ],
              ),
            ),

            // Icône suppression rouge cliquable
            if (onDelete != null)
              IconButton(
                icon: const Icon(Icons.delete, color: Colors.redAccent),
                onPressed: onDelete,
                tooltip: 'Supprimer ce PV',
              )
            else
              const SizedBox(width: 40), // pour conserver l’alignement
          ],
        ),
      ),
    );
  }

  String _formatDate(DateTime date) {
    // Format simple jj/mm/aaaa
    return '${date.day.toString().padLeft(2,'0')}/${date.month.toString().padLeft(2,'0')}/${date.year}';
  }
}
