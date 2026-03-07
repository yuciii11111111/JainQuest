import 'package:flutter/material.dart';

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

  @override
  void initState() {
    super.initState();
    _visibleText = widget.enabled ? '' : widget.text;
    if (widget.enabled) {
      _tick();
    }
  }

  @override
  void didUpdateWidget(covariant TypewriterText oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.text == widget.text && oldWidget.enabled == widget.enabled) {
      return;
    }
    _index = 0;
    _visibleText = widget.enabled ? '' : widget.text;
    if (widget.enabled) {
      _tick();
    }
  }

  Future<void> _tick() async {
    while (mounted && widget.enabled && _index < widget.text.length) {
      await Future<void>.delayed(widget.speed);
      if (!mounted || !widget.enabled) {
        return;
      }
      _index += 1;
      setState(() {
        _visibleText = widget.text.substring(0, _index);
      });
    }
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
