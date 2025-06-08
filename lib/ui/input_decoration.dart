import 'package:flutter/material.dart';
import '../constants/colors.dart';

class InputDecorations {
  // Méthode statique pour un InputDecoration standard avec icône
  static InputDecoration standard(String label, IconData? icon) {
    return InputDecoration(
      labelText: label,
      prefixIcon: icon != null 
          ? Icon(icon, color: AppColors.textSecondary.withOpacity(0.2), size: 22) 
          : null,
      filled: true,
      fillColor: Colors.white,
      contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(50),
        borderSide: BorderSide.none,
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(50),
        borderSide: BorderSide.none,
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(50),
        borderSide: const BorderSide(color: Colors.white),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(50),
        borderSide: const BorderSide(color: Colors.red),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(50),
        borderSide: const BorderSide(color: Colors.red),
      ),
    );
  }
}
