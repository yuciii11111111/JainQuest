import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:jainquest/features/lesson_runner/presentation/lesson_runner_screen.dart';
import 'package:tutorial_coach_mark/tutorial_coach_mark.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/providers/app_providers.dart';
import '../../../core/widgets/common_widgets.dart';
import '../../../core/widgets/gradient_button.dart';
import '../../../core/widgets/progress_ring.dart';
import '../../../core/widgets/floating_card.dart';
import '../../../core/gamification/gamification_constants.dart';
import '../../../core/providers/theme_provider.dart';
import '../../../core/models/user_models.dart';
import '../../../core/models/lesson_models.dart';
import '../../../core/guide/guide_keys.dart';
import '../../path/presentation/unit_path_screen.dart';
import '../../profile/presentation/profile_screen.dart' show ProfileScreen;
import '../../guru/presentation/guru_screen.dart';
import '../../settings/presentation/settings_screen.dart';
import '../../resources/presentation/resources_screen.dart';
import '../../forum/presentation/forum_screen.dart';

class HomeScreen extends ConsumerStatefulWidget {
  final bool showTutorialOnLoad;

  const HomeScreen({
    super.key,
    this.showTutorialOnLoad = false,
  });

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  int _currentIndex = 0;
  final GlobalKey _continueLearningKey = GuideKeys.continueLearningButton;
  final GlobalKey _currentLessonKey = GuideKeys.currentLessonCard;
  final GlobalKey _statsKey = GlobalKey();
  final GlobalKey _askNavKey = GlobalKey();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (widget.showTutorialOnLoad) {
        _showTutorial();
      }
    });
  }

  void _showTutorial() {
    // Basic check to not show every time would go here (StorageService)
    // For this task, we show it to verify the refactor.

    final targets = [
      TargetFocus(
        identify: "stats",
        keyTarget: _statsKey,
        alignSkip: Alignment.bottomRight,
        contents: [
          TargetContent(
            align: ContentAlign.bottom,
            builder: (context, controller) {
              return _GuideBubble(
                title: "Track Your Progress",
                description:
                    "Keep an eye on your streaks, hearts, and XP here. Consistency is key!",
                onNext: controller.next,
              );
            },
          ),
        ],
      ),
      TargetFocus(
        identify: "current_lesson",
        keyTarget: _currentLessonKey,
        alignSkip: Alignment.bottomRight,
        contents: [
          TargetContent(
            align: ContentAlign.top,
            builder: (context, controller) {
              return _GuideBubble(
                title: "Next Up",
                description:
                    "This is your next lesson. Tap to continue your journey!",
                onNext: controller.next,
              );
            },
          ),
        ],
      ),
      TargetFocus(
        identify: "ask_guru",
        keyTarget: _askNavKey,
        alignSkip: Alignment.topRight,
        contents: [
          TargetContent(
            align: ContentAlign.top,
            builder: (context, controller) {
              return _GuideBubble(
                title: "Ask Guru",
                description:
                    "Stuck? Have a question about Jainism? Tap here to ask our AI guide.",
                onNext: controller.next,
                isLast: true,
              );
            },
          ),
        ],
      ),
    ];

    TutorialCoachMark(
      targets: targets,
      colorShadow: Colors.black,
      textSkip: "SKIP",
      paddingFocus: 10,
      opacityShadow: 0.8,
      onFinish: () {
        print("Tutorial finished");
      },
      onClickTarget: (target) {
        print('onClickTarget: $target');
      },
      onClickTargetWithTapPosition: (target, tapDetails) {
        print("target: $target");
        print(
            "clicked at position local: ${tapDetails.localPosition} - global: ${tapDetails.globalPosition}");
      },
      onClickOverlay: (target) {
        print('onClickOverlay: $target');
      },
      onSkip: () {
        print("skip");
        return true;
      },
    ).show(context: context);
  }

  @override
  Widget build(BuildContext context) {
    final user = ref.watch(userProfileProvider);
    final progress = ref.watch(progressProvider);
    final unit = ref.watch(unit1Provider);
    final themeMode = ref.watch(themeModeProvider);
    final toggleTheme = ref.read(themeModeProvider.notifier).toggleTheme;

    return Scaffold(
      backgroundColor: Colors.transparent,
      body: IndexedStack(
        index: _currentIndex,
        children: [
          _HomeTab(
            user: user,
            progress: progress,
            unit: unit,
            themeMode: themeMode,
            onToggleTheme: toggleTheme,
            statsKey: _statsKey,
            continueLearningKey: _continueLearningKey,
            currentLessonKey: _currentLessonKey,
            onShowGuide: _showTutorial,
            onLessonTap: (lesson) {
              ref.read(lessonRunnerProvider.notifier).startLesson(lesson);
              Navigator.of(context).push(
                MaterialPageRoute(builder: (_) => const LessonRunnerScreen()),
              );
            },
          ),
          const ResourcesScreen(),
          const GuruScreen(),
          const ForumScreen(),
          const ProfileScreen(),
        ],
      ),
      bottomNavigationBar: _GlassBottomNav(
        currentIndex: _currentIndex,
        askKey: _askNavKey,
        onTap: (index) => setState(() => _currentIndex = index),
      ),
    );
  }
}

