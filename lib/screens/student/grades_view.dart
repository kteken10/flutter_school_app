import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../models/grade.dart';
import '../../models/subject.dart';
import '../../models/user.dart';

import '../../services/grade_service.dart';
import '../../services/subject_service.dart';
import '../../services/auth_service.dart';

class GradesViewScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final authService = Provider.of<AuthService>(context, listen: false);
    final gradeService = Provider.of<GradeService>(context, listen: false);
    final subjectService = Provider.of<SubjectService>(context, listen: false);

    return Scaffold(
      appBar: AppBar(title: Text('Mes notes')),
      body: StreamBuilder<UserModel?>(
        stream: authService.currentUser,
        builder: (context, userSnapshot) {
          if (userSnapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }

          final user = userSnapshot.data;
          if (user == null || user.studentId == null) {
            return Center(child: Text('Informations étudiant non disponibles'));
          }

          return StreamBuilder<List<Grade>>(
            stream: gradeService.getStudentGrades(user.studentId!),
            builder: (context, gradesSnapshot) {
              if (gradesSnapshot.connectionState == ConnectionState.waiting) {
                return Center(child: CircularProgressIndicator());
              }

              final grades = gradesSnapshot.data ?? [];

              if (grades.isEmpty) {
                return Center(child: Text('Aucune note disponible'));
              }

              return ListView.builder(
                itemCount: grades.length,
                itemBuilder: (context, index) {
                  final grade = grades[index];
                  return FutureBuilder<Subject?>(
                    future: subjectService.getSubjectById(grade.subjectId),
                    builder: (context, subjectSnapshot) {
                      final subject = subjectSnapshot.data;
                      return ListTile(
                        title: Text(subject?.name ?? 'Matière inconnue'),
                        subtitle: Text('Session: ${grade.sessionId}'),
                        trailing: Text('${grade.value.toStringAsFixed(2)}/20'),
                      );
                    },
                  );
                },
              );
            },
          );
        },
      ),
    );
  }
}
