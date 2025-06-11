import 'package:flutter/material.dart';
import '../constants/colors.dart';

class SubjectFilter extends StatelessWidget {
  final List<String> subjects;
  final String? selectedSubject;
  final ValueChanged<String?> onSubjectSelected;

  const SubjectFilter({
    super.key,
    required this.subjects,
    this.selectedSubject,
    required this.onSubjectSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 4),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Filtrer par matière",
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: AppColors.primary,
            ),
          ),
          const SizedBox(height: 8),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: subjects.map((subject) {
                return Padding(
                  padding: const EdgeInsets.only(right: 8),
                  child: ChoiceChip(
                    label: Text(subject),
                    selected: selectedSubject == subject,
                    onSelected: (selected) {
                      onSubjectSelected(selected ? subject : null);
                    },
                    selectedColor: AppColors.primary,
                    labelStyle: TextStyle(
                      color: selectedSubject == subject 
                          ? Colors.white 
                          : AppColors.textPrimary,
                    ),
                  ),
                );
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }
}