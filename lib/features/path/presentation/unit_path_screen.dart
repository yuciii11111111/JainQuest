import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/theme/app_motion.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/localization/app_strings.dart';
import '../../../core/providers/app_providers.dart';
import '../../../core/widgets/common_widgets.dart';
import '../../../core/widgets/progress_ring.dart';
import '../../../core/widgets/glass_card.dart';
import '../../../core/widgets/floating_card.dart';
import '../../../core/models/lesson_models.dart';
import '../../../core/guide/guide_keys.dart';
import '../../../core/navigation/app_navigator.dart';
import '../../../core/widgets/tr_text.dart';
import '../../lesson_runner/presentation/lesson_runner_screen.dart';
import '../../../core/widgets/motion_pressable.dart';

class UnitPathScreen extends ConsumerStatefulWidget {
  const UnitPathScreen({super.key});

  @override
  ConsumerState<UnitPathScreen> createState() => _UnitPathScreenState();
}

class _UnitPathScreenState extends ConsumerState<UnitPathScreen> {
  bool _didAutoScroll = false;

  @override
  Widget build(BuildContext context) {
    final ref = this.ref;
    final unit = ref.watch(unit1Provider);
    final progress = ref.watch(progressProvider);
    final user = ref.watch(userProfileProvider);

    final unitProgress = progress.completedLessons.length / unit.lessons.length;

    if (user.showGuidedTour && !_didAutoScroll) {
      _didAutoScroll = true;
      WidgetsBinding.instance.addPostFrameCallback((_) {
        final targetContext = GuideKeys.whatIsJainismLesson.currentContext;
        if (targetContext != null && mounted) {
          Scrollable.ensureVisible(
            targetContext,
            duration: AppMotion.screenEnter,
            curve: AppMotion.enterCurve,
            alignment: 0.35,
          );
        }
      });
    }

    return Scaffold(
      backgroundColor: Colors.transparent,
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
                    child: MotionPressable(
                      child: IconButton(
                        icon: const Icon(Icons.arrow_back_rounded),
                        onPressed: () => Navigator.of(context).pop(),
                      ),
                    ),
                  ),
                  const SizedBox(width: AppSpacing.sm),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        TrText(
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
                          '${(unitProgress * 100).round()}% - ${progress.completedLessons.length}/${unit.lessons.length} ${context.t('lessons_plural')}',
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
                        color: AppColors.primary,
                        borderRadius: BorderRadius.circular(AppRadius.small),
                      ),
                      child: const Icon(Icons.spa_rounded,
                          color: Colors.white, size: 30),
                    ),
                    const SizedBox(width: AppSpacing.md),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          TrText(
                            unit.title,
                            style: Theme.of(context).textTheme.titleLarge,
                          ),
                          const SizedBox(height: 4),
                          Text(
                            context.t('core_principles'),
                            style: Theme.of(context).textTheme.bodySmall,
                          ),
                          const SizedBox(height: 4),
                          Text(
                            '${unit.lessons.length} ${context.t('lessons_plural')}',
                            style: Theme.of(context).textTheme.labelSmall,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: AppSpacing.lg),
              Text(context.t('learning_path'),
                  style: Theme.of(context).textTheme.headlineSmall),
              const SizedBox(height: AppSpacing.md),
              Column(
                children: [
                  for (var i = 0; i < unit.lessons.length; i++) ...[
                    _PathStep(
                      key: i == 0 ? GuideKeys.firstPathStep : null,
                      lessonTitleKey:
                          i == 0 ? GuideKeys.whatIsJainismLesson : null,
                      lesson: unit.lessons[i],
                      index: i,
                      alignLeft: i.isEven,
                      isCompleted:
                          progress.isLessonCompleted(unit.lessons[i].lessonId),
                      isCurrent: progress
                              .isLessonUnlocked(unit.lessons[i].lessonId) &&
                          !progress.isLessonCompleted(unit.lessons[i].lessonId),
                      onTap: progress.isLessonUnlocked(unit.lessons[i].lessonId)
                          ? () {
                              ref
                                  .read(lessonRunnerProvider.notifier)
                                  .startLesson(unit.lessons[i]);
                              Navigator.of(context)
                                  .pushUltraSmooth(const LessonRunnerScreen());
                            }
                          : null,
                    ),
                    if (i != unit.lessons.length - 1)
                      _PathConnector(
                        alignLeft: i.isEven,
                        nextAlignLeft: (i + 1).isEven,
                      ),
                  ],
                ],
              ),
              const SizedBox(height: AppSpacing.lg),
              _BossCheckpoint(
                  isUnlocked:
                      progress.completedLessons.length >= unit.lessons.length),
              const SizedBox(height: AppSpacing.xl),
            ],
          ),
        ),
      ),
    );
  }
}

class _PathStep extends StatelessWidget {
  final Key? lessonTitleKey;
  final Lesson lesson;
  final int index;
  final bool isCompleted;
  final bool isCurrent;
  final bool alignLeft;
  final VoidCallback? onTap;

