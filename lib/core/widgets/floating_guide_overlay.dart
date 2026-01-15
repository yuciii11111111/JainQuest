import 'dart:math';
import 'package:flutter/material.dart';

class FloatingGuideOverlay extends StatefulWidget {
  const FloatingGuideOverlay({super.key});

  @override
  State<FloatingGuideOverlay> createState() => _FloatingGuideOverlayState();
}

class _FloatingGuideOverlayState extends State<FloatingGuideOverlay>
    with SingleTickerProviderStateMixin {
  static const _assetPath = 'assets/images/duo_guide.png';
  static const _size = 84.0;

  final List<Offset> _waypoints = const [
    Offset(0.08, 0.15),
    Offset(0.72, 0.12),
    Offset(0.65, 0.55),
    Offset(0.12, 0.58),
    Offset(0.78, 0.82),
    Offset(0.18, 0.82),
  ];

  late final AnimationController _controller;
  late Animation<Offset> _position;
  int _currentIndex = 0;
  final Random _random = Random();

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this);
    _setNextHop();
    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _setNextHop() {
    final start = _waypoints[_currentIndex];
    _currentIndex = (_currentIndex + 1) % _waypoints.length;
    final end = _waypoints[_currentIndex];

    _controller.duration = Duration(
      milliseconds: 2200 + _random.nextInt(1400),
    );

    _position = Tween<Offset>(begin: start, end: end).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOutCubic),
    )..addStatusListener((status) {
        if (status == AnimationStatus.completed) {
          _controller.reset();
          _setNextHop();
          _controller.forward();
        }
      });
  }

  @override
  Widget build(BuildContext context) {
    return IgnorePointer(
      ignoring: true,
      child: LayoutBuilder(
        builder: (context, constraints) {
          final maxX = constraints.maxWidth - _size;
          final maxY = constraints.maxHeight - _size;

          return AnimatedBuilder(
            animation: _controller,
            builder: (context, child) {
              final position = _position.value;
              final left = position.dx * maxX;
              final top = position.dy * maxY;
              final bob = sin(_controller.value * pi) * 6;

              return Positioned(
                left: left,
                top: top + bob,
                child: child!,
              );
            },
            child: Image.asset(
              _assetPath,
              width: _size,
              height: _size,
              fit: BoxFit.contain,
            ),
          );
        },
      ),
    );
  }
}
