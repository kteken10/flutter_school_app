import 'package:flutter/material.dart';

class TeacherCardDeco extends StatelessWidget {
  final String imagePath;
  final bool withHorizontalMargin;

  const TeacherCardDeco({
    super.key,
    required this.imagePath,
    this.withHorizontalMargin = true, // option par défaut
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      // padding: const EdgeInsets.all(8),
      margin: withHorizontalMargin
          ? const EdgeInsets.symmetric(horizontal: 16)
          : EdgeInsets.zero,
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
            imagePath,
            fit: BoxFit.cover,
          ),
        ),
      ),
    );
  }
}
