import 'package:flutter/material.dart';

import '../theme/app_motion.dart';

class MotionPressable extends StatefulWidget {
  final Widget child;
  final VoidCallback? onTap;
  final bool enabled;
  final HitTestBehavior behavior;
  final double pressedScale;
  final double hoveredScale;
  final double hoverLift;
  final Duration duration;
  final Curve curve;
  final bool enableHaptics;

  const MotionPressable({
    super.key,
    required this.child,
    this.onTap,
    this.enabled = true,
    this.behavior = HitTestBehavior.deferToChild,
    this.pressedScale = AppMotion.pressedScale,
    this.hoveredScale = AppMotion.subtleHoverScale,
    this.hoverLift = -0.008,
    this.duration = AppMotion.press,
    this.curve = AppMotion.standardCurve,
    this.enableHaptics = true,
  });

  @override
  State<MotionPressable> createState() => _MotionPressableState();
}

class _MotionPressableState extends State<MotionPressable> {
  bool _isHovered = false;
  bool _isPressed = false;
  bool _isFocused = false;

  void _handleTap() {
    if (widget.onTap == null || !widget.enabled) {
      return;
    }
    if (widget.enableHaptics) {
      Feedback.forTap(context);
    }
    widget.onTap?.call();
  }

  void _setHovered(bool value) {
    if (_isHovered == value || !mounted) {
      return;
    }
    setState(() => _isHovered = value);
  }

  void _setPressed(bool value) {
    if (_isPressed == value || !mounted) {
      return;
    }
    setState(() => _isPressed = value);
  }

  void _setFocused(bool value) {
    if (_isFocused == value || !mounted) {
      return;
    }
    setState(() => _isFocused = value);
  }

  @override
  Widget build(BuildContext context) {
    final reduceMotion = AppMotion.reduceMotionOf(context);
    final duration = AppMotion.resolveDuration(context, widget.duration);
    final curve = AppMotion.resolveCurve(context, widget.curve);

    final activeScale = _isPressed
        ? widget.pressedScale
        : ((_isHovered || _isFocused) ? widget.hoveredScale : 1.0);
    final scale = widget.enabled && !reduceMotion ? activeScale : 1.0;
    final slideOffset = widget.enabled && !reduceMotion
        ? Offset(
            0,
            _isPressed
                ? 0.004
                : ((_isHovered || _isFocused) ? widget.hoverLift : 0),
          )
        : Offset.zero;
    final opacity = widget.enabled ? 1.0 : 0.62;

    Widget current = AnimatedOpacity(
      opacity: opacity,
      duration: duration,
      curve: curve,
      child: AnimatedSlide(
        offset: slideOffset,
        duration: duration,
        curve: curve,
        child: AnimatedScale(
          scale: scale,
          duration: duration,
          curve: curve,
          child: widget.child,
        ),
      ),
    );

    current = FocusableActionDetector(
      enabled: widget.enabled && widget.onTap != null,
      mouseCursor:
          widget.enabled ? SystemMouseCursors.click : SystemMouseCursors.basic,
      onShowHoverHighlight: _setHovered,
      onShowFocusHighlight: _setFocused,
      actions: widget.onTap == null
          ? null
          : <Type, Action<Intent>>{
              ActivateIntent: CallbackAction<ActivateIntent>(
                onInvoke: (_) {
                  _handleTap();
                  return null;
                },
              ),
              ButtonActivateIntent: CallbackAction<ButtonActivateIntent>(
                onInvoke: (_) {
                  _handleTap();
                  return null;
                },
              ),
            },
      child: Listener(
        behavior: widget.behavior,
        onPointerDown: (_) => _setPressed(true),
        onPointerUp: (_) => _setPressed(false),
        onPointerCancel: (_) => _setPressed(false),
        child: current,
      ),
    );

    current = Semantics(
      button: widget.onTap != null,
      enabled: widget.enabled,
      child: current,
    );

    if (widget.onTap == null || !widget.enabled) {
      return current;
    }

    return GestureDetector(
      behavior: widget.behavior,
      onTap: _handleTap,
      child: current,
    );
  }
}
