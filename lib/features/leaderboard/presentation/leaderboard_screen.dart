import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/widgets/glass_card.dart';
import '../../../core/widgets/floating_card.dart';
import '../../../core/providers/app_providers.dart';

class LeaderboardScreen extends ConsumerStatefulWidget {
  const LeaderboardScreen({super.key});

  @override
  ConsumerState<LeaderboardScreen> createState() => _LeaderboardScreenState();
}

class _LeaderboardScreenState extends ConsumerState<LeaderboardScreen> {
  bool _isWeekly = true;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final user = ref.watch(userProfileProvider);
    
    // Mock leaderboard data - in production, this would come from a provider
    final leaderboardData = _generateMockLeaderboard(user.id);

    return Scaffold(
      backgroundColor: Colors.transparent,
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            // Header
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.all(AppSpacing.lg),
                child: Column(
                  children: [
                    Text(
                      'Leaderboard',
                      style: Theme.of(context).textTheme.displaySmall,
                    ),
                    const SizedBox(height: AppSpacing.md),
                    // Toggle
                    GlassCard(
                      padding: const EdgeInsets.all(4),
                      child: Row(
                        children: [
                          Expanded(
                            child: _ToggleButton(
                              label: 'Weekly',
                              isSelected: _isWeekly,
                              onTap: () => setState(() => _isWeekly = true),
                            ),
                          ),
                          Expanded(
                            child: _ToggleButton(
                              label: 'All Time',
                              isSelected: !_isWeekly,
                              onTap: () => setState(() => _isWeekly = false),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // Podium
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
                child: _Podium(
                  top3: leaderboardData.take(3).toList(),
                  currentUserId: user.id,
                ),
              ),
            ),

            // Your Rank Card
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.all(AppSpacing.lg),
                child: _YourRankCard(
                  user: user,
                  rank: leaderboardData.indexWhere((e) => e.id == user.id) + 1,
                ),
              ),
            ),

            // Ranking List
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Rankings',
                      style: Theme.of(context).textTheme.headlineSmall,
                    ),
                    const SizedBox(height: AppSpacing.md),
                  ],
                ),
              ),
            ),

            SliverList(
              delegate: SliverChildBuilderDelegate(
                (context, index) {
                  final entry = leaderboardData[index + 3];
                  final isCurrentUser = entry.id == user.id;
                  return Padding(
                    padding: const EdgeInsets.only(bottom: AppSpacing.sm),
                    child: FloatingCard(
                      padding: const EdgeInsets.all(AppSpacing.md),
                      child: Row(
                        children: [
                          // Rank
                          SizedBox(
                            width: 40,
                            child: Text(
                              '${index + 4}',
                              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                                    color: scheme.onSurfaceVariant,
                                  ),
                              textAlign: TextAlign.center,
                            ),
                          ),
                          const SizedBox(width: AppSpacing.md),
                          // Avatar
                          CircleAvatar(
                            radius: 24,
                            backgroundColor: isCurrentUser
                                ? AppColors.primary
                                : scheme.surfaceVariant,
                            child: Text(
                              entry.name[0].toUpperCase(),
                              style: const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ),
                          const SizedBox(width: AppSpacing.md),
                          // Name & XP
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  entry.name,
                                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                        color: isCurrentUser
                                            ? AppColors.primary
                                            : scheme.onSurface,
                                        fontWeight: FontWeight.w700,
                                      ),
                                ),
                                Text(
                                  '${entry.xp} XP',
                                  style: Theme.of(context).textTheme.bodySmall,
                                ),
                              ],
                            ),
                          ),
                          // Level
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: AppSpacing.sm,
                              vertical: AppSpacing.xs,
                            ),
                            decoration: BoxDecoration(
                              color: AppColors.primary,
                              borderRadius: BorderRadius.circular(AppRadius.pill),
                            ),
                            child: Text(
                              'Lvl ${entry.level}',
                              style: const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.w700,
                                fontSize: 12,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
                childCount: leaderboardData.length - 3,
              ),
            ),

            const SliverToBoxAdapter(
              child: SizedBox(height: AppSpacing.xxl),
            ),
          ],
        ),
      ),
    );
  }

  List<_LeaderboardEntry> _generateMockLeaderboard(String currentUserId) {
    return [
      _LeaderboardEntry(id: '1', name: 'Aarav', xp: 2500, level: 8),
      _LeaderboardEntry(id: '2', name: 'Priya', xp: 2300, level: 7),
      _LeaderboardEntry(id: '3', name: 'Rohan', xp: 2100, level: 7),
      _LeaderboardEntry(id: currentUserId, name: 'You', xp: 1800, level: 6),
      _LeaderboardEntry(id: '4', name: 'Sneha', xp: 1700, level: 6),
      _LeaderboardEntry(id: '5', name: 'Kiran', xp: 1500, level: 5),
      _LeaderboardEntry(id: '6', name: 'Ananya', xp: 1300, level: 5),
      _LeaderboardEntry(id: '7', name: 'Vikram', xp: 1100, level: 4),
      _LeaderboardEntry(id: '8', name: 'Meera', xp: 900, level: 4),
      _LeaderboardEntry(id: '9', name: 'Arjun', xp: 700, level: 3),
    ]..sort((a, b) => b.xp.compareTo(a.xp));
  }
}

