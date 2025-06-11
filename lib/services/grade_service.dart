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
    // Nouvelle méthode pour obtenir toutes les notes sous forme de Map
  Future<Map<String, Map<String, Map<String, double>>>> getAllGradesMap() async {
    try {
      final snapshot = await _firestore.collection('grades').get();
      final result = <String, Map<String, Map<String, double>>>{};

      for (var doc in snapshot.docs) {
        final grade = Grade.fromMap(doc.data());
        
        if (!result.containsKey(grade.studentId)) {
          result[grade.studentId] = {};
        }
        
        if (!result[grade.studentId]!.containsKey(grade.subjectId)) {
          result[grade.studentId]![grade.subjectId] = {};
        }
        
        result[grade.studentId]![grade.subjectId]![grade.sessionId] = grade.value!;
      }

      return result;
    } catch (e) {
      print('Error getting grades map: $e');
      return {};
    }
  }

  // Nouvelle méthode pour obtenir les sessions disponibles
  Future<List<String>> getSessions() async {
    try {
      final snapshot = await _firestore.collection('sessions').get();
      return snapshot.docs.map((doc) => doc.id).toList();
    } catch (e) {
      print('Error getting sessions: $e');
      return ['Session 1', 'Session 2']; // Valeur par défaut
    }
  }

}
