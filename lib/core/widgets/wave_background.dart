import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';

/// Interactive animated line background inspired by the provided web component.
class WaveBackground extends StatefulWidget {
  final Color strokeColor;
  final Color backgroundColor;
  final Color pointerColor;
  final double pointerSize;
  final double lineSpacingX;
  final double lineSpacingY;

  const WaveBackground({
    super.key,
    this.strokeColor = const Color(0xFFFFFFFF),
    this.backgroundColor = const Color(0xFF000000),
    this.pointerColor = const Color(0xFFFFFFFF),
    this.pointerSize = 8,
    this.lineSpacingX = 12,
    this.lineSpacingY = 12,
  });

  @override
  State<WaveBackground> createState() => _WaveBackgroundState();
}

class _WaveBackgroundState extends State<WaveBackground>
    with SingleTickerProviderStateMixin {
  final List<List<_WavePoint>> _lines = <List<_WavePoint>>[];
  final _PointerState _pointer = _PointerState();
  final ValueNotifier<int> _repaint = ValueNotifier<int>(0);

  late final Ticker _ticker;
  Size _size = Size.zero;
  int _frame = 0;

  @override
  void initState() {
    super.initState();
    _ticker = createTicker(_tick)..start();
  }

  @override
  void dispose() {
    _ticker.dispose();
    _repaint.dispose();
    super.dispose();
  }

  void _tick(Duration elapsed) {
    if (_lines.isEmpty) return;

    _updatePointerSmoothing();
    _movePoints(elapsed.inMicroseconds / 1000.0);

    _frame++;
    _repaint.value = _frame;
  }

  void _updatePointer(Offset localPosition) {
    if (_size.isEmpty) return;

    _pointer.x = _clamp(localPosition.dx, -10, _size.width + 10);
    _pointer.y = _clamp(localPosition.dy, -10, _size.height + 10);

    if (!_pointer.set) {
      _pointer.sx = _pointer.x;
      _pointer.sy = _pointer.y;
      _pointer.lx = _pointer.x;
      _pointer.ly = _pointer.y;
      _pointer.set = true;
    }
  }

  void _updatePointerSmoothing() {
    _pointer.sx += (_pointer.x - _pointer.sx) * 0.1;
    _pointer.sy += (_pointer.y - _pointer.sy) * 0.1;

    final dx = _pointer.x - _pointer.lx;
    final dy = _pointer.y - _pointer.ly;
    final d = math.sqrt(dx * dx + dy * dy);

    _pointer.v = d;
    _pointer.vs += (d - _pointer.vs) * 0.1;
    _pointer.vs = _clamp(_pointer.vs, 0, 100);

    _pointer.lx = _pointer.x;
    _pointer.ly = _pointer.y;
    _pointer.a = math.atan2(dy, dx);
  }

  void _movePoints(double timeMs) {
    for (final points in _lines) {
      for (final point in points) {
        final move = _valueNoise2D(
              (point.x + timeMs * 0.008) * 0.003,
              (point.y + timeMs * 0.003) * 0.002,
            ) *
            math.pi *
            2;

        point.waveX = math.cos(move) * 12;
        point.waveY = math.sin(move) * 6;

        final dx = point.x - _pointer.sx;
        final dy = point.y - _pointer.sy;
        final d = math.sqrt(dx * dx + dy * dy);
        final l = math.max(175.0, _pointer.vs);

        if (d < l) {
          final s = 1 - d / l;
          final f = math.cos(d * 0.001) * s;

          point.cursorVx +=
              math.cos(_pointer.a) * f * l * _pointer.vs * 0.00035;
          point.cursorVy +=
              math.sin(_pointer.a) * f * l * _pointer.vs * 0.00035;
        }

        point.cursorVx += (0 - point.cursorX) * 0.01;
        point.cursorVy += (0 - point.cursorY) * 0.01;

        point.cursorVx *= 0.95;
        point.cursorVy *= 0.95;

        point.cursorX += point.cursorVx;
        point.cursorY += point.cursorVy;

        point.cursorX = _clamp(point.cursorX, -50, 50);
        point.cursorY = _clamp(point.cursorY, -50, 50);
      }
    }
  }

  void _configure(Size newSize) {
    if (_size == newSize) return;
    _size = newSize;
    _lines
      ..clear()
      ..addAll(_buildLines(newSize));

    if (!_pointer.set) {
      _pointer.x = -10;
      _pointer.y = newSize.height * 0.5;
      _pointer.sx = _pointer.x;
      _pointer.sy = _pointer.y;
      _pointer.lx = _pointer.x;
      _pointer.ly = _pointer.y;
    }
  }

  List<List<_WavePoint>> _buildLines(Size size) {
    final width = size.width;
    final height = size.height;
    final oWidth = width + 200;
    final oHeight = height + 30;

    final totalLines = (oWidth / widget.lineSpacingX).ceil();
    final totalPoints = (oHeight / widget.lineSpacingY).ceil();

    final xStart = (width - widget.lineSpacingX * totalLines) / 2;
    final yStart = (height - widget.lineSpacingY * totalPoints) / 2;

    return List<List<_WavePoint>>.generate(totalLines, (lineIndex) {
      return List<_WavePoint>.generate(totalPoints, (pointIndex) {
        return _WavePoint(
          x: xStart + widget.lineSpacingX * lineIndex,
          y: yStart + widget.lineSpacingY * pointIndex,
        );
      });
    });
  }

  double _valueNoise2D(double x, double y) {
    final x0 = x.floor();
    final y0 = y.floor();
    final xf = x - x0;
    final yf = y - y0;

    final u = xf * xf * (3 - 2 * xf);
    final v = yf * yf * (3 - 2 * yf);

    final n00 = _hash2D(x0, y0);
    final n10 = _hash2D(x0 + 1, y0);
    final n01 = _hash2D(x0, y0 + 1);
    final n11 = _hash2D(x0 + 1, y0 + 1);

    final nx0 = _lerp(n00, n10, u);
    final nx1 = _lerp(n01, n11, u);
    final nxy = _lerp(nx0, nx1, v);

    return nxy * 2 - 1;
  }

  double _hash2D(int x, int y) {
    final n = x * 374761393 + y * 668265263;
    var hash = (n ^ (n >> 13)) * 1274126177;
    hash ^= hash >> 16;
    return (hash & 0x7fffffff) / 0x7fffffff;
  }

  double _lerp(double a, double b, double t) => a + (b - a) * t;

  double _clamp(double value, double min, double max) {
    if (value < min) return min;
    if (value > max) return max;
    return value;
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final size = Size(constraints.maxWidth, constraints.maxHeight);
        if (size.width.isFinite &&
            size.height.isFinite &&
            size.width > 0 &&
            size.height > 0) {
          _configure(size);
        }

        return Listener(
          behavior: HitTestBehavior.translucent,
          onPointerDown: (event) => _updatePointer(event.localPosition),
          onPointerHover: (event) => _updatePointer(event.localPosition),
          onPointerMove: (event) => _updatePointer(event.localPosition),
          child: RepaintBoundary(
            child: CustomPaint(
              painter: _WavePainter(
                lines: _lines,
                pointer: _pointer,
                strokeColor: widget.strokeColor,
                backgroundColor: widget.backgroundColor,
                pointerColor: widget.pointerColor,
                pointerRadius: widget.pointerSize / 2,
                repaint: _repaint,
              ),
              child: const SizedBox.expand(),
            ),
          ),
        );
      },
    );
  }
}

