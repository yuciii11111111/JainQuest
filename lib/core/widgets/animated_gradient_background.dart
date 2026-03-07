import 'dart:math' as math;
import 'dart:async';

import 'package:flutter/material.dart';

import '../theme/app_theme.dart';

class AnimatedGradientBackground extends StatefulWidget {
  final Widget child;
  final bool forceDark;
  final Duration initialCycleDelay;

  const AnimatedGradientBackground({
    super.key,
    required this.child,
    this.forceDark = false,
    this.initialCycleDelay = Duration.zero,
  });

  @override
  State<AnimatedGradientBackground> createState() =>
      _AnimatedGradientBackgroundState();
}

class _AnimatedGradientBackgroundState extends State<AnimatedGradientBackground>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  Timer? _startTimer;
  static const List<List<Color>> _lightPalettes = [
    [
      AppColors.softCream,
      Color(0xFFF7DFE8),
      Color(0xFFF4CFAE),
      AppColors.warmOrange,
    ],
    [
      Color(0xFFE8F7F4),
      Color(0xFFD9F0FF),
      Color(0xFFFBE3B0),
      Color(0xFFFFAF6B),
    ],
    [
      Color(0xFFFFF4D6),
      Color(0xFFFFDDE5),
      Color(0xFFE3D9FF),
      Color(0xFFFF9D7A),
    ],
    [
      Color(0xFFE3F8FF),
      Color(0xFFE1FFE8),
      Color(0xFFFFE7CB),
      Color(0xFFFFA96C),
    ],
  ];

  static const List<List<Color>> _darkPalettes = [
    [
      Color(0xFFED8F45),
      Color(0xFFB7662A),
      Color(0xFF472815),
      Color(0xFF000000),
    ],
    [
      Color(0xFFE8745B),
      Color(0xFF7A3D3A),
      Color(0xFF2C1B25),
      Color(0xFF050505),
    ],
    [
      Color(0xFFDAA24F),
      Color(0xFF875D34),
      Color(0xFF2E2230),
      Color(0xFF030303),
    ],
    [
      Color(0xFFBD8CFF),
      Color(0xFF5A3B77),
      Color(0xFF231B2F),
      Color(0xFF000000),
    ],
  ];

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 10),
    );
    if (widget.initialCycleDelay > Duration.zero) {
      _startTimer = Timer(widget.initialCycleDelay, () {
        if (!mounted) return;
        _controller.repeat();
      });
    } else {
      _controller.repeat();
    }
  }

  @override
  void dispose() {
    _startTimer?.cancel();
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark =
        widget.forceDark || Theme.of(context).brightness == Brightness.dark;

    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        final cycle = isDark ? _darkPalettes : _lightPalettes;
        final paletteProgress = _controller.value * cycle.length;
        final fromIndex = paletteProgress.floor() % cycle.length;
        final toIndex = (fromIndex + 1) % cycle.length;
        final blendT = paletteProgress - paletteProgress.floor();
        final colors = _lerpPalette(cycle[fromIndex], cycle[toIndex], blendT);

        final double t = _controller.value * 2 * math.pi;
        final double x1 = 0.5 + 0.3 * math.cos(t);
        final double y1 = 0.5 + 0.2 * math.sin(t * 0.7);
        final double x2 = 0.5 + 0.2 * math.sin(t * 1.2);
        final double y2 = 0.5 + 0.3 * math.cos(t * 0.8);

        if (!isDark) {
          return DecoratedBox(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: colors,
                stops: const [0.0, 0.35, 0.7, 1.0],
              ),
            ),
            child: DecoratedBox(
              decoration: BoxDecoration(
                gradient: RadialGradient(
                  center: Alignment((x1 - 0.5) * 1.4, (y1 - 0.5) * 1.4),
                  radius: 1.25,
                  colors: [
                    AppColors.warmOrange.withValues(alpha: 0.22),
                    Colors.transparent,
                  ],
                  stops: const [0.0, 0.78],
                ),
              ),
              child: DecoratedBox(
                decoration: BoxDecoration(
                  gradient: RadialGradient(
                    center: Alignment((x2 - 0.5) * 1.7, (y2 - 0.5) * 1.7),
                    radius: 1.45,
                    colors: [
                      Colors.white.withValues(alpha: 0.26),
                      Colors.transparent,
                    ],
                    stops: const [0.0, 0.82],
                  ),
                ),
                child: child,
              ),
            ),
          );
        }

        return DecoratedBox(
          decoration: BoxDecoration(
            gradient: RadialGradient(
              center: Alignment((x1 - 0.5) * 1.6, (y1 - 0.5) * 1.6),
              radius: 2.2,
              colors: colors,
              stops: const [0.0, 0.55, 0.82, 1.0],
            ),
          ),
          child: DecoratedBox(
            decoration: BoxDecoration(
              gradient: RadialGradient(
                center: Alignment((x2 - 0.5) * 1.9, (y2 - 0.5) * 1.9),
                radius: 1.7,
                colors: [
                  AppColors.softCream.withValues(alpha: 0.26),
                  Colors.transparent,
                ],
                stops: const [0.0, 0.75],
              ),
            ),
            child: child,
          ),
        );
      },
      child: widget.child,
    );
  }

  List<Color> _lerpPalette(List<Color> from, List<Color> to, double t) {
    return List<Color>.generate(
      from.length,
      (i) => Color.lerp(from[i], to[i], t) ?? from[i],
    );
  }
}
