import 'dart:async';

import 'package:flutter/material.dart';

class TeacherCardDeco extends StatefulWidget {
  final List<String> imagePaths;
  final bool withHorizontalMargin;

  const TeacherCardDeco({
    super.key,
    required this.imagePaths,
    this.withHorizontalMargin = true,
  });

  @override
  // ignore: library_private_types_in_public_api
  _TeacherCardDecoState createState() => _TeacherCardDecoState();
}

class _TeacherCardDecoState extends State<TeacherCardDeco> {
  late final PageController _pageController;
  late Timer _timer;
  int _currentPage = 0;

  @override
  void initState() {
    super.initState();
    _pageController = PageController();

    _timer = Timer.periodic(const Duration(seconds: 3), (timer) {
      if (widget.imagePaths.isEmpty) return;

      _currentPage++;
      if (_currentPage >= widget.imagePaths.length) {
        _currentPage = 0;
      }
      _pageController.animateToPage(
        _currentPage,
        duration: const Duration(milliseconds: 350),
        curve: Curves.easeInOut,
      );
    });
  }

  @override
  void dispose() {
    _timer.cancel();
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (widget.imagePaths.isEmpty) {
      return const SizedBox.shrink();
    }

    return Container(
      width: double.infinity,
      margin: widget.withHorizontalMargin
          ? const EdgeInsets.symmetric(horizontal: 16)
          : EdgeInsets.zero,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(28),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(24),
        child: SizedBox(
          height: 150,
          width: double.infinity,
          child: PageView.builder(
            controller: _pageController,
            itemCount: widget.imagePaths.length,
            itemBuilder: (context, index) {
              return Image.asset(
                widget.imagePaths[index],
                fit: BoxFit.cover,
              );
            },
            onPageChanged: (index) {
              _currentPage = index;
            },
          ),
        ),
      ),
    );
  }
}
