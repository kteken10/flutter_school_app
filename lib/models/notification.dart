import 'user.dart';

enum NotificationType {
  info,
  warning,
  success,
  error,
}

class NotificationModel {
  final String id;
  final String title;
  final String description;
  final DateTime createdAt;
  final bool isRead;
  final NotificationType type;

  // Destinataire
  final String recipientId; // Correspond à user.id
  final UserRole recipientRole;

  // Optionnel : identifiant de l'expéditeur
  final String? senderId;

  NotificationModel({
    required this.id,
    required this.title,
    required this.description,
    required this.createdAt,
    this.isRead = false,
    required this.type,
    required this.recipientId,
    required this.recipientRole,
    this.senderId,
  });

  factory NotificationModel.fromMap(Map<String, dynamic> map) {
    return NotificationModel(
      id: map['id'],
      title: map['title'],
      description: map['description'],
      createdAt: DateTime.parse(map['createdAt']),
      isRead: map['isRead'] ?? false,
      type: NotificationType.values.firstWhere(
        (e) => e.toString() == 'NotificationType.${map['type']}',
        orElse: () => NotificationType.info,
      ),
      recipientId: map['recipientId'],
      recipientRole: UserRole.values.firstWhere(
        (e) => e.toString() == 'UserRole.${map['recipientRole']}',
      ),
      senderId: map['senderId'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'createdAt': createdAt.toIso8601String(),
      'isRead': isRead,
      'type': type.toString().split('.').last,
      'recipientId': recipientId,
      'recipientRole': recipientRole.toString().split('.').last,
      'senderId': senderId,
    };
  }
}
