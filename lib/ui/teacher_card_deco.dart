import 'package:flutter/material.dart';

class TeacherCardDeco extends StatelessWidget {
  const TeacherCardDeco({super.key});

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
            'assets/teacher_picture.jpg',
            fit: BoxFit.cover,
          ),
        ),
      ),
    );
  }
}