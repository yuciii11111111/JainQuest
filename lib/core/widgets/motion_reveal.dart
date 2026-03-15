import 'dart:async';

import 'package:flutter/material.dart';

import '../theme/app_motion.dart';

class MotionReveal extends StatefulWidget {
  final Widget child;
  final Duration delay;
  final Duration duration;
  final Offset beginOffset;
  final double beginScale;
  final Curve curve;

  const MotionReveal({
    super.key,
    required this.child,
    this.delay = Duration.zero,
    this.duration = AppMotion.reveal,
    this.beginOffset = AppMotion.contentOffset,
    this.beginScale = 0.985,
    this.curve = AppMotion.enterCurve,
  });

  @override
  State<MotionReveal> createState() => _MotionRevealState();
}

class _MotionRevealState extends State<MotionReveal> {
  Timer? _timer;
  bool _isVisible = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) {
        return;
      }
      if (AppMotion.reduceMotionOf(context)) {
        setState(() => _isVisible = true);
        return;
      }
      _timer = Timer(widget.delay, () {
        if (mounted) {
          setState(() => _isVisible = true);
        }
      });
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (AppMotion.reduceMotionOf(context)) {
      return widget.child;
    }

    final duration = AppMotion.resolveDuration(context, widget.duration);
    final curve = AppMotion.resolveCurve(context, widget.curve);

    return AnimatedOpacity(
      opacity: _isVisible ? 1 : 0,
      duration: duration,
      curve: curve,
      child: AnimatedSlide(
        offset: _isVisible ? Offset.zero : widget.beginOffset,
        duration: duration,
        curve: curve,
        child: AnimatedScale(
          scale: _isVisible ? 1 : widget.beginScale,
          duration: duration,
          curve: curve,
          child: widget.child,
        ),
      ),
    );
  }
}
