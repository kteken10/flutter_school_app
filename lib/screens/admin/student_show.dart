import 'package:flutter/material.dart';
import '../../models/user.dart';
import '../../services/student_service.dart';
import '../../ui/student_card_info.dart'; // ✅ Corrigé ici

class AdminStudentsScreen extends StatelessWidget {
  const AdminStudentsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder<List<UserModel>>(
        future: StudentService().getStudents(), // ✅ Corrigé ici
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('Aucun étudiant trouvé'));
          }

          return ListView.builder(
            itemCount: snapshot.data!.length,
            itemBuilder: (context, index) {
              final student = snapshot.data![index];
              return StudentCardInfo(
  student: student,
  subjectCount: student.subjectsDisplay.length,
  
  onTap: () {
    // Naviguer vers le profil de l'étudiant
  },
);

            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Ajouter un nouvel étudiant
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