class _LeaderboardEntry {
  final String id;
  final String name;
  final int xp;
  final int level;

  _LeaderboardEntry({
    required this.id,
    required this.name,
    required this.xp,
    required this.level,
  });
}

class _ToggleButton extends StatelessWidget {
  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  const _ToggleButton({
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: AppSpacing.sm),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.primary : Colors.transparent,
          borderRadius: BorderRadius.circular(AppRadius.pill),
        ),
        child: Text(
          label,
          textAlign: TextAlign.center,
          style: TextStyle(
            color: isSelected ? Colors.white : scheme.onSurfaceVariant,
            fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
          ),
        ),
      ),
    );
  }
}

class _Podium extends StatelessWidget {
  final List<_LeaderboardEntry> top3;
  final String currentUserId;

  const _Podium({
    required this.top3,
    required this.currentUserId,
  });

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    if (top3.length < 3) {
      return const SizedBox.shrink();
    }

    return Row(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        // 2nd Place
        Expanded(
          child: _PodiumPlace(
            entry: top3[1],
            place: 2,
            height: 100,
            color: scheme.onSurfaceVariant,
            isCurrentUser: top3[1].id == currentUserId,
          ),
        ),
        const SizedBox(width: AppSpacing.sm),
        // 1st Place
        Expanded(
          child: _PodiumPlace(
            entry: top3[0],
            place: 1,
            height: 140,
            color: AppColors.achievementGold,
            isCurrentUser: top3[0].id == currentUserId,
          ),
        ),
        const SizedBox(width: AppSpacing.sm),
        // 3rd Place
        Expanded(
          child: _PodiumPlace(
            entry: top3[2],
            place: 3,
            height: 80,
            color: AppColors.warning,
            isCurrentUser: top3[2].id == currentUserId,
          ),
        ),
      ],
    );
  }
}

class _PodiumPlace extends StatelessWidget {
  final _LeaderboardEntry entry;
  final int place;
  final double height;
  final Color color;
  final bool isCurrentUser;

  const _PodiumPlace({
    required this.entry,
    required this.place,
    required this.height,
    required this.color,
    required this.isCurrentUser,
  });

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Column(
      children: [
        // Avatar
        Container(
          width: 60,
          height: 60,
          decoration: BoxDecoration(
            color: place == 1 ? AppColors.primary : scheme.surface,
            shape: BoxShape.circle,
            border: Border.all(
              color: color,
              width: 3,
            ),
          ),
          child: Center(
            child: place == 1
                ? const Icon(Icons.emoji_events_rounded, color: Colors.white, size: 32)
                : Text(
                    entry.name[0].toUpperCase(),
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w800,
                      fontSize: 24,
                    ),
                  ),
          ),
        ),
        const SizedBox(height: AppSpacing.sm),
        // Name
        Text(
          entry.name,
          style: Theme.of(context).textTheme.titleSmall?.copyWith(
                color: isCurrentUser ? AppColors.primary : scheme.onSurface,
                fontWeight: FontWeight.w700,
              ),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
        const SizedBox(height: AppSpacing.xs),
        // XP
        Text(
          '${entry.xp} XP',
          style: Theme.of(context).textTheme.bodySmall,
        ),
        const SizedBox(height: AppSpacing.sm),
        // Podium
        Container(
          height: height,
          decoration: BoxDecoration(
            color: color.withOpacityValue(0.85),
            borderRadius: const BorderRadius.vertical(
              top: Radius.circular(AppRadius.card),
            ),
          ),
          child: Center(
            child: Text(
              '$place',
              style: const TextStyle(
                color: Colors.white,
                fontSize: 32,
                fontWeight: FontWeight.w900,
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class _YourRankCard extends StatelessWidget {
  final dynamic user;
  final int rank;

  const _YourRankCard({
    required this.user,
    required this.rank,
  });

  @override
  Widget build(BuildContext context) {
    return GlassCard(
      padding: const EdgeInsets.all(AppSpacing.lg),
      borderColor: AppColors.primary,
      borderWidth: 2,
      child: Row(
        children: [
          Container(
            width: 60,
            height: 60,
            decoration: BoxDecoration(
              color: AppColors.primary,
              shape: BoxShape.circle,
            ),
            child: Center(
              child: Text(
                '$rank',
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 24,
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
                  'Your Rank',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        color: AppColors.primary,
                        fontWeight: FontWeight.w700,
                      ),
                ),
                Text(
                  '${user.totalXp} XP • Level ${user.level}',
                  style: Theme.of(context).textTheme.bodySmall,
                ),
              ],
            ),
          ),
          const Icon(
            Icons.trending_up_rounded,
            color: AppColors.primary,
            size: 32,
          ),
        ],
      ),
    );
  }
}
