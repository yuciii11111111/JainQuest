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

class TypewriterSequence extends StatelessWidget {
  final List<TypewriterSequenceItem> items;
  final double gap;
  final CrossAxisAlignment crossAxisAlignment;
  final TypewriterSequenceBuilder? itemBuilder;

  const TypewriterSequence({
    super.key,
    required this.items,
    this.gap = 8,
    this.crossAxisAlignment = CrossAxisAlignment.start,
    this.itemBuilder,
  });

  @override
  Widget build(BuildContext context) {
    if (items.isEmpty) {
      return const SizedBox.shrink();
    }

    final children = <Widget>[];
    for (var i = 0; i < items.length; i += 1) {
      final item = items[i];
      final textWidget = TypewriterText(
        text: item.text,
        style: item.style,
        textAlign: item.textAlign,
        maxLines: item.maxLines,
        softWrap: item.softWrap,
      );
      final built = itemBuilder != null
          ? itemBuilder!(context, textWidget, i, item)
          : textWidget;
      children.add(built);
      if (i < items.length - 1) {
        children.add(SizedBox(height: gap));
      }
    }

    return Column(
      crossAxisAlignment: crossAxisAlignment,
      children: children,
    );
  }
}
