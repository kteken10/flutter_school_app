import 'package:flutter/material.dart';
import '../constants/colors.dart';

enum SortOption {
  byGradeValue,
  bySubjectName,
  byTeacherName,
  byDateRecorded,
}

class SortFilterChips extends StatelessWidget {
  final SortOption currentSort;
  final ValueChanged<SortOption> onSortChanged;

  const SortFilterChips({
    super.key,
    required this.currentSort,
    required this.onSortChanged,
  });

  String _labelForOption(SortOption option) {
    switch (option) {
      case SortOption.byGradeValue:
        return 'Valeur de la note';
      case SortOption.bySubjectName:
        return 'Nom de la matière';
      case SortOption.byTeacherName:
        return 'Nom du professeur';
      case SortOption.byDateRecorded:
      default:
        return 'Date';
    }
  }

  @override
  Widget build(BuildContext context) {
    final options = SortOption.values;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Trier par",
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
              children: options.map((option) {
                final selected = option == currentSort;
                return Padding(
                  padding: const EdgeInsets.only(right: 8),
                  child: ChoiceChip(
                    label: Text(_labelForOption(option)),
                    selected: selected,
                    onSelected: (bool selectedChip) {
                      if (selectedChip) {
                        onSortChanged(option);
                      }
                    },
                    selectedColor: AppColors.primary,
                    labelStyle: TextStyle(
                      color: selected ? Colors.white : AppColors.textPrimary,
                    ),
                    backgroundColor: Colors.grey[200],
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
