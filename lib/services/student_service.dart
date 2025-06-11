import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/user.dart';

class StudentService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<String?> getTeacherName(String studentId) async {
    try {
      final doc = await _firestore.collection('users').doc(studentId).get();
      if (doc.exists) {
        final data = doc.data();
        return "${data?['firstName']} ${data?['lastName']}";
      }
    } catch (e) {
      print('Erreur lors de la récupération du nom du professeur: $e');
    }
    return null;
  }

  Future<List<UserModel>> getStudents() async {
    try {
      final querySnapshot = await _firestore
          .collection('users')
          .where('role', isEqualTo: 'student')
          .get();

      return querySnapshot.docs
          .map((doc) => UserModel.fromMap(doc.data()))
          .toList();
    } catch (e) {
      print('Erreur lors du chargement des enseignants: $e');
      return [];
    }
  }
}
