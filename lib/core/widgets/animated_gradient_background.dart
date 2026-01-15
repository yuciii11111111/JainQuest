import 'package:flutter/material.dart';

class AnimatedGradientBackground extends StatefulWidget {
  final Widget child;

  const AnimatedGradientBackground({super.key, required this.child});

  @override
  State<AnimatedGradientBackground> createState() =>
      _AnimatedGradientBackgroundState();
}

class _AnimatedGradientBackgroundState extends State<AnimatedGradientBackground>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  static const _colors = [
    Color(0xFFD6BB5E),
    Color(0xFFD0628A),
    Color(0xFF8D669E),
    Color(0xFF9C92F4),
    Color(0xFFE145A9),
    Color(0xFFA7F7BF),
  ];

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 36),
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        final t = _controller.value;
        final begin = Alignment(-1 + (2 * t), 0);
        final end = Alignment(1 + (2 * t), 0);

        return DecoratedBox(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: begin,
              end: end,
              colors: _colors,
              stops: const [0.0, 0.2, 0.4, 0.6, 0.8, 1.0],
            ),
          ),
          child: child,
        );
      },
      child: widget.child,
    );
  }
}
