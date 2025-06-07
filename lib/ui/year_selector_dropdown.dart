// lib/ui/year_selector_dropdown.dart
import 'package:flutter/material.dart';

import '../constants/colors.dart';

class YearSelectorDropdown extends StatelessWidget {
  final List<String> years;
  final String? selectedYear;
  final ValueChanged<String?> onChanged;

  const YearSelectorDropdown({
    super.key,
    required this.years,
    required this.selectedYear,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white, // Fond blanc
        borderRadius: BorderRadius.circular(8),
       
      ),
      padding: const EdgeInsets.symmetric(horizontal: 12),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: selectedYear,
          icon: const Icon(Icons.arrow_drop_down, size: 20),
          elevation: 2,
          style: const TextStyle(
            color: AppColors.primary,
            fontSize: 14,
            fontWeight: FontWeight.w500,
          ),
          onChanged: onChanged,
          items: years.map<DropdownMenuItem<String>>((String value) {
            return DropdownMenuItem<String>(
              value: value,
              child: Text(value),
            );
          }).toList(),
        ),
      ),
    );
  }
}
