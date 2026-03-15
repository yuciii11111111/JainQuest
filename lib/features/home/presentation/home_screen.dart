import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:jainquest/features/lesson_runner/presentation/lesson_runner_screen.dart';

import '../../../core/gamification/gamification_rules.dart';
import '../../../core/guide/guide_keys.dart';
import '../../../core/localization/app_strings.dart';
import '../../../core/models/lesson_models.dart';
import '../../../core/models/user_models.dart';
import '../../../core/navigation/app_navigator.dart';
import '../../../core/providers/app_providers.dart';
import '../../../core/providers/theme_provider.dart';
import '../../../core/services/storage_service.dart';
import '../../../core/theme/app_motion.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/widgets/animated_tab_stack.dart';
import '../../../core/widgets/common_widgets.dart';
import '../../../core/widgets/floating_card.dart';
import '../../../core/widgets/liquid_glass.dart';
import '../../../core/widgets/motion_pressable.dart';
import '../../../core/widgets/motion_reveal.dart';
import '../../../core/widgets/progress_ring.dart';
import '../../../core/widgets/heart_lock_dialog.dart';
import '../../forum/presentation/forum_screen.dart';
import '../../guru/presentation/guru_screen.dart';
import '../../path/presentation/unit_path_screen.dart';
import '../../profile/presentation/profile_screen.dart' show ProfileScreen;
import '../../resources/presentation/resources_screen.dart';
import '../../settings/presentation/settings_screen.dart';

class HomeScreen extends ConsumerStatefulWidget {
  final bool showTutorialOnLoad;

