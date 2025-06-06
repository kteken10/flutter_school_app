import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';

import '../../models/grade.dart';
import '../../models/subject.dart';
import '../../models/user.dart';
import '../../services/database_service.dart';

class GradeEntryScreen extends StatefulWidget {
  const GradeEntryScreen({super.key});

  @override
  State<GradeEntryScreen> createState() => _GradeEntryScreenState();
}

class _GradeEntryScreenState extends State<GradeEntryScreen> {
  final _formKey = GlobalKey<FormState>();
  final _gradeController = TextEditingController();

  String? selectedStudentId;
  Subject? selectedSubject;
  final DatabaseService _dbService = DatabaseService();

  @override
  void dispose() {
    _gradeController.dispose();
    super.dispose();
  }

  void _submitGrade() {
    if (_formKey.currentState!.validate() &&
        selectedStudentId != null &&
        selectedSubject != null) {
      final grade = Grade(
        id: const Uuid().v4(),
        studentId: selectedStudentId!,
        subjectId: selectedSubject!.id,
        sessionId: 'session_1', // Remplace par une vraie session si nécessaire
        value: double.parse(_gradeController.text),
        teacherId: 'teacher_1', // Remplace par l'ID réel de l’enseignant connecté
        dateRecorded: DateTime.now(),
        isFinal: true, // ou false selon ton besoin
        comment: null, // ou une chaîne de texte si tu veux ajouter un commentaire
      );

      _dbService.addGrade(grade).then((_) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Note ajoutée avec succès')),
        );
        _gradeController.clear();
        setState(() {
          selectedStudentId = null;
          selectedSubject = null;
        });
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Saisir une note'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              // Liste des étudiants
              StreamBuilder<List<UserModel>>(
                stream: _dbService.getStudents(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const CircularProgressIndicator();
                  }

                  final students = snapshot.data ?? [];

                  return DropdownButtonFormField<String>(
                    decoration: const InputDecoration(
                      labelText: 'Étudiant',
                      border: OutlineInputBorder(),
                    ),
                    value: selectedStudentId,
                    items: students.map((student) {
                      return DropdownMenuItem(
                        value: student.id,
                        child: Text(student.fullName),
                      );
                    }).toList(),
                    onChanged: (value) {
                      setState(() {
                        selectedStudentId = value;
                      });
                    },
                    validator: (value) =>
                        value == null ? 'Sélectionnez un étudiant' : null,
                  );
                },
              ),
              const SizedBox(height: 16),

              // Liste des matières
              StreamBuilder<List<Subject>>(
                stream: _dbService.getSubjects(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const CircularProgressIndicator();
                  }

                  final subjects = snapshot.data ?? [];

                  return DropdownButtonFormField<Subject>(
                    decoration: const InputDecoration(
                      labelText: 'Matière',
                      border: OutlineInputBorder(),
                    ),
                    value: selectedSubject,
                    items: subjects.map((subject) {
                      return DropdownMenuItem(
                        value: subject,
                        child: Text(subject.name),
                      );
                    }).toList(),
                    onChanged: (value) {
                      setState(() {
                        selectedSubject = value;
                      });
                    },
                    validator: (value) =>
                        value == null ? 'Sélectionnez une matière' : null,
                  );
                },
              ),
              const SizedBox(height: 16),

              // Saisie de la note
              TextFormField(
                controller: _gradeController,
                decoration: const InputDecoration(
                  labelText: 'Note',
                  border: OutlineInputBorder(),
                ),
                keyboardType: const TextInputType.numberWithOptions(decimal: true),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Entrez une note';
                  }
                  final note = double.tryParse(value);
                  if (note == null || note < 0 || note > 20) {
                    return 'Entrez une note entre 0 et 20';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 24),

              ElevatedButton(
                onPressed: _submitGrade,
                child: const Text('Valider'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
