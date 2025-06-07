import 'package:flutter/material.dart';
import '../../constants/colors.dart';

class FilePickerCard extends StatelessWidget {
  final VoidCallback? onTap;
  final String? fileName;

  const FilePickerCard({
    super.key,
    required this.onTap,
    this.fileName,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
       
        padding: const EdgeInsets.symmetric(vertical: 24),
        decoration: BoxDecoration(
          color: Colors.white, // Fond blanc comme tu souhaitais
          borderRadius: BorderRadius.circular(20),
          
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Image.asset(
              'assets/folder.png',
              width: 100,
              height: 100,
              fit: BoxFit.contain,
            ),
            const SizedBox(height: 16),
          
            if (fileName != null) ...[
              const SizedBox(height: 12),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12),
                child: Text(
                  fileName!,
                  style: TextStyle(
                    fontSize: 14,
                    color: AppColors.textPrimary,
                    fontWeight: FontWeight.w500,
                  ),
                  textAlign: TextAlign.center,
                  overflow: TextOverflow.ellipsis,
                  maxLines: 2,
                ),
              ),
            ]
          ],
        ),
      ),
    );
  }
}
