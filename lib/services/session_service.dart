import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/session.dart';

class SessionService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Stream<List<AcademicSession>> getSessions() {
    return _firestore.collection('sessions').snapshots().map(
          (snapshot) => snapshot.docs.map((doc) => AcademicSession.fromMap(doc.data())).toList(),
        );
  }

  Future<void> addSession(AcademicSession session) async {
    await _firestore.collection('sessions').doc(session.id).set(session.toMap());
  }
}