  const HomeScreen({
    super.key,
    this.showTutorialOnLoad = false,
  });

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen>
    with WidgetsBindingObserver {
  static const List<String> _tabSlugs = <String>[
    'home',
    'resources',
    'guru',
    'community',
    'profile',
  ];
  final GlobalKey _currentLessonKey = GuideKeys.currentLessonCard;
  final GlobalKey _streakCardKey = GlobalKey(debugLabel: 'streak_card');
  final Set<int> _loadedTabs = <int>{0};
  bool _isApplyingRouteInformation = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _restoreSelectedTabFromUri(Uri.base);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (widget.showTutorialOnLoad) {
        _showTutorial();
      }
    });
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
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

  int _tabIndexFromUri(Uri uri) {
    final slug = uri.queryParameters['tab'];
    final index = _tabSlugs.indexOf(slug ?? '');
    return index >= 0 ? index : 0;
  }

  Uri _uriForTab(int index) {
    final normalizedIndex = index.clamp(0, _tabSlugs.length - 1);
    final currentUri = Uri.base;
    final nextQueryParameters = Map<String, String>.from(
      currentUri.queryParameters,
    );

    if (normalizedIndex == 0) {
      nextQueryParameters.remove('tab');
    } else {
      nextQueryParameters['tab'] = _tabSlugs[normalizedIndex];
    }

    return currentUri.replace(
      queryParameters: nextQueryParameters.isEmpty ? null : nextQueryParameters,
      fragment: currentUri.fragment.isEmpty ? null : currentUri.fragment,
    );
  }

  void _restoreSelectedTabFromUri(Uri uri) {
    final tabIndex = _tabIndexFromUri(uri);
    final currentIndex = ref.read(homeTabIndexProvider);
    if (tabIndex == currentIndex) {
      return;
    }
    _isApplyingRouteInformation = true;
    ref.read(homeTabIndexProvider.notifier).state = tabIndex;
    _isApplyingRouteInformation = false;
  }

  Future<void> _syncUriForTab(int index) async {
    if (!kIsWeb) {
      return;
    }
    final nextUri = _uriForTab(index);
    if (nextUri == Uri.base) {
      return;
    }
    await SystemNavigator.routeInformationUpdated(uri: nextUri);
  }

  @override
  Future<bool> didPushRouteInformation(
      RouteInformation routeInformation) async {
    final uri = routeInformation.uri;
    _restoreSelectedTabFromUri(uri);
    return true;
  }

  @override
  Widget build(BuildContext context) {
    ref.listen<int>(homeTabIndexProvider, (previous, next) {
      if (_isApplyingRouteInformation || previous == next) {
        return;
      }
      _syncUriForTab(next);
    });
    final currentIndex = ref.watch(homeTabIndexProvider);
    _loadedTabs.add(currentIndex);
    final user = ref.watch(userProfileProvider);
    final progress = ref.watch(progressProvider);
    final unit = ref.watch(unit1Provider);
    final themeMode = ref.watch(themeModeProvider);

    Future<void> toggleTheme() async {
      await ref.read(themeModeProvider.notifier).toggleTheme();
    }

    return Scaffold(
      backgroundColor: Colors.transparent,
      body: AnimatedTabStack(
        index: currentIndex,
        children: [
          _loadedTabs.contains(0)
              ? _HomeTab(
                  user: user,
                  progress: progress,
                  unit: unit,
                  themeMode: themeMode,
                  onToggleTheme: toggleTheme,
                  streakCardKey: _streakCardKey,
                  currentLessonKey: _currentLessonKey,
                  onShowGuide: _showTutorial,
                  onLessonTap: (lesson) async {
                    final updatedUser = await ref
                        .read(userProfileProvider.notifier)
                        .syncHearts();
                    if (!context.mounted) return;
                    if (!updatedUser.hasHeartsAvailable) {
                      await showHeartLockDialog(context, user: updatedUser);
                      return;
                    }
                    ref.read(lessonRunnerProvider.notifier).startLesson(lesson);
                    Navigator.of(context).pushUltraSmooth(
                      const LessonRunnerScreen(),
                    );
                  },
                )
              : const SizedBox.shrink(),
          _loadedTabs.contains(1)
              ? const ResourcesScreen()
              : const SizedBox.shrink(),
          _loadedTabs.contains(2)
              ? const GuruScreen()
              : const SizedBox.shrink(),
          _loadedTabs.contains(3)
              ? const ForumScreen()
              : const SizedBox.shrink(),
          _loadedTabs.contains(4)
              ? const ProfileScreen()
              : const SizedBox.shrink(),
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
        borderColor:
            Theme.of(context).colorScheme.outline.withOpacityValue(0.45),
        tintColor: Theme.of(context).colorScheme.surface,
        tintOpacity: 0.28,
        padding: EdgeInsets.zero,
        child: SafeArea(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _NavItem(
                icon: Icons.home_rounded,
                label: context.t('home'),
                isSelected: currentIndex == 0,
                onTap: () => onTap(0),
              ),
              _NavItem(
                key: resourcesKey,
                icon: Icons.auto_awesome_rounded,
                label: context.t('resources'),
                isSelected: currentIndex == 1,
                onTap: () => onTap(1),
              ),
              _NavItem(
                key: askKey,
                imageAsset: 'assets/images/duo_guide.png',
                label: context.t('ask'),
                isSelected: currentIndex == 2,
                onTap: () => onTap(2),
              ),
              _NavItem(
                key: communityKey,
                icon: Icons.forum_rounded,
                label: context.t('community'),
                isSelected: currentIndex == 3,
                onTap: () => onTap(3),
              ),
              _NavItem(
                key: profileKey,
                icon: Icons.person_rounded,
                label: context.t('profile'),
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
    final duration = AppMotion.resolveDuration(context, AppMotion.standard);
    final labelStyle = TextStyle(
      fontSize: 11,
      fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
      color: isSelected ? Colors.white : scheme.onSurface,
    );

    return MotionPressable(
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
            AnimatedScale(
              scale: isSelected ? 1.08 : 1.0,
              duration: duration,
              curve: AppMotion.springCurve,
              child: imageAsset != null
                  ? Image.asset(
                      imageAsset!,
                      width: 24,
                      height: 24,
                    )
                  : Icon(
                      icon,
                      size: 24,
                      color: isSelected ? Colors.white : scheme.onSurface,
                    ),
            ),
            const SizedBox(height: 4),
            AnimatedDefaultTextStyle(
              duration: duration,
              curve: AppMotion.standardCurve,
              style: labelStyle,
              child: Text(label),
            ),
            const SizedBox(height: 4),
            AnimatedContainer(
              duration: duration,
              curve: AppMotion.standardCurve,
              width: isSelected ? 18 : 6,
              height: 3,
              decoration: BoxDecoration(
                color: isSelected
                    ? Colors.white.withOpacityValue(0.92)
                    : Colors.white.withOpacityValue(0.22),
                borderRadius: BorderRadius.circular(AppRadius.pill),
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
    final completedToday = progress.completedLessonsOn(DateTime.now());
    final dailyGoalCount = completedToday > 3 ? 3 : completedToday;
    final lessons = unit.lessons;
    final levelProgress =
        LevelSystem.getLevelProgress(user.level, user.totalXp);
    final currentLesson = lessons.firstWhere(
      (lesson) =>
          progress.isLessonUnlocked(lesson.lessonId) &&
          !progress.isLessonCompleted(lesson.lessonId),
      orElse: () => lessons.first,
    );
    Duration revealDelay(int step) {
      return Duration(
        milliseconds: AppMotion.stagger.inMilliseconds * step,
      );
    }

    return SafeArea(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(AppSpacing.lg),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            MotionReveal(
              child: Row(
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          const Icon(
                            Icons.auto_awesome_rounded,
                            color: AppColors.secondary,
                            size: 22,
                          ),
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
                        context.t('level_title', args: {
                          'level': '${user.level}',
                          'title': LevelSystem.getLevelTitle(user.level),
                        }),
                        style: Theme.of(context).textTheme.bodySmall,
                      ),
                    ],
                  ),
                  const Spacer(),
                  _GlassActionIcon(
                    icon: Icons.help_outline_rounded,
                    onTap: onShowGuide,
                    tooltip: context.t('show_guide'),
                  ),
                  const SizedBox(width: AppSpacing.xs),
                  _GlassActionIcon(
                    icon: Icons.notifications_rounded,
                    onTap: () {},
                    tooltip: context.t('notifications'),
                  ),
                  const SizedBox(width: AppSpacing.xs),
                  _GlassActionIcon(
                    icon: themeMode == ThemeMode.dark
                        ? Icons.wb_sunny_rounded
                        : Icons.dark_mode_rounded,
                    onTap: () => onToggleTheme(),
                    tooltip: context.t(
                      themeMode == ThemeMode.dark
                          ? 'switch_to_light_mode'
                          : 'switch_to_dark_mode',
                    ),
                  ),
                  const SizedBox(width: AppSpacing.xs),
                  _GlassActionIcon(
                    icon: Icons.settings_rounded,
                    onTap: () {
                      Navigator.of(context)
                          .pushUltraSmooth(const SettingsScreen());
                    },
                    tooltip: context.t('settings'),
                  ),
                ],
              ),
            ),
            const SizedBox(height: AppSpacing.md),
            MotionReveal(
              delay: revealDelay(1),
              child: FloatingCard(
                padding: const EdgeInsets.all(AppSpacing.lg),
                child: Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            context.t('welcome_back_comma'),
                            style: Theme.of(context).textTheme.bodySmall,
                          ),
                          Text(
                            user.displayName ?? context.t('explorer'),
                            style: Theme.of(context)
                                .textTheme
                                .headlineMedium
                                ?.copyWith(fontWeight: FontWeight.w900),
                          ),
                          const SizedBox(height: AppSpacing.xs),
                          Text(
                            context.t('level_title', args: {
                              'level': '${user.level}',
                              'title': LevelSystem.getLevelTitle(user.level),
                            }),
                            style: Theme.of(context)
                                .textTheme
                                .bodySmall
                                ?.copyWith(color: AppColors.secondary),
                          ),
                          const SizedBox(height: AppSpacing.sm),
                          AnimatedProgressBar(
                            progress: levelProgress,
                            height: 6,
                          ),
                          const SizedBox(height: AppSpacing.xs),
                          Text(
                            context.t('percent_progress', args: {
                              'value': '${(levelProgress * 100).round()}'
                            }),
                            style: Theme.of(context).textTheme.labelSmall,
                          ),
                        ],
                      ),
                    ),
                    ProgressRing(
                      progress: levelProgress,
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
                          Text(
                            context.t('xp'),
                            style: Theme.of(context).textTheme.labelSmall,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: AppSpacing.md),
            MotionReveal(
              delay: revealDelay(2),
              child: Row(
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
                          Text(
                            '${user.currentStreak}',
                            style: Theme.of(context).textTheme.titleLarge,
                          ),
                          Text(
                            context.t('day_streak_label'),
                            style: Theme.of(context).textTheme.labelSmall,
                          ),
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
                          Text(
                            '${user.hearts}',
                            style: Theme.of(context).textTheme.titleLarge,
                          ),
                          Text(
                            context.t('hearts'),
                            style: Theme.of(context).textTheme.labelSmall,
                          ),
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
                          Text(
                            '${user.totalXp}',
                            style: Theme.of(context).textTheme.titleLarge,
                          ),
                          Text(
                            context.t('xp'),
                            style: Theme.of(context).textTheme.labelSmall,
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: AppSpacing.md),
            MotionReveal(
              delay: revealDelay(3),
              child: FloatingCard(
                padding: const EdgeInsets.all(AppSpacing.lg),
                child: Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            context.t('daily_goal'),
                            style: Theme.of(context).textTheme.titleMedium,
                          ),
                          const SizedBox(height: AppSpacing.xs),
                          Text(
                            context.t('lessons_completed_of', args: {
                              'count': '$dailyGoalCount',
                            }),
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
                            tintColor: index < dailyGoalCount
                                ? AppColors.primary
                                : scheme.surface,
                            tintOpacity: index < dailyGoalCount ? 0.5 : 0.2,
                            borderColor: scheme.outline.withOpacityValue(0.45),
                            child: const SizedBox.shrink(),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: AppSpacing.md),
            MotionReveal(
              delay: revealDelay(4),
              child: Row(
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
                            context.t('current_lesson'),
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
                        Navigator.of(context)
                            .pushUltraSmooth(const UnitPathScreen());
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
                            context.t('view_progress'),
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

    final button = MotionPressable(
      onTap: onTap,
      child: iconWidget,
    );

    if (tooltip != null) {
      return Semantics(
        button: true,
        label: tooltip!,
        child: Tooltip(
          message: tooltip!,
          child: button,
        ),
      );
    }

    return button;
  }
}
