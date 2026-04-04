import 'dart:ui';

import 'package:flutter/material.dart';

import '../theme/app_motion.dart';
import '../theme/app_theme.dart';
import 'motion_pressable.dart';

enum LiquidGlassShape { rounded, circle }

class LiquidGlassContainer extends StatelessWidget {
  final Widget child;
  final EdgeInsetsGeometry? padding;
  final EdgeInsetsGeometry? margin;
  final double? width;
  final double? height;
  final BorderRadius? borderRadius;
  final LiquidGlassShape shape;
  final Color? tintColor;
  final double tintOpacity;
  final Color? borderColor;
  final double borderWidth;
  final double blurSigma;
  final VoidCallback? onTap;

  const LiquidGlassContainer({
    super.key,
    required this.child,
    this.padding,
    this.margin,
    this.width,
    this.height,
    this.borderRadius,
    this.shape = LiquidGlassShape.rounded,
    this.tintColor,
    this.tintOpacity = 0.0,
    this.borderColor,
    this.borderWidth = 1.2,
    this.blurSigma = 8,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final isLight = Theme.of(context).brightness == Brightness.light;
    final shapeIsCircle = shape == LiquidGlassShape.circle;
    final resolvedRadius =
        borderRadius ?? BorderRadius.circular(AppRadius.card);
    final effectiveBorderColor = borderColor ??
        (isLight
            ? scheme.outline.withOpacityValue(0.72)
            : Colors.white.withOpacityValue(0.32));
    final highlightColors = isLight
        ? <Color>[
            Colors.white.withOpacityValue(0.9),
            Colors.white.withOpacityValue(0.74),
            AppColors.softCream.withOpacityValue(0.42),
          ]
        : <Color>[
            Colors.white.withOpacityValue(0.28),
            Colors.white.withOpacityValue(0.12),
            Colors.white.withOpacityValue(0.04),
          ];
    final boxShadow = isLight
        ? <BoxShadow>[
            BoxShadow(
              color: AppColors.inkBlack.withOpacityValue(0.06),
              blurRadius: 24,
              spreadRadius: -10,
              offset: const Offset(0, 12),
            ),
          ]
        : const <BoxShadow>[];
    final duration = AppMotion.resolveDuration(context, AppMotion.standard);
    final curve = AppMotion.resolveCurve(context, AppMotion.standardCurve);

    Widget childWidget = AnimatedContainer(
      duration: duration,
      curve: curve,
      decoration: BoxDecoration(
        shape: shapeIsCircle ? BoxShape.circle : BoxShape.rectangle,
        borderRadius: shapeIsCircle ? null : resolvedRadius,
        border: Border.all(
          color: effectiveBorderColor,
          width: borderWidth,
        ),
        color: tintColor?.withOpacityValue(tintOpacity),
        boxShadow: boxShadow,
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: highlightColors,
        ),
      ),
      child: Padding(
        padding: padding ?? EdgeInsets.zero,
        child: child,
      ),
    );

    if (onTap != null) {
      childWidget = Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius:
              shapeIsCircle ? BorderRadius.circular(999) : resolvedRadius,
          child: childWidget,
        ),
      );
    }

    final clipped = shapeIsCircle
        ? ClipOval(
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: blurSigma, sigmaY: blurSigma),
              child: childWidget,
            ),
          )
        : ClipRRect(
            borderRadius: resolvedRadius,
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: blurSigma, sigmaY: blurSigma),
              child: childWidget,
            ),
          );

    final interactiveChild = onTap != null
        ? MotionPressable(
            hoveredScale: AppMotion.subtleHoverScale,
            child: clipped,
          )
        : clipped;

    return Container(
      margin: margin,
      width: width,
      height: height,
      child: interactiveChild,
    );
  }
}

class LiquidGlassIconBubble extends StatelessWidget {
  final IconData icon;
  final double size;
  final double iconSize;
  final Color? iconColor;
  final Color? tintColor;
  final double tintOpacity;
  final BorderRadius? borderRadius;
  final LiquidGlassShape shape;

  const LiquidGlassIconBubble({
    super.key,
    required this.icon,
    this.size = 48,
    this.iconSize = 22,
    this.iconColor,
    this.tintColor,
    this.tintOpacity = 0.0,
    this.borderRadius,
    this.shape = LiquidGlassShape.circle,
  });

  @override
  Widget build(BuildContext context) {
    final isLight = Theme.of(context).brightness == Brightness.light;
    return LiquidGlassContainer(
      width: size,
      height: size,
      shape: shape,
      borderRadius: borderRadius,
      tintColor: tintColor,
      tintOpacity: tintOpacity,
      padding: EdgeInsets.zero,
      child: Center(
        child: Icon(
          icon,
          size: iconSize,
          color: iconColor ??
              (isLight ? AppColors.lightTextPrimary : Colors.white),
        ),
      ),
    );
  }
}
