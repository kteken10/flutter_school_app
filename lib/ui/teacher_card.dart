import 'package:flutter/material.dart';
import '../constants/colors.dart';
import 'add_icons.dart';

class TeacherCard extends StatefulWidget {
  final String name;
  final String email;
  final String profileImageUrl;
  final int subjectCount;
  final int classCount;
  final List<String> subjects;
  final List<String> classes;
  final VoidCallback onAddPressed;

  const TeacherCard({
    super.key,
    required this.name,
    required this.email,
    required this.profileImageUrl,
    required this.subjectCount,
    required this.classCount,
    required this.subjects,
    required this.classes,
    required this.onAddPressed,
  });

  @override
  State<TeacherCard> createState() => _TeacherCardState();
}

class _TeacherCardState extends State<TeacherCard>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Widget _infoBadge({required String label}) {
    return Container(
      margin: const EdgeInsets.only(left: 2),
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.85),
        borderRadius: BorderRadius.circular(14),
      ),
      child: Text(
        label,
        style: const TextStyle(
          color: AppColors.primary,
          fontWeight: FontWeight.w600,
          fontSize: 10,
        ),
      ),
    );
  }

  Widget _buildSubjectChip(String subject) {
    return Chip(
      label: Text(
        subject,
        style: const TextStyle(
          color: AppColors.primary,
          fontWeight: FontWeight.w500,
          fontSize: 10,
        ),
      ),
      backgroundColor: Colors.white.withOpacity(0.85),
      visualDensity: VisualDensity.compact,
      materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
      padding: EdgeInsets.zero,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      constraints: const BoxConstraints(
        maxHeight: 182,
      ),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                AppColors.secondary,
                AppColors.secondary.withOpacity(0.6)
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        const Text(
                          "Matières:",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 11,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        _infoBadge(label: '${widget.subjectCount}'),
                        const SizedBox(width: 4),
                        const Text(
                          "Classes:",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 11,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        _infoBadge(label: '${widget.classCount}'),
                        const Spacer(),
                        AddIcon(
                          onTap: widget.onAddPressed,
                        ),
                      ],
                    ),
                    const SizedBox(height: 6),
                    Row(
                      children: [
                        const Icon(Icons.email, size: 12, color: Colors.white70),
                        const SizedBox(width: 4),
                        Expanded(
                          child: Text(
                            widget.email,
                            style: const TextStyle(fontSize: 11, color: Colors.white70),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 6),
                    const Text(
                      "Matières enseignées :",
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 11,
                      ),
                    ),
                    const SizedBox(height: 4),
                    SizedBox(
                      height: 24,
                      child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: widget.subjects.length,
                        itemBuilder: (context, index) {
                          return Padding(
                            padding: const EdgeInsets.only(right: 4),
                            child: _buildSubjectChip(widget.subjects[index]),
                          );
                        },
                      ),
                    ),
                    const SizedBox(height: 6),
                    const Text(
                      "Classes de l'enseignant :",
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 11,
                      ),
                    ),
                    const SizedBox(height: 4),
                    SizedBox(
                      height: 24,
                      child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: widget.classes.length,
                        itemBuilder: (context, index) {
                          return Padding(
                            padding: const EdgeInsets.only(right: 4),
                            child: _buildSubjectChip(widget.classes[index]),
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}