import 'package:flutter/material.dart';

class TeacherCardDeco extends StatelessWidget {
  final String imagePath;

  const TeacherCardDeco({
    super.key,
    required this.imagePath, // paramètre obligatoire
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(8),
      margin: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(28),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(24),
        child: SizedBox(
          height: 150,
          width: double.infinity,
          child: Image.asset(
            imagePath, // ici on utilise le paramètre
            fit: BoxFit.cover,
          ),
        ),
      ),
    );
  }
}
