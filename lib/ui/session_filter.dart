import 'package:flutter/material.dart';
import '../constants/colors.dart';

class SessionFilter extends StatelessWidget {
  final List<String> sessions;
  final String? selectedSession;
  final ValueChanged<String?> onSessionSelected;

  const SessionFilter({
    super.key,
    required this.sessions,
    this.selectedSession,
    required this.onSessionSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 4),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Filtrer par session",
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
              children: sessions.map((session) {
                return Padding(
                  padding: const EdgeInsets.only(right: 8),
                  child: ChoiceChip(
                    label: Text(session),
                    selected: selectedSession == session,
                    onSelected: (selected) {
                      onSessionSelected(selected ? session : null);
                    },
                    selectedColor: AppColors.primary,
                    labelStyle: TextStyle(
                      color: selectedSession == session 
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