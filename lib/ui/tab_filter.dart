import 'package:flutter/material.dart';
import 'package:schoop_app/constants/colors.dart';

class AcademicTabFilter extends StatefulWidget {
  final List<String> tabs;
  final Function(int index)? onTabSelected;

  const AcademicTabFilter({
    super.key,
    required this.tabs,
    this.onTabSelected,
  });

  @override
  State<AcademicTabFilter> createState() => _AcademicTabFilterState();
}

class _AcademicTabFilterState extends State<AcademicTabFilter> {
  int selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 35,
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: widget.tabs.length,
        itemBuilder: (context, index) {
          bool isSelected = selectedIndex == index;
          return GestureDetector(
            onTap: () {
              setState(() {
                selectedIndex = index;
              });
              if (widget.onTabSelected != null) {
                widget.onTabSelected!(index);
              }
            },
            child: Container(
              margin: const EdgeInsets.symmetric(horizontal: 6),
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
              decoration: BoxDecoration(
                color: isSelected ? AppColors.secondary.withOpacity(0.4) : Colors.white,
                borderRadius: BorderRadius.circular(16),
              
              
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  getAcademicIcon(widget.tabs[index], isSelected),
                  const SizedBox(width: 6),
                  Text(
                    widget.tabs[index],
                    style: TextStyle(
                      color: isSelected ? AppColors.white : Colors.grey[700],
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Icon getAcademicIcon(String tab, bool isSelected) {
    Color iconColor = isSelected ? AppColors.primary : Colors.grey[700]!;

    switch (tab.toLowerCase()) {
      case 'sessions':
      case 'session':
      case 'examens':
      case 'examen':
        return Icon(Icons.event_note, color: iconColor, size: 18);
      case 'classes':
      case 'classe':
        return Icon(Icons.class_, color: iconColor, size: 18);
      case 'matières':
      case 'matiere':
      case 'subjects':
      case 'subject':
        return Icon(Icons.menu_book_rounded, color: iconColor, size: 18);
      default:
        return Icon(Icons.school, color: iconColor, size: 18);
    }
  }
}