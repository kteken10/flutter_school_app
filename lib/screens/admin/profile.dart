import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../models/user.dart';
import '../../services/auth_service.dart';

class AdminProfileScreen extends StatelessWidget {
  const AdminProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final authService = Provider.of<AuthService>(context);
    
    return StreamBuilder<UserModel?>(
      stream: authService.currentUser,
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return const Center(child: CircularProgressIndicator());
        }

        final admin = snapshot.data!;
        
        return Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              CircleAvatar(
                radius: 50,
                backgroundImage: admin.photoUrl != null 
                    ? NetworkImage(admin.photoUrl!)
                    : const AssetImage('assets/default_avatar.png') as ImageProvider,
              ),
              const SizedBox(height: 16),
              Text(
                admin.fullName,
                style: Theme.of(context).textTheme.headlineSmall,
              ),
              Text(admin.email),
              const SizedBox(height: 24),
              ListTile(
                leading: const Icon(Icons.settings),
                title: const Text('Paramètres du compte'),
                onTap: () {},
              ),
              ListTile(
                leading: const Icon(Icons.logout),
                title: const Text('Déconnexion'),
                onTap: () => authService.signOut(),
              ),
            ],
          ),
        );
      },
    );
  }
}