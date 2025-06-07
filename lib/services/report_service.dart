import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/report.dart';

class ReportService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> addReport(Report report) async {
    await _firestore.collection('reports').doc(report.id).set(report.toMap());
  }

  Stream<List<Report>> getTeacherReports(String teacherId) {
    return _firestore
        .collection('reports')
        .where('teacherId', isEqualTo: teacherId)
        .snapshots()
        .map((snapshot) =>
            snapshot.docs.map((doc) => Report.fromMap(doc.data())).toList());
  }
}
