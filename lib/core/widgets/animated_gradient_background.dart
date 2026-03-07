import 'package:flutter/material.dart';
import 'dart:math' as math;

class AnimatedGradientBackground extends StatefulWidget {
  final Widget child;

  const AnimatedGradientBackground({super.key, required this.child});

  @override
  State<AnimatedGradientBackground> createState() =>
      _AnimatedGradientBackgroundState();
}

class _AnimatedGradientBackgroundState extends State<AnimatedGradientBackground>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 10),
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    if (!isDark) {
      return DecoratedBox(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Color(0xFFFFF8E8),
              Color(0xFFFFF1D8),
              Color(0xFFFFE4BF),
              Color(0xFFFFD6A5),
            ],
            stops: [0.0, 0.35, 0.7, 1.0],
          ),
        ),
        child: widget.child,
      );
    }

    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        final double t = _controller.value * 2 * math.pi;
        // Two moving centers for a more "alive" feel
        final double x1 = 0.5 + 0.3 * math.cos(t);
        final double y1 = 0.5 + 0.2 * math.sin(t * 0.7);

        final double x2 = 0.5 + 0.2 * math.sin(t * 1.2);
        final double y2 = 0.5 + 0.3 * math.cos(t * 0.8);

        return DecoratedBox(
          decoration: BoxDecoration(
            gradient: RadialGradient(
              center: Alignment(
                (x1 - 0.5) * 2.2,
                (y1 - 0.5) * 2.2,
              ),
              radius: 1.4,
              colors: const [
                Color(0xFF7A3B12), // Burnt Orange
                Color(0xFF4A260F), // Warm Brown
                Color(0xFF24170F), // Deep Brown
                Color(0xFF090807), // Near Black
              ],
              stops: const [0.0, 0.4, 0.7, 1.0],
            ),
          ),
          child: DecoratedBox(
            decoration: BoxDecoration(
              gradient: RadialGradient(
                center: Alignment(
                  (x2 - 0.5) * 2.5,
                  (y2 - 0.5) * 2.5,
                ),
                radius: 1.2,
                colors: [
                  const Color(0xFFFFB86B).withValues(alpha: 0.2), // Orange Glow
                  Colors.transparent,
                ],
                stops: const [0.0, 0.6],
              ),
            ),
            child: widget.child,
          ),
        );
      },
      child: widget.child,
    );
  }
}