class _WavePainter extends CustomPainter {
  final List<List<_WavePoint>> lines;
  final _PointerState pointer;
  final Color strokeColor;
  final Color backgroundColor;
  final Color pointerColor;
  final double pointerRadius;

  _WavePainter({
    required this.lines,
    required this.pointer,
    required this.strokeColor,
    required this.backgroundColor,
    required this.pointerColor,
    required this.pointerRadius,
    required Listenable repaint,
  }) : super(repaint: repaint);

  @override
  void paint(Canvas canvas, Size size) {
    final backgroundPaint = Paint()..color = backgroundColor;
    canvas.drawRect(Offset.zero & size, backgroundPaint);

    final linePaint = Paint()
      ..color = strokeColor
      ..strokeWidth = 1
      ..style = PaintingStyle.stroke
      ..isAntiAlias = true;

    final path = Path();

    for (final points in lines) {
      if (points.length < 2) continue;

      path.reset();
      final first = _moved(points.first, withCursorForce: false);
      path.moveTo(first.dx, first.dy);

      for (var i = 1; i < points.length; i++) {
        final current = _moved(points[i]);
        path.lineTo(current.dx, current.dy);
      }

      canvas.drawPath(path, linePaint);
    }

    final pointerPaint = Paint()..color = pointerColor;
    canvas.drawCircle(
        Offset(pointer.sx, pointer.sy), pointerRadius, pointerPaint);
  }

  Offset _moved(_WavePoint point, {bool withCursorForce = true}) {
    return Offset(
      point.x + point.waveX + (withCursorForce ? point.cursorX : 0),
      point.y + point.waveY + (withCursorForce ? point.cursorY : 0),
    );
  }

  @override
  bool shouldRepaint(covariant _WavePainter oldDelegate) => false;
}

class _WavePoint {
  final double x;
  final double y;
  double waveX = 0;
  double waveY = 0;
  double cursorX = 0;
  double cursorY = 0;
  double cursorVx = 0;
  double cursorVy = 0;

  _WavePoint({
    required this.x,
    required this.y,
  });
}

class _PointerState {
  double x = -10;
  double y = 0;
  double lx = 0;
  double ly = 0;
  double sx = 0;
  double sy = 0;
  double v = 0;
  double vs = 0;
  double a = 0;
  bool set = false;
}
