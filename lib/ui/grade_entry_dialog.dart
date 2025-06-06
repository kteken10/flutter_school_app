import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';
import '../../models/grade.dart';
import '../../models/subject.dart';
import '../../models/user.dart';
import '../../services/database_service.dart';

class GradeEntryDialog extends StatefulWidget {
  final VoidCallback onGradeSubmitted;

  const GradeEntryDialog({super.key, required this.onGradeSubmitted});

  @override
  State<GradeEntryDialog> createState() => _GradeEntryDialogState();
}

class _GradeEntryDialogState extends State<GradeEntryDialog> {
  final _formKey = GlobalKey<FormState>();
  final _gradeController = TextEditingController();
  String? selectedStudentId;
  Subject? selectedSubject;
  final _dbService = DatabaseService();

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
        sessionId: 'session_1',
        value: double.parse(_gradeController.text),
        teacherId: 'teacher_1',
        dateRecorded: DateTime.now(),
        isFinal: true,
        comment: null,
      );

      _dbService.addGrade(grade).then((_) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Note ajoutée avec succès')),
        );
        widget.onGradeSubmitted(); // Pour rafraîchir la liste
        Navigator.of(context).pop();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Ajouter une note'),
      content: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              StreamBuilder<List<UserModel>>(
                stream: _dbService.getStudents(),
                builder: (context, snapshot) {
                  if (!snapshot.hasData) return const CircularProgressIndicator();
                  final students = snapshot.data!;
                  return DropdownButtonFormField<String>(
                    value: selectedStudentId,
                    decoration: const InputDecoration(labelText: 'Étudiant'),
                    items: students.map((student) {
                      return DropdownMenuItem(
                        value: student.id,
                        child: Text(student.fullName),
                      );
                    }).toList(),
                    onChanged: (value) => setState(() => selectedStudentId = value),
                    validator: (value) => value == null ? 'Sélectionnez un étudiant' : null,
                  );
                },
              ),
              const SizedBox(height: 10),
              StreamBuilder<List<Subject>>(
                stream: _dbService.getSubjects(),
                builder: (context, snapshot) {
                  if (!snapshot.hasData) return const CircularProgressIndicator();
                  final subjects = snapshot.data!;
                  return DropdownButtonFormField<Subject>(
                    value: selectedSubject,
                    decoration: const InputDecoration(labelText: 'Matière'),
                    items: subjects.map((subject) {
                      return DropdownMenuItem(
                        value: subject,
                        child: Text(subject.name),
                      );
                    }).toList(),
                    onChanged: (value) => setState(() => selectedSubject = value),
                    validator: (value) => value == null ? 'Sélectionnez une matière' : null,
                  );
                },
              ),
              const SizedBox(height: 10),
              TextFormField(
                controller: _gradeController,
                decoration: const InputDecoration(labelText: 'Note'),
                keyboardType: const TextInputType.numberWithOptions(decimal: true),
                validator: (value) {
                  final note = double.tryParse(value ?? '');
                  if (note == null || note < 0 || note > 20) {
                    return 'Entrez une note entre 0 et 20';
                  }
                  return null;
                },
              ),
            ],
          ),
        ),
      ),
      actions: [
        TextButton(onPressed: () => Navigator.pop(context), child: const Text('Annuler')),
        ElevatedButton(onPressed: _submitGrade, child: const Text('Valider')),
      ],
    );
  }
}
