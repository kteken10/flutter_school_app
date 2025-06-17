import 'package:flutter/material.dart';
import '../../constants/colors.dart';
import '../../models/user.dart';

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
  final List<UserModel> students;
  final List<String> classes;
  final List<String> subjects;
  final Function(UserModel, String, String, double, String) onSubmit;

  const GradeEntryDialog({
    super.key,
    required this.onGradeSubmitted,
    required this.students,
    required this.classes,
    required this.subjects,
    required this.onSubmit,
  });

  @override
  State<GradeEntryDialog> createState() => _GradeEntryDialogState();
}

class _GradeEntryDialogState extends State<GradeEntryDialog> {
  final _formKey = GlobalKey<FormState>();
  final _gradeController = TextEditingController();
  final _commentController = TextEditingController();

  String? _selectedClass;
  UserModel? _selectedStudent;
  String? _selectedSubject;
  String? _selectedSessionType = 'Contrôle Continu';
  bool _isSubmitting = false;

  final List<String> _sessionTypes = ['Contrôle Continu', 'Session Normale'];
  List<UserModel> _filteredStudents = [];

  @override
  void initState() {
    super.initState();
    _filteredStudents = widget.students;
  }

  @override
  void dispose() {
    _gradeController.dispose();
    _commentController.dispose();
    super.dispose();
  }

  void _showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

  void _filterStudentsByClass(String? classId) {
    setState(() {
      _selectedClass = classId;
      _selectedStudent = null;
      _filteredStudents = classId == null 
          ? widget.students 
          : widget.students.where((s) => s.className == classId).toList();
    });
  }

  void _submitGrade() {
    if (!_formKey.currentState!.validate()) return;
    if (_selectedStudent == null || _selectedSubject == null || _selectedSessionType == null) {
      _showError('Veuillez remplir tous les champs obligatoires');
      return;
    }

    setState(() => _isSubmitting = true);

    final grade = double.parse(_gradeController.text);
    widget.onSubmit(
      _selectedStudent!,
      _selectedSubject!,
      _selectedSessionType!,
      grade,
      _commentController.text,
    );

    widget.onGradeSubmitted();
    Navigator.of(context).pop();
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
                    value: _selectedClass,
                    items: widget.classes.map((c) => DropdownMenuItem(
                      value: c,
                      child: Text(c),
                    )).toList(),
                    onChanged: _filterStudentsByClass,
                    decoration: _buildInputDecoration(),
                    validator: (value) => value == null ? 'Sélection requise' : null,
                  ),
                ),

                GradeFormField(
                  label: 'Étudiant *',
                  child: DropdownButtonFormField<UserModel>(
                    value: _selectedStudent,
                    items: _filteredStudents.map((student) => DropdownMenuItem(
                      value: student,
                      child: Text(student.fullName),
                    )).toList(),
                    onChanged: (student) => setState(() => _selectedStudent = student),
                    decoration: _buildInputDecoration(),
                    validator: (value) => value == null ? 'Sélection requise' : null,
                  ),
                ),

                GradeFormField(
                  label: 'Matière *',
                  child: DropdownButtonFormField<String>(
                    value: _selectedSubject,
                    items: widget.subjects.map((s) => DropdownMenuItem(
                      value: s,
                      child: Text(s),
                    )).toList(),
                    onChanged: (value) => setState(() => _selectedSubject = value),
                    decoration: _buildInputDecoration(),
                    validator: (value) => value == null ? 'Sélection requise' : null,
                  ),
                ),

                GradeFormField(
                  label: 'Type de session *',
                  child: DropdownButtonFormField<String>(
                    value: _selectedSessionType,
                    items: _sessionTypes.map((s) => DropdownMenuItem(
                      value: s,
                      child: Text(s),
                    )).toList(),
                    onChanged: (value) => setState(() => _selectedSessionType = value),
                    decoration: _buildInputDecoration(),
                    validator: (value) => value == null ? 'Sélection requise' : null,
                  ),
                ),

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