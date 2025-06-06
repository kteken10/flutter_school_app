import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../services/database_service.dart';
import '../../models/session.dart';
import '../../models/subject.dart';

class ReportGenerationScreen extends StatefulWidget {
  @override
  _ReportGenerationScreenState createState() => _ReportGenerationScreenState();
}

class _ReportGenerationScreenState extends State<ReportGenerationScreen> {
  String? _selectedSessionId;
  String? _selectedSubjectId;
  bool _isGenerating = false;

  @override
  Widget build(BuildContext context) {
    final databaseService = Provider.of<DatabaseService>(context);

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  Icon(Icons.description, size: 50, color: Colors.blue),
                  SizedBox(height: 16),
                  Text(
                    'Générer un procès-verbal',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 8),
                  Text(
                    'Sélectionnez une session et une matière pour générer le PV',
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
          ),
          SizedBox(height: 24),
          StreamBuilder<List<AcademicSession>>(
            stream: databaseService.getSessions(),
            builder: (context, snapshot) {
              if (!snapshot.hasData) return LinearProgressIndicator();
              return DropdownButtonFormField<String>(
                value: _selectedSessionId,
                items: snapshot.data!.map((session) {
                  return DropdownMenuItem(
                    value: session.id,
                    child: Text(session.name),
                  );
                }).toList(),
                onChanged: (value) => setState(() => _selectedSessionId = value),
                decoration: InputDecoration(
                  labelText: 'Session académique',
                  border: OutlineInputBorder(),
                ),
              );
            },
          ),
          SizedBox(height: 16),
          StreamBuilder<List<Subject>>(
            stream: databaseService.getSubjects(),
            builder: (context, snapshot) {
              if (!snapshot.hasData) return LinearProgressIndicator();
              return DropdownButtonFormField<String>(
                value: _selectedSubjectId,
                items: snapshot.data!.map((subject) {
                  return DropdownMenuItem(
                    value: subject.id,
                    child: Text(subject.name),
                  );
                }).toList(),
                onChanged: (value) => setState(() => _selectedSubjectId = value),
                decoration: InputDecoration(
                  labelText: 'Matière',
                  border: OutlineInputBorder(),
                ),
              );
            },
          ),
          SizedBox(height: 32),
          ElevatedButton.icon(
            icon: _isGenerating
                ? CircularProgressIndicator(color: Colors.white)
                : Icon(Icons.picture_as_pdf),
            label: Text(_isGenerating ? 'Génération...' : 'Générer le PV'),
            onPressed: _canGenerate() ? _generateReport : null,
            style: ElevatedButton.styleFrom(
              minimumSize: Size(double.infinity, 50),
            ),
          ),
        ],
      ),
    );
  }

  bool _canGenerate() {
    return !_isGenerating && _selectedSessionId != null && _selectedSubjectId != null;
  }

  Future<void> _generateReport() async {
    setState(() => _isGenerating = true);
    
    // Simuler la génération du PV
    await Future.delayed(Duration(seconds: 2));
    
    setState(() => _isGenerating = false);
    
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('PV généré avec succès!'),
        backgroundColor: Colors.green,
      ),
    );
  }
}