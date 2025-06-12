import 'package:flutter/material.dart';
import '../constants/colors.dart';

class AddIcon extends StatelessWidget {
  final VoidCallback? onTap;
  const AddIcon({super.key, this.onTap});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 40,
      height: 40,
      decoration: BoxDecoration(
        color: AppColors.secondary,
        shape: BoxShape.circle,
        boxShadow: [
          // Ombre portée pour l'effet flottant
          BoxShadow(
            color: AppColors.secondary.withOpacity(0.4),
            blurRadius: 8,
            spreadRadius: 1,
            offset: const Offset(0, 4),
          ),
          // Ombre interne pour un effet de profondeur
          BoxShadow(
            color: Colors.white.withOpacity(0.1),
            blurRadius: 2,
            offset: const Offset(0, -2),
          ),
        ],
        // Dégradé subtil pour un effet dynamique
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            AppColors.secondary.withOpacity(0.9),
            AppColors.secondary.withOpacity(1.0),
          ],
        ),
      ),
      child: Material(
        type: MaterialType.transparency,
        child: InkWell(
          borderRadius: BorderRadius.circular(20),
          onTap: onTap,
          splashColor: Colors.white.withOpacity(0.3),
          child: const Center(
            child: Icon(
              Icons.add,
              color: Colors.white,
              size: 22,
            ),
          ),
        ),
      ),
    );
  }
}