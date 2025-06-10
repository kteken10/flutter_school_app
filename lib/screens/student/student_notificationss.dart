import 'package:flutter/material.dart';

import '../../ui/notification_card.dart';

class StudentNotificationsScreen extends StatelessWidget {
  const StudentNotificationsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Notifications simulées localement (beaucoup plus nombreuses)
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
        'title': 'Changement de salle',
        'message': 'Le cours de chimie aura lieu en salle 101.',
        'date': DateTime.now().subtract(const Duration(hours: 8)),
        'type': 'general',
        'isRead': false,
      },
      {
        'title': 'Absence justifiée',
        'message': 'Votre absence en histoire a été justifiée.',
        'date': DateTime.now().subtract(const Duration(days: 7)),
        'type': 'absence',
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
      {
        'title': 'Rappel examen',
        'message': 'Examen d\'informatique le 20 juin.',
        'date': DateTime.now().subtract(const Duration(hours: 20)),
        'type': 'reminder',
        'isRead': false,
      },
      {
        'title': 'Problème technique',
        'message': 'Le portail étudiant sera indisponible ce soir.',
        'date': DateTime.now().subtract(const Duration(days: 2)),
        'type': 'alert',
        'isRead': true,
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
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Notification: ${notif['title']}')),
            );
          },
          onDelete: () {
            // Logique de suppression locale (à implémenter si besoin)
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
      case 'reminder':
        return Icons.alarm;
      case 'calendar':
        return Icons.calendar_today;
      case 'message':
        return Icons.message;
      case 'update':
        return Icons.system_update;
      case 'alert':
        return Icons.error_outline;
      default:
        return Icons.notifications;
    }
  }
}
