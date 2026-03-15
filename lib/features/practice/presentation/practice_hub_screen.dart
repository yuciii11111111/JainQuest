import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/localization/app_strings.dart';
import '../../../core/providers/app_providers.dart';
import '../../../core/navigation/app_navigator.dart';
import '../../../core/widgets/common_widgets.dart';
import '../../../core/widgets/motion_pressable.dart';
import 'practice_session_screen.dart';

class PracticeHubScreen extends ConsumerWidget {
  const PracticeHubScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final scheme = Theme.of(context).colorScheme;
    final progress = ref.watch(progressProvider);
    final hasCompletedLessons = progress.completedLessons.isNotEmpty;

    return SafeArea(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(AppSpacing.lg),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            Text(
              context.t('practice'),
              style: Theme.of(context).textTheme.displaySmall,
            ),
            const SizedBox(height: AppSpacing.sm),
            Text(
              context.t('strengthen_knowledge'),
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: scheme.onSurfaceVariant,
                  ),
            ),
            const SizedBox(height: AppSpacing.xl),

            // Mascot
            const Center(
              child: MascotWidget(
                state: MascotState.idle,
                size: 100,
              ),
            ),
            const SizedBox(height: AppSpacing.xl),

            if (!hasCompletedLessons) ...[
              // No completed lessons message
              Container(
                padding: const EdgeInsets.all(AppSpacing.lg),
                decoration: BoxDecoration(
                  color: scheme.surface,
                  borderRadius: BorderRadius.circular(AppRadius.card),
                  border: Border.all(color: scheme.outline),
                ),
                child: Column(
                  children: [
                    Icon(
                      Icons.lock_rounded,
                      size: 48,
                      color: scheme.onSurfaceVariant,
                    ),
                    const SizedBox(height: AppSpacing.md),
                    Text(
                      context.t('complete_lessons_unlock'),
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            color: scheme.onSurfaceVariant,
                          ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: AppSpacing.sm),
                    Text(
                      context.t('practice_from_completed'),
                      style: Theme.of(context).textTheme.bodySmall,
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            ] else ...[
              // Practice modes
              _PracticeModeCard(
                icon: Icons.refresh_rounded,
                title: context.t('review'),
                description: context.t('review_desc'),
                color: AppColors.primary,
                rewards: [context.t('earn_xp'), context.t('refill_hearts')],
                onTap: () {
                  ref
                      .read(practiceProvider.notifier)
                      .startPractice(PracticeMode.review);
                  Navigator.of(context)
                      .pushUltraSmooth(const PracticeSessionScreen());
                },
              ),
              const SizedBox(height: AppSpacing.md),

              _PracticeModeCard(
                icon: Icons.gps_fixed_rounded,
                title: context.t('target_weak_spots'),
                description: context.t('weak_spots_desc'),
                color: AppColors.secondary,
                rewards: [
                  context.t('improve_accuracy'),
                  context.t('refill_hearts')
                ],
                onTap: () {
                  ref
                      .read(practiceProvider.notifier)
                      .startPractice(PracticeMode.targetWeakSpots);
                  Navigator.of(context)
                      .pushUltraSmooth(const PracticeSessionScreen());
                },
              ),
            ],

            const SizedBox(height: AppSpacing.xl),

            // Stats section
            Text(
              context.t('your_progress'),
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: AppSpacing.md),

            Row(
              children: [
                Expanded(
                  child: _StatCard(
                    icon: Icons.check_circle_rounded,
                    value: '${progress.completedLessons.length}',
                    label: context.t('lessons_completed_label'),
                    color: AppColors.success,
                  ),
                ),
                const SizedBox(width: AppSpacing.md),
                Expanded(
                  child: _StatCard(
                    icon: Icons.workspace_premium_rounded,
                    value: '${progress.earnedBadges.length}',
                    label: context.t('badges_earned'),
                    color: AppColors.secondary,
                  ),
                ),
              ],
            ),

            const SizedBox(height: AppSpacing.xl),

            // Tips
            Container(
              padding: const EdgeInsets.all(AppSpacing.lg),
              decoration: BoxDecoration(
                color: AppColors.primary.withOpacityValue(0.1),
                borderRadius: BorderRadius.circular(AppRadius.card),
              ),
              child: Row(
                children: [
                  const Icon(
                    Icons.lightbulb_rounded,
                    color: AppColors.primary,
                    size: 24,
                  ),
                  const SizedBox(width: AppSpacing.md),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          context.t('tip'),
                          style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w700,
                            color: AppColors.primary,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          context.t('practice_refills_heart'),
                          style: Theme.of(context).textTheme.bodyMedium,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _PracticeModeCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String description;
  final Color color;
  final List<String> rewards;
  final VoidCallback onTap;

  const _PracticeModeCard({
    required this.icon,
    required this.title,
    required this.description,
    required this.color,
    required this.rewards,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return MotionPressable(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(AppSpacing.lg),
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surface,
          borderRadius: BorderRadius.circular(AppRadius.card),
          border: Border.all(color: color.withOpacityValue(0.3)),
        ),
        child: Row(
          children: [
            Container(
              width: 56,
              height: 56,
              decoration: BoxDecoration(
                color: color.withOpacityValue(0.1),
                borderRadius: BorderRadius.circular(14),
              ),
              child: Icon(icon, color: color, size: 28),
            ),
            const SizedBox(width: AppSpacing.md),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    description,
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                  const SizedBox(height: AppSpacing.sm),
                  Wrap(
                    spacing: AppSpacing.sm,
                    children: rewards.map((reward) {
                      return Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: AppSpacing.sm,
                          vertical: 2,
                        ),
                        decoration: BoxDecoration(
                          color: color.withOpacityValue(0.1),
                          borderRadius: BorderRadius.circular(AppRadius.pill),
                        ),
                        child: Text(
                          reward,
                          style: TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.w600,
                            color: color,
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                ],
              ),
            ),
            Icon(
              Icons.chevron_right_rounded,
              color: Theme.of(context).colorScheme.onSurfaceVariant,
            ),
          ],
        ),
      ),
    );
  }
}

class _StatCard extends StatelessWidget {
  final IconData icon;
  final String value;
  final String label;
  final Color color;

  const _StatCard({
    required this.icon,
    required this.value,
    required this.label,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Container(
      padding: const EdgeInsets.all(AppSpacing.lg),
      decoration: BoxDecoration(
        color: scheme.surface,
        borderRadius: BorderRadius.circular(AppRadius.card),
        border: Border.all(color: scheme.outline),
      ),
      child: Column(
        children: [
          Icon(icon, color: color, size: 28),
          const SizedBox(height: AppSpacing.sm),
          Text(
            value,
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.w800,
              color: color,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: Theme.of(context).textTheme.bodySmall,
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
