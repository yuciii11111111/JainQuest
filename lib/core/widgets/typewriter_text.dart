import 'package:flutter/material.dart';

import '../theme/app_motion.dart';

class TypewriterText extends StatefulWidget {
  final String text;
  final TextStyle? style;
  final TextAlign? textAlign;
  final int? maxLines;
  final bool softWrap;
  final bool enabled;
  final Duration speed;

  const TypewriterText({
    super.key,
    required this.text,
    this.style,
    this.textAlign,
    this.maxLines,
    this.softWrap = true,
    this.enabled = false,
    this.speed = const Duration(milliseconds: 18),
  });

  @override
  State<TypewriterText> createState() => _TypewriterTextState();
}

class _TypewriterTextState extends State<TypewriterText> {
  late String _visibleText;
  int _index = 0;
  int _runId = 0;
  bool _hasResolvedMotion = false;
  bool _reduceMotion = false;

  @override
  void initState() {
    super.initState();
    _visibleText = widget.text;
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final reduceMotion = AppMotion.reduceMotionOf(context);
    if (_hasResolvedMotion && _reduceMotion == reduceMotion) {
      return;
    }
    _hasResolvedMotion = true;
    _reduceMotion = reduceMotion;
    _restartAnimation();
  }

  @override
  void didUpdateWidget(covariant TypewriterText oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.text == widget.text && oldWidget.enabled == widget.enabled) {
      return;
    }
    _restartAnimation();
  }

  void _restartAnimation() {
    final shouldAnimate = widget.enabled && !_reduceMotion;
    _runId += 1;
    _index = 0;
    _visibleText = shouldAnimate ? '' : widget.text;
    if (shouldAnimate) {
      _tick(_runId);
    }
  }

  Future<void> _tick(int runId) async {
    while (mounted &&
        widget.enabled &&
        _index < widget.text.length &&
        _runId == runId) {
      await Future<void>.delayed(widget.speed);
      if (!mounted || !widget.enabled || _runId != runId) {
        return;
      }
      _index += 1;
      setState(() {
        _visibleText = widget.text.substring(0, _index);
      });
    }
  }

  @override
  void dispose() {
    _runId += 1;
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Text(
      _visibleText,
      style: widget.style,
      textAlign: widget.textAlign,
      maxLines: widget.maxLines,
      softWrap: widget.softWrap,
      overflow: widget.maxLines != null
          ? TextOverflow.ellipsis
          : TextOverflow.visible,
    );
  }
}
