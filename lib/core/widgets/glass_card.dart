import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import 'liquid_glass.dart';

class GlassCard extends StatelessWidget {
  final Widget child;
  final EdgeInsetsGeometry? padding;
  final EdgeInsetsGeometry? margin;
  final double? width;
  final double? height;
  final VoidCallback? onTap;
  final BorderRadius? borderRadius;
  final Color? borderColor;
  final double borderWidth;

  const GlassCard({
    super.key,
    required this.child,
    this.padding,
    this.margin,
    this.width,
    this.height,
    this.onTap,
    this.borderRadius,
    this.borderColor,
    this.borderWidth = 1.0,
  });

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final card = LiquidGlassContainer(
      width: width,
      height: height,
      margin: margin,
      padding: padding ?? const EdgeInsets.all(AppSpacing.md),
      borderRadius: borderRadius ?? BorderRadius.circular(AppRadius.card),
      borderColor: borderColor ?? scheme.outline.withOpacityValue(0.6),
      borderWidth: borderWidth,
      tintColor: scheme.surface,
      tintOpacity: 0.26,
      child: child,
    );

    if (onTap != null) {
      return LiquidGlassContainer(
        width: width,
        height: height,
        margin: margin,
        padding: padding ?? const EdgeInsets.all(AppSpacing.md),
        borderRadius: borderRadius ?? BorderRadius.circular(AppRadius.card),
        borderColor: borderColor ?? scheme.outline.withOpacityValue(0.6),
        borderWidth: borderWidth,
        tintColor: scheme.surface,
        tintOpacity: 0.26,
        onTap: onTap,
        child: child,
      );
    }

    return card;
  }
}
