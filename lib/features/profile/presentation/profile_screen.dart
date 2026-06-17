import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fl_chart/fl_chart.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/providers/app_providers.dart';
import '../../../core/navigation/app_navigator.dart';
import '../../../core/widgets/glass_card.dart';
import '../../../core/widgets/floating_card.dart';
import '../../profile/presentation/profile_setup_screen.dart';
import '../../../core/widgets/gradient_button.dart';
import '../../../core/widgets/progress_ring.dart';
import '../../../core/gamification/gamification_constants.dart';
import '../../../core/gamification/gamification_rules.dart';
import '../../../core/models/badge_definition.dart';
import '../../../core/models/user_models.dart' as user_models;
import '../../auth/presentation/create_account_screen.dart';
import '../../leaderboard/presentation/leaderboard_screen.dart';
import '../../settings/presentation/settings_screen.dart';
import '../../../core/localization/app_strings.dart';

// Import types directly for convenience
typedef UserProfile = user_models.UserProfile;
typedef ProgressState = user_models.ProgressState;
typedef BadgeModel = user_models.Badge;

class ProfileScreen extends ConsumerStatefulWidget {
  const ProfileScreen({super.key});

  @override
  ConsumerState<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends ConsumerState<ProfileScreen> {
  void _openLeaderboard() {
    Navigator.of(context).pushUltraSmooth(const LeaderboardScreen());
  }

  Future<void> _signOut() async {
    await FirebaseAuth.instance.signOut();
    if (!mounted) return;
    Navigator.of(context).pushAndRemoveUntilUltraSmooth(
      const CreateAccountScreen(),
      (route) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final user = ref.watch(userProfileProvider);
    final progress = ref.watch(progressProvider);
    final lessonBadges = ref.watch(badgesProvider);
    final leaderboardAsync = ref.watch(leaderboardProvider);
    final leaderboardRank = leaderboardAsync.maybeWhen(
      data: (profiles) {
        final rankIndex =
            profiles.indexWhere((profile) => profile.id == user.id);
        return rankIndex >= 0 ? rankIndex + 1 : null;
      },
      orElse: () => null,
    );
    // Get all badges from gamification system
    const allBadges = BadgeDefinitions.allBadges;

    return Scaffold(
      backgroundColor: Colors.transparent,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.only(bottom: AppSpacing.xl),
          child: Column(
            children: [
              // Header
              Padding(
                padding: const EdgeInsets.all(AppSpacing.lg),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      context.t('profile'),
                      style: Theme.of(context)
                          .textTheme
                          .displaySmall
                          ?.copyWith(fontWeight: FontWeight.w800),
                    ),
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          icon: const Icon(Icons.emoji_events_rounded),
                          color: AppColors.achievementGold,
                          onPressed: _openLeaderboard,
                          tooltip: context.t('leaderboard'),
                        ),
                        IconButton(
                          icon: const Icon(Icons.settings_rounded),
                          color: scheme.onSurfaceVariant,
                          onPressed: () {
                            Navigator.of(context)
                                .pushUltraSmooth(const SettingsScreen());
                          },
                          tooltip: context.t('settings'),
                        ),
                      ],
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
                      Stack(
                        alignment: Alignment.topRight,
                        children: [
                          Container(
                            width: 100,
                            height: 100,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: AppColors.secondary.withOpacityValue(0.18),
                            ),
                            child: Center(
                              child: Container(
                                width: 86,
                                height: 86,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: scheme.surface,
                                ),
                                child: _ProfileAvatar(
                                  avatarUrl: user.avatarUrl,
                                  emoji: user.avatarEmoji,
                                ),
                              ),
                            ),
                          ),
                          Positioned(
                            right: 4,
                            top: 4,
                            child: FloatingActionButton.small(
                              heroTag: 'editProfile',
                              backgroundColor: AppColors.primary,
                              onPressed: () {
                                Navigator.of(context).pushUltraSmooth(
                                  const ProfileSetupScreen(isFirstTime: false),
                                );
                              },
                              child: const Icon(Icons.edit_rounded, size: 18),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: AppSpacing.md),
                      Text(
                        user.displayName ?? context.t('learner'),
                        style: Theme.of(context)
                            .textTheme
                            .headlineMedium
                            ?.copyWith(fontWeight: FontWeight.w800),
                      ),
                      const SizedBox(height: AppSpacing.xs),
                      Text(
                        context.t('level_title', args: {
                          'level': '${user.level}',
                          'title': LevelSystem.getLevelTitle(user.level),
                        }),
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                              color: scheme.onSurfaceVariant,
                            ),
                      ),
                      const SizedBox(height: AppSpacing.lg),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          _QuickStat(
                            icon: Icons.star_rounded,
                            label: context.t('points'),
                            value: '${user.totalXp}',
                            color: AppColors.achievementGold,
                          ),
                          _QuickStat(
                            icon: Icons.public_rounded,
                            label: context.t('level'),
                            value: '${user.level}',
                            color: AppColors.highlight,
                          ),
                          _QuickStat(
                            icon: Icons.local_fire_department_rounded,
                            label: context.t('streak'),
                            value: '${user.currentStreak}',
                            color: AppColors.secondary,
                          ),
                        ],
                      ),
                      const SizedBox(height: AppSpacing.lg),
                      _ProfileRankCard(
                        rank: leaderboardRank,
                        onTap: _openLeaderboard,
                      ),
                    ],
                  ),
                ),
              ),

              _BadgesTab(
                user: user,
                progress: progress,
                lessonBadges: lessonBadges,
                allBadges: allBadges,
              ),
              _StatsTab(user: user, progress: progress),
              const SizedBox(height: AppSpacing.sm),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
                child: GradientButton(
                  label: context.t('sign_out'),
                  icon: Icons.logout_rounded,
                  onPressed: _signOut,
                  width: double.infinity,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _QuickStat extends StatelessWidget {
  final IconData icon;
  final String value;
  final String label;
  final Color color;

  const _QuickStat({
    required this.icon,
    required this.value,
    required this.label,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: color.withOpacityValue(0.15),
            shape: BoxShape.circle,
            border: Border.all(color: color.withOpacityValue(0.4)),
          ),
          child: Icon(icon, color: color, size: 22),
        ),
        const SizedBox(height: AppSpacing.xs),
        Text(
          value,
          style: Theme.of(context)
              .textTheme
              .titleMedium
              ?.copyWith(fontWeight: FontWeight.w800),
        ),
        Text(
          label,
          style: Theme.of(context).textTheme.labelSmall?.copyWith(
                color: scheme.onSurfaceVariant,
              ),
        ),
      ],
    );
  }
}

