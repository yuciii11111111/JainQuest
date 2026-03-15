import 'package:flutter/material.dart';

import '../theme/app_motion.dart';

final GlobalKey<NavigatorState> appNavigatorKey = GlobalKey<NavigatorState>();

const Duration _kSmoothTransitionDuration = AppMotion.screenEnter;
const Duration _kSmoothReverseTransitionDuration = AppMotion.screenExit;

Widget _buildSmoothTransition(
  BuildContext context,
  Animation<double> animation,
  Animation<double> secondaryAnimation,
  Widget child, {
  Curve curve = AppMotion.enterCurve,
  Curve reverseCurve = AppMotion.exitCurve,
}) {
  if (AppMotion.reduceMotionOf(context)) {
    return FadeTransition(opacity: animation, child: child);
  }

  final fade = CurvedAnimation(
    parent: animation,
    curve: const Interval(0.0, 0.92, curve: AppMotion.enterCurve),
    reverseCurve: reverseCurve,
  );
  final slide = CurvedAnimation(
    parent: animation,
    curve: curve,
    reverseCurve: reverseCurve,
  );
  final scale = CurvedAnimation(
    parent: animation,
    curve: AppMotion.standardCurve,
    reverseCurve: reverseCurve,
  );
  final secondary = CurvedAnimation(
    parent: secondaryAnimation,
    curve: AppMotion.standardCurve,
    reverseCurve: AppMotion.standardCurve,
  );

  return AnimatedBuilder(
    animation: secondary,
    child: child,
    builder: (context, transitionChild) {
      final outgoingScale =
          1 - (secondary.value * (1 - AppMotion.secondaryRouteScale));
      final outgoingOpacity = (1 - (secondary.value * 0.08)).clamp(0.0, 1.0);
      final outgoingShift = -12 * secondary.value;

      return Transform.translate(
        offset: Offset(outgoingShift, 0),
        child: Opacity(
          opacity: outgoingOpacity,
          child: ScaleTransition(
            scale: Tween<double>(
              begin: AppMotion.routeScale,
              end: 1.0,
            ).animate(scale),
            child: SlideTransition(
              position: Tween<Offset>(
                begin: AppMotion.routeOffset,
                end: Offset.zero,
              ).animate(slide),
              child: FadeTransition(
                opacity: fade,
                child: Transform.scale(
                  scale: outgoingScale,
                  child: transitionChild,
                ),
              ),
            ),
          ),
        ),
      );
    },
  );
}

class AppSmoothTransitionsBuilder extends PageTransitionsBuilder {
  const AppSmoothTransitionsBuilder();

  @override
  Widget buildTransitions<T>(
    PageRoute<T> route,
    BuildContext context,
    Animation<double> animation,
    Animation<double> secondaryAnimation,
    Widget child,
  ) {
    return _buildSmoothTransition(
      context,
      animation,
      secondaryAnimation,
      child,
    );
  }
}

Route<T> buildUltraSmoothRoute<T>(
  Widget page, {
  RouteSettings? settings,
  Duration duration = _kSmoothTransitionDuration,
  Duration reverseDuration = _kSmoothReverseTransitionDuration,
  Curve curve = AppMotion.enterCurve,
  Curve reverseCurve = AppMotion.exitCurve,
}) {
  return PageRouteBuilder<T>(
    settings: settings,
    pageBuilder: (_, __, ___) => page,
    transitionDuration: duration,
    reverseTransitionDuration: reverseDuration,
    transitionsBuilder: (context, animation, secondaryAnimation, child) {
      return _buildSmoothTransition(
        context,
        animation,
        secondaryAnimation,
        child,
        curve: curve,
        reverseCurve: reverseCurve,
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
