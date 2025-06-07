import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import '../../constants/colors.dart';
import '../../ui/file_pciker_card.dart';
import '../../ui/teacher_card_deco.dart';
import '../../ui/pv_card.dart';  // Ton widget PvCard avec suppression

class GradeImportScreen extends StatefulWidget {
  const GradeImportScreen({super.key});

  @override
  State<GradeImportScreen> createState() => _GradeImportScreenState();
}

class _GradeImportScreenState extends State<GradeImportScreen> {
  String? _fileName;
  bool _isImporting = false;

  final List<Map<String, dynamic>> _importedPvs = [
    {'fileName': 'notes_math_2025.xlsx', 'date': DateTime(2025, 5, 15)},
    {'fileName': 'pv_physique_mars.csv', 'date': DateTime(2025, 3, 28)},
    {'fileName': 'resultats_chimie.xls', 'date': DateTime(2025, 2, 10)},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Titre de la page + dossier en haut à droite
           Padding(
  padding: const EdgeInsets.fromLTRB(16.0, 40.0, 16.0, 16.0),
  child: Row(
    mainAxisAlignment: MainAxisAlignment.spaceBetween,
    crossAxisAlignment: CrossAxisAlignment.center, // CENTRER VERTICALEMENT
    children: [
      const Text(
        'Importer des notes',
        style: TextStyle(
          fontSize: 20,
          color: AppColors.textPrimary,
        ),
      ),

      SizedBox(
        width: 40,
        height: 40,
        child: FilePickerCard(
          onTap: _isImporting ? null : () async {
            await _selectFile();
          },
          fileName: null,
        ),
      ),
    ],
  ),
),


        

            const TeacherCardDeco(imagePath: 'assets/import_note.jpg'),

            if (_importedPvs.isNotEmpty) ...[
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    'PV déjà importés :',
                    style: TextStyle(
                       fontSize: 16,
                                    fontWeight: FontWeight.w600,
                                    color: AppColors.primary,
                    ),
                  ),
                ),
              ),

           

              ListView.builder(
                physics: const NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                itemCount: _importedPvs.length,
                itemBuilder: (context, index) {
                  final pv = _importedPvs[index];
                  return PvCard(
                    fileName: pv['fileName'],
                    importDate: pv['date'],
                    onTap: () {
                      // action clic sur PV
                    },
                    onDelete: () {
                      setState(() {
                        _importedPvs.removeAt(index);
                      });
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('${pv['fileName']} supprimé')),
                      );
                    },
                  );
                },
              ),

              const SizedBox(height: 24),
            ],

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


            if (_fileName != null) ...[
              const SizedBox(height: 32),

              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 40),
                child: SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.secondary,
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
                            child: CircularProgressIndicator(
                              color: Colors.white,
                              strokeWidth: 3,
                            ),
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

    setState(() {
      _importedPvs.add({
        'fileName': _fileName!,
        'date': DateTime.now(),
      });
      _fileName = null;
      _isImporting = false;
    });

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Importation réussie!'),
        backgroundColor: Colors.green,
      ),
    );
  }
}
