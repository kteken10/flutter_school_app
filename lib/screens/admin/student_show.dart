import 'package:flutter/material.dart';
import '../../models/user.dart';
import '../../services/student_service.dart';
import '../../ui/student_card_info.dart';

class AdminStudentsScreen extends StatelessWidget {
  const AdminStudentsScreen({super.key});

  // Liste fictive d'étudiants pour mode bypass
  List<UserModel> getFakeStudents() {
    return [
      UserModel(
        id: 'bypass1',
        firstName: 'Bypass',
        lastName: 'Etudiant1',
        role: UserRole.student,
        email: 'bypass1@exemple.com',
        studentId: '999001',
        className: 'Classe Bypass A',
        department: 'Département Fictif',
        createdAt: DateTime.now(),
        
      ),
      UserModel(
        id: 'bypass2',
        firstName: 'Bypass',
        lastName: 'Etudiant2',
        role: UserRole.student,
        email: 'bypass2@exemple.com',
        studentId: '999002',
        className: 'Classe Bypass B',
        department: 'Département Fictif',
        createdAt: DateTime.now(),
       
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder<List<UserModel>>(
        future: StudentService().getStudents(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          List<UserModel> students;

          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            // Mode bypass : données fictives
            students = getFakeStudents();
          } else {
            students = snapshot.data!;
          }

          if (students.isEmpty) {
            return const Center(child: Text('Aucun étudiant trouvé'));
          }

          return ListView.builder(
            itemCount: students.length,
            itemBuilder: (context, index) {
              final student = students[index];
              return StudentCardInfo(
                student: student,
                subjectCount: student.subjectsDisplay.length,
                onTap: () {
                  // TODO : navigation vers profil étudiant
                },
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // TODO : Ajouter un nouvel étudiant
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
