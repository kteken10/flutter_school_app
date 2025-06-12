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
import '../models/class.dart';

// Composant pour les champs de formulaire standardisés
class GradeFormField extends StatelessWidget {
  final String label;
  final Widget child;
  final EdgeInsetsGeometry? padding;

  const GradeFormField({
    super.key,
    required this.label,
    required this.child,
    this.padding,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: padding ?? const EdgeInsets.only(bottom: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: const TextStyle(
              fontWeight: FontWeight.w500,
              color: AppColors.textprimary,
            ),
          ),
          const SizedBox(height: 8),
          child,
        ],
      ),
    );
  }
}

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

  String? _selectedClassId;
  String? _selectedStudentId;
  Subject? _selectedSubject;
  String? _selectedSessionId;
  GradeStatus _selectedStatus = GradeStatus.graded;

  List<ClasseModel> _classes = [];
  List<UserModel> _students = [];
  List<Subject> _subjects = [];
  List<AcademicSession> _sessions = [];

  final DatabaseService _dbService = DatabaseService();
  bool _isSubmitting = false;

  @override
  void initState() {
    super.initState();
    _loadInitialData();
  }

  @override
  void dispose() {
    _gradeController.dispose();
    _commentController.dispose();
    super.dispose();
  }

  Future<void> _loadInitialData() async {
    try {
      final results = await Future.wait([
        _dbService.getClasses(),
        _dbService.getSubjects().first,
        _dbService.getSessions().first,
      ]);

      if (!mounted) return;

      setState(() {
        _classes = List<ClasseModel>.from(results[0]);
        _subjects = List<Subject>.from(results[1]);
        _sessions = List<AcademicSession>.from(results[2]);
      });
    } catch (e) {
      _showError('Erreur de chargement: ${e.toString()}');
    }
  }

  Future<void> _loadStudents(String classId) async {
    try {
      final students = await _dbService.getStudentsByClass(classId);
      if (!mounted) return;

      setState(() {
        _students = List<UserModel>.from(students);
        _selectedStudentId = null;
      });
    } catch (e) {
      _showError('Erreur de chargement des étudiants: ${e.toString()}');
    }
  }

  void _showError(String message) {
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(message)),
      );
    }
  }

  Future<void> _submitGrade() async {
    if (!_formKey.currentState!.validate()) return;
    if (_selectedClassId == null ||
        _selectedStudentId == null ||
        _selectedSubject == null ||
        _selectedSessionId == null) {
      _showError('Veuillez remplir tous les champs obligatoires');
      return;
    }

    setState(() => _isSubmitting = true);

    try {
      final authService = Provider.of<AuthService>(context, listen: false);
      final currentUser = await authService.getCurrentUserModel();

      if (currentUser == null) {
        throw Exception('Utilisateur non connecté');
      }

      final student = _students.firstWhere((s) => s.id == _selectedStudentId);
      final session = _sessions.firstWhere((s) => s.id == _selectedSessionId);

      final grade = Grade(
        id: const Uuid().v4(),
        studentId: _selectedStudentId!,
        subjectId: _selectedSubject!.id,
        sessionId: _selectedSessionId!,
        sessionType: session.type,
        value: _selectedStatus == GradeStatus.graded
            ? double.parse(_gradeController.text)
            : null,
        status: _selectedStatus,
        comment: _commentController.text.isNotEmpty
            ? _commentController.text
            : null,
        teacherId: currentUser.id,
        dateRecorded: DateTime.now(),
        classId: student.className ?? _selectedClassId!,
      );

      await _dbService.addGrade(grade);

      if (!mounted) return;
      widget.onGradeSubmitted();
      Navigator.of(context).pop();
    } catch (e) {
      _showError('Erreur: ${e.toString()}');
    } finally {
      if (mounted) {
        setState(() => _isSubmitting = false);
      }
    }
  }

  InputDecoration _buildInputDecoration() {
    return InputDecoration(
      contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: Colors.grey.shade300),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: Colors.grey.shade300),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: AppColors.secondary, width: 1.5),
      ),
      filled: true,
      fillColor: Colors.grey.shade50,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      insetPadding: const EdgeInsets.all(20),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(24),
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
                    color: AppColors.secondary,
                  ),
                ),
                const SizedBox(height: 24),

                GradeFormField(
                  label: 'Classe *',
                  child: DropdownButtonFormField<String>(
                    value: _selectedClassId,
                    items: _classes.map((c) => DropdownMenuItem(
                      value: c.id,
                      child: Text(c.name),
                    )).toList(),
                    onChanged: (value) {
                      if (value != null) {
                        setState(() => _selectedClassId = value);
                        _loadStudents(value);
                      }
                    },
                    decoration: _buildInputDecoration(),
                    validator: (value) => value == null ? 'Sélection requise' : null,
                  ),
                ),

                GradeFormField(
                  label: 'Étudiant *',
                  child: DropdownButtonFormField<String>(
                    value: _selectedStudentId,
                    items: _students.map((s) => DropdownMenuItem(
                      value: s.id,
                      child: Text('${s.fullName} (${s.studentId ?? 'N/A'})'),
                    )).toList(),
                    onChanged: (value) =>
                        setState(() => _selectedStudentId = value),
                    decoration: _buildInputDecoration(),
                    validator: (value) =>
                        value == null ? 'Sélection requise' : null,
                    disabledHint: _selectedClassId == null
                        ? const Text('Sélectionnez d\'abord une classe')
                        : null,
                  ),
                ),

                GradeFormField(
                  label: 'Matière *',
                  child: DropdownButtonFormField<Subject>(
                    value: _selectedSubject,
                    items: _subjects.map((s) => DropdownMenuItem(
                      value: s,
                      child: Text(s.name),
                    )).toList(),
                    onChanged: (value) => setState(() => _selectedSubject = value),
                    decoration: _buildInputDecoration(),
                    validator: (value) => value == null ? 'Sélection requise' : null,
                  ),
                ),

                GradeFormField(
                  label: 'Session *',
                  child: DropdownButtonFormField<String>(
                    value: _selectedSessionId,
                    items: _sessions.map((s) {
                      final isControleContinu = s.type == ExamSessionType.controleContinu;
                      return DropdownMenuItem(
                        value: s.id,
                        child: Row(
                          children: [
                            Icon(
                              isControleContinu ? Icons.assignment : Icons.assignment_turned_in,
                              color: isControleContinu ? Colors.blue : Colors.green,
                              size: 20,
                            ),
                            const SizedBox(width: 8),
                            Text(s.name),
                          ],
                        ),
                      );
                    }).toList(),
                    onChanged: (value) => setState(() => _selectedSessionId = value),
                    decoration: _buildInputDecoration(),
                    validator: (value) => value == null ? 'Sélection requise' : null,
                  ),
                ),

                // GradeFormField(
                //   label: 'Statut *',
                //   child: StatusSelector(
                //     value: _selectedStatus,
                //     onChanged: (value) {
                //       if (value != null) {
                //         setState(() {
                //           _selectedStatus = value;
                //           if (value != GradeStatus.graded) {
                //             _gradeController.clear();
                //           }
                //         });
                //       }
                //     },
                //   ),
                // ),

                if (_selectedStatus == GradeStatus.graded)
                  GradeFormField(
                    label: 'Note sur 20 *',
                    child: TextFormField(
                      controller: _gradeController,
                      keyboardType: const TextInputType.numberWithOptions(decimal: true),
                      decoration: _buildInputDecoration(),
                      validator: (value) {
                        if (value == null || value.isEmpty) return 'Note requise';
                        final val = double.tryParse(value);
                        if (val == null) return 'Nombre invalide';
                        if (val < 0 || val > 20) return 'Doit être entre 0 et 20';
                        return null;
                      },
                    ),
                  ),

                GradeFormField(
                  label: 'Commentaire (optionnel)',
                  child: TextFormField(
                    controller: _commentController,
                    maxLines: 2,
                    decoration: _buildInputDecoration(),
                  ),
                ),

                const SizedBox(height: 20),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: _isSubmitting ? null : _submitGrade,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.secondary,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: _isSubmitting
                        ? const CircularProgressIndicator(color: Colors.white)
                        : const Text(
                            'ENREGISTRER LA NOTE',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
