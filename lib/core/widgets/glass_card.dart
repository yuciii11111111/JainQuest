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
    final isLight = Theme.of(context).brightness == Brightness.light;
    final resolvedBorderColor =
        borderColor ?? scheme.outline.withOpacityValue(isLight ? 0.78 : 0.6);
    final resolvedTintOpacity = isLight ? 0.82 : 0.26;

    LiquidGlassContainer buildCard({VoidCallback? onTap}) {
      return LiquidGlassContainer(
        width: width,
        height: height,
        margin: margin,
        padding: padding ?? const EdgeInsets.all(AppSpacing.md),
        borderRadius: borderRadius ?? BorderRadius.circular(AppRadius.card),
        borderColor: resolvedBorderColor,
        borderWidth: borderWidth,
        tintColor: scheme.surface,
        tintOpacity: resolvedTintOpacity,
        onTap: onTap,
        child: child,
      );
    }

    return buildCard(onTap: onTap);
  }
}
