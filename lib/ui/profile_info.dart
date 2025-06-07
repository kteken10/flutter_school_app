import 'package:flutter/material.dart';

class ProfileInfoCard extends StatelessWidget {
  final Widget child;
  final EdgeInsetsGeometry margin;
  final EdgeInsetsGeometry padding;
  final double borderRadius;
  final Color backgroundColor;
  final List<BoxShadow>? boxShadow;

  const ProfileInfoCard({
    super.key,
    required this.child,
    this.margin = const EdgeInsets.symmetric(vertical: 6, horizontal: 16),
    this.padding = const EdgeInsets.all(12),
    this.borderRadius = 16,
    this.backgroundColor = Colors.white,
    this.boxShadow,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: margin,
      padding: padding,
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(borderRadius),
        boxShadow: boxShadow ??
            [
              BoxShadow(
                color: Colors.black.withOpacity(0.05),
                blurRadius: 4,
                offset: const Offset(0, 2),
              ),
            ],
      ),
      child: child,
    );
  }
}
