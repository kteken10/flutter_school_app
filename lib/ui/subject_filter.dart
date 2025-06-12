import 'package:flutter/material.dart';
import '../constants/colors.dart';

class SubjectFilter extends StatelessWidget {
  final List<String> subjects;
  final String? selectedSubject;
  final ValueChanged<String?> onSubjectSelected;
  final EdgeInsetsGeometry? padding;

  const SubjectFilter({
    super.key,
    required this.subjects,
    this.selectedSubject,
    required this.onSubjectSelected,
    this.padding,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: padding ?? const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(
                "Matières :",
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: AppColors.secondary,
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: subjects.map((subject) {
                    return Flexible(
                      fit: FlexFit.tight,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 4),
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(16),
                            color: selectedSubject == subject
                                ? AppColors.secondary.withOpacity(0.2)
                                : AppColors.white,
                          ),
                          child: Material(
                            color: Colors.transparent,
                            child: InkWell(
                              borderRadius: BorderRadius.circular(16),
                              onTap: () {
                                onSubjectSelected(selectedSubject == subject ? null : subject);
                              },
                              child: Padding(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 12,
                                  vertical: 6,
                                ),
                                child: Center(
                                  child: Text(
                                    subject,
                                    style: TextStyle(
                                      fontSize: 12,
                                      fontWeight: FontWeight.w500,
                                      color: selectedSubject == subject
                                          ? AppColors.secondary
                                          : AppColors.textPrimary,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    );
                  }).toList(),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