class _ProfileRankCard extends StatelessWidget {
  final int? rank;
  final VoidCallback onTap;

  const _ProfileRankCard({
    required this.rank,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final rankLabel = rank == null ? '--' : '#$rank';

    return FloatingCard(
      onTap: onTap,
      padding: const EdgeInsets.all(AppSpacing.md),
      child: Row(
        children: [
          Container(
            width: 56,
            height: 56,
            decoration: const BoxDecoration(
              color: AppColors.primary,
              shape: BoxShape.circle,
            ),
            child: Center(
              child: Text(
                rankLabel,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.w900,
                ),
              ),
            ),
          ),
          const SizedBox(width: AppSpacing.md),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  context.t('your_rank'),
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w700,
                      ),
                ),
                const SizedBox(height: AppSpacing.xs),
                Text(
                  context.t('leaderboard'),
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: scheme.onSurfaceVariant,
                      ),
                ),
              ],
            ),
          ),
          Icon(
            Icons.arrow_forward_rounded,
            color: scheme.onSurfaceVariant,
          ),
        ],
      ),
    );
  }
}

class _ProfileAvatar extends StatelessWidget {
  final String? avatarUrl;
  final String? emoji;

  const _ProfileAvatar({this.avatarUrl, this.emoji});

  @override
  Widget build(BuildContext context) {
    if (avatarUrl != null && avatarUrl!.isNotEmpty) {
      final targetPixels =
          (86 * MediaQuery.devicePixelRatioOf(context)).round();
      return ClipOval(
        child: Image.network(
          avatarUrl!,
          width: 86,
          height: 86,
          cacheWidth: targetPixels,
          cacheHeight: targetPixels,
          fit: BoxFit.cover,
          errorBuilder: (_, __, ___) => const Icon(
            Icons.self_improvement_rounded,
            size: 48,
            color: Colors.white,
          ),
        ),
      );
    }
    if (emoji != null && emoji!.trim().isNotEmpty) {
      return Text(
        emoji!,
        style: const TextStyle(fontSize: 40),
      );
    }
    return const Icon(Icons.self_improvement_rounded,
        size: 48, color: Colors.white);
  }
}

