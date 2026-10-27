import 'package:flutter/material.dart';
import '../../constants/colors.dart';
import '../../data/dummy_grade.dart';
import '../../models/grade.dart';

/// Relevé de notes : synthèse (moyenne pondérée, crédits, mention) puis une
/// carte par session, notes colorées selon le niveau.
class StudentTranscriptScreen extends StatelessWidget {
  const StudentTranscriptScreen({super.key});

  /// Regroupe les notes fictives par session et calcule les moyennes pondérées.
  List<_Session> _buildSessions() {
    final Map<String, List<Grade>> bySession = {};
    for (final grade in dummyGrades) {
      bySession.putIfAbsent(grade.sessionId, () => []).add(grade);
    }

    var index = 0;
    return bySession.entries.map((entry) {
      index++;
      final courses = entry.value.map((grade) {
        final subject = dummySubjects[grade.subjectId];
        return _Course(
          name: subject?.name ?? 'Cours inconnu',
          grade: grade.value ?? 0,
          credit: subject?.credit ?? 0,
          image: grade.subjectImagePath,
        );
      }).toList();
      return _Session(name: 'Session $index', courses: courses);
    }).toList();
  }

  static Color _gradeColor(double g) {
    if (g >= 16) return const Color(0xFF16A34A);
    if (g >= 12) return const Color(0xFF2563EB);
    if (g >= 10) return const Color(0xFFD97706);
    return AppColors.alert;
  }

  static String _mention(double avg) {
    if (avg >= 16) return 'Très bien';
    if (avg >= 14) return 'Bien';
    if (avg >= 12) return 'Assez bien';
    if (avg >= 10) return 'Passable';
    return 'Ajourné';
  }

  @override
  Widget build(BuildContext context) {
    final sessions = _buildSessions();
    final allCourses = sessions.expand((s) => s.courses).toList();
    final credits = allCourses.fold<int>(0, (sum, c) => sum + c.credit);
    final average = credits == 0
        ? 0.0
        : allCourses.fold<double>(0, (sum, c) => sum + c.grade * c.credit) / credits;

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        bottom: false,
        child: ListView(
          padding: const EdgeInsets.fromLTRB(20, 16, 20, 24),
          children: [
            const Text(
              'Relevé de notes',
              style: TextStyle(fontSize: 26, fontWeight: FontWeight.w700, color: AppColors.textPrimary),
            ),
            const SizedBox(height: 4),
            const Text(
              'Licence 1 · Informatique · 2023-2024',
              style: TextStyle(fontSize: 14, color: AppColors.textprimary),
            ),
            const SizedBox(height: 20),
            _SummaryCard(average: average, credits: credits, mention: _mention(average)),
            const SizedBox(height: 24),
            for (final session in sessions) ...[
              _SessionCard(session: session, gradeColor: _gradeColor),
              const SizedBox(height: 14),
            ],
          ],
        ),
      ),
    );
  }
}

class _Course {
  final String name;
  final double grade;
  final int credit;
  final String image;

  const _Course({required this.name, required this.grade, required this.credit, required this.image});
}

class _Session {
  final String name;
  final List<_Course> courses;

  const _Session({required this.name, required this.courses});

  int get credits => courses.fold(0, (s, c) => s + c.credit);
  double get average => credits == 0 ? 0 : courses.fold<double>(0, (s, c) => s + c.grade * c.credit) / credits;
}

class _SummaryCard extends StatelessWidget {
  final double average;
  final int credits;
  final String mention;

  const _SummaryCard({required this.average, required this.credits, required this.mention});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(22),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [AppColors.primary, AppColors.secondary],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(color: AppColors.primary.withOpacity(0.25), blurRadius: 24, offset: const Offset(0, 10)),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Moyenne générale', style: TextStyle(color: Colors.white70, fontSize: 14)),
          const SizedBox(height: 6),
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                average.toStringAsFixed(2),
                style: const TextStyle(color: Colors.white, fontSize: 44, fontWeight: FontWeight.w700, height: 1),
              ),
              const Padding(
                padding: EdgeInsets.only(left: 6, bottom: 6),
                child: Text('/ 20', style: TextStyle(color: Colors.white70, fontSize: 18)),
              ),
              const Spacer(),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.18),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(mention,
                    style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w600, fontSize: 13)),
              ),
            ],
          ),
          const SizedBox(height: 18),
          ClipRRect(
            borderRadius: BorderRadius.circular(6),
            child: LinearProgressIndicator(
              value: (average / 20).clamp(0, 1),
              minHeight: 8,
              backgroundColor: Colors.white.withOpacity(0.2),
              valueColor: const AlwaysStoppedAnimation(Colors.white),
            ),
          ),
          const SizedBox(height: 18),
          Row(
            children: [
              _Metric(value: '$credits', label: 'Crédits validés'),
              const SizedBox(width: 28),
              const _Metric(value: '1er', label: 'Semestre'),
              const SizedBox(width: 28),
              const _Metric(value: '12 / 48', label: 'Rang'),
            ],
          ),
        ],
      ),
    );
  }
}

class _Metric extends StatelessWidget {
  final String value;
  final String label;

  const _Metric({required this.value, required this.label});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(value, style: const TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.w700)),
        Text(label, style: const TextStyle(color: Colors.white70, fontSize: 12)),
      ],
    );
  }
}

class _SessionCard extends StatelessWidget {
  final _Session session;
  final Color Function(double) gradeColor;

  const _SessionCard({required this.session, required this.gradeColor});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: const Color(0xFFE8E5F2)),
      ),
      child: Column(
        children: [
          Row(
            children: [
              Text(session.name,
                  style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w700, color: AppColors.textPrimary)),
              const Spacer(),
              Text('${session.credits} crédits',
                  style: const TextStyle(fontSize: 13, color: AppColors.textprimary)),
            ],
          ),
          const SizedBox(height: 8),
          for (final course in session.courses)
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8),
              child: Row(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: Image.asset(course.image, width: 44, height: 44, fit: BoxFit.cover,
                        errorBuilder: (_, __, ___) => Container(
                              width: 44,
                              height: 44,
                              color: AppColors.background,
                              child: const Icon(Icons.menu_book_rounded, color: AppColors.secondary),
                            )),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(course.name,
                            style: const TextStyle(
                                fontSize: 15, fontWeight: FontWeight.w600, color: AppColors.textPrimary)),
                        Text('${course.credit} crédits ECTS',
                            style: const TextStyle(fontSize: 12.5, color: AppColors.textprimary)),
                      ],
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: gradeColor(course.grade).withOpacity(0.1),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      course.grade.toStringAsFixed(1),
                      style: TextStyle(
                          color: gradeColor(course.grade), fontWeight: FontWeight.w700, fontSize: 15),
                    ),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }
}
