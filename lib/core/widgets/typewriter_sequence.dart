import 'dart:async';

import 'package:flutter/material.dart';
import 'typewriter_text.dart';

class TypewriterSequenceItem {
  final String text;
  final TextStyle? style;
  final TextAlign? textAlign;
  final Duration speed;
  final Duration punctuationDelay;
  final int? maxLines;
  final bool softWrap;
  final bool showCursor;
  final bool blinkCursor;
  final Duration cursorBlinkPeriod;
  final String cursor;

  const TypewriterSequenceItem({
    required this.text,
    this.style,
    this.textAlign,
    this.speed = const Duration(milliseconds: 18),
    this.punctuationDelay = const Duration(milliseconds: 140),
    this.maxLines,
    this.softWrap = true,
    this.showCursor = false,
    this.blinkCursor = false,
    this.cursorBlinkPeriod = const Duration(milliseconds: 550),
    this.cursor = '|',
  });
}

typedef TypewriterSequenceBuilder = Widget Function(
  BuildContext context,
  Widget child,
  int index,
  TypewriterSequenceItem item,
);

class TypewriterSequence extends StatefulWidget {
  final List<TypewriterSequenceItem> items;
  final double gap;
  final Duration pauseBetween;
  final CrossAxisAlignment crossAxisAlignment;
  final TypewriterSequenceBuilder? itemBuilder;

  const TypewriterSequence({
    super.key,
    required this.items,
    this.gap = 8,
    this.pauseBetween = const Duration(milliseconds: 160),
    this.crossAxisAlignment = CrossAxisAlignment.start,
    this.itemBuilder,
  });

  @override
  State<TypewriterSequence> createState() => _TypewriterSequenceState();
}

class _TypewriterSequenceState extends State<TypewriterSequence> {
  Timer? _pauseTimer;
  int _activeIndex = 0;
  late String _itemsSignature;

  @override
  void initState() {
    super.initState();
    _itemsSignature = _buildSignature(widget.items);
  }

  @override
  void didUpdateWidget(covariant TypewriterSequence oldWidget) {
    super.didUpdateWidget(oldWidget);
    final newSignature = _buildSignature(widget.items);
    if (newSignature != _itemsSignature) {
      _itemsSignature = newSignature;
      _pauseTimer?.cancel();
      _activeIndex = 0;
    }
  }

  @override
  void dispose() {
    _pauseTimer?.cancel();
    super.dispose();
  }

  void _advance() {
    if (_activeIndex >= widget.items.length - 1) return;
    _pauseTimer?.cancel();
    _pauseTimer = Timer(widget.pauseBetween, () {
      if (!mounted) return;
      setState(() {
        _activeIndex += 1;
      });
    });
  }

  String _buildSignature(List<TypewriterSequenceItem> items) {
    return items.map((item) => item.text).join('|');
  }

  @override
  Widget build(BuildContext context) {
    final items = widget.items;
    if (items.isEmpty) {
      return const SizedBox.shrink();
    }

    final visibleCount = _activeIndex.clamp(0, items.length - 1);
    final children = <Widget>[];
    for (var i = 0; i <= visibleCount; i += 1) {
      final item = items[i];
      final isActive = i == visibleCount;
      final textWidget = TypewriterText(
        text: item.text,
        style: item.style,
        textAlign: item.textAlign,
        speed: item.speed,
        punctuationDelay: item.punctuationDelay,
        maxLines: item.maxLines,
        softWrap: item.softWrap,
        shouldAnimate: isActive,
        showCursor: isActive && item.showCursor,
        blinkCursor: isActive && item.blinkCursor,
        cursorBlinkPeriod: item.cursorBlinkPeriod,
        cursor: item.cursor,
        onComplete: isActive ? _advance : null,
      );
      final built = widget.itemBuilder != null
          ? widget.itemBuilder!(context, textWidget, i, item)
          : textWidget;
      children.add(built);
      if (i < visibleCount) {
        children.add(SizedBox(height: widget.gap));
      }
    }

    return Column(
      crossAxisAlignment: widget.crossAxisAlignment,
      children: children,
    );
  }
}
