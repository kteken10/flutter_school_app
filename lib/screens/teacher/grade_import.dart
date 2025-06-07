import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import '../../constants/colors.dart';
import '../../ui/teacher_card_deco.dart';

class GradeImportScreen extends StatefulWidget {
  const GradeImportScreen({super.key});

  @override
  State<GradeImportScreen> createState() => _GradeImportScreenState();
}

class _GradeImportScreenState extends State<GradeImportScreen> {
  String? _fileName;
  bool _isImporting = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.quaternary.withOpacity(0.1),

      appBar: AppBar(
        title: const Text('Upload des Notes'),
        centerTitle: true,
      ),

      body: SingleChildScrollView(
        child: Column(
          children: [
            // Carte de déco avec image
            const SizedBox(height: 24),
            const TeacherCardDeco(imagePath: 'assets/import_note.jpg'),
            const SizedBox(height: 24),

            // Sous-titre explicatif
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Text(
                'Sélectionnez un fichier Excel ou CSV contenant les notes',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.grey.shade600,
                ),
              ),
            ),

            const SizedBox(height: 32),

            // Bouton choisir fichier
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 40),
              child: ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.secondary,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                ),
                icon: const Icon(Icons.attach_file, size: 22),
                label: const Text(
                  'Choisir un fichier',
                  style: TextStyle(fontSize: 18),
                ),
                onPressed: _isImporting ? null : _selectFile,
              ),
            ),

            if (_fileName != null) ...[
              const SizedBox(height: 24),

              // Affichage nom du fichier
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 32),
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  decoration: BoxDecoration(
                    color: AppColors.quaternary.withOpacity(0.15),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(Icons.insert_drive_file, size: 20, color: AppColors.primary),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          _fileName!,
                          style: TextStyle(
                            fontSize: 16,
                            color: AppColors.textPrimary,
                            fontWeight: FontWeight.w600,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 32),

              // Bouton Importer
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 40),
                child: SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                    ),
                    onPressed: _isImporting ? null : _importGrades,
                    child: _isImporting
                        ? SizedBox(
                            height: 24,
                            width: 24,
                            child: CircularProgressIndicator(color: Colors.white, strokeWidth: 3),
                          )
                        : const Text(
                            'Importer les notes',
                            style: TextStyle(fontSize: 18),
                          ),
                  ),
                ),
              ),
            ],

            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }

  Future<void> _selectFile() async {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['xlsx', 'xls', 'csv'],
    );

    if (result != null) {
      setState(() {
        _fileName = result.files.single.name;
      });
    }
  }

  Future<void> _importGrades() async {
    if (_fileName == null) return;

    setState(() => _isImporting = true);

    // Simulation d'import
    await Future.delayed(const Duration(seconds: 2));

    setState(() => _isImporting = false);

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Importation réussie!'),
        backgroundColor: Colors.green,
      ),
    );
  }
}
