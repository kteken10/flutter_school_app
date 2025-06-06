import 'package:flutter/material.dart';

class NotificationScreen extends StatelessWidget {
  const NotificationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Exemple de notifications statiques
    final notifications = [
      'Nouvelle note ajoutée pour l\'étudiant X.',
      'Importation de notes réussie.',
      'Votre profil a été mis à jour.',
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text('Notifications'),
      ),
      body: notifications.isEmpty
          ? const Center(child: Text('Aucune notification.'))
          : ListView.separated(
              itemCount: notifications.length,
              separatorBuilder: (_, __) => const Divider(height: 1),
              itemBuilder: (context, index) => ListTile(
                leading: const Icon(Icons.notifications),
                title: Text(notifications[index]),
              ),
            ),
    );
  }
}