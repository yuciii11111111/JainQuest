import 'package:flutter/material.dart';

import '../theme/app_motion.dart';

class AnimatedTabStack extends StatefulWidget {
  final int index;
  final List<Widget> children;

  const AnimatedTabStack({
    super.key,
    required this.index,
    required this.children,
  });

  @override
  State<AnimatedTabStack> createState() => _AnimatedTabStackState();
}

class _AnimatedTabStackState extends State<AnimatedTabStack> {
  late int _previousIndex = widget.index;

  @override
  void didUpdateWidget(covariant AnimatedTabStack oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.index != widget.index) {
      _previousIndex = oldWidget.index;
    }
  }

  @override
  Widget build(BuildContext context) {
    final direction = widget.index >= _previousIndex ? 1.0 : -1.0;

    return Stack(
      fit: StackFit.expand,
      children: [
        for (int i = 0; i < widget.children.length; i++)
          Positioned.fill(
            child: _AnimatedTabLayer(
              isActive: i == widget.index,
              wasActive: i == _previousIndex,
              direction: direction,
              child: widget.children[i],
            ),
          ),
      ],
    );
  }
}

class _AnimatedTabLayer extends StatelessWidget {
  final bool isActive;
  final bool wasActive;
  final double direction;
  final Widget child;

  const _AnimatedTabLayer({
    required this.isActive,
    required this.wasActive,
    required this.direction,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    if (AppMotion.reduceMotionOf(context)) {
      return Offstage(
        offstage: !isActive,
        child: TickerMode(
          enabled: isActive,
          child: child,
        ),
      );
    }

    final duration = AppMotion.resolveDuration(
      context,
      AppMotion.tabSwitch,
    );
    final curve = isActive ? AppMotion.enterCurve : AppMotion.exitCurve;
    final horizontalOffset =
        isActive ? 0.0 : (wasActive ? -0.04 : 0.04) * direction;

    return IgnorePointer(
      ignoring: !isActive,
      child: ExcludeSemantics(
        excluding: !isActive,
        child: AnimatedOpacity(
          opacity: isActive ? 1 : 0,
          duration: duration,
          curve: curve,
          child: AnimatedSlide(
            offset: Offset(horizontalOffset, 0),
            duration: duration,
            curve: curve,
            child: AnimatedScale(
              scale: isActive ? 1 : AppMotion.tabInactiveScale,
              duration: duration,
              curve: AppMotion.standardCurve,
              child: TickerMode(
                enabled: isActive,
                child: child,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
