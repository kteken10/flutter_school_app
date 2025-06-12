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
          Row(
            children: [
              Text(
                "Classes :",
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: AppColors.secondary,
                ),
              ),
              const SizedBox(width: 4),
              Expanded(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: classes.map((cls) {
                    return Flexible(
                      fit: FlexFit.tight,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 4),
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(16),
                            color: selectedClass == cls
                                ? AppColors.secondary.withOpacity(0.2)
                                : AppColors.white,
                          ),
                          child: Material(
                            color: Colors.transparent,
                            child: InkWell(
                              borderRadius: BorderRadius.circular(16),
                              onTap: () {
                                onClassSelected(selectedClass == cls ? null : cls);
                              },
                              child: Padding(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 12,
                                  vertical: 6,
                                ),
                                child: Center(
                                  child: Text(
                                    cls,
                                    style: TextStyle(
                                      fontSize: 12,
                                      fontWeight: FontWeight.w500,
                                      color: selectedClass == cls
                                          ? AppColors.secondary
                                          : AppColors.textprimary,
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