class _GlassBottomNav extends StatelessWidget {
  final int currentIndex;
  final Key? askKey;
  final ValueChanged<int> onTap;

  const _GlassBottomNav({
    required this.currentIndex,
    this.askKey,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Container(
      padding: const EdgeInsets.symmetric(vertical: AppSpacing.sm),
      decoration: BoxDecoration(
        color: scheme.surface,
        border: Border(
          top: BorderSide(color: scheme.outline, width: 1),
        ),
      ),
      child: SafeArea(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            _NavItem(
              icon: Icons.home_rounded,
              label: 'Home',
              isSelected: currentIndex == 0,
              onTap: () => onTap(0),
            ),
            _NavItem(
              icon: Icons.auto_awesome_rounded,
              label: 'Resources',
              isSelected: currentIndex == 1,
              onTap: () => onTap(1),
            ),
            _NavItem(
              key: askKey,
              imageAsset: 'assets/images/duo_guide.png',
              label: 'Ask',
              isSelected: currentIndex == 2,
              onTap: () => onTap(2),
            ),
            _NavItem(
              icon: Icons.forum_rounded,
              label: 'Community',
              isSelected: currentIndex == 3,
              onTap: () => onTap(3),
            ),
            _NavItem(
              icon: Icons.person_rounded,
              label: 'Profile',
              isSelected: currentIndex == 4,
              onTap: () => onTap(4),
            ),
          ],
        ),
      ),
    );
  }
}

