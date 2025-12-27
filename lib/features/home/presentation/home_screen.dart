import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/providers/app_providers.dart';
import '../../../core/widgets/common_widgets.dart';
import '../../../core/widgets/glass_card.dart';
import '../../../core/widgets/gradient_button.dart';
import '../../../core/widgets/progress_ring.dart';
import '../../../core/widgets/floating_card.dart';
import '../../../core/widgets/profile_setup_dialog.dart';
import '../../../core/gamification/gamification_constants.dart';
import '../../path/presentation/unit_path_screen.dart';
import '../../profile/presentation/profile_screen.dart';
import '../../guru/presentation/guru_screen.dart';
import '../../settings/presentation/settings_screen.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  int _currentIndex = 0;
  bool _hasCheckedProfile = false;

  @override
  void initState() {
    super.initState();
    // Check profile after first frame
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _checkProfileSetup();
    });
  }

  void _checkProfileSetup() {
    if (_hasCheckedProfile) return;
    _hasCheckedProfile = true;

    final user = ref.read(userProfileProvider);
    if (user.displayName == null || user.displayName!.isEmpty) {
      // Show profile setup dialog after a short delay
      Future.delayed(const Duration(milliseconds: 500), () {
        if (mounted) {
          showDialog(
            context: context,
            barrierDismissible: false,
            builder: (context) => const ProfileSetupDialog(isFirstTime: true),
          );
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final user = ref.watch(userProfileProvider);
    final progress = ref.watch(progressProvider);

    return Scaffold(
      backgroundColor: AppColors.backgroundBase,
      body: IndexedStack(
        index: _currentIndex,
        children: [
          _HomeTab(user: user, progress: progress),
          const GuruScreen(),
          const ProfileScreen(),
        ],
      ),
      bottomNavigationBar: _GlassBottomNav(
        currentIndex: _currentIndex,
        onTap: (index) => setState(() => _currentIndex = index),
      ),
    );
  }
}

class _GlassBottomNav extends StatelessWidget {
  final int currentIndex;
  final ValueChanged<int> onTap;

  const _GlassBottomNav({
    required this.currentIndex,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        boxShadow: AppShadows.glassCard,
      ),
      child: ClipRRect(
        child: BackdropFilter(
          filter: const ColorFilter.mode(
            Colors.transparent,
            BlendMode.srcOver,
          ),
          child: Container(
            padding: const EdgeInsets.symmetric(vertical: AppSpacing.sm),
            decoration: BoxDecoration(
              color: AppColors.backgroundCard.withOpacity(0.8),
              border: const Border(
                top: BorderSide(color: AppColors.glassBorder, width: 1),
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
                    label: 'Ask Guru',
                    isSelected: currentIndex == 1,
                    onTap: () => onTap(1),
                  ),
                  _NavItem(
                    icon: Icons.person_rounded,
                    label: 'Profile',
                    isSelected: currentIndex == 2,
                    onTap: () => onTap(2),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _NavItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  const _NavItem({
    required this.icon,
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.md,
          vertical: AppSpacing.xs,
        ),
        decoration: BoxDecoration(
          gradient: isSelected ? AppGradients.primary : null,
          borderRadius: BorderRadius.circular(AppRadius.pill),
          boxShadow: isSelected ? AppShadows.glowing : null,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              size: 24,
              color: isSelected ? Colors.white : AppColors.textSecondary,
            ),
            const SizedBox(height: 4),
            Text(
              label,
              style: TextStyle(
                fontSize: 11,
                fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                color: isSelected ? Colors.white : AppColors.textSecondary,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _HomeTab extends StatelessWidget {
  final dynamic user;
  final dynamic progress;

  const _HomeTab({required this.user, required this.progress});

  @override
  Widget build(BuildContext context) {
    final dailyGoalProgress =
        progress.completedLessons.isEmpty ? 0.0 : (progress.completedLessons.length / 3).clamp(0.0, 1.0);

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
                        const Icon(Icons.auto_awesome_rounded, color: AppColors.secondary, size: 22),
                        const SizedBox(width: AppSpacing.xs),
                        Text(
                          'JainQuest',
                          style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w800),
                        ),
                      ],
                    ),
                    Text(
                      'Level ${user.level} • ${LevelSystem.getLevelTitle(user.level)}',
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                  ],
                ),
                const Spacer(),
                IconButton(
                  icon: const Icon(Icons.notifications_rounded),
                  onPressed: () {},
                  color: AppColors.textSecondary,
                ),
                IconButton(
                  icon: const Icon(Icons.settings_rounded),
                  onPressed: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(builder: (_) => const SettingsScreen()),
                    );
                  },
                  color: AppColors.textSecondary,
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
                          style: Theme.of(context).textTheme.headlineMedium?.copyWith(fontWeight: FontWeight.w900),
                        ),
                        const SizedBox(height: AppSpacing.xs),
                        Text(
                          'Level ${user.level} • ${LevelSystem.getLevelTitle(user.level)}',
                          style: Theme.of(context).textTheme.bodySmall?.copyWith(color: AppColors.secondary),
                        ),
                        const SizedBox(height: AppSpacing.sm),
                        AnimatedProgressBar(
                          progress: LevelSystem.getLevelProgress(user.level, user.totalXp),
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
                    progress: LevelSystem.getLevelProgress(user.level, user.totalXp),
                    size: 72,
                    strokeWidth: 8,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          '${user.totalXp}',
                          style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w900),
                        ),
                        Text('XP', style: Theme.of(context).textTheme.labelSmall),
                      ],
                    ),
                  ),
                ],
              ),
            )
                .animate()
                .fadeIn(duration: 250.ms)
                .slideY(begin: -0.05, end: 0, duration: 250.ms),
            const SizedBox(height: AppSpacing.md),
            Row(
              children: [
                Expanded(
                  child: FloatingCard(
                    padding: const EdgeInsets.all(AppSpacing.md),
                    child: Column(
                      children: [
                        const Icon(Icons.local_fire_department_rounded, color: AppColors.warning, size: 28),
                        const SizedBox(height: AppSpacing.xs),
                        Text('${user.currentStreak}', style: Theme.of(context).textTheme.titleLarge),
                        Text('day streak', style: Theme.of(context).textTheme.labelSmall),
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
                        const Icon(Icons.favorite_rounded, color: AppColors.danger, size: 28),
                        const SizedBox(height: AppSpacing.xs),
                        Text('${user.hearts}', style: Theme.of(context).textTheme.titleLarge),
                        Text('hearts', style: Theme.of(context).textTheme.labelSmall),
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
                        const Icon(Icons.star_rounded, color: AppColors.achievementGold, size: 28),
                        const SizedBox(height: AppSpacing.xs),
                        Text('${user.totalXp}', style: Theme.of(context).textTheme.titleLarge),
                        Text('XP', style: Theme.of(context).textTheme.labelSmall),
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
                        Text('Daily Goal', style: Theme.of(context).textTheme.titleMedium),
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
                              : AppColors.textMuted.withOpacity(0.5),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: AppSpacing.md),
            GradientButton(
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
                      gradient: AppGradients.primary,
                      borderRadius: BorderRadius.circular(AppRadius.small),
                      boxShadow: AppShadows.glowing,
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
                          'Ahimsa (Non-violence)',
                          style: Theme.of(context).textTheme.titleLarge,
                        ),
                        const SizedBox(height: 2),
                        Text(
                          'The supreme principle of Jainism',
                          style: Theme.of(context).textTheme.bodySmall,
                        ),
                      ],
                    ),
                  ),
                  const Icon(Icons.arrow_forward_ios_rounded, size: 16, color: AppColors.textSecondary),
                ],
              ),
            ),
            const SizedBox(height: AppSpacing.lg),
            Text('Your Journey', style: Theme.of(context).textTheme.headlineSmall),
            const SizedBox(height: AppSpacing.sm),
            FloatingCard(
              padding: const EdgeInsets.all(AppSpacing.lg),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _JourneyStep(
                    label: 'What is Jainism?',
                    isCompleted: progress.completedLessons.contains('lesson1'),
                    isCurrent: false,
                  ),
                  const SizedBox(height: AppSpacing.md),
                  _JourneyStep(
                    label: 'Ahimsa (Non-violence)',
                    isCompleted: progress.completedLessons.contains('lesson2'),
                    isCurrent: true,
                  ),
                  const SizedBox(height: AppSpacing.md),
                  const _JourneyStep(
                    label: 'The Five Vows',
                    isCompleted: false,
                    isCurrent: false,
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

class _JourneyStep extends StatelessWidget {
  final String label;
  final bool isCompleted;
  final bool isCurrent;

  const _JourneyStep({
    required this.label,
    required this.isCompleted,
    required this.isCurrent,
  });

  @override
  Widget build(BuildContext context) {
    final Color circleColor = isCompleted
        ? AppColors.success
        : isCurrent
            ? AppColors.primary
            : AppColors.textMuted;

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Column(
          children: [
            Container(
              width: 28,
              height: 28,
              decoration: BoxDecoration(
                color: circleColor.withOpacity(0.2),
                shape: BoxShape.circle,
                border: Border.all(color: circleColor, width: 2),
              ),
              child: Icon(
                isCompleted ? Icons.check_rounded : Icons.circle,
                size: 16,
                color: circleColor,
              ),
            ),
            const SizedBox(height: AppSpacing.xs),
            Container(
              width: 2,
              height: 24,
              color: AppColors.backgroundElevated,
            ),
          ],
        ),
        const SizedBox(width: AppSpacing.md),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.only(top: 4),
            child: Text(
              label,
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    color: isCompleted || isCurrent ? AppColors.textPrimary : AppColors.textSecondary,
                  ),
            ),
          ),
        ),
      ],
    );
  }
}
