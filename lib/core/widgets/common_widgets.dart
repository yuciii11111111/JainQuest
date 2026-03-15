import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../gamification/gamification_rules.dart';
import '../localization/app_strings.dart';
import '../theme/app_motion.dart';
import '../theme/app_theme.dart';
import 'liquid_glass.dart';
import 'motion_pressable.dart';
import 'tr_text.dart';

// ============================================================================
// Stats Pill Widget
// ============================================================================

class StatsPill extends StatelessWidget {
  final IconData icon;
  final String value;
  final Color? color;
  final Color? backgroundColor;

  const StatsPill({
    super.key,
    required this.icon,
    required this.value,
    this.color,
    this.backgroundColor,
  });

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final pillColor = color ?? scheme.onSurface;
    final bgColor = backgroundColor ?? scheme.surface;

    return LiquidGlassContainer(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.md,
        vertical: AppSpacing.sm,
      ),
      borderRadius: BorderRadius.circular(AppRadius.pill),
      borderColor: scheme.outline.withOpacityValue(0.6),
      tintColor: bgColor,
      tintOpacity: 0.35,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 18, color: pillColor),
          const SizedBox(width: AppSpacing.xs),
          Text(
            value,
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w700,
              color: pillColor,
            ),
          ),
        ],
      ),
    );
  }
}

// ============================================================================
// XP Pill
// ============================================================================

class XpPill extends StatelessWidget {
  final int xp;

  const XpPill({super.key, required this.xp});

  @override
  Widget build(BuildContext context) {
    return StatsPill(
      icon: Icons.star_rounded,
      value: '$xp ${context.t('xp')}',
      color: AppColors.achievementGold,
    );
  }
}

// ============================================================================
// Hearts Pill
// ============================================================================

class HeartsPill extends StatelessWidget {
  final int hearts;

  const HeartsPill({super.key, required this.hearts});

  @override
  Widget build(BuildContext context) {
    return StatsPill(
      icon: Icons.favorite_rounded,
      value: '$hearts',
      color: AppColors.danger,
    );
  }
}

class HeartLossOverlay extends StatefulWidget {
  const HeartLossOverlay({
    super.key,
    required this.heartsBefore,
    required this.heartsAfter,
    this.onComplete,
  });

  final int heartsBefore;
  final int heartsAfter;
  final VoidCallback? onComplete;

  @override
  State<HeartLossOverlay> createState() => _HeartLossOverlayState();
}

