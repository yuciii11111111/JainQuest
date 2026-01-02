import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';

class TypewriterText extends StatefulWidget {
  final String text;
  final TextStyle? style;
  final TextAlign? textAlign;
  final Duration speed;
  final Duration startDelay;
  final Duration punctuationDelay;
  final int? maxLines;
  final bool softWrap;
  final bool shouldAnimate;
  final bool showCursor;
  final bool blinkCursor;
  final Duration cursorBlinkPeriod;
  final String cursor;
  final VoidCallback? onComplete;

  const TypewriterText({
    super.key,
    required this.text,
    this.style,
    this.textAlign,
    this.speed = const Duration(milliseconds: 18),
    this.startDelay = Duration.zero,
    this.punctuationDelay = const Duration(milliseconds: 140),
    this.maxLines,
    this.softWrap = true,
    this.shouldAnimate = true,
    this.showCursor = false,
    this.blinkCursor = false,
    this.cursorBlinkPeriod = const Duration(milliseconds: 550),
    this.cursor = '|',
    this.onComplete,
  });

  @override
  State<TypewriterText> createState() => _TypewriterTextState();
}

class _TypewriterTextState extends State<TypewriterText> {
  Timer? _timer;
  Timer? _startDelayTimer;
  Timer? _cursorTimer;
  int _visibleCount = 0;
  bool _cursorVisible = true;
  late final Random _random;

  @override
  void initState() {
    super.initState();
    _random = Random();
    if (!widget.shouldAnimate) {
      _visibleCount = widget.text.length;
      _setupCursor();
      return;
    }
    _startTyping();
    _setupCursor();
  }

  @override
  void didUpdateWidget(TypewriterText oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.text != widget.text) {
      _timer?.cancel();
      _startDelayTimer?.cancel();
      _visibleCount = 0;
      if (widget.shouldAnimate) {
        _startTyping();
      } else {
        _visibleCount = widget.text.length;
      }
    }
    if (oldWidget.showCursor != widget.showCursor ||
        oldWidget.blinkCursor != widget.blinkCursor ||
        oldWidget.cursorBlinkPeriod != widget.cursorBlinkPeriod) {
      _setupCursor();
    }
  }

  void _startTyping() {
    _startDelayTimer?.cancel();
    if (widget.startDelay == Duration.zero) {
      _typeNext();
      return;
    }
    _startDelayTimer = Timer(widget.startDelay, () {
      if (!mounted) return;
      _typeNext();
    });
  }

  void _typeNext() {
    if (!mounted) return;
    if (_visibleCount >= widget.text.length) {
      widget.onComplete?.call();
      return;
    }
    setState(() {
      _visibleCount++;
    });
    final delay = _delayForChar(widget.text[_visibleCount - 1]);
    _timer?.cancel();
    _timer = Timer(delay, _typeNext);
  }

  Duration _delayForChar(String char) {
    const hardStops = ['.', '!', '?'];
    const softStops = [',', ';', ':'];
    if (char == '\n') {
      return Duration(
        milliseconds: (widget.punctuationDelay.inMilliseconds * 0.8).round(),
      );
    }
    if (hardStops.contains(char)) {
      return widget.punctuationDelay;
    }
    if (softStops.contains(char)) {
      return Duration(
        milliseconds: (widget.punctuationDelay.inMilliseconds * 0.6).round(),
      );
    }
    if (char == ' ' || char == '\t') {
      return Duration(
        milliseconds: (widget.speed.inMilliseconds * 0.6).round(),
      );
    }
    final baseMs = widget.speed.inMilliseconds.toDouble();
    final jitter = (baseMs * 0.18) * (_random.nextDouble() * 2 - 1);
    final adjusted = (baseMs + jitter).clamp(6.0, baseMs * 1.6);
    return Duration(milliseconds: adjusted.round());
  }

  void _setupCursor() {
    _cursorTimer?.cancel();
    _cursorVisible = true;
    if (!widget.showCursor || !widget.blinkCursor) return;
    _cursorTimer = Timer.periodic(widget.cursorBlinkPeriod, (_) {
      if (!mounted) return;
      setState(() {
        _cursorVisible = !_cursorVisible;
      });
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    _startDelayTimer?.cancel();
    _cursorTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final displayText = widget.text.substring(0, _visibleCount.clamp(0, widget.text.length));
    final showCursor = widget.showCursor && (_cursorVisible || !widget.blinkCursor);
    return Text(
      showCursor ? '$displayText${widget.cursor}' : displayText,
      style: widget.style,
      textAlign: widget.textAlign,
      maxLines: widget.maxLines,
      softWrap: widget.softWrap,
      overflow: widget.maxLines != null ? TextOverflow.ellipsis : TextOverflow.visible,
    );
  }
}
