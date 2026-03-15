import 'package:flutter/material.dart';
import 'dart:ui';
import '../theme/app_motion.dart';
import '../theme/app_theme.dart';
import 'motion_pressable.dart';

class GradientButton extends StatelessWidget {
  final String label;
  final VoidCallback? onPressed;
  final Gradient? gradient;
  final IconData? icon;
  final bool isLoading;
  final EdgeInsetsGeometry? padding;
  final double? width;
  final double? height;
  final bool glow;
  final bool crystal;

  const GradientButton({
    super.key,
    required this.label,
    this.onPressed,
    this.gradient,
    this.icon,
    this.isLoading = false,
    this.padding,
    this.width,
    this.height,
    this.glow = true,
    this.crystal = false,
  });

  @override
  Widget build(BuildContext context) {
    if (crystal) {
      return _CrystalGlassButton(
        label: label,
        icon: icon,
        onPressed: isLoading ? null : onPressed,
        isLoading: isLoading,
        width: width,
        height: height ?? 56,
      );
    }

    final baseColor = _resolveColor(gradient) ?? AppColors.primary;
    final borderRadius = BorderRadius.circular(AppRadius.button);
    final enabled = !isLoading && onPressed != null;

    return MotionPressable(
      enabled: enabled,
      hoveredScale: AppMotion.subtleHoverScale,
      duration: AppMotion.quick,
      curve: AppMotion.enterCurve,
      child: SizedBox(
        width: width,
        height: height ?? 56,
        child: ClipRRect(
          borderRadius: borderRadius,
          child: BackdropFilter(
            filter: ImageFilter.blur(
              sigmaX: AppColors.glassBlur,
              sigmaY: AppColors.glassBlur,
            ),
            child: Container(
              decoration: BoxDecoration(
                borderRadius: borderRadius,
                color: const Color(0x66240F03),
                border: Border.all(
                  color: Colors.white.withOpacityValue(0.22),
                ),
              ),
              child: ElevatedButton(
                onPressed: enabled ? onPressed : null,
                style: ElevatedButton.styleFrom(
                  backgroundColor: baseColor.withOpacityValue(0.72),
                  foregroundColor: Colors.white,
                  disabledBackgroundColor: baseColor.withOpacityValue(0.45),
                  elevation: 0,
                  shadowColor: Colors.transparent,
                  padding: padding ??
                      const EdgeInsets.symmetric(
                        horizontal: AppSpacing.lg,
                        vertical: AppSpacing.md,
                      ),
                  shape: RoundedRectangleBorder(
                    borderRadius: borderRadius,
                  ),
                ),
                child: _AnimatedButtonContent(
                  isLoading: isLoading,
                  icon: icon,
                  label: label,
                  color: Colors.white,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Color? _resolveColor(Gradient? gradient) {
    if (gradient is LinearGradient && gradient.colors.isNotEmpty) {
      return gradient.colors.first;
    }
    if (gradient is RadialGradient && gradient.colors.isNotEmpty) {
      return gradient.colors.first;
    }
    if (gradient is SweepGradient && gradient.colors.isNotEmpty) {
      return gradient.colors.first;
    }
    return null;
  }
}

class _CrystalGlassButton extends StatefulWidget {
  final String label;
  final VoidCallback? onPressed;
  final IconData? icon;
  final bool isLoading;
  final double? width;
  final double height;

  const _CrystalGlassButton({
    required this.label,
    required this.onPressed,
    required this.icon,
    required this.isLoading,
    required this.width,
    required this.height,
  });

  @override
  State<_CrystalGlassButton> createState() => _CrystalGlassButtonState();
}

class _CrystalGlassButtonState extends State<_CrystalGlassButton> {
  @override
  Widget build(BuildContext context) {
    final enabled = widget.onPressed != null && !widget.isLoading;
    final textColor = enabled ? Colors.white : Colors.white70;

    return SizedBox(
      width: widget.width,
      height: widget.height,
      child: MotionPressable(
        enabled: enabled,
        hoveredScale: AppMotion.subtleHoverScale,
        duration: AppMotion.quick,
        curve: AppMotion.enterCurve,
        child: ClipRRect(
          borderRadius: BorderRadius.circular(999),
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 8, sigmaY: 8),
            child: DecoratedBox(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(999),
                border: Border.all(
                  color: Colors.white.withOpacityValue(enabled ? 0.45 : 0.2),
                  width: 1.2,
                ),
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    Colors.white.withOpacityValue(enabled ? 0.28 : 0.14),
                    Colors.white.withOpacityValue(enabled ? 0.12 : 0.06),
                    Colors.white.withOpacityValue(enabled ? 0.04 : 0.02),
                  ],
                ),
              ),
              child: Material(
                color: Colors.transparent,
                child: InkWell(
                  onTap: enabled ? widget.onPressed : null,
                  borderRadius: BorderRadius.circular(999),
                  child: Center(
                    child: _AnimatedButtonContent(
                      isLoading: widget.isLoading,
                      icon: widget.icon,
                      label: widget.label,
                      color: textColor,
                      letterSpacing: 1,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _AnimatedButtonContent extends StatelessWidget {
  final bool isLoading;
  final IconData? icon;
  final String label;
  final Color color;
  final double? letterSpacing;

  const _AnimatedButtonContent({
    required this.isLoading,
    required this.icon,
    required this.label,
    required this.color,
    this.letterSpacing,
  });

  @override
  Widget build(BuildContext context) {
    final duration = AppMotion.resolveDuration(context, AppMotion.standard);

    return AnimatedSwitcher(
      duration: duration,
      switchInCurve: AppMotion.enterCurve,
      switchOutCurve: AppMotion.exitCurve,
      transitionBuilder: (child, animation) {
        final fade = CurvedAnimation(
          parent: animation,
          curve: AppMotion.enterCurve,
          reverseCurve: AppMotion.exitCurve,
        );

        return FadeTransition(
          opacity: fade,
          child: ScaleTransition(
            scale: Tween<double>(begin: 0.96, end: 1).animate(fade),
            child: child,
          ),
        );
      },
      child: isLoading
          ? SizedBox(
              key: const ValueKey('button-loading'),
              width: 24,
              height: 24,
              child: CircularProgressIndicator(
                strokeWidth: 2,
                color: color,
              ),
            )
          : Row(
              key: const ValueKey('button-label'),
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                if (icon != null) ...[
                  Icon(icon, color: color, size: 20),
                  const SizedBox(width: AppSpacing.sm),
                ],
                Text(
                  label,
                  style: Theme.of(context).textTheme.labelLarge?.copyWith(
                        color: color,
                        letterSpacing: letterSpacing,
                        fontWeight: FontWeight.w700,
                      ),
                ),
              ],
            ),
    );
  }
}
