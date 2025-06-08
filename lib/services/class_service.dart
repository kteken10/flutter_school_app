import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/class.dart';

class ClassService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> createClass(String name, String department) async {
    final doc = _firestore.collection('classes').doc();
    final classModel = ClasseModel(
      id: doc.id,
      name: name,
      department: department,
      createdAt: DateTime.now(),
    );
    await doc.set(classModel.toMap());
  }

  Future<List<ClasseModel>> fetchAllClasses() async {
    final snapshot = await _firestore.collection('classes').get();
    return snapshot.docs.map((doc) {
      return ClasseModel.fromMap(doc.data());
    }).toList();
  }
  Future<bool> classExists(String name) async {
  final snapshot = await _firestore
      .collection('classes')
      .where('name', isEqualTo: name)
      .get();
  return snapshot.docs.isNotEmpty;
}

}
