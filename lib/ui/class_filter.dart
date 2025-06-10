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
      padding: padding ?? const EdgeInsets.fromLTRB(16, 8, 16, 4),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Filtrer par classe",
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
              children: classes.map((cls) {
                return Padding(
                  padding: const EdgeInsets.only(right: 8),
                  child: ChoiceChip(
                    label: Text(cls),
                    selected: selectedClass == cls,
                    onSelected: (selected) {
                      onClassSelected(selected ? cls : null);
                    },
                    selectedColor: AppColors.primary,
                    labelStyle: TextStyle(
                      color: selectedClass == cls 
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