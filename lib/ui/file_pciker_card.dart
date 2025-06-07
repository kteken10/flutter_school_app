import 'package:flutter/material.dart';
import '../../constants/colors.dart';

class FilePickerCard extends StatefulWidget {
  final VoidCallback? onTap;
  final String? fileName;

  const FilePickerCard({
    super.key,
    required this.onTap,
    this.fileName,
  });

  @override
  State<FilePickerCard> createState() => _FilePickerCardState();
}

class _FilePickerCardState extends State<FilePickerCard> with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _animation;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      duration: const Duration(seconds: 1),
      vsync: this,
    )..repeat(reverse: true);

    _animation = Tween<double>(begin: 20, end: 26).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: widget.onTap,
      child: Container(
        width: 30,
        height: 30,
        padding: EdgeInsets.zero,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(15),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 4,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Center(
          child: AnimatedBuilder(
            animation: _animation,
            builder: (context, child) {
              return Icon(
                Icons.cloud_upload_outlined,
                size: _animation.value,
                color: AppColors.primary,
              );
            },
          ),
        ),
      ),
    );
  }
}
