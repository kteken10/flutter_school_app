import 'package:flutter/material.dart';

import '../../ui/notification_card.dart';


class StudentNotificationsScreen extends StatelessWidget {
  const StudentNotificationsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Notifications simulées localement
    final List<Map<String, dynamic>> fakeNotifications = [
      {
        'title': 'Note disponible',
        'message': 'Votre note de mathématiques est disponible.',
        'date': DateTime.now().subtract(const Duration(hours: 2)),
        'type': 'grade',
        'isRead': false,
      },
      {
        'title': 'Absence signalée',
        'message': 'Vous avez été noté absent au cours de biologie.',
        'date': DateTime.now().subtract(const Duration(days: 1, hours: 3)),
        'type': 'absence',
        'isRead': true,
      },
      {
        'title': 'Annonce générale',
        'message': 'Le campus sera fermé ce vendredi.',
        'date': DateTime.now().subtract(const Duration(days: 5)),
        'type': 'general',
        'isRead': false,
      },
      {
        'title': 'Rappel de devoir',
        'message': 'N\'oubliez pas le devoir de français à rendre lundi.',
        'date': DateTime.now().subtract(const Duration(hours: 5)),
        'type': 'reminder',
        'isRead': false,
      },
      {
        'title': 'Mise à jour du calendrier',
        'message': 'Les dates des examens ont été mises à jour.',
        'date': DateTime.now().subtract(const Duration(days: 3)),
        'type': 'calendar',
        'isRead': true,
      },
      {
        'title': 'Nouveau message',
        'message': 'Vous avez reçu un message de Mme Dupont.',
        'date': DateTime.now().subtract(const Duration(minutes: 45)),
        'type': 'message',
        'isRead': false,
      },
      {
        'title': 'Note disponible',
        'message': 'Votre note de physique est disponible.',
        'date': DateTime.now().subtract(const Duration(days: 2, hours: 1)),
        'type': 'grade',
        'isRead': true,
      },
      
      {
        'title': 'Invitation réunion parents',
        'message': 'Réunion parents-professeurs le 15 juin.',
        'date': DateTime.now().subtract(const Duration(days: 10)),
        'type': 'general',
        'isRead': false,
      },
      {
        'title': 'Mise à jour application',
        'message': 'Nouvelle version de l\'application disponible.',
        'date': DateTime.now().subtract(const Duration(days: 1)),
        'type': 'update',
        'isRead': false,
      },
      
    ];

    if (fakeNotifications.isEmpty) {
      return const Center(child: Text('Aucune notification'));
    }

    return ListView.builder(
      padding: const EdgeInsets.symmetric(vertical: 16),
      itemCount: fakeNotifications.length,
      itemBuilder: (context, index) {
        final notif = fakeNotifications[index];

        return NotificationCard(
          title: notif['title'] ?? 'Notification',
          description: notif['message'] ?? '',
          dateTime: notif['date'],
          icon: _getNotificationIcon(notif['type']),
          isRead: notif['isRead'],
          onTap: () {
            // Simuler une action
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Notification: ${notif['title']}')),
            );
          },
          onDelete: () {
            // Tu peux ajouter une logique de suppression locale ici si nécessaire
          },
        );
      },
    );
  }

  IconData _getNotificationIcon(String? type) {
    switch (type) {
      case 'grade':
        return Icons.grade;
      case 'absence':
        return Icons.warning;
      case 'general':
        return Icons.info;
      default:
        return Icons.notifications;
    }
  }
}
