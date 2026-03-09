import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:jainquest/features/lesson_runner/presentation/lesson_runner_screen.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/providers/app_providers.dart';
import '../../../core/services/storage_service.dart';
import '../../../core/widgets/common_widgets.dart';
import '../../../core/widgets/progress_ring.dart';
import '../../../core/widgets/floating_card.dart';
import '../../../core/widgets/liquid_glass.dart';
import '../../../core/gamification/gamification_constants.dart';
import '../../../core/providers/theme_provider.dart';
import '../../../core/models/user_models.dart';
import '../../../core/models/lesson_models.dart';
import '../../../core/guide/guide_keys.dart';
import '../../../core/navigation/app_navigator.dart';
import '../../profile/presentation/profile_screen.dart' show ProfileScreen;
import '../../guru/presentation/guru_screen.dart';
import '../../settings/presentation/settings_screen.dart';
import '../../resources/presentation/resources_screen.dart';
import '../../forum/presentation/forum_screen.dart';
import '../../path/presentation/unit_path_screen.dart';

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
  final GlobalKey _currentLessonKey = GuideKeys.currentLessonCard;
  final GlobalKey _streakCardKey = GlobalKey(debugLabel: 'streak_card');

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
    ref.read(homeTabIndexProvider.notifier).state = 0;
    final user = ref.read(userProfileProvider);
    if (!user.showGuidedTour) {
      StorageService.saveUserProfile(user.copyWith(showGuidedTour: true)).then((
        _,
      ) {
        ref.read(userProfileProvider.notifier).refresh();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final currentIndex = ref.watch(homeTabIndexProvider);
    final user = ref.watch(userProfileProvider);
    final progress = ref.watch(progressProvider);
    final unit = ref.watch(unit1Provider);
    final themeMode = ref.watch(themeModeProvider);
    Future<void> toggleTheme() async {
      await ref.read(themeModeProvider.notifier).toggleTheme();
    }

    return Scaffold(
      backgroundColor: Colors.transparent,
      body: IndexedStack(
        index: currentIndex,
        children: [
          _HomeTab(
            user: user,
            progress: progress,
            unit: unit,
            themeMode: themeMode,
            onToggleTheme: toggleTheme,
            streakCardKey: _streakCardKey,
            currentLessonKey: _currentLessonKey,
            onShowGuide: _showTutorial,
            onLessonTap: (lesson) {
              ref.read(lessonRunnerProvider.notifier).startLesson(lesson);
              Navigator.of(context).pushUltraSmooth(const LessonRunnerScreen());
            },
          ),
          const ResourcesScreen(),
          const GuruScreen(),
          const ForumScreen(),
          const ProfileScreen(),
        ],
      ),
      bottomNavigationBar: _GlassBottomNav(
        currentIndex: currentIndex,
        resourcesKey: GuideKeys.resourcesNavItem,
        askKey: GuideKeys.askGuruNavItem,
        communityKey: GuideKeys.communityNavItem,
        profileKey: GuideKeys.profileNavItem,
        onTap: (index) => ref.read(homeTabIndexProvider.notifier).state = index,
      ),
    );
  }
}

class _GlassBottomNav extends StatelessWidget {
  final int currentIndex;
  final Key? resourcesKey;
  final Key? askKey;
  final Key? communityKey;
  final Key? profileKey;
  final ValueChanged<int> onTap;

  const _GlassBottomNav({
    required this.currentIndex,
    this.resourcesKey,
    this.askKey,
    this.communityKey,
    this.profileKey,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: AppSpacing.sm),
      child: LiquidGlassContainer(
        borderRadius: BorderRadius.circular(0),
        borderColor: Theme.of(context).colorScheme.outline.withOpacityValue(0.45),
        tintColor: Theme.of(context).colorScheme.surface,
        tintOpacity: 0.28,
        padding: EdgeInsets.zero,
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
                key: resourcesKey,
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
                key: communityKey,
                icon: Icons.forum_rounded,
                label: 'Community',
                isSelected: currentIndex == 3,
                onTap: () => onTap(3),
              ),
              _NavItem(
                key: profileKey,
                icon: Icons.person_rounded,
                label: 'Profile',
                isSelected: currentIndex == 4,
                onTap: () => onTap(4),
              ),
            ],
          ),
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
      child: LiquidGlassContainer(
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.md,
          vertical: AppSpacing.xs,
        ),
        borderRadius: BorderRadius.circular(AppRadius.pill),
        tintColor: isSelected ? AppColors.primary : scheme.surface,
        tintOpacity: isSelected ? 0.5 : 0.12,
        borderColor: isSelected
            ? Colors.white.withOpacityValue(0.45)
            : scheme.outline.withOpacityValue(0.45),
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
                color: isSelected ? Colors.white : scheme.onSurface,
              ),
            const SizedBox(height: 4),
            Text(
              label,
              style: TextStyle(
                fontSize: 11,
                fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                color: isSelected ? Colors.white : scheme.onSurface,
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
  final Future<void> Function() onToggleTheme;
  final Key? streakCardKey;
  final GlobalKey currentLessonKey;
  final VoidCallback onShowGuide;
  final ValueChanged<Lesson> onLessonTap;

  const _HomeTab({
    required this.user,
    required this.progress,
    required this.unit,
    required this.themeMode,
    required this.onToggleTheme,
    this.streakCardKey,
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
                _GlassActionIcon(
                  icon: Icons.help_outline_rounded,
                  onTap: onShowGuide,
                  tooltip: 'Show Guide',
                ),
                const SizedBox(width: AppSpacing.xs),
                _GlassActionIcon(
                  icon: Icons.notifications_rounded,
                  onTap: () {},
                ),
                const SizedBox(width: AppSpacing.xs),
                _GlassActionIcon(
                  icon: themeMode == ThemeMode.dark
                      ? Icons.wb_sunny_rounded
                      : Icons.dark_mode_rounded,
                  onTap: () => onToggleTheme(),
                ),
                const SizedBox(width: AppSpacing.xs),
                _GlassActionIcon(
                  icon: Icons.settings_rounded,
                  onTap: () {
                    Navigator.of(context).pushUltraSmooth(const SettingsScreen());
                  },
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
              children: [
                Expanded(
                  child: FloatingCard(
                    key: streakCardKey,
                    padding: const EdgeInsets.all(AppSpacing.md),
                    child: Column(
                      children: [
                        const LiquidGlassIconBubble(
                          icon: Icons.local_fire_department_rounded,
                          iconSize: 28,
                          tintColor: AppColors.warning,
                          tintOpacity: 0.34,
                        ),
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
                        const LiquidGlassIconBubble(
                          icon: Icons.favorite_rounded,
                          iconSize: 28,
                          tintColor: AppColors.danger,
                          tintOpacity: 0.34,
                        ),
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
                        const LiquidGlassIconBubble(
                          icon: Icons.star_rounded,
                          iconSize: 28,
                          tintColor: AppColors.achievementGold,
                          tintOpacity: 0.34,
                        ),
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
                        child: LiquidGlassContainer(
                          width: 12,
                          height: 12,
                          shape: LiquidGlassShape.circle,
                          tintColor: index < progress.completedLessons.length
                              ? AppColors.primary
                              : scheme.surface,
                          tintOpacity: index < progress.completedLessons.length
                              ? 0.5
                              : 0.2,
                          borderColor:
                              scheme.outline.withOpacityValue(0.45),
                          child: const SizedBox.shrink(),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: AppSpacing.md),
            Row(
              children: [
                Expanded(
                  child: FloatingCard(
                    key: currentLessonKey,
                    height: 50,
                    onTap: () {
                      onLessonTap(currentLesson);
                    },
                    padding: const EdgeInsets.symmetric(
                      horizontal: AppSpacing.md,
                      vertical: AppSpacing.sm,
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(Icons.play_arrow_rounded, size: 18),
                        const SizedBox(width: AppSpacing.xs),
                        Text(
                          'Current Lesson',
                          style: Theme.of(context)
                              .textTheme
                              .labelLarge
                              ?.copyWith(fontWeight: FontWeight.w700),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(width: AppSpacing.sm),
                Expanded(
                  child: FloatingCard(
                    height: 50,
                    onTap: () {
                      Navigator.of(context).pushUltraSmooth(const UnitPathScreen());
                    },
                    padding: const EdgeInsets.symmetric(
                      horizontal: AppSpacing.md,
                      vertical: AppSpacing.sm,
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(Icons.timeline_rounded, size: 18),
                        const SizedBox(width: AppSpacing.xs),
                        Text(
                          'View Progress',
                          style: Theme.of(context)
                              .textTheme
                              .labelLarge
                              ?.copyWith(fontWeight: FontWeight.w700),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: AppSpacing.xl),
          ],
        ),
      ),
    );
  }
}

class _GlassActionIcon extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;
  final String? tooltip;

  const _GlassActionIcon({
    required this.icon,
    required this.onTap,
    this.tooltip,
  });

  @override
  Widget build(BuildContext context) {
    final iconWidget = LiquidGlassIconBubble(
      icon: icon,
      size: 36,
      iconSize: 18,
      iconColor: Theme.of(context).colorScheme.onSurface,
      tintColor: Theme.of(context).colorScheme.surface,
      tintOpacity: 0.2,
    );

    if (tooltip != null) {
      return Tooltip(
        message: tooltip!,
        child: InkWell(
          onTap: onTap,
          customBorder: const CircleBorder(),
          child: iconWidget,
        ),
      );
    }

    return InkWell(
      onTap: onTap,
      customBorder: const CircleBorder(),
      child: iconWidget,
    );
  }
}
