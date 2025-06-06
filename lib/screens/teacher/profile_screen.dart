import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../services/auth_service.dart';
import '../../models/user.dart';

class ProfileScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final authService = Provider.of<AuthService>(context);

    return StreamBuilder<UserModel?>(
      stream: authService.currentUser,
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return Center(child: CircularProgressIndicator());
        }

        final user = snapshot.data!;

        return SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              CircleAvatar(
                radius: 50,
                backgroundColor: Theme.of(context).primaryColor,
                child: Text(
                  user.fullName[0],
                  style: TextStyle(fontSize: 40, color: Colors.white),
                ),
              ),
              SizedBox(height: 16),
              Text(
                user.fullName,
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 8),
              Text(
                user.email,
                style: TextStyle(fontSize: 16, color: Colors.grey),
              ),
              SizedBox(height: 24),
              Card(
                child: ListTile(
                  leading: Icon(Icons.school),
                  title: Text('Département'),
                  subtitle: Text(user.department ?? 'Non spécifié'),
                ),
              ),
              Card(
                child: ListTile(
                  leading: Icon(Icons.calendar_today),
                  title: Text('Membre depuis'),
                  subtitle: Text('${user.createdAt.day}/${user.createdAt.month}/${user.createdAt.year}'),
                ),
              ),
              SizedBox(height: 32),
              ElevatedButton(
                onPressed: () {
                  // Naviguer vers l'édition du profil
                },
                child: Text('Modifier le profil'),
              ),
              SizedBox(height: 16),
              TextButton(
                onPressed: () async {
                  await authService.signOut();
                },
                child: Text(
                  'Déconnexion',
                  style: TextStyle(color: Colors.red),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}