import 'package:flutter_test/flutter_test.dart';
import 'package:jainquest/core/gamification/gamification_rules.dart';
import 'package:jainquest/core/gamification/gamification_service.dart';
import 'package:jainquest/core/models/user_models.dart';

void main() {
  test('applyXp follows shared level thresholds without mutating streak date',
      () {
    final lastActivityDate = DateTime(2026, 3, 1);
    final user = UserProfile(
      id: 'user-1',
      totalXp: 50,
      level: 2,
      currentStreak: 3,
      longestStreak: 4,
      hearts: 5,
      lastActivityDate: lastActivityDate,
      createdAt: DateTime(2026, 1, 1),
    );

    final updated = GamificationService.applyXp(user, 100);

    expect(updated.totalXp, 150);
    expect(updated.level, LevelSystem.getLevelFromXp(150));
    expect(updated.lastActivityDate, lastActivityDate);
  });

  test('lesson completion summary keeps answer XP and bonus XP separate', () {
    final summary = GamificationService.buildLessonCompletionSummary(
      answerXp: 5,
      isPerfectQuiz: true,
      isFirstCompletion: true,
    );

    expect(summary.answerXp, 5);
    expect(summary.perfectBonusXp, XpRewards.perfect);
    expect(summary.firstCompletionBonusXp, XpRewards.firstCompletion);
    expect(summary.totalXp, 15);
  });

  test('practice completion summary only marks a refill when hearts increase',
      () {
    final fullHeartsSummary =
        GamificationService.buildPracticeCompletionSummary(
      answerXp: 8,
      heartsBefore: 5,
      heartsAfter: 5,
    );
    final refilledSummary = GamificationService.buildPracticeCompletionSummary(
      answerXp: 8,
      heartsBefore: 4,
      heartsAfter: 5,
    );

    expect(fullHeartsSummary.heartRefilled, isFalse);
    expect(refilledSummary.heartRefilled, isTrue);
  });

  test('applyHeartDelta clamps within the allowed heart range', () {
    final user = UserProfile(
      id: 'user-2',
      hearts: 1,
      createdAt: DateTime(2026, 1, 1),
    );

    final emptied = GamificationService.applyHeartDelta(user, delta: -3);
    final refilled = GamificationService.applyHeartDelta(user, delta: 10);

    expect(emptied.hearts, 0);
    expect(refilled.hearts, HeartsSystem.maxHearts);
  });
}