class _BadgesTab extends StatelessWidget {
  final UserProfile user;
  final ProgressState progress;
  final List<BadgeDefinition> lessonBadges;
  final List<BadgeModel> allBadges;

  const _BadgesTab({
    required this.user,
    required this.progress,
    required this.lessonBadges,
    required this.allBadges,
  });

  /// The `BadgeDefinitions.allBadges` IDs are never written to
  /// `progress.earnedBadges` (only `BADGE_*` lesson IDs are), so these
  /// achievements would otherwise stay permanently locked. Derive their
  /// earned state from data we already track. `guru_seeker` has no persisted
  /// counter, so it is intentionally hidden rather than shown forever-locked.
  bool _isGamificationBadgeEarned(String badgeId) {
    switch (badgeId) {
      case 'first_steps':
        return progress.completedLessons.isNotEmpty;
      case 'week_warrior':
        return user.longestStreak >= 7;
      case 'perfect_score':
        return progress.lessonProgress.values
            .any((lesson) => lesson.bestScore >= 100);
      case 'unit_master':
        return progress.earnedBadges.contains('BADGE_UNIT_MASTER');
      case 'streak_legend':
        return user.longestStreak >= 30;
      default:
        return progress.earnedBadges.contains(badgeId);
    }
  }

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    // Combine all badges
    final combinedBadges = <_BadgeDisplay>[];
    final seenBadgeIds = <String>{};

    // Add lesson badges (BadgeDefinition)
    for (final badge in lessonBadges) {
      final isEarned = progress.earnedBadges.contains(badge.id);
      seenBadgeIds.add(badge.id);
      combinedBadges.add(_BadgeDisplay(
        id: badge.id,
        name: badge.name,
        description: badge.description,
        isEarned: isEarned,
      ));
    }

    // Add gamification badges (Badge)
    for (final badge in allBadges) {
      // No persisted counter exists for this one, so it can never reflect
      // reality — hide it instead of showing a permanently-locked badge.
      if (badge.id == 'guru_seeker') continue;
      // Skip if already added as lesson badge
      if (!seenBadgeIds.add(badge.id)) continue;

      combinedBadges.add(_BadgeDisplay(
        id: badge.id,
        name: badge.name,
        description: badge.description,
        isEarned: _isGamificationBadgeEarned(badge.id),
      ));
    }

