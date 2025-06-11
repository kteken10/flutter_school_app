import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../services/auth_service.dart';
import '../../models/user.dart';

class AdminProfileScreen extends StatelessWidget {
  const AdminProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final authService = Provider.of<AuthService>(context);

    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        title: const Text('Mon Profil'),
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 0.5,
        foregroundColor: Colors.black,
      ),
      body: StreamBuilder<UserModel?>(
        stream: authService.currentUser,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          // Mode bypass : utilisateur fictif par défaut si pas connecté
          final user = snapshot.data ??
              UserModel(
                id: 'bypass_admin',
                firstName: 'Administrateur',
                lastName: 'Par Défaut',
                role: UserRole.admin,
                email: 'admin@exemple.com',
                department: 'Département fictif',
                createdAt: DateTime.now(),
              );

          return SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                // Avatar
                CircleAvatar(
                  radius: 50,
                  backgroundColor: Colors.blueAccent.withOpacity(0.1),
                  child: Text(
                    user.fullName.isNotEmpty ? user.fullName[0].toUpperCase() : '',
                    style: const TextStyle(fontSize: 40, color: Colors.blueAccent),
                  ),
                ),
                const SizedBox(height: 16),

                // Nom et Email
                Text(
                  user.fullName,
                  style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 4),
                Text(
                  user.email,
                  style: TextStyle(color: Colors.grey[600], fontSize: 14),
                ),

                const SizedBox(height: 24),

                // Infos utilisateur
                _InfoCard(
                  icon: Icons.school,
                  title: 'Département',
                  value: user.department ?? 'Non spécifié',
                ),
                _InfoCard(
                  icon: Icons.calendar_today,
                  title: 'Membre depuis',
                  value:
                      '${user.createdAt.day.toString().padLeft(2, '0')}/${user.createdAt.month.toString().padLeft(2, '0')}/${user.createdAt.year}',
                ),

                const SizedBox(height: 24),

                // Boutons (si utilisateur réel connecté, sinon on ne propose pas la déconnexion)
                if (snapshot.hasData && snapshot.data != null) ...[
                  _ProfileButton(
                    text: 'Modifier le profil',
                    onPressed: () {
                      Navigator.pushNamed(context, '/editProfile');
                    },
                  ),
                  const SizedBox(height: 12),
                  _ProfileButton(
                    text: 'Déconnexion',
                    color: Colors.redAccent,
                    onPressed: () async {
                      await authService.signOut();
                      Navigator.pushReplacementNamed(context, '/login');
                    },
                  ),
                ] else
                  Center(
                    child: Text(
                      'Mode Bypass : utilisateur non connecté',
                      style: TextStyle(
                        color: Colors.grey[600],
                        fontStyle: FontStyle.italic,
                        fontSize: 14,
                      ),
                    ),
                  ),
              ],
            ),
          );
        },
      ),
    );
  }
}

class _InfoCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String value;

  const _InfoCard({
    required this.icon,
    required this.title,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      elevation: 0,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            Icon(icon, color: Colors.blueAccent),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                        fontSize: 14, color: Colors.grey, fontWeight: FontWeight.w500),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    value,
                    style: const TextStyle(
                        fontSize: 16, color: Colors.black87, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ProfileButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;
  final Color? color;

  const _ProfileButton({
    required this.text,
    required this.onPressed,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: color ?? Colors.blueAccent,
          padding: const EdgeInsets.symmetric(vertical: 14),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        ),
        onPressed: onPressed,
        child: Text(
          text,
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500, color: Colors.white),
        ),
      ),
    );
  }
}
