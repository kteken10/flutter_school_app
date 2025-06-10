import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/subject.dart';

class SubjectService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Stream<List<Subject>> getSubjects() {
    return _firestore.collection('subjects').snapshots().map(
          (snapshot) => snapshot.docs.map((doc) => Subject.fromMap(doc.data())).toList(),
        );
  }

  Future<void> addSubject(Subject subject) async {
    await _firestore.collection('subjects').doc(subject.id).set(subject.toMap());
  }

  Future<Subject?> getSubjectById(String subjectId) async {
    try {
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

  Future<String?> getSubjectName(String subjectId) async {
  try {
    final doc = await _firestore.collection('subjects').doc(subjectId).get();
    if (doc.exists) {
      final data = doc.data();
      if (data != null && data.containsKey('name')) {
        return data['name'] as String;
      }
    }
    return null;
  } catch (e) {
    print('Erreur lors de la récupération du nom de la matière: $e');
    return null;
  }
}

}
