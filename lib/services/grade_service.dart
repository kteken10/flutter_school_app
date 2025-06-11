import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/grade.dart';

class GradeService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Stream<List<Grade>> getStudentGrades(String studentId, String year) {
  return _firestore
      .collection('grades')
      .where('studentId', isEqualTo: studentId)
      .where('year', isEqualTo: year)
      .snapshots()
      .map((snapshot) =>
          snapshot.docs.map((doc) => Grade.fromMap(doc.data())).toList());
}


  Stream<List<Grade>> getAllGrades() {
    return _firestore
        .collection('grades')
        .snapshots()
        .map((snapshot) =>
            snapshot.docs.map((doc) => Grade.fromMap(doc.data())).toList());
  }

  Future<void> addGrade(Grade grade) async {
    await _firestore.collection('grades').doc(grade.id).set(grade.toMap());
  }

  Future<void> updateGrade(Grade grade) async {
    await _firestore.collection('grades').doc(grade.id).update(grade.toMap());
  }
}
