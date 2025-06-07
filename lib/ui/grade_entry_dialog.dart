import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';
import '../../models/grade.dart';
import '../../models/subject.dart';
import '../../models/user.dart';
import '../../services/database_service.dart';
import '../../constants/colors.dart'; // pour AppColors

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
        widget.onGradeSubmitted();
        Navigator.of(context).pop();
      });
    }
  }

  InputDecoration _inputDecoration(String label) {
    return InputDecoration(
      labelText: label,
      filled: true,
      fillColor: Colors.grey[100],
      contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: const BorderSide(color: Colors.transparent),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: const BorderSide(color: Colors.transparent),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: BorderSide(color: AppColors.primary, width: 1.5),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      insetPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(28)),
      backgroundColor: Colors.white,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text(
                  'Ajouter une note',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: AppColors.textPrimary,
                    inherit: true,
                  ),
                ),
                const SizedBox(height: 20),
                StreamBuilder<List<UserModel>>(
                  stream: _dbService.getStudents(),
                  builder: (context, snapshot) {
                    if (snapshot.hasError) {
                      return Text('Erreur: ${snapshot.error}');
                    }
                    if (!snapshot.hasData) {
                      return const Center(child: CircularProgressIndicator());
                    }
                    final students = snapshot.data!;
                    return DropdownButtonFormField<String>(
                      value: selectedStudentId,
                      decoration: _inputDecoration('Étudiant'),
                      isExpanded: true,
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
                const SizedBox(height: 12),
                StreamBuilder<List<Subject>>(
                  stream: _dbService.getSubjects(),
                  builder: (context, snapshot) {
                    if (snapshot.hasError) {
                      return Text('Erreur: ${snapshot.error}');
                    }
                    if (!snapshot.hasData) {
                      return const Center(child: CircularProgressIndicator());
                    }
                    final subjects = snapshot.data!;
                    return DropdownButtonFormField<Subject>(
                      value: selectedSubject,
                      decoration: _inputDecoration('Matière'),
                      isExpanded: true,
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
                const SizedBox(height: 12),
                TextFormField(
                  controller: _gradeController,
                  decoration: _inputDecoration('Note (sur 20)'),
                  keyboardType: const TextInputType.numberWithOptions(decimal: true),
                  validator: (value) {
                    final note = double.tryParse(value ?? '');
                    if (note == null || note < 0 || note > 20) {
                      return 'Entrez une note entre 0 et 20';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 24),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    OutlinedButton(
                      onPressed: () => Navigator.pop(context),
                      style: OutlinedButton.styleFrom(
                        foregroundColor: AppColors.primary,
                        side: const BorderSide(color: AppColors.primary),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                      ),
                      child: const Text('Annuler'),
                    ),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primary,
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(18),
                        ),
                        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                      ),
                      onPressed: _submitGrade,
                      child: const Text(
                        'Valider',
                        style: TextStyle(
                          inherit: true,
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
