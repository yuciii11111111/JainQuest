import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/providers/app_providers.dart';
import '../../../core/providers/theme_provider.dart';
import '../../../core/widgets/common_widgets.dart';
import '../../../core/widgets/glass_card.dart';
import '../../../core/widgets/floating_card.dart';
import '../../../core/widgets/progress_ring.dart';
import '../../../core/widgets/profile_setup_dialog.dart';
import '../../../core/widgets/gradient_button.dart';
import '../../../core/gamification/gamification_constants.dart';
import '../../../core/models/user_models.dart' as user_models;
import '../../../core/content/unit1_content.dart';

// Import types directly for convenience
typedef UserProfile = user_models.UserProfile;
typedef ProgressState = user_models.ProgressState;
typedef BadgeModel = user_models.Badge;

class ProfileScreen extends ConsumerStatefulWidget {
  const ProfileScreen({super.key});

  @override
  ConsumerState<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends ConsumerState<ProfileScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final user = ref.watch(userProfileProvider);
    final progress = ref.watch(progressProvider);
    final lessonBadges = ref.watch(badgesProvider);
    // Get all badges from gamification system
    final allBadges = BadgeDefinitions.allBadges;

    return Scaffold(
      backgroundColor: AppColors.backgroundBase,
      body: SafeArea(
        child: Column(
          children: [
            // Scrollable Header Section
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    // Header
                    Padding(
                      padding: const EdgeInsets.all(AppSpacing.lg),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Profile',
                            style: Theme.of(context).textTheme.displaySmall,
                          ),
                          // Theme Toggle
                          IconButton(
                            icon: ref.watch(themeModeProvider) == ThemeMode.dark
                                ? const Icon(Icons.light_mode_rounded)
                                : const Icon(Icons.dark_mode_rounded),
                            color: AppColors.primary,
                            onPressed: () {
                              ref.read(themeModeProvider.notifier).toggleTheme();
                            },
                            tooltip: ref.watch(themeModeProvider) == ThemeMode.dark
                                ? 'Switch to Light Mode'
                                : 'Switch to Dark Mode',
                          ),
                        ],
                      ),
                    ),

                    // Avatar & Stats Card
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
                      child: GlassCard(
                        padding: const EdgeInsets.all(AppSpacing.lg),
                        child: Column(
                          children: [
                            // Edit Button
                            Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                IconButton(
                                  icon: const Icon(Icons.edit_rounded),
                                  color: AppColors.primary,
                                  onPressed: () {
                                    showDialog(
                                      context: context,
                                      builder: (context) => const ProfileSetupDialog(isFirstTime: false),
                                    );
                                  },
                                  tooltip: 'Edit Profile',
                                ),
                              ],
                            ),
                            // Avatar
                            Container(
                              width: 100,
                              height: 100,
                              decoration: BoxDecoration(
                                gradient: AppGradients.primary,
                                shape: BoxShape.circle,
                                border: Border.all(
                                  color: AppColors.primary,
                                  width: 4,
                                ),
                                boxShadow: AppShadows.glowing,
                              ),
                              child: const Icon(
                                Icons.person_rounded,
                                size: 60,
                                color: Colors.white,
                              ),
                            ),
                            const SizedBox(height: AppSpacing.md),
                            // Name & Level
                            Text(
                              user.displayName ?? 'Learner',
                              style: Theme.of(context).textTheme.headlineMedium,
                            ),
                            const SizedBox(height: AppSpacing.xs),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: AppSpacing.md,
                                vertical: AppSpacing.xs,
                              ),
                              decoration: BoxDecoration(
                                gradient: AppGradients.primary,
                                borderRadius: BorderRadius.circular(AppRadius.pill),
                              ),
                              child: Text(
                                'Level ${user.level} • ${LevelSystem.getLevelTitle(user.level)}',
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w700,
                                  fontSize: 14,
                                ),
                              ),
                            ),
                            const SizedBox(height: AppSpacing.lg),
                            // Stats Row
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                _StatItem(
                                  icon: Icons.star_rounded,
                                  value: '${user.totalXp}',
                                  label: 'XP',
                                  color: AppColors.achievementGold,
                                ),
                                _StatItem(
                                  icon: Icons.local_fire_department_rounded,
                                  value: '${user.currentStreak}',
                                  label: 'Streak',
                                  color: AppColors.warning,
                                ),
                                _StatItem(
                                  icon: Icons.favorite_rounded,
                                  value: '${user.hearts}',
                                  label: 'Hearts',
                                  color: AppColors.danger,
                                ),
                              ],
                            ),
                          ],
                        ),
                      )
                          .animate()
                          .fadeIn(duration: 300.ms)
                          .slideY(begin: -0.1, end: 0, duration: 300.ms),
                    ),

                    // Level Progress
                    Padding(
                      padding: const EdgeInsets.all(AppSpacing.lg),
                      child: FloatingCard(
                        padding: const EdgeInsets.all(AppSpacing.lg),
                        child: Column(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  'Level Progress',
                                  style: Theme.of(context).textTheme.titleLarge,
                                ),
                                Text(
                                  '${user.xpProgressInLevel}/${user.xpForNextLevel} XP',
                                  style: Theme.of(context).textTheme.bodySmall,
                                ),
                              ],
                            ),
                            const SizedBox(height: AppSpacing.md),
                            Row(
                              children: [
                                ProgressRing(
                                  progress: LevelSystem.getLevelProgress(
                                    user.level,
                                    user.totalXp,
                                  ),
                                  size: 80,
                                  strokeWidth: 8,
                                  child: Text(
                                    '${user.level}',
                                    style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                                          fontWeight: FontWeight.w900,
                                        ),
                                  ),
                                ),
                                const SizedBox(width: AppSpacing.md),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      AnimatedProgressBar(
                                        progress: LevelSystem.getLevelProgress(
                                          user.level,
                                          user.totalXp,
                                        ),
                                        height: 12,
                                      ),
                                      const SizedBox(height: AppSpacing.xs),
                                      Text(
                                        '${LevelSystem.getXpNeededForNextLevel(user.level, user.totalXp)} XP to Level ${user.level + 1}',
                                        style: Theme.of(context).textTheme.bodySmall,
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      )
                          .animate(delay: 100.ms)
                          .fadeIn(duration: 300.ms)
                          .slideX(begin: -0.1, end: 0, duration: 300.ms),
                    ),

                    // Tabs
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
                      child: GlassCard(
                        padding: EdgeInsets.zero,
                        child: TabBar(
                          controller: _tabController,
                          indicator: BoxDecoration(
                            gradient: AppGradients.primary,
                            borderRadius: BorderRadius.circular(AppRadius.pill),
                          ),
                          labelColor: Colors.white,
                          unselectedLabelColor: AppColors.textSecondary,
                          labelStyle: const TextStyle(
                            fontWeight: FontWeight.w700,
                          ),
                          tabs: const [
                            Tab(text: 'Badges'),
                            Tab(text: 'Stats'),
                            Tab(text: 'Details'),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // Tab Content
            Expanded(
              flex: 2,
              child: TabBarView(
                controller: _tabController,
                children: [
                  _BadgesTab(progress: progress, lessonBadges: lessonBadges, allBadges: allBadges),
                  _StatsTab(user: user, progress: progress),
                  _DetailsTab(user: user, progress: progress),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _StatItem extends StatelessWidget {
  final IconData icon;
  final String value;
  final String label;
  final Color color;

  const _StatItem({
    required this.icon,
    required this.value,
    required this.label,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Icon(icon, color: color, size: 28),
        const SizedBox(height: AppSpacing.xs),
        Text(
          value,
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.w800,
              ),
        ),
        Text(
          label,
          style: Theme.of(context).textTheme.bodySmall,
        ),
      ],
    );
  }
}

class _BadgesTab extends StatelessWidget {
  final ProgressState progress;
  final List<BadgeDefinition> lessonBadges;
  final List<BadgeModel> allBadges;

  const _BadgesTab({
    required this.progress,
    required this.lessonBadges,
    required this.allBadges,
  });

  @override
  Widget build(BuildContext context) {
    // Combine all badges
    final combinedBadges = <_BadgeDisplay>[];
    
    // Add lesson badges (BadgeDefinition)
    for (final badge in lessonBadges) {
      final isEarned = progress.earnedBadges.contains(badge.id);
      combinedBadges.add(_BadgeDisplay(
        id: badge.id,
        name: badge.name,
        description: badge.description ?? 'Complete lessons to unlock',
        isEarned: isEarned,
      ));
    }
    
    // Add gamification badges (Badge)
    for (final badge in allBadges) {
      // Skip if already added as lesson badge
      if (combinedBadges.any((b) => b.id == badge.id)) continue;
      
      final isEarned = progress.earnedBadges.contains(badge.id);
      combinedBadges.add(_BadgeDisplay(
        id: badge.id,
        name: badge.name,
        description: badge.description,
        isEarned: isEarned,
      ));
    }

    return SingleChildScrollView(
      padding: const EdgeInsets.all(AppSpacing.lg),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Your Badges',
            style: Theme.of(context).textTheme.titleLarge,
          ),
          const SizedBox(height: AppSpacing.sm),
          Text(
            '${combinedBadges.where((b) => b.isEarned).length} of ${combinedBadges.length} earned',
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: AppColors.textSecondary,
                ),
          ),
          const SizedBox(height: AppSpacing.lg),
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3,
              crossAxisSpacing: AppSpacing.md,
              mainAxisSpacing: AppSpacing.md,
            ),
            itemCount: combinedBadges.length,
            itemBuilder: (context, index) {
              final badge = combinedBadges[index];

              return GestureDetector(
                onTap: () {
                  _showBadgeDetails(context, badge);
                },
                child: FloatingCard(
                  padding: const EdgeInsets.all(AppSpacing.sm),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        width: 60,
                        height: 60,
                        decoration: BoxDecoration(
                          gradient: badge.isEarned ? AppGradients.accent : null,
                          color: badge.isEarned ? null : AppColors.backgroundElevated,
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: badge.isEarned ? AppColors.secondary : AppColors.glassBorder,
                            width: 3,
                          ),
                          boxShadow: badge.isEarned ? AppShadows.glowing : null,
                        ),
                        child: Stack(
                          alignment: Alignment.center,
                          children: [
                            Icon(
                              Icons.workspace_premium_rounded,
                              size: 32,
                              color: badge.isEarned ? Colors.white : AppColors.textMuted,
                            ),
                            if (!badge.isEarned)
                              Container(
                                decoration: BoxDecoration(
                                  color: AppColors.backgroundBase.withOpacity(0.7),
                                  shape: BoxShape.circle,
                                ),
                              ),
                          ],
                        ),
                      ),
                      const SizedBox(height: AppSpacing.xs),
                      Text(
                        badge.name,
                        textAlign: TextAlign.center,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                              color: badge.isEarned
                                  ? AppColors.textPrimary
                                  : AppColors.textMuted,
                              fontWeight: badge.isEarned ? FontWeight.w600 : FontWeight.w400,
                            ),
                      ),
                    ],
                  ),
                )
                    .animate(delay: (index * 50).ms)
                    .fadeIn(duration: 300.ms)
                    .scale(begin: const Offset(0.9, 0.9), end: const Offset(1, 1)),
              );
            },
          ),
        ],
      ),
    );
  }

  void _showBadgeDetails(BuildContext context, _BadgeDisplay badge) {
    showDialog(
      context: context,
      builder: (context) => Dialog(
        backgroundColor: Colors.transparent,
        child: GlassCard(
          padding: const EdgeInsets.all(AppSpacing.xl),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 100,
                height: 100,
                decoration: BoxDecoration(
                  gradient: badge.isEarned ? AppGradients.accent : null,
                  color: badge.isEarned ? null : AppColors.backgroundElevated,
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: badge.isEarned ? AppColors.secondary : AppColors.glassBorder,
                    width: 4,
                  ),
                  boxShadow: badge.isEarned ? AppShadows.glowing : null,
                ),
                child: Icon(
                  Icons.workspace_premium_rounded,
                  size: 50,
                  color: badge.isEarned ? Colors.white : AppColors.textMuted,
                ),
              ),
              const SizedBox(height: AppSpacing.lg),
              Text(
                badge.name,
                style: Theme.of(context).textTheme.headlineSmall,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: AppSpacing.sm),
              Text(
                badge.description,
                style: Theme.of(context).textTheme.bodyMedium,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: AppSpacing.lg),
              if (!badge.isEarned)
                Container(
                  padding: const EdgeInsets.all(AppSpacing.sm),
                  decoration: BoxDecoration(
                    color: AppColors.warning.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(AppRadius.small),
                    border: Border.all(color: AppColors.warning.withOpacity(0.3)),
                  ),
                  child: Text(
                    'Locked - Complete challenges to unlock',
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: AppColors.warning,
                        ),
                    textAlign: TextAlign.center,
                  ),
                ),
              const SizedBox(height: AppSpacing.lg),
              GradientButton(
                label: 'Close',
                onPressed: () => Navigator.of(context).pop(),
                width: double.infinity,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _BadgeDisplay {
  final String id;
  final String name;
  final String description;
  final bool isEarned;

  _BadgeDisplay({
    required this.id,
    required this.name,
    required this.description,
    required this.isEarned,
  });
}

class _StatsTab extends StatelessWidget {
  final UserProfile user;
  final ProgressState progress;

  const _StatsTab({
    required this.user,
    required this.progress,
  });

  @override
  Widget build(BuildContext context) {
    // Calculate additional stats
    final totalLessonsCompleted = progress.completedLessons.length;
    final totalXpEarned = user.totalXp;
    final averageScore = _calculateAverageScore(progress);
    final totalPracticeSessions = 0; // Placeholder - would come from practice logs

    return SingleChildScrollView(
      padding: const EdgeInsets.all(AppSpacing.lg),
      child: Column(
        children: [
          // Streak Stats
          FloatingCard(
            padding: const EdgeInsets.all(AppSpacing.md),
            child: Row(
              children: [
                Container(
                  width: 48,
                  height: 48,
                  decoration: BoxDecoration(
                    gradient: AppGradients.warm,
                    borderRadius: BorderRadius.circular(AppRadius.small),
                  ),
                  child: const Icon(
                    Icons.local_fire_department_rounded,
                    color: Colors.white,
                    size: 28,
                  ),
                ),
                const SizedBox(width: AppSpacing.md),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Current Streak',
                        style: Theme.of(context).textTheme.titleSmall,
                      ),
                      Text(
                        '${user.currentStreak} days',
                        style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                              fontWeight: FontWeight.w800,
                            ),
                      ),
                    ],
                  ),
                ),
                if (user.currentStreak > 0)
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: AppSpacing.sm,
                      vertical: AppSpacing.xs,
                    ),
                    decoration: BoxDecoration(
                      gradient: AppGradients.warm,
                      borderRadius: BorderRadius.circular(AppRadius.pill),
                    ),
                    child: Text(
                      '🔥',
                      style: const TextStyle(fontSize: 20),
                    ),
                  ),
              ],
            ),
          ),
          const SizedBox(height: AppSpacing.md),
          FloatingCard(
            padding: const EdgeInsets.all(AppSpacing.md),
            child: Row(
              children: [
                Container(
                  width: 48,
                  height: 48,
                  decoration: BoxDecoration(
                    gradient: AppGradients.primary,
                    borderRadius: BorderRadius.circular(AppRadius.small),
                  ),
                  child: const Icon(
                    Icons.emoji_events_rounded,
                    color: Colors.white,
                    size: 28,
                  ),
                ),
                const SizedBox(width: AppSpacing.md),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Best Streak',
                        style: Theme.of(context).textTheme.titleSmall,
                      ),
                      Text(
                        '${user.longestStreak} days',
                        style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                              fontWeight: FontWeight.w800,
                            ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: AppSpacing.lg),

          // Learning Stats
          Text(
            'Learning Stats',
            style: Theme.of(context).textTheme.titleLarge,
          ),
          const SizedBox(height: AppSpacing.md),
          FloatingCard(
            padding: const EdgeInsets.all(AppSpacing.md),
            child: Row(
              children: [
                Container(
                  width: 48,
                  height: 48,
                  decoration: BoxDecoration(
                    gradient: AppGradients.success,
                    borderRadius: BorderRadius.circular(AppRadius.small),
                  ),
                  child: const Icon(
                    Icons.check_circle_rounded,
                    color: Colors.white,
                    size: 28,
                  ),
                ),
                const SizedBox(width: AppSpacing.md),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Lessons Completed',
                        style: Theme.of(context).textTheme.titleSmall,
                      ),
                      Text(
                        '$totalLessonsCompleted',
                        style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                              fontWeight: FontWeight.w800,
                            ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: AppSpacing.md),
          FloatingCard(
            padding: const EdgeInsets.all(AppSpacing.md),
            child: Row(
              children: [
                Container(
                  width: 48,
                  height: 48,
                  decoration: BoxDecoration(
                    gradient: AppGradients.primary,
                    borderRadius: BorderRadius.circular(AppRadius.small),
                  ),
                  child: const Icon(
                    Icons.star_rounded,
                    color: Colors.white,
                    size: 28,
                  ),
                ),
                const SizedBox(width: AppSpacing.md),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Total XP Earned',
                        style: Theme.of(context).textTheme.titleSmall,
                      ),
                      Text(
                        '$totalXpEarned XP',
                        style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                              fontWeight: FontWeight.w800,
                            ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          if (averageScore > 0) ...[
            const SizedBox(height: AppSpacing.md),
            FloatingCard(
              padding: const EdgeInsets.all(AppSpacing.md),
              child: Row(
                children: [
                  Container(
                    width: 48,
                    height: 48,
                    decoration: BoxDecoration(
                      gradient: AppGradients.accent,
                      borderRadius: BorderRadius.circular(AppRadius.small),
                    ),
                    child: const Icon(
                      Icons.trending_up_rounded,
                      color: Colors.white,
                      size: 28,
                    ),
                  ),
                  const SizedBox(width: AppSpacing.md),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Average Score',
                          style: Theme.of(context).textTheme.titleSmall,
                        ),
                        Text(
                          '$averageScore%',
                          style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                                fontWeight: FontWeight.w800,
                              ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
          const SizedBox(height: AppSpacing.md),
          FloatingCard(
            padding: const EdgeInsets.all(AppSpacing.md),
            child: Row(
              children: [
                Container(
                  width: 48,
                  height: 48,
                  decoration: BoxDecoration(
                    color: AppColors.highlight.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(AppRadius.small),
                    border: Border.all(color: AppColors.highlight),
                  ),
                  child: Icon(
                    Icons.fitness_center_rounded,
                    color: AppColors.highlight,
                    size: 28,
                  ),
                ),
                const SizedBox(width: AppSpacing.md),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Practice Sessions',
                        style: Theme.of(context).textTheme.titleSmall,
                      ),
                      Text(
                        '$totalPracticeSessions',
                        style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                              fontWeight: FontWeight.w800,
                            ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  int _calculateAverageScore(ProgressState progress) {
    if (progress.lessonProgress.isEmpty) return 0;
    int totalScore = 0;
    int count = 0;
    for (final lessonProgress in progress.lessonProgress.values) {
      if (lessonProgress.bestScore > 0) {
        totalScore += lessonProgress.bestScore;
        count++;
      }
    }
    return count > 0 ? (totalScore / count).round() : 0;
  }
}

class _DetailsTab extends StatelessWidget {
  final UserProfile user;
  final ProgressState progress;

  const _DetailsTab({
    required this.user,
    required this.progress,
  });

  @override
  Widget build(BuildContext context) {
    final daysSinceJoined = DateTime.now().difference(user.createdAt).inDays;
    final lastActivityDays = user.lastActivityDate != null
        ? DateTime.now().difference(user.lastActivityDate!).inDays
        : null;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(AppSpacing.lg),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Account Details',
            style: Theme.of(context).textTheme.titleLarge,
          ),
          const SizedBox(height: AppSpacing.md),
          FloatingCard(
            padding: const EdgeInsets.all(AppSpacing.md),
            child: Column(
              children: [
                _DetailRow(
                  icon: Icons.person_rounded,
                  label: 'Display Name',
                  value: user.displayName ?? 'Not set',
                ),
                const Divider(),
                _DetailRow(
                  icon: Icons.fingerprint_rounded,
                  label: 'User ID',
                  value: user.id.substring(0, 8) + '...',
                ),
                const Divider(),
                _DetailRow(
                  icon: Icons.calendar_today_rounded,
                  label: 'Member Since',
                  value: '${_formatDate(user.createdAt)} ($daysSinceJoined days ago)',
                ),
                const Divider(),
                _DetailRow(
                  icon: Icons.access_time_rounded,
                  label: 'Last Activity',
                  value: user.lastActivityDate != null
                      ? '${_formatDate(user.lastActivityDate!)} ${lastActivityDays == 0 ? "(Today)" : "($lastActivityDays days ago)"}'
                      : 'Never',
                ),
              ],
            ),
          ),
          const SizedBox(height: AppSpacing.lg),
          Text(
            'Progress Summary',
            style: Theme.of(context).textTheme.titleLarge,
          ),
          const SizedBox(height: AppSpacing.md),
          FloatingCard(
            padding: const EdgeInsets.all(AppSpacing.md),
            child: Column(
              children: [
                _DetailRow(
                  icon: Icons.shield_rounded,
                  label: 'Current Level',
                  value: 'Level ${user.level} • ${LevelSystem.getLevelTitle(user.level)}',
                ),
                const Divider(),
                _DetailRow(
                  icon: Icons.workspace_premium_rounded,
                  label: 'Badges Earned',
                  value: '${progress.earnedBadges.length}',
                ),
                const Divider(),
                _DetailRow(
                  icon: Icons.book_rounded,
                  label: 'Lessons Completed',
                  value: '${progress.completedLessons.length}',
                ),
                const Divider(),
                _DetailRow(
                  icon: Icons.lock_open_rounded,
                  label: 'Lessons Unlocked',
                  value: '${progress.unlockedLessons.length}',
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  String _formatDate(DateTime date) {
    return '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';
  }
}

class _DetailRow extends StatelessWidget {
  final String label;
  final String value;
  final IconData? icon;

  const _DetailRow({
    required this.label,
    required this.value,
    this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        if (icon != null) ...[
          Icon(icon, size: 20, color: AppColors.textSecondary),
          const SizedBox(width: AppSpacing.sm),
        ],
        Expanded(
          child: Text(
            label,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: AppColors.textSecondary,
                ),
          ),
        ),
        Flexible(
          child: Text(
            value,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
            textAlign: TextAlign.end,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }
}
