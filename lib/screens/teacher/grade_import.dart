import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';

class GradeImportScreen extends StatefulWidget {
  @override
  _GradeImportScreenState createState() => _GradeImportScreenState();
}

class _GradeImportScreenState extends State<GradeImportScreen> {
  String? _fileName;
  bool _isImporting = false;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.upload_file, size: 80, color: Colors.blue),
          SizedBox(height: 24),
          Text(
            'Importer des notes',
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 16),
          Text(
            'Sélectionnez un fichier Excel ou CSV contenant les notes',
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 16, color: Colors.grey),
          ),
          SizedBox(height: 32),
          ElevatedButton.icon(
            icon: Icon(Icons.attach_file),
            label: Text('Choisir un fichier'),
            onPressed: _isImporting ? null : _selectFile,
          ),
          SizedBox(height: 16),
          if (_fileName != null) ...[
            SizedBox(height: 16),
            Text('Fichier sélectionné: $_fileName'),
            SizedBox(height: 24),
            ElevatedButton(
              onPressed: _isImporting ? null : _importGrades,
              child: _isImporting
                  ? CircularProgressIndicator(color: Colors.white)
                  : Text('Importer les notes'),
            ),
          ],
        ],
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

    // Simuler un import
    await Future.delayed(Duration(seconds: 2));

    setState(() => _isImporting = false);

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Importation réussie!'),
        backgroundColor: Colors.green,
      ),
    );
  }
}