import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../theme/app_theme.dart';

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
    final pillColor = color ?? AppColors.textPrimary;
    final bgColor = backgroundColor ?? AppColors.backgroundCard;

    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.md,
        vertical: AppSpacing.sm,
      ),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(AppRadius.pill),
        border: Border.all(color: AppColors.glassBorder),
        boxShadow: AppShadows.glassCard,
      ),
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
      value: '$xp XP',
      color: AppColors.achievementGold,
      backgroundColor: AppColors.backgroundCard,
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
      backgroundColor: AppColors.backgroundCard,
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
      backgroundColor: AppColors.backgroundCard,
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
      value: 'Lvl $level',
      color: AppColors.primary,
      backgroundColor: AppColors.backgroundCard,
    );
  }
}

// ============================================================================
// Animated Progress Bar
// ============================================================================

class AnimatedProgressBar extends StatelessWidget {
  final double progress;
  final double height;
  final Color? backgroundColor;
  final Color? progressColor;
  final Duration duration;

  const AnimatedProgressBar({
    super.key,
    required this.progress,
    this.height = 8,
    this.backgroundColor,
    this.progressColor,
    this.duration = const Duration(milliseconds: 300),
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      decoration: BoxDecoration(
        color: backgroundColor ?? AppColors.backgroundElevated,
        borderRadius: BorderRadius.circular(height / 2),
      ),
      child: LayoutBuilder(
        builder: (context, constraints) {
          return Stack(
            children: [
              AnimatedContainer(
                duration: duration,
                curve: Curves.easeOutCubic,
                width: constraints.maxWidth * progress.clamp(0.0, 1.0),
                height: height,
                decoration: BoxDecoration(
                  gradient: progressColor != null
                      ? null
                      : AppGradients.primary,
                  color: progressColor,
                  borderRadius: BorderRadius.circular(height / 2),
                ),
              ),
            ],
          );
        },
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
    return SizedBox(
      width: fullWidth ? double.infinity : null,
      height: 56,
      child: ElevatedButton(
        onPressed: isLoading ? null : onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primary,
          foregroundColor: Colors.white,
          disabledBackgroundColor: AppColors.primary.withOpacity(0.5),
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
    return SizedBox(
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
    Color backgroundColor;
    Color borderColor;
    Color textColor;
    IconData? trailingIcon;

    switch (state) {
      case ChoiceState.normal:
        backgroundColor = AppColors.backgroundCard;
        borderColor = AppColors.glassBorder;
        textColor = AppColors.textPrimary;
        break;
      case ChoiceState.selected:
        backgroundColor = AppColors.backgroundCard;
        borderColor = AppColors.primary;
        textColor = AppColors.textPrimary;
        break;
      case ChoiceState.correct:
        backgroundColor = AppColors.backgroundCard;
        borderColor = AppColors.success;
        textColor = AppColors.success;
        trailingIcon = Icons.check_circle_rounded;
        break;
      case ChoiceState.incorrect:
        backgroundColor = AppColors.backgroundCard;
        borderColor = AppColors.danger;
        textColor = AppColors.danger;
        trailingIcon = Icons.cancel_rounded;
        break;
    }

    return GestureDetector(
      onTap: state == ChoiceState.normal || state == ChoiceState.selected
          ? () {
              HapticFeedback.lightImpact();
              onTap?.call();
            }
          : null,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        curve: Curves.easeOutCubic,
        padding: const EdgeInsets.all(AppSpacing.md),
        decoration: BoxDecoration(
          color: backgroundColor,
          borderRadius: BorderRadius.circular(AppRadius.button),
          border: Border.all(color: borderColor, width: 2),
        ),
        child: Row(
          children: [
            Expanded(
              child: Text(
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
    return Container(
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: AppColors.backgroundCard,
        borderRadius: BorderRadius.circular(AppRadius.card),
        border: Border.all(
          color: isCorrect ? AppColors.success : AppColors.danger,
          width: 2,
        ),
        boxShadow: AppShadows.glassCard,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            children: [
              Icon(
                isCorrect ? Icons.check_circle_rounded : Icons.info_rounded,
                color: isCorrect ? AppColors.success : AppColors.danger,
                size: 24,
              ),
              const SizedBox(width: AppSpacing.sm),
              Text(
                isCorrect ? 'Correct' : 'Not quite',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                  color: isCorrect ? AppColors.success : AppColors.danger,
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.sm),
          Text(
            message,
            style: TextStyle(
              fontSize: 14,
              color: isCorrect ? AppColors.success : AppColors.danger,
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
                  backgroundColor: isCorrect ? AppColors.success : AppColors.danger,
                  foregroundColor: Colors.white,
                ),
                child: const Text('Continue'),
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
    return Container(
      padding: padding ?? const EdgeInsets.all(AppSpacing.lg),
      decoration: BoxDecoration(
        color: AppColors.backgroundCard,
        borderRadius: BorderRadius.circular(AppRadius.card),
        border: Border.all(color: AppColors.glassBorder),
        boxShadow: AppShadows.glassCard,
      ),
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
        color = AppColors.textSecondary;
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

    final isCelebrating = state == MascotState.correct || state == MascotState.complete;
    
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        gradient: isCelebrating
            ? LinearGradient(
                colors: [
                  color.withOpacity(0.3),
                  color.withOpacity(0.1),
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              )
            : null,
        color: isCelebrating ? null : color.withOpacity(0.1),
        shape: BoxShape.circle,
        border: Border.all(
          color: color.withOpacity(0.3),
          width: 2,
        ),
        boxShadow: isCelebrating
            ? [
                BoxShadow(
                  color: color.withOpacity(0.5),
                  blurRadius: 20,
                  spreadRadius: 2,
                ),
              ]
            : null,
      ),
      child: Icon(
        icon,
        size: size * 0.6,
        color: color,
      ),
    )
        .animate(target: isCelebrating ? 1 : 0)
        .scale(
          duration: 300.ms,
          begin: const Offset(1.0, 1.0),
          end: const Offset(1.2, 1.2),
        )
        .then()
        .scale(
          duration: 300.ms,
          begin: const Offset(1.2, 1.2),
          end: const Offset(1.0, 1.0),
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
    return Opacity(
      opacity: isEarned ? 1.0 : 0.3,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: size,
            height: size,
            decoration: BoxDecoration(
              gradient: isEarned ? AppGradients.accent : null,
              color: isEarned ? null : AppColors.backgroundElevated,
              shape: BoxShape.circle,
              border: Border.all(
                color: isEarned ? AppColors.secondary : AppColors.glassBorder,
                width: 3,
              ),
              boxShadow: isEarned ? AppShadows.glowing : null,
            ),
            child: Icon(
              Icons.workspace_premium_rounded,
              size: size * 0.5,
              color: isEarned ? AppColors.secondary : AppColors.textSecondary,
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
                color: isEarned ? AppColors.textPrimary : AppColors.textSecondary,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
