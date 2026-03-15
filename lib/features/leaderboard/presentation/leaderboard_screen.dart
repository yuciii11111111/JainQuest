import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/localization/app_strings.dart';
import '../../../core/models/user_models.dart';
import '../../../core/providers/app_providers.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/widgets/floating_card.dart';
import '../../../core/widgets/glass_card.dart';

final leaderboardProvider =
    StreamProvider.autoDispose<List<UserProfile>>((ref) {
  return FirebaseFirestore.instance
      .collection('users')
      .orderBy('totalXp', descending: true)
      .snapshots()
      .map((snapshot) {
    final profiles = snapshot.docs
        .map((doc) => UserProfile.fromMap(doc.data(), fallbackId: doc.id))
        .toList()
      ..sort(_compareLeaderboardProfiles);
    return profiles;
  });
});

int _compareLeaderboardProfiles(UserProfile a, UserProfile b) {
  final xpComparison = b.totalXp.compareTo(a.totalXp);
  if (xpComparison != 0) {
    return xpComparison;
  }

  final levelComparison = b.level.compareTo(a.level);
  if (levelComparison != 0) {
    return levelComparison;
  }

  final nameComparison =
      _leaderboardSortKey(a).compareTo(_leaderboardSortKey(b));
  if (nameComparison != 0) {
    return nameComparison;
  }

  return a.id.compareTo(b.id);
}

String _leaderboardSortKey(UserProfile profile) {
  final displayName = profile.displayName?.trim();
  if (displayName != null && displayName.isNotEmpty) {
    return displayName.toLowerCase();
  }

  final email = profile.email?.trim();
  if (email != null && email.isNotEmpty) {
    return email.toLowerCase();
  }

  return profile.id.toLowerCase();
}

String _displayNameFor(UserProfile profile, BuildContext context) {
  final displayName = profile.displayName?.trim();
  if (displayName != null && displayName.isNotEmpty) {
    return displayName;
  }

  final email = profile.email?.trim();
  if (email != null && email.isNotEmpty) {
    final username = email.split('@').first.trim();
    if (username.isNotEmpty) {
      return username;
    }
  }

  return context.t('learner');
}

String _avatarLabel(String name) {
  final trimmedName = name.trim();
  if (trimmedName.isEmpty) {
    return '?';
  }
  return trimmedName[0].toUpperCase();
}

class LeaderboardScreen extends ConsumerWidget {
  const LeaderboardScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final scheme = Theme.of(context).colorScheme;
    final user = ref.watch(userProfileProvider);
    final leaderboardAsync = ref.watch(leaderboardProvider);

    return Scaffold(
      backgroundColor: Colors.transparent,
      body: SafeArea(
        child: leaderboardAsync.when(
          loading: () => const _LeaderboardStateCard(
            child: CircularProgressIndicator(),
          ),
          error: (_, __) => const _LeaderboardStateCard(
            child: Icon(
              Icons.emoji_events_rounded,
              size: 44,
              color: AppColors.primary,
            ),
          ),
          data: (profiles) {
            final leaderboardData = profiles
                .map(
                  (profile) => _LeaderboardEntry(
                    id: profile.id,
                    name: _displayNameFor(profile, context),
                    xp: profile.totalXp,
                    level: profile.level,
                  ),
                )
                .toList();
            final rankIndex =
                profiles.indexWhere((profile) => profile.id == user.id);
            final rank = rankIndex >= 0 ? rankIndex + 1 : null;

            return CustomScrollView(
              slivers: [
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.all(AppSpacing.lg),
                    child: Text(
                      context.t('leaderboard'),
                      style: Theme.of(context).textTheme.displaySmall,
                    ),
                  ),
                ),
                if (leaderboardData.isEmpty)
                  const SliverFillRemaining(
                    hasScrollBody: false,
                    child: _LeaderboardStateCard(
                      child: Icon(
                        Icons.people_alt_rounded,
                        size: 44,
                        color: AppColors.primary,
                      ),
                    ),
                  )
                else ...[
                  SliverToBoxAdapter(
                    child: Padding(
                      padding:
                          const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
                      child: _Podium(
                        topEntries: leaderboardData.take(3).toList(),
                        currentUserId: user.id,
                      ),
                    ),
                  ),
                  SliverToBoxAdapter(
                    child: Padding(
                      padding: const EdgeInsets.all(AppSpacing.lg),
                      child: _YourRankCard(
                        user: user,
                        rank: rank,
                      ),
                    ),
                  ),
                  SliverToBoxAdapter(
                    child: Padding(
                      padding:
                          const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            context.t('rankings'),
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
                        final entry = leaderboardData[index];
                        final isCurrentUser = entry.id == user.id;
                        final rankColor = index == 0
                            ? AppColors.achievementGold
                            : index == 1
                                ? scheme.onSurfaceVariant
                                : index == 2
                                    ? AppColors.warning
                                    : scheme.onSurfaceVariant;

                        return Padding(
                          padding: const EdgeInsets.only(bottom: AppSpacing.sm),
                          child: FloatingCard(
                            padding: const EdgeInsets.all(AppSpacing.md),
                            child: Row(
                              children: [
                                SizedBox(
                                  width: 40,
                                  child: Text(
                                    '${index + 1}',
                                    style: Theme.of(context)
                                        .textTheme
                                        .titleLarge
                                        ?.copyWith(
                                          color: isCurrentUser
                                              ? AppColors.primary
                                              : rankColor,
                                          fontWeight: FontWeight.w800,
                                        ),
                                    textAlign: TextAlign.center,
                                  ),
                                ),
                                const SizedBox(width: AppSpacing.md),
                                CircleAvatar(
                                  radius: 24,
                                  backgroundColor: isCurrentUser
                                      ? AppColors.primary
                                      : scheme.surfaceContainerHighest,
                                  child: Text(
                                    _avatarLabel(entry.name),
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ),
                                ),
                                const SizedBox(width: AppSpacing.md),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        entry.name,
                                        style: Theme.of(context)
                                            .textTheme
                                            .titleMedium
                                            ?.copyWith(
                                              color: isCurrentUser
                                                  ? AppColors.primary
                                                  : scheme.onSurface,
                                              fontWeight: FontWeight.w700,
                                            ),
                                      ),
                                      Text(
                                        '${entry.xp} ${context.t('xp')}',
                                        style: Theme.of(context)
                                            .textTheme
                                            .bodySmall,
                                      ),
                                    ],
                                  ),
                                ),
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: AppSpacing.sm,
                                    vertical: AppSpacing.xs,
                                  ),
                                  decoration: BoxDecoration(
                                    color: AppColors.primary,
                                    borderRadius:
                                        BorderRadius.circular(AppRadius.pill),
                                  ),
                                  child: Text(
                                    context.t(
                                      'level_abbreviated',
                                      args: {'level': '${entry.level}'},
                                    ),
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
                      childCount: leaderboardData.length,
                    ),
                  ),
                  const SliverToBoxAdapter(
                    child: SizedBox(height: AppSpacing.xxl),
                  ),
                ],
              ],
            );
          },
        ),
      ),
    );
  }
}

