import 'package:flutter/material.dart';

class PulsingAvatar extends StatefulWidget {
  final String imagePath;
  final bool isOnline;

  const PulsingAvatar({
    super.key,
    required this.imagePath,
    this.isOnline = true,
  });

  @override
  State<PulsingAvatar> createState() => _PulsingAvatarState();
}

class _PulsingAvatarState extends State<PulsingAvatar>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  // Nombre de cercles pulsants
  static const int pulseCount = 3;
  // Durée totale de l'animation
  static const Duration pulseDuration = Duration(seconds: 3);

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: pulseDuration,
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  // Widget d’un cercle pulsant avec un délai de démarrage
  Widget _buildPulse(int index) {
    final double start = index / pulseCount;
    final double end = start + (1 / pulseCount);

    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        double t = (_controller.value - start);
        if (t < 0) t += 1; // Pour boucler

        // t va de 0 à 1 dans la fenêtre [start, end]
        double progress = (t / (1 / pulseCount)).clamp(0.0, 1.0);

        double size = 44 + 40 * progress; // Taille du cercle qui grandit
        double opacity = (1.0 - progress).clamp(0.0, 1.0);

        return Container(
            width: size,
            height: size,
          
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.green.withOpacity(opacity * 0.3),
            ),
          );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 80,
      height: 80,
      child: Stack(
       
        children: [
          // Cercles pulsants
          for (int i = 0; i < pulseCount; i++) _buildPulse(i),

          // Contour blanc et ombre autour de l'avatar
          Container(
            padding: const EdgeInsets.all(4),
            decoration: BoxDecoration(
              color: Colors.white,
              shape: BoxShape.circle,
             
            ),
            child: CircleAvatar(
              radius: 22,
              backgroundImage: AssetImage(widget.imagePath),
            ),
          ),

          // Pastille "online" verte
          if (widget.isOnline)
            Positioned(
              bottom: 10,
               left: 20,
              child: Container(
                width: 14,
                height: 14,
                decoration: BoxDecoration(
                  color: Colors.green,
                  shape: BoxShape.circle,
                  border: Border.all(color: Colors.white, width: 2),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