class _NavItem extends StatelessWidget {
  final IconData? icon;
  final String? imageAsset;
  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  const _NavItem({
    super.key,
    this.icon,
    this.imageAsset,
    required this.label,
    required this.isSelected,
    required this.onTap,
  }) : assert(icon != null || imageAsset != null);

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.md,
          vertical: AppSpacing.xs,
        ),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.primary : Colors.transparent,
          borderRadius: BorderRadius.circular(AppRadius.pill),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (imageAsset != null)
              Image.asset(
                imageAsset!,
                width: 24,
                height: 24,
              )
            else
              Icon(
                icon,
                size: 24,
                color: isSelected ? Colors.white : scheme.onSurfaceVariant,
              ),
            const SizedBox(height: 4),
            Text(
              label,
              style: TextStyle(
                fontSize: 11,
                fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                color: isSelected ? Colors.white : scheme.onSurfaceVariant,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _HomeTab extends StatelessWidget {
  final UserProfile user;
  final ProgressState progress;
  final Unit unit;
  final ThemeMode themeMode;
  final VoidCallback onToggleTheme;
  final Key? statsKey;
  final GlobalKey continueLearningKey;
  final GlobalKey currentLessonKey;
  final VoidCallback onShowGuide;
  final ValueChanged<Lesson> onLessonTap;

  const _HomeTab({
    required this.user,
    required this.progress,
    required this.unit,
    required this.themeMode,
    required this.onToggleTheme,
    this.statsKey,
    required this.continueLearningKey,
    required this.currentLessonKey,
    required this.onShowGuide,
    required this.onLessonTap,
  });

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final List<Lesson> lessons = unit.lessons;
    final Lesson currentLesson = lessons.firstWhere(
      (lesson) =>
          progress.isLessonUnlocked(lesson.lessonId) &&
          !progress.isLessonCompleted(lesson.lessonId),
      orElse: () => lessons.first,
    );

    return SafeArea(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(AppSpacing.lg),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        const Icon(Icons.auto_awesome_rounded,
                            color: AppColors.secondary, size: 22),
                        const SizedBox(width: AppSpacing.xs),
                        Text(
                          'JainQuest',
                          style: Theme.of(context)
                              .textTheme
                              .titleLarge
                              ?.copyWith(fontWeight: FontWeight.w800),
                        ),
                      ],
                    ),
                    Text(
                      'Level ${user.level} - ${LevelSystem.getLevelTitle(user.level)}',
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                  ],
                ),
                const Spacer(),
                IconButton(
                  icon: const Icon(Icons.help_outline_rounded),
                  onPressed: onShowGuide,
                  color: scheme.onSurfaceVariant,
                  tooltip: 'Show Guide',
                ),
                IconButton(
                  icon: const Icon(Icons.notifications_rounded),
                  onPressed: () {},
                  color: scheme.onSurfaceVariant,
                ),
                IconButton(
                  icon: Icon(
                    themeMode == ThemeMode.dark
                        ? Icons.wb_sunny_rounded
                        : Icons.dark_mode_rounded,
                  ),
                  onPressed: onToggleTheme,
                  color: scheme.onSurfaceVariant,
                ),
                IconButton(
                  icon: const Icon(Icons.settings_rounded),
                  onPressed: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(builder: (_) => const SettingsScreen()),
                    );
                  },
                  color: scheme.onSurfaceVariant,
                ),
              ],
            ),
            const SizedBox(height: AppSpacing.md),
            FloatingCard(
              padding: const EdgeInsets.all(AppSpacing.lg),
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Welcome back,',
                          style: Theme.of(context).textTheme.bodySmall,
                        ),
                        Text(
                          user.displayName ?? 'Explorer',
                          style: Theme.of(context)
                              .textTheme
                              .headlineMedium
                              ?.copyWith(fontWeight: FontWeight.w900),
                        ),
                        const SizedBox(height: AppSpacing.xs),
                        Text(
                          'Level ${user.level} - ${LevelSystem.getLevelTitle(user.level)}',
                          style: Theme.of(context)
                              .textTheme
                              .bodySmall
                              ?.copyWith(color: AppColors.secondary),
                        ),
                        const SizedBox(height: AppSpacing.sm),
                        AnimatedProgressBar(
                          progress: LevelSystem.getLevelProgress(
                              user.level, user.totalXp),
                          height: 6,
                        ),
                        const SizedBox(height: AppSpacing.xs),
                        Text(
                          '${(LevelSystem.getLevelProgress(user.level, user.totalXp) * 100).round()}% progress',
                          style: Theme.of(context).textTheme.labelSmall,
                        ),
                      ],
                    ),
                  ),
                  ProgressRing(
                    progress:
                        LevelSystem.getLevelProgress(user.level, user.totalXp),
                    size: 72,
                    strokeWidth: 8,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          '${user.totalXp}',
                          style: Theme.of(context)
                              .textTheme
                              .titleLarge
                              ?.copyWith(fontWeight: FontWeight.w900),
                        ),
                        Text('XP',
                            style: Theme.of(context).textTheme.labelSmall),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: AppSpacing.md),
            Row(
              key: statsKey,
              children: [
                Expanded(
                  child: FloatingCard(
                    padding: const EdgeInsets.all(AppSpacing.md),
                    child: Column(
                      children: [
                        const Icon(Icons.local_fire_department_rounded,
                            color: AppColors.warning, size: 28),
                        const SizedBox(height: AppSpacing.xs),
                        Text('${user.currentStreak}',
                            style: Theme.of(context).textTheme.titleLarge),
                        Text('day streak',
                            style: Theme.of(context).textTheme.labelSmall),
                      ],
                    ),
                  ),
                ),
                const SizedBox(width: AppSpacing.md),
                Expanded(
                  child: FloatingCard(
                    padding: const EdgeInsets.all(AppSpacing.md),
                    child: Column(
                      children: [
                        const Icon(Icons.favorite_rounded,
                            color: AppColors.danger, size: 28),
                        const SizedBox(height: AppSpacing.xs),
                        Text('${user.hearts}',
                            style: Theme.of(context).textTheme.titleLarge),
                        Text('hearts',
                            style: Theme.of(context).textTheme.labelSmall),
                      ],
                    ),
                  ),
                ),
                const SizedBox(width: AppSpacing.md),
                Expanded(
                  child: FloatingCard(
                    padding: const EdgeInsets.all(AppSpacing.md),
                    child: Column(
                      children: [
                        const Icon(Icons.star_rounded,
                            color: AppColors.achievementGold, size: 28),
                        const SizedBox(height: AppSpacing.xs),
                        Text('${user.totalXp}',
                            style: Theme.of(context).textTheme.titleLarge),
                        Text('XP',
                            style: Theme.of(context).textTheme.labelSmall),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: AppSpacing.md),
            FloatingCard(
              padding: const EdgeInsets.all(AppSpacing.lg),
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Daily Goal',
                            style: Theme.of(context).textTheme.titleMedium),
                        const SizedBox(height: AppSpacing.xs),
                        Text(
                          '${progress.completedLessons.length}/3 lessons completed',
                          style: Theme.of(context).textTheme.bodySmall,
                        ),
                      ],
                    ),
                  ),
                  Row(
                    children: List.generate(
                      3,
                      (index) => Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 3),
                        child: Icon(
                          Icons.circle,
                          size: 12,
                          color: index < progress.completedLessons.length
                              ? AppColors.primary
                              : scheme.onSurfaceVariant.withOpacityValue(0.5),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: AppSpacing.md),
            GradientButton(
              key: continueLearningKey,
              label: 'Continue Learning',
              icon: Icons.play_arrow_rounded,
              onPressed: () {
                Navigator.of(context).push(
                  MaterialPageRoute(builder: (_) => const UnitPathScreen()),
                );
              },
              width: double.infinity,
            ),
            const SizedBox(height: AppSpacing.md),
            FloatingCard(
              key: currentLessonKey,
              onTap: () {
                Navigator.of(context).push(
                  MaterialPageRoute(builder: (_) => const UnitPathScreen()),
                );
              },
              padding: const EdgeInsets.all(AppSpacing.lg),
              child: Row(
                children: [
                  Container(
                    width: 48,
                    height: 48,
                    decoration: BoxDecoration(
                      color: AppColors.primary,
                      borderRadius: BorderRadius.circular(AppRadius.small),
                    ),
                    child: const Icon(Icons.spa_rounded, color: Colors.white),
                  ),
                  const SizedBox(width: AppSpacing.md),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Current Lesson',
                          style: Theme.of(context).textTheme.labelSmall,
                        ),
                        Text(
                          currentLesson.title,
                          style: Theme.of(context).textTheme.titleLarge,
                        ),
                        const SizedBox(height: 2),
                        Text(
                          (currentLesson.learningObjectives as List).isNotEmpty
                              ? (currentLesson.learningObjectives as List).first
                              : 'Continue your learning journey',
                          style: Theme.of(context).textTheme.bodySmall,
                        ),
                      ],
                    ),
                  ),
                  Icon(
                    Icons.arrow_forward_ios_rounded,
                    size: 16,
                    color: scheme.onSurfaceVariant,
                  ),
                ],
              ),
            ),
            const SizedBox(height: AppSpacing.lg),
            Text('Your Journey',
                style: Theme.of(context).textTheme.headlineSmall),
            const SizedBox(height: AppSpacing.sm),
            _JourneyPath(
              lessons: lessons,
              progress: progress,
              onLessonTap: (lesson) {
                if (!progress.isLessonUnlocked(lesson.lessonId)) {
                  return;
                }
                onLessonTap(lesson);
              },
            ),
            const SizedBox(height: AppSpacing.xl),
          ],
        ),
      ),
    );
  }
}

