import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../models/user.dart';
import '../../services/auth_service.dart';
import 'grades_view.dart';
// import 'transcript.dart';
// import 'notifications.dart';

class StudentHomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final authService = Provider.of<AuthService>(context);
    
    return Scaffold(
      appBar: AppBar(
        title: Text('Tableau de bord étudiant'),
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
                        Text('Numéro étudiant: ${user.studentId ?? 'N/A'}'),
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
                      icon: Icons.grade,
                      title: 'Mes notes',
                      onTap: () => Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => GradesViewScreen()),
                      ),
                    ),
                    _buildMenuCard(
                      context,
                      icon: Icons.list_alt,
                      title: 'Relevé de notes',
                      onTap: () => {}
                      
                      // Navigator.push(
                      //   context,
                      //   MaterialPageRoute(builder: (context) => TranscriptScreen()),
                      // ),
                    ),
                    _buildMenuCard(
                      context,
                      icon: Icons.notifications,
                      title: 'Notifications',
                      onTap: () => {}
                      
                      // Navigator.push(
                      //   contex,
                      //   MaterialPageRoute(builder: (context) => NotificationsScreen()),
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