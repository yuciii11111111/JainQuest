import 'package:flutter/material.dart';
import 'package:share_plus/share_plus.dart';
import '../../../../core/gamification/gamification_service.dart';
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
  final LessonCompletionSummary summary;
  final String? badgeEarned;
  final int streak;
  final VoidCallback onContinue;

  const LessonCompleteScreenWidget({
    super.key,
    required this.screen,
    required this.summary,
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
    final displayedXp = widget.summary.totalXp;
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
                    const SizedBox(height: AppSpacing.lg),
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(AppSpacing.md),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacityValue(0.06),
                        borderRadius: BorderRadius.circular(AppRadius.card),
                        border: Border.all(
                          color: Colors.white.withOpacityValue(0.08),
                        ),
                      ),
                      child: Column(
                        children: [
                          _RewardBreakdownRow(
                            label: context.t('answer_xp'),
                            amount: widget.summary.answerXp,
                          ),
                          if (widget.summary.awardedPerfectBonus) ...[
                            const SizedBox(height: AppSpacing.sm),
                            _RewardBreakdownRow(
                              label: context.t('perfect_score_bonus'),
                              amount: widget.summary.perfectBonusXp,
                              highlight: AppColors.success,
                            ),
                          ],
                          if (widget.summary.awardedFirstCompletionBonus) ...[
                            const SizedBox(height: AppSpacing.sm),
                            _RewardBreakdownRow(
                              label: context.t('first_completion_bonus'),
                              amount: widget.summary.firstCompletionBonusXp,
                              highlight: AppColors.secondary,
                            ),
                          ],
                          const Padding(
                            padding: EdgeInsets.symmetric(
                              vertical: AppSpacing.sm,
                            ),
                            child: Divider(height: 1),
                          ),
                          _RewardBreakdownRow(
                            label: context.t('session_total_xp'),
                            amount: widget.summary.totalXp,
                            emphasize: true,
                          ),
                        ],
                      ),
                    ),
                    if (widget.summary.awardedPerfectBonus) ...[
                      const SizedBox(height: AppSpacing.md),
                      _BonusChip(
                        icon: Icons.emoji_events_rounded,
                        label: context.t('perfect_score_bonus'),
                        color: AppColors.success,
                      ),
                    ],
                    if (widget.summary.awardedFirstCompletionBonus) ...[
                      const SizedBox(height: AppSpacing.sm),
                      _BonusChip(
                        icon: Icons.rocket_launch_rounded,
                        label: context.t('first_completion_bonus'),
                        color: AppColors.secondary,
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
                  SharePlus.instance.share(
                    ShareParams(
                      text: context.t(
                        'share_msg',
                        args: {'xp': widget.summary.totalXp.toString()},
                      ),
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

class _RewardBreakdownRow extends StatelessWidget {
  const _RewardBreakdownRow({
    required this.label,
    required this.amount,
    this.highlight,
    this.emphasize = false,
  });

  final String label;
  final int amount;
  final Color? highlight;
  final bool emphasize;

  @override
  Widget build(BuildContext context) {
    final color = highlight ?? Theme.of(context).colorScheme.onSurface;
    final textStyle = emphasize
        ? Theme.of(context).textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w800,
              color: color,
            )
        : Theme.of(context).textTheme.bodyLarge?.copyWith(
              fontWeight: FontWeight.w700,
              color: color,
            );

    return Row(
      children: [
        Expanded(
          child: Text(
            label,
            style: textStyle,
          ),
        ),
        Text(
          '+$amount XP',
          style: textStyle,
        ),
      ],
    );
  }
}

class _BonusChip extends StatelessWidget {
  const _BonusChip({
    required this.icon,
    required this.label,
    required this.color,
  });

  final IconData icon;
  final String label;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.md,
        vertical: AppSpacing.sm,
      ),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(AppRadius.pill),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            icon,
            size: 20,
            color: Colors.white,
          ),
          const SizedBox(width: AppSpacing.xs),
          Text(
            label,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w700,
              color: Colors.white,
            ),
          ),
        ],
      ),
    );
  }
}
