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

  static UserProfile applyHeartDelta(UserProfile user, {required int delta}) {
    final updatedHearts =
        (user.hearts + delta).clamp(0, HeartsSystem.maxHearts).toInt();
    return user.copyWith(hearts: updatedHearts);
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