class _HeartLossOverlayState extends State<HeartLossOverlay>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 1350),
  )..addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        widget.onComplete?.call();
      }
    });

  late final Animation<double> _fade = TweenSequence<double>([
    TweenSequenceItem(
      tween: Tween(begin: 0.0, end: 1.0).chain(
        CurveTween(curve: Curves.easeOutCubic),
      ),
      weight: 18,
    ),
    TweenSequenceItem(
      tween: ConstantTween<double>(1.0),
      weight: 52,
    ),
    TweenSequenceItem(
      tween: Tween(begin: 1.0, end: 0.0).chain(
        CurveTween(curve: Curves.easeInCubic),
      ),
      weight: 30,
    ),
  ]).animate(_controller);

  late final Animation<double> _scale = TweenSequence<double>([
    TweenSequenceItem(
      tween: Tween(begin: 0.84, end: 1.04).chain(
        CurveTween(curve: Curves.easeOutBack),
      ),
      weight: 28,
    ),
    TweenSequenceItem(
      tween: Tween(begin: 1.04, end: 0.98).chain(
        CurveTween(curve: Curves.easeOut),
      ),
      weight: 34,
    ),
    TweenSequenceItem(
      tween: Tween(begin: 0.98, end: 0.94).chain(
        CurveTween(curve: Curves.easeInOut),
      ),
      weight: 38,
    ),
  ]).animate(_controller);

  @override
  void initState() {
    super.initState();
    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (widget.heartsBefore <= widget.heartsAfter) {
      return const SizedBox.shrink();
    }

    return IgnorePointer(
      child: Align(
        alignment: Alignment.topCenter,
        child: Padding(
          padding: const EdgeInsets.only(top: 104),
          child: FadeTransition(
            opacity: _fade,
            child: ScaleTransition(
              scale: _scale,
              child: LiquidGlassContainer(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppSpacing.lg,
                  vertical: AppSpacing.md,
                ),
                borderRadius: BorderRadius.circular(AppRadius.card),
                borderColor: Colors.white.withOpacityValue(0.32),
                tintColor: Theme.of(context).colorScheme.surface,
                tintOpacity: 0.62,
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: List.generate(
                    HeartsSystem.maxHearts,
                    (index) => Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: AppSpacing.xs,
                      ),
                      child: _AnimatedHeartIcon(
                        index: index,
                        heartsBefore: widget.heartsBefore,
                        heartsAfter: widget.heartsAfter,
                        progress: _controller,
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

class _AnimatedHeartIcon extends StatelessWidget {
  const _AnimatedHeartIcon({
    required this.index,
    required this.heartsBefore,
    required this.heartsAfter,
    required this.progress,
  });

  final int index;
  final int heartsBefore;
  final int heartsAfter;
  final Animation<double> progress;

  @override
  Widget build(BuildContext context) {
    final isFilledHeart = index < heartsAfter;
    final isBreakingHeart = index == heartsAfter && index < heartsBefore;
    final iconSize = isBreakingHeart ? 34.0 : 30.0;

    if (isFilledHeart) {
      return const Icon(
        Icons.favorite_rounded,
        size: 30,
        color: AppColors.danger,
      );
    }

    if (!isBreakingHeart) {
      return Icon(
        Icons.favorite_border_rounded,
        size: 30,
        color: AppColors.danger.withOpacityValue(0.32),
      );
    }

    return AnimatedBuilder(
      animation: progress,
      builder: (context, _) {
        final breakProgress = ((progress.value - 0.22) / 0.42).clamp(0.0, 1.0);
        final settleProgress = ((progress.value - 0.64) / 0.18).clamp(0.0, 1.0);
        final wobble = math.sin(breakProgress * math.pi * 6) *
            0.14 *
            (1.0 - breakProgress);
        final pulse = 1.0 + (0.18 * (1.0 - (breakProgress - 0.5).abs() * 2));

        final IconData icon;
        final Color color;
        if (breakProgress < 0.38) {
          icon = Icons.favorite_rounded;
          color = AppColors.danger;
        } else if (settleProgress < 1.0) {
          icon = Icons.heart_broken;
          color = Color.lerp(
                AppColors.danger,
                const Color(0xFF7A0B16),
                breakProgress,
              ) ??
              AppColors.danger;
        } else {
          icon = Icons.favorite_border_rounded;
          color = AppColors.danger.withOpacityValue(0.3);
        }

        return Transform.rotate(
          angle: wobble,
          child: Transform.scale(
            scale: settleProgress < 1.0 ? pulse : 1.0,
            child: Icon(
              icon,
              size: iconSize,
              color: color,
            ),
          ),
        );
      },
    );
  }
}

// ============================================================================
// Streak Pill
// ============================================================================

class StreakPill extends StatelessWidget {
  final int streak;

  const StreakPill({super.key, required this.streak});

  @override
  Widget build(BuildContext context) {
    return StatsPill(
      icon: Icons.local_fire_department_rounded,
      value: '$streak',
      color: AppColors.warning,
    );
  }
}

// ============================================================================
// Level Pill
// ============================================================================

class LevelPill extends StatelessWidget {
  final int level;

  const LevelPill({super.key, required this.level});

  @override
  Widget build(BuildContext context) {
    return StatsPill(
      icon: Icons.shield_rounded,
      value: '${context.t('level')} $level',
      color: AppColors.primary,
    );
  }
}

// ============================================================================
// Progress Bar
// ============================================================================

class AnimatedProgressBar extends StatelessWidget {
  final double progress;
  final double height;
  final Color? backgroundColor;
  final Color? progressColor;

  const AnimatedProgressBar({
    super.key,
    required this.progress,
    this.height = 8,
    this.backgroundColor,
    this.progressColor,
  });

  @override
  Widget build(BuildContext context) {
    final normalizedProgress = progress.clamp(0.0, 1.0).toDouble();
    final radius = BorderRadius.circular(height / 2);
    final fillColor = progressColor ?? AppColors.primary;
    final duration = AppMotion.resolveDuration(context, AppMotion.progress);
    final curve = AppMotion.resolveCurve(context, AppMotion.enterCurve);

    return Container(
      height: height,
      decoration: BoxDecoration(
        color: backgroundColor ??
            Theme.of(context).colorScheme.surfaceContainerHighest,
        borderRadius: radius,
      ),
      child: ClipRRect(
        borderRadius: radius,
        child: TweenAnimationBuilder<double>(
          tween: Tween<double>(end: normalizedProgress),
          duration: duration,
          curve: curve,
          builder: (context, value, _) {
            return FractionallySizedBox(
              alignment: Alignment.centerLeft,
              widthFactor: value,
              child: Container(
                height: height,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.centerLeft,
                    end: Alignment.centerRight,
                    colors: [
                      fillColor.withOpacityValue(0.82),
                      fillColor,
                      Colors.white.withOpacityValue(0.92),
                    ],
                    stops: const [0.0, 0.72, 1.0],
                  ),
                  borderRadius: radius,
                  boxShadow: value > 0
                      ? [
                          BoxShadow(
                            color: fillColor.withOpacityValue(0.3),
                            blurRadius: 18,
                            spreadRadius: -6,
                          ),
                        ]
                      : const [],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}

// ============================================================================
// Primary Button
// ============================================================================

class PrimaryButton extends StatelessWidget {
  final String label;
  final VoidCallback? onPressed;
  final bool isLoading;
  final IconData? icon;
  final bool fullWidth;

  const PrimaryButton({
    super.key,
    required this.label,
    this.onPressed,
    this.isLoading = false,
    this.icon,
    this.fullWidth = true,
  });

  @override
  Widget build(BuildContext context) {
    final enabled = !isLoading && onPressed != null;
    return MotionPressable(
      enabled: enabled,
      child: SizedBox(
        width: fullWidth ? double.infinity : null,
        height: 56,
        child: ElevatedButton(
          onPressed: enabled ? onPressed : null,
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.primary,
            foregroundColor: Colors.white,
            disabledBackgroundColor: AppColors.primary.withOpacityValue(0.5),
            elevation: 0,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(AppRadius.button),
            ),
          ),
          child: isLoading
              ? const SizedBox(
                  width: 24,
                  height: 24,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    color: Colors.white,
                  ),
                )
              : Row(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    if (icon != null) ...[
                      Icon(icon, size: 20),
                      const SizedBox(width: AppSpacing.sm),
                    ],
                    Text(
                      label,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ],
                ),
        ),
      ),
    );
  }
}

// ============================================================================
// Secondary Button
// ============================================================================

class SecondaryButton extends StatelessWidget {
  final String label;
  final VoidCallback? onPressed;
  final IconData? icon;
  final bool fullWidth;

  const SecondaryButton({
    super.key,
    required this.label,
    this.onPressed,
    this.icon,
    this.fullWidth = true,
  });

  @override
  Widget build(BuildContext context) {
    return MotionPressable(
      enabled: onPressed != null,
      child: SizedBox(
        width: fullWidth ? double.infinity : null,
        height: 56,
        child: OutlinedButton(
          onPressed: onPressed,
          style: OutlinedButton.styleFrom(
            foregroundColor: AppColors.primary,
            side: const BorderSide(color: AppColors.primary, width: 2),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(AppRadius.button),
            ),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (icon != null) ...[
                Icon(icon, size: 20),
                const SizedBox(width: AppSpacing.sm),
              ],
              Text(
                label,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ============================================================================
// Choice Button (for quiz answers)
// ============================================================================

enum ChoiceState { normal, selected, correct, incorrect }

class ChoiceButton extends StatelessWidget {
  final String label;
  final ChoiceState state;
  final VoidCallback? onTap;

  const ChoiceButton({
    super.key,
    required this.label,
    this.state = ChoiceState.normal,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    const correctColor = Color(0xFF2E7D32);
    const incorrectColor = Color(0xFFC62828);
    Color backgroundColor;
    Color borderColor;
    Color textColor;
    IconData? trailingIcon;

    switch (state) {
      case ChoiceState.normal:
        backgroundColor = Theme.of(context).colorScheme.surface;
        borderColor = Theme.of(context).colorScheme.outline;
        textColor = Theme.of(context).colorScheme.onSurface;
        break;
      case ChoiceState.selected:
        backgroundColor = Theme.of(context).colorScheme.surface;
        borderColor = AppColors.primary;
        textColor = Theme.of(context).colorScheme.onSurface;
        break;
      case ChoiceState.correct:
        backgroundColor = correctColor.withOpacityValue(0.14);
        borderColor = correctColor;
        textColor = correctColor;
        trailingIcon = Icons.check_circle_rounded;
        break;
      case ChoiceState.incorrect:
        backgroundColor = incorrectColor.withOpacityValue(0.14);
        borderColor = incorrectColor;
        textColor = incorrectColor;
        trailingIcon = Icons.cancel_rounded;
        break;
    }

    final resolvedOnTap =
        state == ChoiceState.normal || state == ChoiceState.selected
            ? () {
                HapticFeedback.lightImpact();
                onTap?.call();
              }
            : null;

    return MotionPressable(
      onTap: resolvedOnTap,
      enabled: resolvedOnTap != null,
      child: LiquidGlassContainer(
        padding: const EdgeInsets.all(AppSpacing.md),
        borderRadius: BorderRadius.circular(AppRadius.button),
        borderColor: borderColor,
        borderWidth: 2,
        tintColor: backgroundColor,
        tintOpacity: 0.45,
        child: Row(
          children: [
            Expanded(
              child: TrText(
                label,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: textColor,
                ),
              ),
            ),
            if (trailingIcon != null)
              Icon(trailingIcon, color: textColor, size: 24),
          ],
        ),
      ),
    );
  }
}

// ============================================================================
// Feedback Banner
// ============================================================================

class FeedbackBanner extends StatelessWidget {
  final bool isCorrect;
  final String message;
  final VoidCallback? onContinue;

  const FeedbackBanner({
    super.key,
    required this.isCorrect,
    required this.message,
    this.onContinue,
  });

  @override
  Widget build(BuildContext context) {
    const correctColor = Color(0xFF2E7D32);
    const incorrectColor = Color(0xFFC62828);
    return LiquidGlassContainer(
      padding: const EdgeInsets.all(AppSpacing.md),
      borderRadius: BorderRadius.circular(AppRadius.card),
      borderColor: isCorrect ? correctColor : incorrectColor,
      borderWidth: 2,
      tintColor: isCorrect ? correctColor : incorrectColor,
      tintOpacity: 0.16,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            children: [
              Icon(
                isCorrect ? Icons.check_circle_rounded : Icons.info_rounded,
                color: isCorrect ? correctColor : incorrectColor,
                size: 24,
              ),
              const SizedBox(width: AppSpacing.sm),
              Text(
                isCorrect ? context.t('correct') : context.t('not_quite'),
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                  color: isCorrect ? correctColor : incorrectColor,
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.sm),
          TrText(
            message,
            style: TextStyle(
              fontSize: 14,
              color: isCorrect ? correctColor : incorrectColor,
              height: 1.45,
            ),
          ),
          if (onContinue != null) ...[
            const SizedBox(height: AppSpacing.md),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: onContinue,
                style: ElevatedButton.styleFrom(
                  backgroundColor: isCorrect ? correctColor : incorrectColor,
                  foregroundColor: Colors.white,
                ),
                child: Text(context.t('continue')),
              ),
            ),
          ],
        ],
      ),
    );
  }
}

// ============================================================================
// Content Card
// ============================================================================

class ContentCard extends StatelessWidget {
  final String? title;
  final String body;
  final Widget? leading;
  final EdgeInsets? padding;

  const ContentCard({
    super.key,
    this.title,
    required this.body,
    this.leading,
    this.padding,
  });

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return LiquidGlassContainer(
      padding: padding ?? const EdgeInsets.all(AppSpacing.lg),
      borderRadius: BorderRadius.circular(AppRadius.card),
      borderColor: scheme.outline.withOpacityValue(0.6),
      tintColor: scheme.surface,
      tintOpacity: 0.3,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (leading != null) ...[
            leading!,
            const SizedBox(width: AppSpacing.md),
          ],
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (title != null) ...[
                  Text(
                    title!,
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  const SizedBox(height: AppSpacing.sm),
                ],
                Text(
                  body,
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                        height: 1.5,
                      ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ============================================================================
// Mascot Widget (Placeholder for Lottie)
// ============================================================================

enum MascotState { idle, correct, wrong, streak, complete }

class MascotWidget extends StatelessWidget {
  final MascotState state;
  final double size;

  const MascotWidget({
    super.key,
    this.state = MascotState.idle,
    this.size = 120,
  });

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    // In production, replace with Lottie animation
    IconData icon;
    Color color;

    switch (state) {
      case MascotState.idle:
        icon = Icons.sentiment_satisfied_alt_rounded;
        color = AppColors.primary;
        break;
      case MascotState.correct:
        icon = Icons.celebration_rounded;
        color = AppColors.success;
        break;
      case MascotState.wrong:
        icon = Icons.sentiment_dissatisfied_rounded;
        color = scheme.onSurfaceVariant;
        break;
      case MascotState.streak:
        icon = Icons.local_fire_department_rounded;
        color = AppColors.primary;
        break;
      case MascotState.complete:
        icon = Icons.emoji_events_rounded;
        color = AppColors.secondary;
        break;
    }

    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: color.withOpacityValue(0.12),
        shape: BoxShape.circle,
        border: Border.all(
          color: color.withOpacityValue(0.3),
          width: 2,
        ),
      ),
      child: Icon(
        icon,
        size: size * 0.6,
        color: color,
      ),
    );
  }
}

// ============================================================================
// Badge Widget
// ============================================================================

class BadgeWidget extends StatelessWidget {
  final String name;
  final bool isEarned;
  final double size;

  const BadgeWidget({
    super.key,
    required this.name,
    this.isEarned = false,
    this.size = 80,
  });

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Opacity(
      opacity: isEarned ? 1.0 : 0.3,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: size,
            height: size,
            decoration: BoxDecoration(
              color: isEarned
                  ? AppColors.secondary.withOpacityValue(0.12)
                  : Theme.of(context).colorScheme.surfaceContainerHighest,
              shape: BoxShape.circle,
              border: Border.all(
                color: isEarned
                    ? AppColors.secondary
                    : Theme.of(context).colorScheme.outline,
                width: 3,
              ),
            ),
            child: Icon(
              Icons.workspace_premium_rounded,
              size: size * 0.5,
              color: isEarned ? AppColors.secondary : scheme.onSurfaceVariant,
            ),
          ),
          const SizedBox(height: AppSpacing.sm),
          SizedBox(
            width: size + 20,
            child: Text(
              name,
              textAlign: TextAlign.center,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: isEarned ? scheme.onSurface : scheme.onSurfaceVariant,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
// ============================================================================
// Social Sign In Button
// ============================================================================

class SocialSignInButton extends StatelessWidget {
  final String label;
  final String iconAsset;
  final VoidCallback? onPressed;
  final bool isLoading;

  const SocialSignInButton({
    super.key,
    required this.label,
    required this.iconAsset,
    this.onPressed,
    this.isLoading = false,
  });

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final isNetwork = iconAsset.startsWith('http');
    final enabled = !isLoading && onPressed != null;
    final iconPixels = (24 * MediaQuery.devicePixelRatioOf(context)).round();

    return MotionPressable(
      enabled: enabled,
      child: SizedBox(
        width: double.infinity,
        height: 56,
        child: OutlinedButton(
          onPressed: enabled ? onPressed : null,
          style: OutlinedButton.styleFrom(
            foregroundColor: scheme.onSurface,
            side: BorderSide(color: scheme.outline),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(AppRadius.button),
            ),
            backgroundColor: scheme.surface.withOpacityValue(0.5),
          ),
          child: isLoading
              ? const SizedBox(
                  width: 24,
                  height: 24,
                  child: CircularProgressIndicator(strokeWidth: 2),
                )
              : Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    if (isNetwork)
                      Image.network(
                        iconAsset,
                        width: 24,
                        height: 24,
                        cacheWidth: iconPixels,
                        cacheHeight: iconPixels,
                      )
                    else
                      Image.asset(iconAsset, width: 24, height: 24),
                    const SizedBox(width: AppSpacing.md),
                    Text(
                      label,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
        ),
      ),
    );
  }
}
