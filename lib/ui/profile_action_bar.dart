import 'package:flutter/material.dart';
import '../constants/colors.dart';

class ProfileActionButton extends StatelessWidget {
  final VoidCallback onPressed;
  final String text;
  final IconData icon;
  final Color color;
  final double iconSize;
  final TextStyle? textStyle;

  const ProfileActionButton({
    super.key,
    required this.onPressed,
    required this.text,
    this.icon = Icons.arrow_forward_ios,
    this.color = AppColors.primary,
    this.iconSize = 18,
    this.textStyle,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: color,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        elevation: 2,
      ),
      onPressed: onPressed,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            text,
            style: textStyle ??
                const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
                ),
          ),
          const SizedBox(width: 8),
          Icon(
            icon,
            size: iconSize,
            color: Colors.white,
          ),
        ],
      ),
    );
  }
}