class _JourneyPath extends StatelessWidget {
  final List<Lesson> lessons;
  final ProgressState progress;
  final ValueChanged<Lesson> onLessonTap;

  const _JourneyPath({
    required this.lessons,
    required this.progress,
    required this.onLessonTap,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        for (int i = 0; i < lessons.length; i++) ...[
          _JourneyNode(
            lesson: lessons[i],
            isCompleted: progress.isLessonCompleted(lessons[i].lessonId),
            isCurrent: progress.isLessonUnlocked(lessons[i].lessonId) &&
                !progress.isLessonCompleted(lessons[i].lessonId),
            isUnlocked: progress.isLessonUnlocked(lessons[i].lessonId),
            alignLeft: i.isEven,
            isLast: i == lessons.length - 1,
            onTap: () => onLessonTap(lessons[i]),
            index: i,
          ),
          if (i != lessons.length - 1)
            _JourneyConnector(
              alignLeft: i.isEven,
              nextAlignLeft: (i + 1).isEven,
            ),
        ],
      ],
    );
  }
}

class _JourneyNode extends StatelessWidget {
  final Lesson lesson;
  final bool isCompleted;
  final bool isCurrent;
  final bool isUnlocked;
  final bool alignLeft;
  final bool isLast;
  final VoidCallback onTap;
  final int index;

