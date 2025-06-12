import 'package:flutter/material.dart';
import '../../constants/colors.dart';
import '../../data/dummy_grade.dart';
import '../../models/grade.dart';

class StudentTranscriptScreen extends StatelessWidget {
  const StudentTranscriptScreen({super.key});

  /// Fonction pour construire un relevé à partir des données fictives
  Map<String, dynamic> getFakeTranscriptFromDummy() {
    // Regroupe les notes par sessionId (considéré comme semestre)
    final Map<String, List<Grade>> sessionsMap = {};

    for (var grade in dummyGrades) {
      if (!sessionsMap.containsKey(grade.sessionId)) {
        sessionsMap[grade.sessionId] = [];
      }
      sessionsMap[grade.sessionId]!.add(grade);
    }

    // Construire la liste des semestres
    final semesters = sessionsMap.entries.map((entry) {
      final sessionId = entry.key;
      final grades = entry.value;

      // Ici tu peux mettre un vrai nom de session si tu as un modèle Session
      final sessionName = sessionId; // sinon juste l'ID ou un nom fixe

      // Construire la liste des cours avec note et crédit
      final courses = grades.map((grade) {
        final subject = dummySubjects[grade.subjectId];
        return {
          'name': subject?.name ?? 'Cours inconnu',
          'grade': grade.value,
          'credit': subject?.credit ?? 0,
        };
      }).toList();

      // Calculer la moyenne pondérée par crédits
      double totalPoints = 0;
      int totalCredits = 0;
      for (var c in courses) {
        totalPoints += (c['grade'] as double) * (c['credit'] as int);
        totalCredits += c['credit'] as int;
      }
      final average = totalCredits > 0 ? totalPoints / totalCredits : 0;

      return {
        'name': sessionName,
        'courses': courses,
        'average': average,
      };
    }).toList();

    return {'semesters': semesters};
  }

  @override
  Widget build(BuildContext context) {
    final fakeTranscript = getFakeTranscriptFromDummy();
    final semesters = fakeTranscript['semesters'] as List<dynamic>;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Relevé de notes académique'),
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
                                child: Text('${course['name']} (${course['credit']} crédits)'),
                              ),
                              Chip(
                                label: Text(
                                  '${(course['grade'] as double).toStringAsFixed(2)}',
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
                          'Moyenne: ${(semester['average'] as double).toStringAsFixed(2)}',
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
                'Données fictives uniquement (pas de connexion nécessaire)',
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
}
