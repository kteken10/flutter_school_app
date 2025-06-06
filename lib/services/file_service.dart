import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';

import '../models/grade.dart';

class FileService {
  final FirebaseStorage _storage = FirebaseStorage.instance;

  Future<String?> pickAndUploadFile() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['pdf', 'doc', 'docx', 'xls', 'xlsx'],
    );

    if (result != null) {
      File file = File(result.files.single.path!);
      String fileName = DateTime.now().millisecondsSinceEpoch.toString();
      Reference ref = _storage.ref().child('reports/$fileName');
      UploadTask uploadTask = ref.putFile(file);
      
      TaskSnapshot snapshot = await uploadTask;
      String downloadUrl = await snapshot.ref.getDownloadURL();
      
      return downloadUrl;
    }
    return null;
  }

  Future<void> generateAndExportGrades(List<Grade> grades, String fileName) async {
    // Générer un fichier CSV ou Excel avec les notes
    String csvContent = "Étudiant,Matière,Note,Date\n";
    for (var grade in grades) {
      csvContent += "${grade.studentId},${grade.subjectId},${grade.value},${grade.dateRecorded}\n";
    }

    // Sauvegarder temporairement le fichier
    final directory = await getTemporaryDirectory();
    final file = File('${directory.path}/$fileName.csv');
    await file.writeAsString(csvContent);

    // Partager le fichier
    await Share.shareXFiles([XFile(file.path)], text: 'Export des notes');
  }
}