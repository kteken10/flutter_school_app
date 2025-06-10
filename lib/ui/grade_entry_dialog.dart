import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';
import 'package:provider/provider.dart';

import '../../models/grade.dart';
import '../../models/subject.dart';
import '../../models/user.dart';
import '../../services/database_service.dart';
import '../../services/auth_service.dart';
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
  final _commentController = TextEditingController();

  String? selectedClassId;
  String? selectedStudentId;
  Subject? selectedSubject;
  String? selectedSessionId;

  List<String> classes = [];
  List<UserModel> students = [];
  List<Subject> subjects = [];
  List<AcademicSession> sessions = [];

  final _dbService = DatabaseService();
  bool _isSubmitting = false;

  // Style commun pour les champs de formulaire
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
  void initState() {
    super.initState();
    _fetchInitialData();
  }

  Future<void> _fetchInitialData() async {
    try {
      final fetchedClasses = await _dbService.getClasses();
      final fetchedSubjects = await _dbService.getSubjects().first;
      final fetchedSessions = await _dbService.getSessions().first;

      if (mounted) {
        setState(() {
          classes = fetchedClasses.map((c) => c.name).toList();
          subjects = fetchedSubjects;
          sessions = fetchedSessions;
        });
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Erreur de chargement: ${e.toString()}')),
        );
      }
    }
  }

  Future<void> _fetchStudentsForClass(String className) async {
    try {
      final fetchedStudents = await _dbService.getStudentsByClass(className);
      if (mounted) {
        setState(() {
          students = fetchedStudents;
          selectedStudentId = null;
        });
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Erreur de chargement des étudiants: ${e.toString()}')),
        );
      }
    }
  }

  @override
  void dispose() {
    _gradeController.dispose();
    _commentController.dispose();
    super.dispose();
  }

  Future<void> _submitGrade() async {
    if (!_formKey.currentState!.validate() ||
        selectedClassId == null ||
        selectedStudentId == null ||
        selectedSubject == null ||
        selectedSessionId == null) {
      return;
    }

    setState(() => _isSubmitting = true);

    try {
      final authService = Provider.of<AuthService>(context, listen: false);
      final currentUser = await authService.getCurrentUserModel();

      if (currentUser == null || currentUser.id == null) {
        throw Exception('Enseignant non connecté');
      }

      final selectedSession = sessions.firstWhere((s) => s.id == selectedSessionId);

      final grade = Grade(
        id: const Uuid().v4(),
        studentId: selectedStudentId!,
        subjectId: selectedSubject!.id,
        sessionId: selectedSessionId!,
        sessionType: selectedSession.type,
        value: double.parse(_gradeController.text),
        teacherId: currentUser.id,
        dateRecorded: DateTime.now(),
        isFinal: true,
        comment: _commentController.text.isNotEmpty ? _commentController.text : null,
      
      );

      await _dbService.addGrade(grade);

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Note enregistrée avec succès')),
        );
        widget.onGradeSubmitted();
        Navigator.of(context).pop();
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Erreur: ${e.toString()}')),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isSubmitting = false);
      }
    }
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
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Saisie de note',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: AppColors.primary,
                  ),
                ),
                const SizedBox(height: 20),

                // Sélection de la classe
                DropdownButtonFormField<String>(
                  decoration: _inputDecoration('Classe *'),
                  value: selectedClassId,
                  items: classes.map((classId) => DropdownMenuItem(
                    value: classId,
                    child: Text(classId),
                  )).toList(),
                  onChanged: (value) {
                    if (value != null) {
                      setState(() => selectedClassId = value);
                      _fetchStudentsForClass(value);
                    }
                  },
                  validator: (value) => value == null ? 'Champ obligatoire' : null,
                ),
                const SizedBox(height: 16),

                // Sélection de l'étudiant
                DropdownButtonFormField<String>(
                  decoration: _inputDecoration('Étudiant *'),
                  value: selectedStudentId,
                  items: students.map((s) => DropdownMenuItem(
                    value: s.id,
                    child: Text('${s.fullName} (${s.studentId ?? 'N/A'})'),
                  )).toList(),
                  onChanged: (value) => setState(() => selectedStudentId = value),
                  validator: (value) => value == null ? 'Champ obligatoire' : null,
                  disabledHint: selectedClassId == null 
                      ? const Text('Sélectionnez d\'abord une classe')
                      : null,
                ),
                const SizedBox(height: 16),

                // Sélection de la matière
                DropdownButtonFormField<Subject>(
                  decoration: _inputDecoration('Matière *'),
                  value: selectedSubject,
                  items: subjects.map((s) => DropdownMenuItem(
                    value: s,
                    child: Text(s.name),
                  )).toList(),
                  onChanged: (value) => setState(() => selectedSubject = value),
                  validator: (value) => value == null ? 'Champ obligatoire' : null,
                ),
                const SizedBox(height: 16),

                // Sélection de la session
                DropdownButtonFormField<String>(
                  decoration: _inputDecoration('Session *'),
                  value: selectedSessionId,
                  items: sessions.map((s) => DropdownMenuItem(
                    value: s.id,
                    child: Row(
                      children: [
                        Icon(
                          s.type == ExamSessionType.controleContinu 
                              ? Icons.assignment 
                              : Icons.assignment_turned_in,
                          color: s.type == ExamSessionType.controleContinu 
                              ? Colors.blue 
                              : Colors.green,
                        ),
                        const SizedBox(width: 8),
                        Text('${s.name} (${s.name})'),
                      ],
                    ),
                  )).toList(),
                  onChanged: (value) => setState(() => selectedSessionId = value),
                  validator: (value) => value == null ? 'Champ obligatoire' : null,
                ),
                const SizedBox(height: 16),

                // Saisie de la note
                TextFormField(
                  controller: _gradeController,
                  keyboardType: const TextInputType.numberWithOptions(decimal: true),
                  decoration: _inputDecoration('Note sur 20 *'),
                  validator: (value) {
                    if (value == null || value.isEmpty) return 'Champ obligatoire';
                    final val = double.tryParse(value);
                    if (val == null) return 'Nombre invalide';
                    if (val < 0 || val > 20) return 'Doit être entre 0 et 20';
                    return null;
                  },
                ),
                const SizedBox(height: 16),

                // Commentaire optionnel
                TextFormField(
                  controller: _commentController,
                  decoration: _inputDecoration('Commentaire (optionnel)'),
                  maxLines: 2,
                ),
                const SizedBox(height: 24),

                // Bouton d'enregistrement
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: _isSubmitting ? null : _submitGrade,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                    ),
                    child: _isSubmitting
                        ? const CircularProgressIndicator(color: Colors.white)
                        : const Text('ENREGISTRER LA NOTE', 
                            style: TextStyle(fontWeight: FontWeight.bold)),
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