    return Padding(
      padding: const EdgeInsets.all(AppSpacing.lg),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            context.t('your_badges'),
            style: Theme.of(context).textTheme.titleLarge,
          ),
          const SizedBox(height: AppSpacing.sm),
          Text(
            context.t('earned_of_total', args: {
              'earned': '${combinedBadges.where((b) => b.isEarned).length}',
              'total': '${combinedBadges.length}'
            }),
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: scheme.onSurfaceVariant,
                ),
          ),
          const SizedBox(height: AppSpacing.lg),
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
              maxCrossAxisExtent: 180,
              crossAxisSpacing: AppSpacing.md,
              mainAxisSpacing: AppSpacing.md,
              childAspectRatio: 0.95,
            ),
            itemCount: combinedBadges.length,
            itemBuilder: (context, index) {
              final badge = combinedBadges[index];

              return FloatingCard(
                onTap: () => _showBadgeDetails(context, badge),
                padding: const EdgeInsets.all(AppSpacing.sm),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      width: 52,
                      height: 52,
                      decoration: BoxDecoration(
                        color: badge.isEarned
                            ? AppColors.secondary.withOpacityValue(0.16)
                            : scheme.surfaceContainerHighest,
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: badge.isEarned
                              ? AppColors.secondary
                              : scheme.outline,
                          width: 2,
                        ),
                      ),
                      child: Stack(
                        alignment: Alignment.center,
                        children: [
                          Icon(
                            Icons.workspace_premium_rounded,
                            size: 26,
                            color: badge.isEarned
                                ? AppColors.secondary
                                : scheme.onSurfaceVariant,
                          ),
                          if (!badge.isEarned)
                            Container(
                              decoration: BoxDecoration(
                                color: scheme.surface.withOpacityValue(0.7),
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
                      style: Theme.of(context).textTheme.labelSmall?.copyWith(
                            color: badge.isEarned
                                ? scheme.onSurface
                                : scheme.onSurfaceVariant,
                            fontWeight: badge.isEarned
                                ? FontWeight.w600
                                : FontWeight.w400,
                          ),
                    ),
                  ],
                ),
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
      builder: (context) {
        final scheme = Theme.of(context).colorScheme;
        return Dialog(
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
                    color: badge.isEarned
                        ? AppColors.secondary.withOpacityValue(0.16)
                        : scheme.surfaceContainerHighest,
                    shape: BoxShape.circle,
                    border: Border.all(
                      color:
                          badge.isEarned ? AppColors.secondary : scheme.outline,
                      width: 4,
                    ),
                  ),
                  child: Icon(
                    Icons.workspace_premium_rounded,
                    size: 50,
                    color: badge.isEarned
                        ? AppColors.secondary
                        : scheme.onSurfaceVariant,
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
                      color: AppColors.warning.withOpacityValue(0.1),
                      borderRadius: BorderRadius.circular(AppRadius.small),
                      border: Border.all(
                          color: AppColors.warning.withOpacityValue(0.3)),
                    ),
                    child: Text(
                      context.t('locked_badge'),
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: AppColors.warning,
                          ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                const SizedBox(height: AppSpacing.lg),
                GradientButton(
                  label: context.t('close'),
                  onPressed: () => Navigator.of(context).pop(),
                  width: double.infinity,
                ),
              ],
            ),
          ),
        );
      },
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
    final scheme = Theme.of(context).colorScheme;
    final totalLessonsCompleted = progress.completedLessons.length;
    final levelProgress =
        LevelSystem.getLevelProgress(user.level, user.totalXp);
    final dayLabels = _buildWeekdayLabels(context);
    final activityCounts = _buildWeeklyLessonCounts(progress);
    final trendPoints = List.generate(
      7,
      (i) => FlSpot(i.toDouble(), activityCounts[i].toDouble()),
    );
    final maxCount = activityCounts.reduce((a, b) => a > b ? a : b);
    final chartMaxY = (maxCount == 0 ? 1 : maxCount + 1).toDouble();

    return Padding(
      padding: const EdgeInsets.all(AppSpacing.lg),
      child: Column(
        children: [
          FloatingCard(
            padding: const EdgeInsets.all(AppSpacing.lg),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(context.t('progress'),
                        style: Theme.of(context).textTheme.titleMedium),
                    Text('${(levelProgress * 100).round()}%',
                        style: Theme.of(context).textTheme.titleMedium),
                  ],
                ),
                const SizedBox(height: AppSpacing.md),
                Row(
                  children: [
                    ProgressRing(
                      progress: levelProgress,
                      size: 120,
                      strokeWidth: 10,
                      color: AppColors.primary,
                      backgroundColor: scheme.surfaceContainerHighest,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            '${(levelProgress * 100).round()}%',
                            style: Theme.of(context)
                                .textTheme
                                .titleLarge
                                ?.copyWith(fontWeight: FontWeight.w800),
                          ),
                          Text(
                            context.t('level_num',
                                args: {'level': '${user.level}'}),
                            style: Theme.of(context)
                                .textTheme
                                .labelSmall
                                ?.copyWith(color: scheme.onSurfaceVariant),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: AppSpacing.lg),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            context.t('keep_going'),
                            style:
                                Theme.of(context).textTheme.bodySmall?.copyWith(
                                      color: scheme.onSurfaceVariant,
                                    ),
                          ),
                          const SizedBox(height: AppSpacing.sm),
                          _DetailRow(
                            label: context.t('xp_to_next_level'),
                            value:
                                '${LevelSystem.getXpNeededForNextLevel(user.level, user.totalXp)}',
                            icon: Icons.trending_up,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: AppSpacing.sm),
              ],
            ),
          ),
          const SizedBox(height: AppSpacing.md),
          FloatingCard(
            padding: const EdgeInsets.all(AppSpacing.lg),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(context.t('activity'),
                    style: Theme.of(context).textTheme.titleMedium),
                const SizedBox(height: AppSpacing.md),
                SizedBox(
                  height: 200,
                  child: LineChart(
                    LineChartData(
                      minX: 0,
                      maxX: 6,
                      minY: 0,
                      maxY: chartMaxY,
                      titlesData: FlTitlesData(
                        bottomTitles: AxisTitles(
                          sideTitles: SideTitles(
                            showTitles: true,
                            getTitlesWidget: (value, meta) {
                              if (value.toInt() < 0 ||
                                  value.toInt() >= dayLabels.length) {
                                return const SizedBox.shrink();
                              }
                              return Padding(
                                padding: const EdgeInsets.only(top: 8),
                                child: Text(dayLabels[value.toInt()],
                                    style:
                                        Theme.of(context).textTheme.labelSmall),
                              );
                            },
                            interval: 1,
                          ),
                        ),
                        leftTitles: const AxisTitles(
                          sideTitles: SideTitles(showTitles: false),
                        ),
                        rightTitles: const AxisTitles(
                            sideTitles: SideTitles(showTitles: false)),
                        topTitles: const AxisTitles(
                            sideTitles: SideTitles(showTitles: false)),
                      ),
                      gridData: FlGridData(
                        show: true,
                        drawVerticalLine: false,
                        getDrawingHorizontalLine: (value) => FlLine(
                          color: scheme.outline,
                          strokeWidth: 1,
                        ),
                      ),
                      lineTouchData: LineTouchData(
                        handleBuiltInTouches: true,
                        touchTooltipData: LineTouchTooltipData(
                          tooltipRoundedRadius: 12,
                          tooltipPadding: const EdgeInsets.symmetric(
                              horizontal: 12, vertical: 8),
                          getTooltipItems: (touchedSpots) {
                            return touchedSpots.map((spot) {
                              final index = spot.x
                                  .toInt()
                                  .clamp(0, activityCounts.length - 1);
                              final count = activityCounts[index];
                              final label = count == 1
                                  ? context.t('lesson_singular')
                                  : context.t('lessons_plural');
                              return LineTooltipItem(
                                '$count $label',
                                Theme.of(context)
                                        .textTheme
                                        .labelSmall
                                        ?.copyWith(
                                          color: scheme.onSurface,
                                        ) ??
                                    const TextStyle(color: Colors.white),
                              );
                            }).toList();
                          },
                        ),
                      ),
                      borderData: FlBorderData(show: false),
                      lineBarsData: [
                        LineChartBarData(
                          isCurved: true,
                          spots: trendPoints,
                          color: AppColors.primary,
                          barWidth: 3,
                          belowBarData: BarAreaData(
                            show: true,
                            color: AppColors.primary.withOpacityValue(0.12),
                          ),
                          dotData: const FlDotData(show: true),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: AppSpacing.sm),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: _DetailRow(
                        label: context.t('lessons_completed_stat'),
                        value: '$totalLessonsCompleted',
                        icon: Icons.check_circle,
                      ),
                    ),
                    const SizedBox(width: AppSpacing.md),
                    Expanded(
                      child: _DetailRow(
                        label: context.t('badges_label'),
                        value: '${progress.earnedBadges.length}',
                        icon: Icons.workspace_premium,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  List<int> _buildWeeklyLessonCounts(ProgressState progress) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final counts = List<int>.filled(7, 0);

    for (final lesson in progress.lessonProgress.values) {
      final completedAt = lesson.lastCompletedAt;
      if (completedAt == null) continue;
      final completedDay = DateTime(
        completedAt.year,
        completedAt.month,
        completedAt.day,
      );
      final diff = today.difference(completedDay).inDays;
      if (diff < 0 || diff > 6) continue;
      final index = 6 - diff;
      counts[index] += 1;
    }

    return counts;
  }

  List<String> _buildWeekdayLabels(BuildContext context) {
    final keys = [
      'day_initial_mon',
      'day_initial_tue',
      'day_initial_wed',
      'day_initial_thu',
      'day_initial_fri',
      'day_initial_sat',
      'day_initial_sun',
    ];
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    return List.generate(7, (index) {
      final day = today.subtract(Duration(days: 6 - index));
      return context.t(keys[(day.weekday - 1) % 7]);
    });
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
    final scheme = Theme.of(context).colorScheme;
    return Row(
      children: [
        if (icon != null) ...[
          Icon(icon, size: 20, color: scheme.onSurfaceVariant),
          const SizedBox(width: AppSpacing.sm),
        ],
        Expanded(
          child: Text(
            label,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: scheme.onSurfaceVariant,
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
