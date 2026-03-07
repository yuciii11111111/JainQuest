import 'package:flutter/material.dart';
import 'dart:ui';
import '../theme/app_theme.dart';

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

    return SizedBox(
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
              onPressed: isLoading ? null : onPressed,
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
              child: isLoading
                  ? const SizedBox(
                      width: 24,
                      height: 24,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                      ),
                    )
                  : Row(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        if (icon != null) ...[
                          Icon(icon, color: Colors.white, size: 20),
                          const SizedBox(width: AppSpacing.sm),
                        ],
                        Text(
                          label,
                          style:
                              Theme.of(context).textTheme.labelLarge?.copyWith(
                                    color: Colors.white,
                                    fontWeight: FontWeight.w700,
                                  ),
                        ),
                      ],
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
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    final enabled = widget.onPressed != null && !widget.isLoading;
    final textColor = enabled ? Colors.white : Colors.white70;

    return SizedBox(
      width: widget.width,
      height: widget.height,
      child: MouseRegion(
        onEnter: (_) => setState(() => _hovered = true),
        onExit: (_) => setState(() => _hovered = false),
        child: AnimatedScale(
          duration: const Duration(milliseconds: 240),
          curve: Curves.easeOutCubic,
          scale: _hovered && enabled ? 1.03 : 1.0,
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
                      child: widget.isLoading
                          ? const SizedBox(
                              width: 20,
                              height: 20,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                color: Colors.white,
                              ),
                            )
                          : Row(
                              mainAxisSize: MainAxisSize.min,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                if (widget.icon != null) ...[
                                  Icon(widget.icon, color: textColor, size: 20),
                                  const SizedBox(width: AppSpacing.sm),
                                ],
                                Text(
                                  widget.label,
                                  style: Theme.of(context)
                                      .textTheme
                                      .labelLarge
                                      ?.copyWith(
                                        color: textColor,
                                        letterSpacing: 1,
                                        fontWeight: FontWeight.w700,
                                      ),
                                ),
                              ],
                            ),
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
