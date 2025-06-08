import 'package:flutter/material.dart';
import '../constants/colors.dart';

class InputField extends StatelessWidget {
  final TextEditingController controller;
  final String label;
  final String? hintText;
  final TextInputType keyboardType;
  final bool obscureText;
  final Widget? prefixIcon;
  final Widget? suffixIcon;
  final bool showSearchIcon;
  final Color borderColor;
  final Color? focusedBorderColor;
  final String? Function(String?)? validator; // Ajout du validateur
  final bool enabled; // Nouveau paramètre pour enabled

  const InputField({
    super.key,
    required this.controller,
    this.label = '',
    this.hintText,
    this.keyboardType = TextInputType.text,
    this.obscureText = false,
    this.prefixIcon,
    this.suffixIcon,
    this.showSearchIcon = false,
    this.borderColor = Colors.white,
    this.focusedBorderColor,
    this.validator, // Ajout dans le constructeur
    this.enabled = true, // Valeur par défaut à true
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (label.isNotEmpty)
            Text(
              label,
              style: const TextStyle(
                color: Colors.black,
              ),
            ),
          const SizedBox(height: 8.0),
          TextFormField(
            controller: controller,
            keyboardType: keyboardType,
            obscureText: obscureText,
            style: const TextStyle(color: Colors.black),
            enabled: enabled, // Utilisation du paramètre enabled
            validator: validator, // Ajout du validateur ici
            decoration: InputDecoration(
              fillColor: Colors.white,
              filled: true,
              contentPadding: const EdgeInsets.symmetric(
                vertical: 12.0,
                horizontal: 16.0,
              ),
              hintText: hintText,
              hintStyle: const TextStyle(color: AppColors.textSecondary),
              prefixIcon: prefixIcon ?? (showSearchIcon 
                  ? const Icon(
                      Icons.search_rounded,
                      color: AppColors.textSecondary,
                      size: 24,
                    ) 
                  : null),
              suffixIcon: suffixIcon,
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(16.0),
                borderSide: BorderSide(color: borderColor),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(16.0),
                borderSide: BorderSide(
                  color: focusedBorderColor ?? borderColor,
                  width: 1,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}