  const _PathStep({
    super.key,
    this.lessonTitleKey,
    required this.lesson,
    required this.index,
    required this.isCompleted,
    required this.isCurrent,
    required this.alignLeft,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    const double ringSize = 84;
    const double nodeSize = 60;
    const double horizontalInset = 12;
    final scheme = Theme.of(context).colorScheme;
    final isLocked = !isCompleted && !isCurrent;

    final Color ringColor = isCompleted
        ? AppColors.success
        : isCurrent
            ? AppColors.primary
            : scheme.outline;

    final IconData icon = _PathIcons.forIndex(index, isLocked: isLocked);

    final Widget node = ProgressRing(
      progress: isCompleted ? 1.0 : 0.0,
      size: ringSize,
      strokeWidth: 8,
      color: ringColor,
      backgroundColor: scheme.surfaceContainerHighest.withOpacityValue(0.6),
      child: Container(
        width: nodeSize,
        height: nodeSize,
        decoration: BoxDecoration(
          color: isLocked ? scheme.surfaceContainerHighest : ringColor,
          shape: BoxShape.circle,
          boxShadow: [
            BoxShadow(
              color: ringColor.withOpacityValue(isLocked ? 0.2 : 0.35),
              blurRadius: 12,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        child: Icon(
          icon,
          color: isLocked ? scheme.onSurfaceVariant : Colors.white,
          size: 28,
        ),
      ),
    );

    return MotionPressable(
      onTap: onTap,
      enabled: onTap != null,
      child: SizedBox(
        width: double.infinity,
        child: Column(
          crossAxisAlignment:
              alignLeft ? CrossAxisAlignment.start : CrossAxisAlignment.end,
          children: [
            Row(
              children: [
                if (!alignLeft) const Expanded(child: SizedBox()),
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: horizontalInset),
                  child: node,
                ),
                if (alignLeft) const Expanded(child: SizedBox()),
              ],
            ),
            const SizedBox(height: AppSpacing.sm),
            SizedBox(
              key: lessonTitleKey,
              width: 180,
              child: TrText(
                lesson.title,
                textAlign: alignLeft ? TextAlign.left : TextAlign.right,
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      color:
                          isLocked ? scheme.onSurfaceVariant : scheme.onSurface,
                    ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _PathConnector extends StatelessWidget {
  final bool alignLeft;
  final bool nextAlignLeft;

  const _PathConnector({
    required this.alignLeft,
    required this.nextAlignLeft,
  });

  @override
  Widget build(BuildContext context) {
    const double height = 52;
    return SizedBox(
      width: double.infinity,
      height: height,
      child: CustomPaint(
        painter: _PathConnectorPainter(
          alignLeft: alignLeft,
          nextAlignLeft: nextAlignLeft,
          color: Theme.of(context).colorScheme.outline.withOpacityValue(0.5),
        ),
      ),
    );
  }
}

class _PathConnectorPainter extends CustomPainter {
  final bool alignLeft;
  final bool nextAlignLeft;
  final Color color;

  _PathConnectorPainter({
    required this.alignLeft,
    required this.nextAlignLeft,
    required this.color,
  });

  @override
  void paint(Canvas canvas, Size size) {
    const double ringSize = 84;
    const double horizontalInset = 12;
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = 6
      ..strokeCap = StrokeCap.round;

    final startX = alignLeft
        ? horizontalInset + ringSize / 2
        : size.width - horizontalInset - ringSize / 2;
    final endX = nextAlignLeft
        ? horizontalInset + ringSize / 2
        : size.width - horizontalInset - ringSize / 2;

    final path = Path()
      ..moveTo(startX, 0)
      ..cubicTo(
        startX,
        size.height * 0.45,
        endX,
        size.height * 0.55,
        endX,
        size.height,
      );

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant _PathConnectorPainter oldDelegate) {
    return oldDelegate.alignLeft != alignLeft ||
        oldDelegate.nextAlignLeft != nextAlignLeft ||
        oldDelegate.color != color;
  }
}

class _PathIcons {
  static const List<IconData> _icons = [
    Icons.star_rounded,
    Icons.mic_rounded,
    Icons.videocam_rounded,
    Icons.auto_awesome_rounded,
    Icons.menu_book_rounded,
    Icons.emoji_events_rounded,
  ];

  static IconData forIndex(int index, {required bool isLocked}) {
    if (isLocked) {
      return Icons.lock_rounded;
    }
    return _icons[index % _icons.length];
  }
}

class _BossCheckpoint extends StatelessWidget {
  final bool isUnlocked;

  const _BossCheckpoint({required this.isUnlocked});

  @override
  Widget build(BuildContext context) {
    return GlassCard(
      padding: const EdgeInsets.all(AppSpacing.lg),
      borderColor: isUnlocked
          ? AppColors.warning
          : Theme.of(context).colorScheme.outline,
      borderWidth: isUnlocked ? 2 : 1,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 64,
            height: 64,
            decoration: BoxDecoration(
              color: isUnlocked
                  ? AppColors.warning
                  : Theme.of(context).colorScheme.surfaceContainerHighest,
              shape: BoxShape.circle,
              border: Border.all(
                color: isUnlocked
                    ? AppColors.warning
                    : Theme.of(context).colorScheme.outline,
                width: 3,
              ),
            ),
            child: Icon(
              isUnlocked ? Icons.emoji_events_rounded : Icons.lock_rounded,
              color: Colors.white,
              size: 32,
            ),
          ),
          const SizedBox(width: AppSpacing.md),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                context.t('boss_checkpoint'),
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                      color: isUnlocked
                          ? AppColors.warning
                          : Theme.of(context).colorScheme.onSurfaceVariant,
                    ),
              ),
              const SizedBox(height: 4),
              Text(
                isUnlocked
                    ? context.t('test_mastery')
                    : context.t('complete_to_unlock'),
                style: Theme.of(context).textTheme.bodySmall,
              ),
            ],
          ),
        ],
      ),
    );
  }
}
