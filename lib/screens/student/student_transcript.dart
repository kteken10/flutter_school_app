import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:provider/provider.dart';
import '../../constants/colors.dart';
import '../../services/auth_service.dart';
import '../../models/user.dart';

class StudentTranscriptScreen extends StatelessWidget {
  const StudentTranscriptScreen({super.key});

  // Relevé fictif pour le mode bypass
  Map<String, dynamic> getFakeTranscript() {
    return {
      'semesters': [
        {
          'name': 'Semestre 1 (Bypass)',
          'courses': [
            {'name': 'Mathématiques', 'grade': 14.5},
            {'name': 'Physique', 'grade': 13.0},
            {'name': 'Informatique', 'grade': 15.0},
          ],
          'average': 14.17,
        },
        {
          'name': 'Semestre 2 (Bypass)',
          'courses': [
            {'name': 'Chimie', 'grade': 12.0},
            {'name': 'Biologie', 'grade': 13.5},
            {'name': 'Anglais', 'grade': 14.0},
          ],
          'average': 13.17,
        },
      ],
    };
  }

  @override
  Widget build(BuildContext context) {
    final authService = Provider.of<AuthService>(context);

    return StreamBuilder<UserModel?>(
      stream: authService.currentUser,
      builder: (context, userSnapshot) {
        final bool isRealUser = userSnapshot.hasData && userSnapshot.data != null;

        if (!isRealUser) {
          // Mode bypass : affichage du relevé fictif
          final fakeTranscript = getFakeTranscript();
          final semesters = fakeTranscript['semesters'] as List<dynamic>;

          return Scaffold(
            appBar: AppBar(
              title: const Text('Relevé de notes académique (Bypass)'),
              backgroundColor: AppColors.primary,
            ),
            body: SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Relevé de notes académique',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 20),
                  ...semesters.map((semester) {
                    return Card(
                      margin: const EdgeInsets.only(bottom: 16),
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              semester['name'] ?? 'Semestre inconnu',
                              style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 10),
                            ...(semester['courses'] as List<dynamic>).map((course) {
                              return Padding(
                                padding: const EdgeInsets.symmetric(vertical: 8),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Expanded(
                                      child: Text(course['name'] ?? 'Cours inconnu'),
                                    ),
                                    Chip(
                                      label: Text(
                                        '${course['grade']?.toStringAsFixed(2) ?? '--'}',
                                        style: const TextStyle(color: Colors.white),
                                      ),
                                      backgroundColor: AppColors.primary,
                                    ),
                                  ],
                                ),
                              );
                            }).toList(),
                            const SizedBox(height: 10),
                            Align(
                              alignment: Alignment.centerRight,
                              child: Text(
                                'Moyenne: ${semester['average']?.toStringAsFixed(2) ?? '--'}',
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  }).toList(),
                  const SizedBox(height: 30),
                  Center(
                    child: Text(
                      'Mode Bypass : relevé fictif affiché',
                      style: TextStyle(
                        color: Colors.grey[600],
                        fontStyle: FontStyle.italic,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        }

        // Si utilisateur réel, on récupère le relevé réel depuis Firestore
        final studentId = userSnapshot.data!.studentId;

        return StreamBuilder<QuerySnapshot>(
          stream: FirebaseFirestore.instance
              .collection('transcripts')
              .where('studentId', isEqualTo: studentId)
              .snapshots(),
          builder: (context, snapshot) {
            if (snapshot.hasError) {
              return Scaffold(
                appBar: AppBar(title: const Text('Relevé de notes académique')),
                body: Center(child: Text('Erreur: ${snapshot.error}')),
              );
            }

            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Scaffold(
                body: Center(child: CircularProgressIndicator()),
              );
            }

            final transcripts = snapshot.data!.docs;

            if (transcripts.isEmpty) {
              return Scaffold(
                appBar: AppBar(title: const Text('Relevé de notes académique')),
                body: const Center(child: Text('Aucun relevé disponible')),
              );
            }

            final transcript = transcripts.first.data() as Map<String, dynamic>;
            final semesters = transcript['semesters'] as List<dynamic>? ?? [];

            return Scaffold(
              appBar: AppBar(
                title: const Text('Relevé de notes académique'),
                backgroundColor: AppColors.primary,
                actions: [
                  IconButton(
                    icon: const Icon(Icons.logout),
                    onPressed: () async {
                      await authService.signOut();
                      Navigator.pushReplacementNamed(context, '/login');
                    },
                    tooltip: 'Déconnexion',
                  )
                ],
              ),
              body: SingleChildScrollView(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ...semesters.map((semester) {
                      return Card(
                        margin: const EdgeInsets.only(bottom: 16),
                        child: Padding(
                          padding: const EdgeInsets.all(16),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                semester['name'] ?? 'Semestre inconnu',
                                style: const TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 10),
                              ...(semester['courses'] as List<dynamic>).map((course) {
                                return Padding(
                                  padding: const EdgeInsets.symmetric(vertical: 8),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Expanded(
                                        child: Text(course['name'] ?? 'Cours inconnu'),
                                      ),
                                      Chip(
                                        label: Text(
                                          '${course['grade']?.toStringAsFixed(2) ?? '--'}',
                                          style: const TextStyle(color: Colors.white),
                                        ),
                                        backgroundColor: AppColors.primary,
                                      ),
                                    ],
                                  ),
                                );
                              }).toList(),
                              const SizedBox(height: 10),
                              Align(
                                alignment: Alignment.centerRight,
                                child: Text(
                                  'Moyenne: ${semester['average']?.toStringAsFixed(2) ?? '--'}',
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    }).toList(),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }
}
