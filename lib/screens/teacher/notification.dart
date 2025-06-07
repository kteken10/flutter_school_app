import 'package:flutter/material.dart';
import '../../ui/notification_card.dart';

class NotificationScreen extends StatelessWidget {
  const NotificationScreen({super.key});

  @override
  Widget build(BuildContext context) {
   
    final notifications = [
      {
        'title': 'Nouvelle note ajoutée',
        'description': 'Une note a été ajoutée pour l\'étudiant Jean Dupont en Mathématiques',
        'dateTime': DateTime.now().subtract(const Duration(minutes: 30)),
        'isRead': false,
      },
      {
        'title': 'Importation réussie',
        'description': 'L\'importation des notes pour la classe de Terminale S est terminée',
        'dateTime': DateTime.now().subtract(const Duration(hours: 2)),
        'isRead': true,
      },
      {
        'title': 'Mise à jour du profil',
        'description': 'Vos informations de profil ont été mises à jour avec succès',
        'dateTime': DateTime.now().subtract(const Duration(days: 1)),
        'isRead': true,
      },
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text('Notifications'),
        actions: [
          IconButton(
            icon: const Icon(Icons.mark_as_unread),
            onPressed: () {
              // Marquer toutes comme lues
            },
            tooltip: 'Tout marquer comme lu',
          ),
          IconButton(
            icon: const Icon(Icons.delete_outline),
            onPressed: () {
              // Supprimer toutes les notifications
            },
            tooltip: 'Supprimer tout',
          ),
        ],
      ),
      body: notifications.isEmpty
          ? const Center(
              child: Text(
                'Aucune notification',
                style: TextStyle(fontSize: 16, color: Colors.grey),
              ),
            )
          : ListView.separated(
              padding: const EdgeInsets.symmetric(vertical: 8),
              itemCount: notifications.length,
              separatorBuilder: (_, __) => const SizedBox(height: 8),
              itemBuilder: (context, index) {
                final notification = notifications[index];
                return NotificationCard(
                  title: notification['title'] as String,
                  description: notification['description'] as String,
                  dateTime: notification['dateTime'] as DateTime,
                  isRead: notification['isRead'] as bool,
                  icon: _getNotificationIcon(notification['title'] as String),
                  onTap: () {
                    // Action quand on clique sur la notification
                    _handleNotificationTap(context, index);
                  },
                  onDelete: () {
                    // Action pour supprimer la notification
                    _handleNotificationDelete(index);
                  },
                );
              },
            ),
    );
  }

  IconData _getNotificationIcon(String title) {
    if (title.contains('note')) return Icons.grade;
    if (title.contains('Importation')) return Icons.cloud_done;
    if (title.contains('profil')) return Icons.person;
    return Icons.notifications;
  }

  void _handleNotificationTap(BuildContext context, int index) {
    // Gérer le clic sur une notification
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Notification $index cliquée'),
        duration: const Duration(seconds: 1),
      ),
    );
  }

  void _handleNotificationDelete(int index) {
    // Gérer la suppression d'une notification
    // En production, vous voudrez probablement mettre à jour l'état
    debugPrint('Notification $index supprimée');
  }
}