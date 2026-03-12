import 'package:flutter/material.dart';
import 'package:share_plus/share_plus.dart';
import '../../../../core/localization/app_strings.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/models/lesson_models.dart';
import '../../../../core/widgets/common_widgets.dart';
import '../../../../core/widgets/gradient_button.dart';
import '../../../../core/widgets/floating_card.dart';
import '../../../../core/guide/guide_keys.dart';
import '../../../../core/widgets/tr_text.dart';

class LessonCompleteScreenWidget extends StatefulWidget {
  final LessonCompleteScreen screen;
  final int xpEarned;
  final bool isPerfect;
  final String? badgeEarned;
  final int streak;
  final VoidCallback onContinue;

  const LessonCompleteScreenWidget({
    super.key,
    required this.screen,
    required this.xpEarned,
    required this.isPerfect,
    this.badgeEarned,
    required this.streak,
    required this.onContinue,
  });

  @override
  State<LessonCompleteScreenWidget> createState() =>
      _LessonCompleteScreenWidgetState();
}

class _LessonCompleteScreenWidgetState
    extends State<LessonCompleteScreenWidget> {
  @override
  Widget build(BuildContext context) {
    final displayedXp = widget.xpEarned;
    return Stack(
      children: [
        // Content
        SingleChildScrollView(
          padding: const EdgeInsets.all(AppSpacing.lg),
          child: Column(
            children: [
              const SizedBox(height: AppSpacing.xl),

              // Mascot celebration
              const MascotWidget(
                state: MascotState.complete,
                size: 120,
              ),

              const SizedBox(height: AppSpacing.xl),

              // Title
              TrText(
                widget.screen.title,
                style: Theme.of(context).textTheme.displaySmall?.copyWith(
                      color: AppColors.success,
                      fontWeight: FontWeight.w900,
                    ),
                textAlign: TextAlign.center,
              ),

              const SizedBox(height: AppSpacing.lg),

              // XP Earned Card
              FloatingCard(
                padding: const EdgeInsets.all(AppSpacing.lg),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(
                          Icons.star_rounded,
                          size: 40,
                          color: AppColors.achievementGold,
                        ),
                        const SizedBox(width: AppSpacing.sm),
                        Text(
                          '+$displayedXp XP',
                          style: Theme.of(context)
                              .textTheme
                              .displayMedium
                              ?.copyWith(
                                color: AppColors.warning,
                                fontWeight: FontWeight.w900,
                              ),
                        ),
                      ],
                    ),
                    if (widget.isPerfect) ...[
                      const SizedBox(height: AppSpacing.md),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: AppSpacing.md,
                          vertical: AppSpacing.sm,
                        ),
                        decoration: BoxDecoration(
                          color: AppColors.success,
                          borderRadius: BorderRadius.circular(AppRadius.pill),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Icon(
                              Icons.emoji_events_rounded,
                              size: 20,
                              color: Colors.white,
                            ),
                            const SizedBox(width: AppSpacing.xs),
                            Text(
                              context.t('perfect_score_bonus'),
                              style: const TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w700,
                                color: Colors.white,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ],
                ),
              ),

              const SizedBox(height: AppSpacing.lg),

              // Badge Earned
              if (widget.badgeEarned != null)
                FloatingCard(
                  padding: const EdgeInsets.all(AppSpacing.lg),
                  child: Column(
                    children: [
                      Container(
                        width: 80,
                        height: 80,
                        decoration: BoxDecoration(
                          color: AppColors.secondary,
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: AppColors.secondary,
                            width: 4,
                          ),
                        ),
                        child: const Icon(
                          Icons.workspace_premium_rounded,
                          size: 48,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(height: AppSpacing.md),
                      Text(
                        context.t('badge_earned'),
                        style: Theme.of(context).textTheme.titleLarge?.copyWith(
                              color: AppColors.secondary,
                              fontWeight: FontWeight.w700,
                            ),
                      ),
                      const SizedBox(height: AppSpacing.xs),
                      TrText(
                        widget.screen.rewardText,
                        style: Theme.of(context).textTheme.bodyMedium,
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),

              // Streak Update
              if (widget.streak > 0)
                Padding(
                  padding: const EdgeInsets.only(top: AppSpacing.lg),
                  child: FloatingCard(
                    padding: const EdgeInsets.all(AppSpacing.md),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(
                          Icons.local_fire_department_rounded,
                          color: AppColors.warning,
                          size: 32,
                        ),
                        const SizedBox(width: AppSpacing.sm),
                        Text(
                          context.t(
                            'day_streak',
                            args: {'count': widget.streak.toString()},
                          ),
                          style:
                              Theme.of(context).textTheme.titleLarge?.copyWith(
                                    color: AppColors.warning,
                                    fontWeight: FontWeight.w800,
                                  ),
                        ),
                      ],
                    ),
                  ),
                ),

              const SizedBox(height: AppSpacing.xl),

              // Continue Button
              GradientButton(
                key: GuideKeys.lessonCompleteContinueButton,
                label: context.t('continue'),
                icon: Icons.arrow_forward_rounded,
                onPressed: widget.onContinue,
                width: double.infinity,
              ),

              const SizedBox(height: AppSpacing.md),

              // Share Button
              GradientButton(
                label: context.t('share_achievement'),
                icon: Icons.share_rounded,
                onPressed: () {
                  Share.share(
                    context.t(
                      'share_msg',
                      args: {'xp': widget.xpEarned.toString()},
                    ),
                  );
                },
                width: double.infinity,
              ),

              const SizedBox(height: AppSpacing.xl),
            ],
          ),
        ),
      ],
    );
  }
}
