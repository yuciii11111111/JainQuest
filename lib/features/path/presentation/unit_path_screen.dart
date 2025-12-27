import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/providers/app_providers.dart';
import '../../../core/widgets/common_widgets.dart';
import '../../../core/widgets/glass_card.dart';
import '../../../core/widgets/floating_card.dart';
import '../../../core/models/lesson_models.dart';
import '../../lesson_runner/presentation/lesson_runner_screen.dart';

class UnitPathScreen extends ConsumerWidget {
  const UnitPathScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final unit = ref.watch(unit1Provider);
    final progress = ref.watch(progressProvider);
    final user = ref.watch(userProfileProvider);

    final unitProgress = progress.completedLessons.length / unit.lessons.length;

    return Scaffold(
      backgroundColor: AppColors.backgroundBase,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(AppSpacing.lg),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  GlassCard(
                    padding: EdgeInsets.zero,
                    child: IconButton(
                      icon: const Icon(Icons.arrow_back_rounded),
                      onPressed: () => Navigator.of(context).pop(),
                    ),
                  ),
                  const SizedBox(width: AppSpacing.sm),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          unit.title,
                          style: Theme.of(context).textTheme.headlineSmall,
                        ),
                        const SizedBox(height: 4),
                        AnimatedProgressBar(
                          progress: unitProgress,
                          height: 6,
                        ),
                        const SizedBox(height: 4),
                        Text(
                          '${(unitProgress * 100).round()}% • ${progress.completedLessons.length}/${unit.lessons.length} lessons',
                          style: Theme.of(context).textTheme.labelSmall,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: AppSpacing.sm),
                  HeartsPill(hearts: user.hearts),
                  const SizedBox(width: AppSpacing.sm),
                  XpPill(xp: user.totalXp),
                ],
              ),
              const SizedBox(height: AppSpacing.lg),
              FloatingCard(
                padding: const EdgeInsets.all(AppSpacing.lg),
                child: Row(
                  children: [
                    Container(
                      width: 56,
                      height: 56,
                      decoration: BoxDecoration(
                        gradient: AppGradients.primary,
                        borderRadius: BorderRadius.circular(AppRadius.small),
                        boxShadow: AppShadows.glowing,
                      ),
                      child: const Icon(Icons.spa_rounded, color: Colors.white, size: 30),
                    ),
                    const SizedBox(width: AppSpacing.md),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            unit.title,
                            style: Theme.of(context).textTheme.titleLarge,
                          ),
                          const SizedBox(height: 4),
                          Text(
                            'Learn the core principles and history',
                            style: Theme.of(context).textTheme.bodySmall,
                          ),
                          const SizedBox(height: 4),
                          Text(
                            '${unit.lessons.length} lessons',
                            style: Theme.of(context).textTheme.labelSmall,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: AppSpacing.lg),
              Text('Learning Path', style: Theme.of(context).textTheme.headlineSmall),
              const SizedBox(height: AppSpacing.md),
              Column(
                children: [
                  for (var i = 0; i < unit.lessons.length; i++) ...[
                    _PathStep(
                      lesson: unit.lessons[i],
                      index: i,
                      isCompleted: progress.isLessonCompleted(unit.lessons[i].lessonId),
                      isCurrent: progress.isLessonUnlocked(unit.lessons[i].lessonId) &&
                          !progress.isLessonCompleted(unit.lessons[i].lessonId),
                      onTap: progress.isLessonUnlocked(unit.lessons[i].lessonId)
                          ? () {
                              ref.read(lessonRunnerProvider.notifier).startLesson(unit.lessons[i]);
                              Navigator.of(context).push(
                                MaterialPageRoute(builder: (_) => const LessonRunnerScreen()),
                              );
                            }
                          : null,
                    ),
                    if (i != unit.lessons.length - 1)
                      Container(
                        width: 2,
                        height: 32,
                        color: AppColors.backgroundElevated,
                        margin: const EdgeInsets.symmetric(vertical: AppSpacing.sm),
                      ),
                  ],
                ],
              ),
              const SizedBox(height: AppSpacing.lg),
              _BossCheckpoint(isUnlocked: progress.completedLessons.length >= unit.lessons.length),
              const SizedBox(height: AppSpacing.xl),
            ],
          ),
        ),
      ),
    );
  }
}

class _PathStep extends StatelessWidget {
  final Lesson lesson;
  final int index;
  final bool isCompleted;
  final bool isCurrent;
  final VoidCallback? onTap;

  const _PathStep({
    required this.lesson,
    required this.index,
    required this.isCompleted,
    required this.isCurrent,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    Color borderColor;
    Widget icon;

    if (isCompleted) {
      borderColor = AppColors.success;
      icon = const Icon(Icons.check_rounded, color: Colors.white);
    } else if (isCurrent) {
      borderColor = AppColors.primary;
      icon = const Icon(Icons.play_arrow_rounded, color: Colors.white);
    } else {
      borderColor = AppColors.textMuted;
      icon = const Icon(Icons.lock_rounded, color: Colors.white70);
    }

    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          Container(
            width: 64,
            height: 64,
            decoration: BoxDecoration(
              gradient: isCompleted || isCurrent ? AppGradients.primary : null,
              color: isCompleted || isCurrent ? null : AppColors.backgroundElevated,
              shape: BoxShape.circle,
              border: Border.all(color: borderColor, width: 3),
              boxShadow: isCurrent ? AppShadows.glowing : null,
            ),
            child: Center(child: icon),
          ),
          const SizedBox(height: AppSpacing.sm),
          Text(
            lesson.title,
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  color: isCompleted || isCurrent ? AppColors.textPrimary : AppColors.textSecondary,
                ),
          ),
        ],
      ),
    );
  }
}

class _BossCheckpoint extends StatelessWidget {
  final bool isUnlocked;

  const _BossCheckpoint({required this.isUnlocked});

  @override
  Widget build(BuildContext context) {
    return GlassCard(
      padding: const EdgeInsets.all(AppSpacing.lg),
      borderColor: isUnlocked ? AppColors.warning : AppColors.glassBorder,
      borderWidth: isUnlocked ? 2 : 1,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 64,
            height: 64,
            decoration: BoxDecoration(
              gradient: isUnlocked ? AppGradients.warm : null,
              color: isUnlocked ? null : AppColors.backgroundElevated,
              shape: BoxShape.circle,
              border: Border.all(
                color: isUnlocked ? AppColors.warning : AppColors.glassBorder,
                width: 3,
              ),
              boxShadow: isUnlocked ? AppShadows.glowing : null,
            ),
            child: Icon(
              isUnlocked ? Icons.emoji_events_rounded : Icons.lock_rounded,
              color: Colors.white,
              size: 32,
            ),
          )
              .animate(onPlay: (controller) {
                if (isUnlocked) controller.repeat();
              })
              .shimmer(
                duration: 2000.ms,
                color: AppColors.warning.withOpacity(0.5),
              ),
          const SizedBox(width: AppSpacing.md),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Boss Checkpoint',
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                      color: isUnlocked ? AppColors.warning : AppColors.textSecondary,
                    ),
              ),
              const SizedBox(height: 4),
              Text(
                isUnlocked
                    ? 'Test your mastery!'
                    : 'Complete all lessons to unlock',
                style: Theme.of(context).textTheme.bodySmall,
              ),
            ],
          ),
        ],
      ),
    );
  }
}
