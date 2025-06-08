import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';

import '../../models/grade.dart';
import '../../models/subject.dart';
import '../../models/user.dart';
import '../../services/database_service.dart';
import '../../constants/colors.dart';
import '../../models/session.dart';

class GradeEntryDialog extends StatefulWidget {
  final VoidCallback onGradeSubmitted;

  const GradeEntryDialog({super.key, required this.onGradeSubmitted});

  @override
  State<GradeEntryDialog> createState() => _GradeEntryDialogState();
}

class _GradeEntryDialogState extends State<GradeEntryDialog> {
  final _formKey = GlobalKey<FormState>();
  final _gradeController = TextEditingController();

  String? selectedClassId;
  String? selectedStudentId;
  Subject? selectedSubject;
  ExamSessionType? selectedSessionType;

  List<String> classes = [];
  List<UserModel> students = [];
  List<Subject> subjects = [];

  final _dbService = DatabaseService();

  bool _isSubmitting = false;

  @override
  void initState() {
    super.initState();
    _fetchInitialData();
  }

 void _fetchInitialData() async {
  final fetchedClasses = await _dbService.getClasses();

  // Pour convertir le Stream<List<Subject>> en List<Subject> :
  final fetchedSubjects = await _dbService.getSubjects().first;

  setState(() {
    classes = fetchedClasses.map((c) => c.name).toList();
    subjects = fetchedSubjects;
  });
}


  /// Charge les étudiants d’une classe sélectionnée
  void _fetchStudentsForClass(String classId) async {
    final fetchedStudents = await _dbService.getStudentsByClass(classId);
    setState(() {
      students = fetchedStudents;
      selectedStudentId = null; // reset sélection étudiant
    });
  }

  @override
  void dispose() {
    _gradeController.dispose();
    super.dispose();
  }

  /// Soumission du formulaire d’ajout de note
  void _submitGrade() async {
    if (!_formKey.currentState!.validate() ||
        selectedClassId == null ||
        selectedStudentId == null ||
        selectedSubject == null ||
        selectedSessionType == null) {
      return;
    }

    setState(() => _isSubmitting = true);

    final grade = Grade(
      id: const Uuid().v4(),
      studentId: selectedStudentId!,
      subjectId: selectedSubject!.id,
      sessionId: 'session_1', // TODO: gérer dynamiquement ?
      sessionType: selectedSessionType!,
      value: double.parse(_gradeController.text),
      teacherId: 'teacher_1', // TODO: récupérer id enseignant connecté
      dateRecorded: DateTime.now(),
      isFinal: true,
      comment: null,
      academicYearId: '2024-2025', // TODO: rendre dynamique
    );

    try {
      await _dbService.addGrade(grade);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Note ajoutée avec succès')),
        );
        widget.onGradeSubmitted();
        Navigator.of(context).pop();
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Erreur lors de l\'ajout de la note : $e')),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isSubmitting = false);
      }
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
                    color: AppColors.primary,
                  ),
                ),
                const SizedBox(height: 20),

                // Sélection de la classe
                DropdownButtonFormField<String>(
                  decoration: _inputDecoration('Classe'),
                  value: selectedClassId,
                  items: classes.map((classId) {
                    return DropdownMenuItem(
                      value: classId,
                      child: Text(classId), // Adapter selon ClassModel si besoin
                    );
                  }).toList(),
                  onChanged: (value) {
                    if (value != null) {
                      setState(() => selectedClassId = value);
                      _fetchStudentsForClass(value);
                    }
                  },
                  validator: (value) => value == null ? 'Sélectionnez une classe' : null,
                ),
                const SizedBox(height: 16),

                // Étudiants filtrés par classe
                DropdownButtonFormField<String>(
                  decoration: _inputDecoration('Étudiant'),
                  value: selectedStudentId,
                  items: students.map((s) => DropdownMenuItem(
                        value: s.id,
                        child: Text(s.fullName),
                      )).toList(),
                  onChanged: (value) => setState(() => selectedStudentId = value),
                  validator: (value) => value == null ? 'Sélectionnez un étudiant' : null,
                ),
                const SizedBox(height: 16),

                // Matière
                DropdownButtonFormField<Subject>(
                  decoration: _inputDecoration('Matière'),
                  value: selectedSubject,
                  items: subjects.map((s) => DropdownMenuItem(
                        value: s,
                        child: Text(s.name),
                      )).toList(),
                  onChanged: (value) => setState(() => selectedSubject = value),
                  validator: (value) => value == null ? 'Sélectionnez une matière' : null,
                ),
                const SizedBox(height: 16),

                // Session
                DropdownButtonFormField<ExamSessionType>(
                  decoration: _inputDecoration('Type de session'),
                  value: selectedSessionType,
                  items: ExamSessionType.values.map((type) {
                    return DropdownMenuItem(
                      value: type,
                      child: Text(type.name),
                    );
                  }).toList(),
                  onChanged: (value) => setState(() => selectedSessionType = value),
                  validator: (value) => value == null ? 'Sélectionnez un type de session' : null,
                ),
                const SizedBox(height: 16),

                // Note
                TextFormField(
                  controller: _gradeController,
                  keyboardType: const TextInputType.numberWithOptions(decimal: true),
                  decoration: _inputDecoration('Note sur 20'),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Entrez une note';
                    }
                    final val = double.tryParse(value);
                    if (val == null || val < 0 || val > 20) {
                      return 'La note doit être entre 0 et 20';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 24),

                // Bouton de validation désactivé pendant la soumission
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: _isSubmitting ? null : _submitGrade,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                    ),
                    child: _isSubmitting
                        ? const SizedBox(
                            height: 20,
                            width: 20,
                            child: CircularProgressIndicator(
                              color: Colors.white,
                              strokeWidth: 2,
                            ),
                          )
                        : const Text('Valider', style: TextStyle(fontSize: 16)),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
