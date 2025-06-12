import 'package:flutter/material.dart';
import '../constants/colors.dart';

class SessionFilter extends StatelessWidget {
  final List<String> sessions;
  final String? selectedSession;
  final ValueChanged<String?> onSessionSelected;
  final EdgeInsetsGeometry? padding;

  const SessionFilter({
    super.key,
    required this.sessions,
    this.selectedSession,
    required this.onSessionSelected,
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
            "Sessions :",
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
              children: sessions.map((session) {
                final bool isSelected = selectedSession == session;
                return Padding(
                  padding: const EdgeInsets.only(right: 8),
                  child: GestureDetector(
                    onTap: () => onSessionSelected(isSelected ? null : session),
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                      decoration: BoxDecoration(
                        color: isSelected
                            ? AppColors.secondary.withOpacity(0.2)
                            : AppColors.white,
                        borderRadius: BorderRadius.circular(16),
                      
                      ),
                      child: Text(
                        session,
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                          color: isSelected
                              ? AppColors.secondary
                              : AppColors.textPrimary,
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
