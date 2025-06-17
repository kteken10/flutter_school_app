import 'package:flutter/material.dart';
import '../../models/user.dart';
import '../../ui/student_card_info.dart';

class AdminStudentsScreen extends StatefulWidget {
  const AdminStudentsScreen({super.key});

  @override
  State<AdminStudentsScreen> createState() => _AdminStudentsScreenState();
}

class _AdminStudentsScreenState extends State<AdminStudentsScreen> {
  final TextEditingController _searchController = TextEditingController();
  List<UserModel> allStudents = [];
  List<UserModel> filteredStudents = [];

  @override
  void initState() {
    super.initState();
    allStudents = getLocalStudents();
    filteredStudents = allStudents;
    _searchController.addListener(_onSearchChanged);
  }

  void _onSearchChanged() {
    final query = _searchController.text.toLowerCase();
    setState(() {
      filteredStudents = allStudents.where((student) {
        final fullName = "${student.firstName} ${student.lastName}".toLowerCase();
        return fullName.contains(query);
      }).toList();
    });
  }

  List<UserModel> getLocalStudents() {
    return [
      UserModel(
        id: 'et001',
        firstName: 'Alice',
        lastName: 'Dupont',
        role: UserRole.student,
        email: 'alice.dupont@example.com',
        studentId: '1001',
        className: 'L1',
        department: 'Informatique',
        createdAt: DateTime(2023, 9, 1),
      ),
      UserModel(
        id: 'et002',
        firstName: 'Brice',
        lastName: 'Ngoma',
        role: UserRole.student,
        email: 'brice.ngoma@example.com',
        studentId: '1002',
        className: 'L2',
        department: 'Mathématiques',
        createdAt: DateTime(2023, 9, 1),
      ),
      UserModel(
        id: 'et003',
        firstName: 'Carla',
        lastName: 'Mbappe',
        role: UserRole.student,
        email: 'carla.mbappe@example.com',
        studentId: '1003',
        className: 'M1',
        department: 'Physique',
        createdAt: DateTime(2023, 9, 1),
      ),
      UserModel(
        id: 'et004',
        firstName: 'David',
        lastName: 'Kouassi',
        role: UserRole.student,
        email: 'david.kouassi@example.com',
        studentId: '1004',
        className: 'L3',
        department: 'Chimie',
        createdAt: DateTime(2023, 9, 1),
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Liste des étudiants'),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: TextField(
              controller: _searchController,
              decoration: const InputDecoration(
                labelText: 'Rechercher un étudiant',
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 4),
            child: Align(
              alignment: Alignment.centerLeft,
              child: Text(
                'Étudiants trouvés : ${filteredStudents.length}',
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
          ),
          Expanded(
            child: filteredStudents.isEmpty
                ? const Center(child: Text('Aucun étudiant trouvé'))
                : ListView.builder(
                    itemCount: filteredStudents.length,
                    itemBuilder: (context, index) {
                      final student = filteredStudents[index];
                      return StudentCardInfo(
                        student: student,
                        subjectCount: student.subjectsDisplay.length,
                        onTap: () {
                          // TODO: Naviguer vers le détail de l'étudiant
                        },
                      );
                    },
                  ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // TODO: Ajouter un nouvel étudiant localement
        },
        child: const Icon(Icons.add),
      ),
    );
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }
}