import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/notification.dart';


class NotificationService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  /// Crée une notification pour un utilisateur spécifique
  Future<void> createNotification(NotificationModel notification) async {
    final doc = _firestore.collection('notifications').doc(notification.id);
    await doc.set(notification.toMap());
  }

  /// Récupère toutes les notifications pour un utilisateur spécifique
  Future<List<NotificationModel>> fetchNotificationsForUser(String userId) async {
    final snapshot = await _firestore
        .collection('notifications')
        .where('recipientId', isEqualTo: userId)
        .orderBy('createdAt', descending: true)
        .get();

    return snapshot.docs.map((doc) {
      return NotificationModel.fromMap(doc.data());
    }).toList();
  }

  /// Marque une notification comme lue
  Future<void> markAsRead(String notificationId) async {
    await _firestore
        .collection('notifications')
        .doc(notificationId)
        .update({'isRead': true});
  }

  /// Supprime une notification
  Future<void> deleteNotification(String notificationId) async {
    await _firestore.collection('notifications').doc(notificationId).delete();
  }

  /// Supprime toutes les notifications d’un utilisateur (optionnel)
  Future<void> deleteAllNotificationsForUser(String userId) async {
    final batch = _firestore.batch();
    final snapshot = await _firestore
        .collection('notifications')
        .where('recipientId', isEqualTo: userId)
        .get();

    for (final doc in snapshot.docs) {
      batch.delete(doc.reference);
    }

    await batch.commit();
  }
}
