import 'package:flutter/material.dart';

final GlobalKey<NavigatorState> appNavigatorKey = GlobalKey<NavigatorState>();

const Duration _kSmoothTransitionDuration = Duration(milliseconds: 720);
const Duration _kSmoothReverseTransitionDuration = Duration(milliseconds: 560);

Route<T> buildUltraSmoothRoute<T>(
  Widget page, {
  RouteSettings? settings,
  Duration duration = _kSmoothTransitionDuration,
  Duration reverseDuration = _kSmoothReverseTransitionDuration,
  Curve curve = Curves.easeInOutCubicEmphasized,
  Curve reverseCurve = Curves.easeInOutCubic,
}) {
  return PageRouteBuilder<T>(
    settings: settings,
    pageBuilder: (_, __, ___) => page,
    transitionDuration: duration,
    reverseTransitionDuration: reverseDuration,
    transitionsBuilder: (_, animation, __, child) {
      final fade = CurvedAnimation(
        parent: animation,
        curve: const Interval(0.0, 1.0, curve: Curves.easeOutCubic),
        reverseCurve: Curves.easeInCubic,
      );
      final slide = CurvedAnimation(
        parent: animation,
        curve: curve,
        reverseCurve: reverseCurve,
      );
      final scale = CurvedAnimation(
        parent: animation,
        curve: const Interval(0.0, 1.0, curve: Curves.easeOutCubic),
        reverseCurve: Curves.easeInCubic,
      );

      return FadeTransition(
        opacity: fade,
        child: SlideTransition(
          position: Tween<Offset>(
            begin: const Offset(0.03, 0.0),
            end: Offset.zero,
          ).animate(slide),
          child: ScaleTransition(
            scale: Tween<double>(begin: 0.992, end: 1.0).animate(scale),
            child: child,
          ),
        ),
      );
    },
  );
}

extension SmoothNavigatorState on NavigatorState {
  Future<T?> pushUltraSmooth<T extends Object?>(Widget page) {
    return push<T>(buildUltraSmoothRoute<T>(page));
  }

  Future<T?> pushReplacementUltraSmooth<T extends Object?, TO extends Object?>(
    Widget page,
  ) {
    return pushReplacement<T, TO>(buildUltraSmoothRoute<T>(page));
  }

  Future<T?> pushAndRemoveUntilUltraSmooth<T extends Object?>(
    Widget page,
    RoutePredicate predicate,
  ) {
    return pushAndRemoveUntil<T>(buildUltraSmoothRoute<T>(page), predicate);
  }
}