class _LeaderboardStateCard extends StatelessWidget {
  final Widget child;

  const _LeaderboardStateCard({
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.lg),
        child: GlassCard(
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.xl,
            vertical: AppSpacing.xl,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              child,
              const SizedBox(height: AppSpacing.md),
              Text(
                context.t('leaderboard'),
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.w700,
                    ),
              ),
            ],
          ),
        ),
      ),
    );
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

class _Podium extends StatelessWidget {
  final List<_LeaderboardEntry> topEntries;
  final String currentUserId;

  const _Podium({
    required this.topEntries,
    required this.currentUserId,
  });

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    if (topEntries.isEmpty) {
      return const SizedBox.shrink();
    }

    if (topEntries.length == 1) {
      return Row(
        children: [
          const Spacer(),
          Expanded(
            child: _PodiumPlace(
              entry: topEntries[0],
              place: 1,
              height: 140,
              color: AppColors.achievementGold,
              isCurrentUser: topEntries[0].id == currentUserId,
            ),
          ),
          const Spacer(),
        ],
      );
    }

    return Row(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Expanded(
          child: _PodiumPlace(
            entry: topEntries[1],
            place: 2,
            height: 100,
            color: scheme.onSurfaceVariant,
            isCurrentUser: topEntries[1].id == currentUserId,
          ),
        ),
        const SizedBox(width: AppSpacing.sm),
        Expanded(
          child: _PodiumPlace(
            entry: topEntries[0],
            place: 1,
            height: 140,
            color: AppColors.achievementGold,
            isCurrentUser: topEntries[0].id == currentUserId,
          ),
        ),
        if (topEntries.length > 2) ...[
          const SizedBox(width: AppSpacing.sm),
          Expanded(
            child: _PodiumPlace(
              entry: topEntries[2],
              place: 3,
              height: 80,
              color: AppColors.warning,
              isCurrentUser: topEntries[2].id == currentUserId,
            ),
          ),
        ],
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
    final avatarBackground =
        place == 1 ? AppColors.primary : color.withOpacityValue(0.18);
    final avatarForeground = place == 1 ? Colors.white : color;

    return Column(
      children: [
        Container(
          width: 60,
          height: 60,
          decoration: BoxDecoration(
            color: avatarBackground,
            shape: BoxShape.circle,
            border: Border.all(
              color: color,
              width: 3,
            ),
          ),
          child: Center(
            child: place == 1
                ? const Icon(
                    Icons.emoji_events_rounded,
                    color: Colors.white,
                    size: 32,
                  )
                : Text(
                    _avatarLabel(entry.name),
                    style: TextStyle(
                      color: avatarForeground,
                      fontWeight: FontWeight.w800,
                      fontSize: 24,
                    ),
                  ),
          ),
        ),
        const SizedBox(height: AppSpacing.sm),
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
        Text(
          '${entry.xp} ${context.t('xp')}',
          style: Theme.of(context).textTheme.bodySmall,
        ),
        const SizedBox(height: AppSpacing.sm),
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
  final UserProfile user;
  final int? rank;

  const _YourRankCard({
    required this.user,
    required this.rank,
  });

  @override
  Widget build(BuildContext context) {
    final rankLabel = rank == null ? '?' : '$rank';
    return GlassCard(
      padding: const EdgeInsets.all(AppSpacing.lg),
      borderColor: AppColors.primary,
      borderWidth: 2,
      child: Row(
        children: [
          Container(
            width: 60,
            height: 60,
            decoration: const BoxDecoration(
              color: AppColors.primary,
              shape: BoxShape.circle,
            ),
            child: Center(
              child: Text(
                rankLabel,
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
                  context.t('your_rank'),
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        color: AppColors.primary,
                        fontWeight: FontWeight.w700,
                      ),
                ),
                Text(
                  context.t('xp_level_stats', args: {
                    'xp': '${user.totalXp}',
                    'level': '${user.level}',
                  }),
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
