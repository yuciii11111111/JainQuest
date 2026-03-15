import 'package:flutter/material.dart';

class AppMotion {
  AppMotion._();

  static const Duration none = Duration(milliseconds: 1);
  static const Duration press = Duration(milliseconds: 120);
  static const Duration hover = Duration(milliseconds: 160);
  static const Duration quick = Duration(milliseconds: 180);
  static const Duration standard = Duration(milliseconds: 240);
  static const Duration emphasis = Duration(milliseconds: 320);
  static const Duration screenEnter = Duration(milliseconds: 360);
  static const Duration screenExit = Duration(milliseconds: 260);
  static const Duration progress = Duration(milliseconds: 300);
  static const Duration tabSwitch = Duration(milliseconds: 320);
  static const Duration reveal = Duration(milliseconds: 420);
  static const Duration stagger = Duration(milliseconds: 70);

  static const Curve enterCurve = Cubic(0.16, 1, 0.3, 1);
  static const Curve exitCurve = Cubic(0.55, 0, 1, 0.45);
  static const Curve standardCurve = Cubic(0.2, 0.8, 0.2, 1);
  static const Curve emphasizedCurve = Cubic(0.2, 0.9, 0.2, 1);
  static const Curve ambientCurve = Cubic(0.65, 0, 0.35, 1);
  static const Curve springCurve = Cubic(0.34, 1.56, 0.64, 1);

  static const double pressedScale = 0.98;
  static const double subtleHoverScale = 1.012;
  static const double routeScale = 0.985;
  static const double secondaryRouteScale = 0.992;
  static const double tabInactiveScale = 0.992;

  static const Offset routeOffset = Offset(0.035, 0.0);
  static const Offset contentOffset = Offset(0.0, 0.04);
  static const Offset tabOffset = Offset(0.05, 0.0);
  static const Offset tooltipOffset = Offset(0.0, 0.05);

  static bool reduceMotionOf(BuildContext context) {
    return MediaQuery.maybeOf(context)?.disableAnimations ?? false;
  }

  static Duration resolveDuration(
    BuildContext context,
    Duration duration, {
    Duration reducedDuration = none,
  }) {
    return reduceMotionOf(context) ? reducedDuration : duration;
  }

  static Curve resolveCurve(
    BuildContext context,
    Curve curve, {
    Curve reducedCurve = Curves.linear,
  }) {
    return reduceMotionOf(context) ? reducedCurve : curve;
  }
}
