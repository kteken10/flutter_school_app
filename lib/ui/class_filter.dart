import 'package:flutter/material.dart';
import '../constants/colors.dart';

class ClassFilter extends StatelessWidget {
  final List<String> classes;
  final String? selectedClass;
  final ValueChanged<String?> onClassSelected;
  final EdgeInsetsGeometry? padding;

  const ClassFilter({
    super.key,
    required this.classes,
    this.selectedClass,
    required this.onClassSelected,
    this.padding,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: padding ?? const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Classes :",
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: AppColors.secondary,
            ),
          ),
          const SizedBox(height: 8),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: classes.map((cls) {
                final bool isSelected = selectedClass == cls;
                return Padding(
                  padding: const EdgeInsets.only(right: 8),
                  child: GestureDetector(
                    onTap: () => onClassSelected(isSelected ? null : cls),
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                      decoration: BoxDecoration(
                        color: isSelected
                            ? AppColors.secondary.withOpacity(0.2)
                            : AppColors.white,
                        borderRadius: BorderRadius.circular(16),
                       
                      ),
                      child: Text(
                        cls,
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                          color: isSelected
                              ? AppColors.secondary
                              : AppColors.textprimary,
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
    );
  }
}
