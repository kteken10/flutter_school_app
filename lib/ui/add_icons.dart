import 'package:flutter/material.dart';
import '../constants/colors.dart';

class AddIcon extends StatelessWidget {
  final VoidCallback? onTap;
  const AddIcon({super.key, this.onTap});

  @override
  Widget build(BuildContext context) {
    return Container(
   
      child: Container(
        width: 40,
        height: 40,
        decoration: BoxDecoration(
          color: Colors.white,
          shape: BoxShape.circle,
          border: Border.all(
            color: AppColors.secondary,
            width: 1,
          ),
          boxShadow: [
            BoxShadow(
              color: AppColors.secondary,
              blurRadius: 4,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: IconButton(
          icon: const Icon(Icons.add, color: AppColors.secondary, size: 22),
          onPressed: onTap,
          splashRadius: 22,
          padding: EdgeInsets.zero,
          constraints: const BoxConstraints(),
        ),
      ),
    );
  }
}