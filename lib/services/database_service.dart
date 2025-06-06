import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/grade.dart';
import '../models/subject.dart';
import '../models/session.dart';
import '../models/report.dart';
import '../models/user.dart';

class DatabaseService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Notes
  Stream<List<Grade>> getStudentGrades(String studentId) {
    return _firestore
        .collection('grades')
        .where('studentId', isEqualTo: studentId)
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

  // Matières
  Stream<List<Subject>> getSubjects() {
    return _firestore.collection('subjects').snapshots().map((snapshot) =>
        snapshot.docs.map((doc) => Subject.fromMap(doc.data())).toList());
  }

  Future<void> addSubject(Subject subject) async {
    await _firestore.collection('subjects').doc(subject.id).set(subject.toMap());
  }

  // Sessions académiques
  Stream<List<AcademicSession>> getSessions() {
    return _firestore.collection('sessions').snapshots().map((snapshot) =>
        snapshot.docs.map((doc) => AcademicSession.fromMap(doc.data())).toList());
  }

  // Rapports/PV
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



   Future<Subject?> getSubjectById(String subjectId) async {
    // Exemple avec une base de données fictive ou Firestore
    // Remplace ce code par ta logique réelle d'accès aux données
    try {
      // Supposons que tu utilises Firestore :
      final doc = await _firestore.collection('subjects').doc(subjectId).get();
      if (doc.exists) {
        return Subject.fromMap(doc.data()!);
      }
      return null;
    } catch (e) {
      print('Erreur lors de la récupération de la matière: $e');
      return null;
    }
  }
  // 🔽 Méthode pour récupérer uniquement les étudiants
  Stream<List<UserModel>> getStudents() {
    return _firestore
        .collection('users')
        .where('role', isEqualTo: 'student') // Vérifie bien la valeur dans Firestore
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => UserModel.fromMap(doc.data()))
            .toList());
  }

  // 🔽 À ajouter dans ta classe DatabaseService
Stream<List<Grade>> getAllGrades() {
  return _firestore
      .collection('grades')
      .snapshots()
      .map((snapshot) =>
          snapshot.docs.map((doc) => Grade.fromMap(doc.data())).toList());
}

// 🔽 Ajoute ceci dans ta classe DatabaseService
Future<UserModel?> getUserById(String userId) async {
  try {
    final doc = await _firestore.collection('users').doc(userId).get();
    if (doc.exists) {
      return UserModel.fromMap(doc.data()!);
    }
    return null;
  } catch (e) {
    print('Erreur lors de la récupération de l\'utilisateur: $e');
    return null;
  }
}


}