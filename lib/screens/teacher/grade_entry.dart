import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';

import '../../models/grade.dart';
import '../../models/subject.dart';
import '../../models/user.dart';
import '../../models/session.dart';
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
  String? selectedSessionId;
  String? selectedAcademicYearId;
  ExamSessionType? selectedSessionType;

  final DatabaseService _dbService = DatabaseService();

  @override
  void dispose() {
    _gradeController.dispose();
    super.dispose();
  }

  void _submitGrade() {
    if (_formKey.currentState!.validate() &&
        selectedStudentId != null &&
        selectedSubject != null &&
        selectedSessionId != null &&
        selectedAcademicYearId != null &&
        selectedSessionType != null) {
      final grade = Grade(
        id: const Uuid().v4(),
        studentId: selectedStudentId!,
        subjectId: selectedSubject!.id,
        sessionId: selectedSessionId!,
        sessionType: selectedSessionType!,
        value: double.parse(_gradeController.text),
        teacherId: 'teacher_1', // À remplacer par l’ID réel de l’enseignant
        dateRecorded: DateTime.now(),
        isFinal: true,
        comment: null,
        academicYearId: selectedAcademicYearId!,
      );

      _dbService.addGrade(grade).then((_) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Note ajoutée avec succès')),
        );
        _gradeController.clear();
        setState(() {
          selectedStudentId = null;
          selectedSubject = null;
          selectedSessionId = null;
          selectedAcademicYearId = null;
          selectedSessionType = null;
        });
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Saisir une note')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              // Étudiant
              StreamBuilder<List<UserModel>>(
                stream: _dbService.getStudents(),
                builder: (context, snapshot) {
                  if (!snapshot.hasData) return const CircularProgressIndicator();
                  final students = snapshot.data!;
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
                    onChanged: (value) => setState(() => selectedStudentId = value),
                    validator: (value) =>
                        value == null ? 'Sélectionnez un étudiant' : null,
                  );
                },
              ),
              const SizedBox(height: 16),

              // Matière
              StreamBuilder<List<Subject>>(
                stream: _dbService.getSubjects(),
                builder: (context, snapshot) {
                  if (!snapshot.hasData) return const CircularProgressIndicator();
                  final subjects = snapshot.data!;
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
                    onChanged: (value) => setState(() => selectedSubject = value),
                    validator: (value) =>
                        value == null ? 'Sélectionnez une matière' : null,
                  );
                },
              ),
              const SizedBox(height: 16),

              // Session académique
              StreamBuilder<List<AcademicSession>>(
                stream: _dbService.getSessions(),
                builder: (context, snapshot) {
                  if (!snapshot.hasData) return const CircularProgressIndicator();
                  final sessions = snapshot.data!;
                  return DropdownButtonFormField<String>(
                    decoration: const InputDecoration(
                      labelText: 'Session Académique',
                      border: OutlineInputBorder(),
                    ),
                    value: selectedSessionId,
                    items: sessions.map((session) {
                      return DropdownMenuItem(
                        value: session.id,
                        child: Text(session.name),
                      );
                    }).toList(),
                    onChanged: (value) => setState(() => selectedSessionId = value),
                    validator: (value) =>
                        value == null ? 'Sélectionnez une session' : null,
                  );
                },
              ),
              const SizedBox(height: 16),

              // Année académique (temporaire, à remplacer si base de données disponible)
              DropdownButtonFormField<String>(
                decoration: const InputDecoration(
                  labelText: 'Année académique',
                  border: OutlineInputBorder(),
                ),
                value: selectedAcademicYearId,
                items: const [
                  DropdownMenuItem(value: '2023-2024', child: Text('2023-2024')),
                  DropdownMenuItem(value: '2024-2025', child: Text('2024-2025')),
                ],
                onChanged: (value) => setState(() => selectedAcademicYearId = value),
                validator: (value) =>
                    value == null ? 'Sélectionnez une année académique' : null,
              ),
              const SizedBox(height: 16),

              // Type de session d'examen
              DropdownButtonFormField<ExamSessionType>(
                decoration: const InputDecoration(
                  labelText: 'Type de session',
                  border: OutlineInputBorder(),
                ),
                value: selectedSessionType,
                items: ExamSessionType.values.map((type) {
                  return DropdownMenuItem(
                    value: type,
                    child: Text(type.name), // Ou customiser l'affichage
                  );
                }).toList(),
                onChanged: (value) => setState(() => selectedSessionType = value),
                validator: (value) =>
                    value == null ? 'Sélectionnez un type de session' : null,
              ),
              const SizedBox(height: 16),

              // Note
              TextFormField(
                controller: _gradeController,
                decoration: const InputDecoration(
                  labelText: 'Note',
                  border: OutlineInputBorder(),
                ),
                keyboardType:
                    const TextInputType.numberWithOptions(decimal: true),
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
