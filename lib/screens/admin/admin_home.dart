import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../models/user.dart';
import '../../services/auth_service.dart';
// import 'user_management.dart';
// import 'system_settings.dart';

class AdminHomeScreen extends StatelessWidget {
  const AdminHomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final authService = Provider.of<AuthService>(context);
    
    return Scaffold(
      appBar: AppBar(
        title: Text('Tableau de bord administrateur'),
        actions: [
          IconButton(
            icon: Icon(Icons.logout),
            onPressed: () async {
              await authService.signOut();
            },
          ),
        ],
      ),
      body: StreamBuilder<UserModel?>(
        stream: authService.currentUser,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }
          
          final user = snapshot.data;
          if (user == null) {
            return Center(child: Text('Utilisateur non connecté'));
          }
          
          return Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Card(
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      children: [
                        Text(user.fullName, style: Theme.of(context).textTheme.headlineSmall),
                        SizedBox(height: 8),
                        Text('Rôle: Administrateur'),
                        Text('Email: ${user.email}'),
                      ],
                    ),
                  ),
                ),
              ),
              Expanded(
                child: GridView.count(
                  crossAxisCount: 2,
                  children: [
                    _buildMenuCard(
                      context,
                      icon: Icons.people,
                      title: 'Gestion des utilisateurs',
                      onTap: () {
                        
                      },
                      // onTap: () => Navigator.push(
                      //   context,
                      //   MaterialPageRoute(builder: (context) => UserManagementScreen()),
                      // ),
                    ),
                    _buildMenuCard(
                      context,
                      icon: Icons.settings,
                      title: 'Paramètres système',
                      onTap:() {
                        
                      },
                      // onTap: () => Navigator.push(
                      //   context,
                      //   MaterialPageRoute(builder: (context) => SystemSettingsScreen()),
                      // ),
                    ),
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildMenuCard(BuildContext context, {required IconData icon, required String title, required VoidCallback onTap}) {
    return Card(
      child: InkWell(
        onTap: onTap,
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(icon, size: 48),
              SizedBox(height: 8),
              Text(title),
            ],
          ),
        ),
      ),
    );
  }
}