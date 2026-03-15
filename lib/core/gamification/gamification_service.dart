import 'dart:math' as math;

import '../models/user_models.dart';
import 'gamification_rules.dart';

class LessonCompletionSummary {
  const LessonCompletionSummary({
    required this.answerXp,
    this.perfectBonusXp = 0,
    this.firstCompletionBonusXp = 0,
  });

  final int answerXp;
  final int perfectBonusXp;
  final int firstCompletionBonusXp;

  int get bonusXp => perfectBonusXp + firstCompletionBonusXp;
  int get totalXp => answerXp + bonusXp;
  bool get awardedPerfectBonus => perfectBonusXp > 0;
  bool get awardedFirstCompletionBonus => firstCompletionBonusXp > 0;
}

class PracticeCompletionSummary {
  const PracticeCompletionSummary({
    required this.answerXp,
    required this.heartsBefore,
    required this.heartsAfter,
  });

  final int answerXp;
  final int heartsBefore;
  final int heartsAfter;

  bool get heartRefilled => heartsAfter > heartsBefore;
}

class GamificationService {
  GamificationService._();

  static UserProfile applyXp(UserProfile user, int xp) {
    final updatedTotalXp = math.max(0, user.totalXp + xp);
    return user.copyWith(
      totalXp: updatedTotalXp,
      level: LevelSystem.getLevelFromXp(updatedTotalXp),
    );
  }

  static UserProfile syncHearts(
    UserProfile user, {
    DateTime? now,
  }) {
    final currentTime = now ?? DateTime.now();
    final effectiveHeartLosses =
        user.heartLossTimestamps.isEmpty && user.hearts < HeartsSystem.maxHearts
            ? List<DateTime>.generate(
                HeartsSystem.maxHearts - user.hearts,
                (_) => currentTime,
              )
            : user.heartLossTimestamps;
    final activeHeartLosses = effectiveHeartLosses
        .where(
          (lostAt) =>
              currentTime.isBefore(lostAt.add(HeartsSystem.heartRegenDuration)),
        )
        .toList()
      ..sort((a, b) => a.compareTo(b));

    final updatedHearts =
        (HeartsSystem.maxHearts - activeHeartLosses.length).clamp(
      0,
      HeartsSystem.maxHearts,
    );

    if (updatedHearts == user.hearts &&
        _timestampsMatch(activeHeartLosses, user.heartLossTimestamps)) {
      return user;
    }

    return user.copyWith(
      hearts: updatedHearts,
      heartLossTimestamps: activeHeartLosses,
    );
  }

  static UserProfile applyHeartDelta(
    UserProfile user, {
    required int delta,
    DateTime? now,
  }) {
    final currentTime = now ?? DateTime.now();
    final syncedUser = syncHearts(user, now: currentTime);
    final updatedHeartLosses =
        List<DateTime>.from(syncedUser.heartLossTimestamps)
          ..sort((a, b) => a.compareTo(b));

    if (delta < 0) {
      final heartsToLose = (-delta).clamp(0, HeartsSystem.maxHearts);
      for (var i = 0; i < heartsToLose; i++) {
        if (updatedHeartLosses.length >= HeartsSystem.maxHearts) {
          break;
        }
        updatedHeartLosses.add(currentTime);
      }
      updatedHeartLosses.sort((a, b) => a.compareTo(b));
    } else if (delta > 0) {
      final heartsToRefill = delta.clamp(0, HeartsSystem.maxHearts);
      for (var i = 0; i < heartsToRefill; i++) {
        if (updatedHeartLosses.isEmpty) {
          break;
        }
        // Keep the soonest timer intact when we refill immediately.
        updatedHeartLosses.removeLast();
      }
    }

    return syncedUser.copyWith(
      hearts: HeartsSystem.maxHearts - updatedHeartLosses.length,
      heartLossTimestamps: updatedHeartLosses,
    );
  }

  static bool _timestampsMatch(
    List<DateTime> first,
    List<DateTime> second,
  ) {
    if (identical(first, second)) return true;
    if (first.length != second.length) return false;
    for (var i = 0; i < first.length; i++) {
      if (first[i] != second[i]) {
        return false;
      }
    }
    return true;
  }

  static LessonCompletionSummary buildLessonCompletionSummary({
    required int answerXp,
    required bool isPerfectQuiz,
    required bool isFirstCompletion,
  }) {
    return LessonCompletionSummary(
      answerXp: answerXp,
      perfectBonusXp: isPerfectQuiz ? XpRewards.perfect : 0,
      firstCompletionBonusXp: isFirstCompletion ? XpRewards.firstCompletion : 0,
    );
  }

  static PracticeCompletionSummary buildPracticeCompletionSummary({
    required int answerXp,
    required int heartsBefore,
    required int heartsAfter,
  }) {
    return PracticeCompletionSummary(
      answerXp: answerXp,
      heartsBefore: heartsBefore,
      heartsAfter: heartsAfter,
    );
  }
}
