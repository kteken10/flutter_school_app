import 'package:flutter/material.dart';
import '../constants/colors.dart';
import 'input_field.dart';

class SearchZone extends StatelessWidget {
  final TextEditingController controller;
  final VoidCallback? onCameraPressed;
  final VoidCallback? onMicPressed;
  final String hintText;
  final bool showSearchIcon;
  final double spacing;

  const SearchZone({
    super.key,
    required this.controller,
    this.onCameraPressed,
    this.onMicPressed,
    this.hintText = 'Search',
    this.showSearchIcon = true,
    this.spacing = 12.0,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // Champ de recherche étendu
          Expanded(
            child: InputField(
              controller: controller,
              keyboardType: TextInputType.text,
              obscureText: false,
              showSearchIcon: showSearchIcon,
              hintText: hintText,
              borderColor: Colors.transparent,
              suffixIcon: onMicPressed != null
                  ? IconButton(
                      icon: const Icon(Icons.mic, color: AppColors.textSecondary),
                      onPressed: onMicPressed,
                    )
                  : null,
            ),
          ),

          // Espacement
          SizedBox(width: spacing),

          // Bouton caméra parfaitement aligné
          if (onCameraPressed != null)
            Container(
              height: 40,
              width: 40,
              margin: const EdgeInsets.only(top: 8),
              child: IconButton(
                icon: const Icon(Icons.camera_alt, size: 20, color: AppColors.textSecondary),
                onPressed: onCameraPressed,
                padding: EdgeInsets.zero,
                style: IconButton.styleFrom(
                  backgroundColor: AppColors.textSecondary.withOpacity(0.7),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(50),
                    side: const BorderSide(color: AppColors.textSecondary, width: 1),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}