  const _JourneyNode({
    required this.lesson,
    required this.isCompleted,
    required this.isCurrent,
    required this.isUnlocked,
    required this.alignLeft,
    required this.isLast,
    required this.onTap,
    required this.index,
  });

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    const double ringSize = 88;
    const double nodeSize = 60;
    const double horizontalInset = 12;
    final isLocked = !isUnlocked;
    final Color ringColor = isCompleted
        ? AppColors.success
        : isCurrent
            ? AppColors.primary
            : scheme.outline;

    final IconData icon = _JourneyIcons.forIndex(index, isLocked: isLocked);

    final node = GestureDetector(
      onTap: isUnlocked ? onTap : null,
      child: ProgressRing(
        progress: isCompleted ? 1.0 : (isCurrent ? 0.72 : 0.0),
        size: ringSize,
        strokeWidth: 8,
        color: ringColor,
        backgroundColor: scheme.surfaceVariant.withOpacityValue(0.6),
        child: Container(
          width: nodeSize,
          height: nodeSize,
          decoration: BoxDecoration(
            color: isLocked ? scheme.surfaceVariant : ringColor,
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                color: ringColor.withOpacityValue(isLocked ? 0.18 : 0.35),
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
      ),
    );

    return Row(
      children: [
        if (!alignLeft) const Expanded(child: SizedBox()),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: horizontalInset),
          child: Column(
            crossAxisAlignment:
                alignLeft ? CrossAxisAlignment.start : CrossAxisAlignment.end,
            children: [
              node,
              const SizedBox(height: AppSpacing.sm),
              SizedBox(
                width: 170,
                child: Text(
                  lesson.title,
                  textAlign: alignLeft ? TextAlign.left : TextAlign.right,
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        color: isLocked
                            ? scheme.onSurfaceVariant
                            : scheme.onSurface,
                      ),
                ),
              ),
            ],
          ),
        ),
        if (alignLeft) const Expanded(child: SizedBox()),
      ],
    );
  }
}

class _JourneyConnector extends StatelessWidget {
  final bool alignLeft;
  final bool nextAlignLeft;

  const _JourneyConnector({
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
        painter: _JourneyConnectorPainter(
          alignLeft: alignLeft,
          nextAlignLeft: nextAlignLeft,
          color: Theme.of(context).colorScheme.outline.withOpacityValue(0.45),
        ),
      ),
    );
  }
}

class _JourneyConnectorPainter extends CustomPainter {
  final bool alignLeft;
  final bool nextAlignLeft;
  final Color color;

  _JourneyConnectorPainter({
    required this.alignLeft,
    required this.nextAlignLeft,
    required this.color,
  });

  @override
  void paint(Canvas canvas, Size size) {
    const double ringSize = 88;
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
  bool shouldRepaint(covariant _JourneyConnectorPainter oldDelegate) {
    return oldDelegate.alignLeft != alignLeft ||
        oldDelegate.nextAlignLeft != nextAlignLeft ||
        oldDelegate.color != color;
  }
}

class _JourneyIcons {
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

class _GuideBubble extends StatelessWidget {
  final String title;
  final String description;
  final VoidCallback onNext;
  final bool isLast;

  const _GuideBubble({
    required this.title,
    required this.description,
    required this.onNext,
    this.isLast = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF1E1E1E), // Solid dark background
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.white24),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.5),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Image.asset('assets/images/duo_guide.png', height: 40, width: 40),
              const SizedBox(width: 12),
              Text(
                title,
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            description,
            style: const TextStyle(color: Colors.white70, fontSize: 14),
          ),
          const SizedBox(height: 16),
          Align(
            alignment: Alignment.centerRight,
            child: ElevatedButton(
              onPressed: onNext,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.white,
                foregroundColor: Colors.black,
                shape: const StadiumBorder(),
                padding:
                    const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
              ),
              child: Text(isLast ? "Finish" : "Next"),
            ),
          ),
        ],
      ),
    );
  }
}
