import 'package:equatable/equatable.dart';
import 'package:hive/hive.dart';

part 'user_models.g.dart';

// ============================================================================
// User Profile
// ============================================================================

@HiveType(typeId: 0)
class UserProfile extends Equatable {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final String? displayName;

  @HiveField(2)
  final int totalXp;

  @HiveField(3)
  final int level;

  @HiveField(4)
  final int currentStreak;

  @HiveField(5)
  final int longestStreak;

  @HiveField(6)
  final int hearts;

  @HiveField(7)
  final DateTime? lastActivityDate;

  @HiveField(8)
  final int streakFreezes;

  @HiveField(9)
  final DateTime createdAt;

  const UserProfile({
    required this.id,
    this.displayName,
    this.totalXp = 0,
    this.level = 1,
    this.currentStreak = 0,
    this.longestStreak = 0,
    this.hearts = 5,
    this.lastActivityDate,
    this.streakFreezes = 1,
    required this.createdAt,
  });

  UserProfile copyWith({
    String? id,
    String? displayName,
    int? totalXp,
    int? level,
    int? currentStreak,
    int? longestStreak,
    int? hearts,
    DateTime? lastActivityDate,
    int? streakFreezes,
    DateTime? createdAt,
  }) {
    return UserProfile(
      id: id ?? this.id,
      displayName: displayName ?? this.displayName,
      totalXp: totalXp ?? this.totalXp,
      level: level ?? this.level,
      currentStreak: currentStreak ?? this.currentStreak,
      longestStreak: longestStreak ?? this.longestStreak,
      hearts: hearts ?? this.hearts,
      lastActivityDate: lastActivityDate ?? this.lastActivityDate,
      streakFreezes: streakFreezes ?? this.streakFreezes,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  static const int maxHearts = 5;

  int get xpForNextLevel => 50 * level;
  int get xpProgressInLevel => totalXp - _totalXpForLevel(level - 1);
  int get xpNeededForLevel => xpForNextLevel - xpProgressInLevel;

  static int _totalXpForLevel(int level) {
    if (level <= 0) return 0;
    // Sum of 50*1 + 50*2 + ... + 50*level = 50 * level * (level + 1) / 2
    return 25 * level * (level + 1);
  }

  double get levelProgress {
    final neededForThisLevel = 50 * level;
    return xpProgressInLevel / neededForThisLevel;
  }

  @override
  List<Object?> get props => [
        id,
        displayName,
        totalXp,
        level,
        currentStreak,
        longestStreak,
        hearts,
        lastActivityDate,
        streakFreezes,
        createdAt,
      ];
}

// ============================================================================
// Progress State
// ============================================================================

@HiveType(typeId: 1)
class ProgressState extends Equatable {
  @HiveField(0)
  final Map<String, LessonProgress> lessonProgress;

  @HiveField(1)
  final List<String> completedLessons;

  @HiveField(2)
  final List<String> unlockedLessons;

  @HiveField(3)
  final List<String> earnedBadges;

  const ProgressState({
    this.lessonProgress = const {},
    this.completedLessons = const [],
    this.unlockedLessons = const ['U01_L01'],
    this.earnedBadges = const [],
  });

  ProgressState copyWith({
    Map<String, LessonProgress>? lessonProgress,
    List<String>? completedLessons,
    List<String>? unlockedLessons,
    List<String>? earnedBadges,
  }) {
    return ProgressState(
      lessonProgress: lessonProgress ?? this.lessonProgress,
      completedLessons: completedLessons ?? this.completedLessons,
      unlockedLessons: unlockedLessons ?? this.unlockedLessons,
      earnedBadges: earnedBadges ?? this.earnedBadges,
    );
  }

  bool isLessonCompleted(String lessonId) => completedLessons.contains(lessonId);
  bool isLessonUnlocked(String lessonId) => unlockedLessons.contains(lessonId);
  bool hasBadge(String badgeId) => earnedBadges.contains(badgeId);

  @override
  List<Object?> get props => [
        lessonProgress,
        completedLessons,
        unlockedLessons,
        earnedBadges,
      ];
}

// ============================================================================
// Lesson Progress
// ============================================================================

@HiveType(typeId: 2)
class LessonProgress extends Equatable {
  @HiveField(0)
  final String lessonId;

  @HiveField(1)
  final bool isCompleted;

  @HiveField(2)
  final int timesCompleted;

  @HiveField(3)
  final int bestScore;

  @HiveField(4)
  final int totalXpEarned;

  @HiveField(5)
  final DateTime? firstCompletedAt;

  @HiveField(6)
  final DateTime? lastCompletedAt;

  @HiveField(7)
  final DateTime? lastReplayBonusAt;

  const LessonProgress({
    required this.lessonId,
    this.isCompleted = false,
    this.timesCompleted = 0,
    this.bestScore = 0,
    this.totalXpEarned = 0,
    this.firstCompletedAt,
    this.lastCompletedAt,
    this.lastReplayBonusAt,
  });

  LessonProgress copyWith({
    String? lessonId,
    bool? isCompleted,
    int? timesCompleted,
    int? bestScore,
    int? totalXpEarned,
    DateTime? firstCompletedAt,
    DateTime? lastCompletedAt,
    DateTime? lastReplayBonusAt,
  }) {
    return LessonProgress(
      lessonId: lessonId ?? this.lessonId,
      isCompleted: isCompleted ?? this.isCompleted,
      timesCompleted: timesCompleted ?? this.timesCompleted,
      bestScore: bestScore ?? this.bestScore,
      totalXpEarned: totalXpEarned ?? this.totalXpEarned,
      firstCompletedAt: firstCompletedAt ?? this.firstCompletedAt,
      lastCompletedAt: lastCompletedAt ?? this.lastCompletedAt,
      lastReplayBonusAt: lastReplayBonusAt ?? this.lastReplayBonusAt,
    );
  }

  bool get canGetReplayBonus {
    if (lastReplayBonusAt == null) return true;
    final hoursSinceLastBonus =
        DateTime.now().difference(lastReplayBonusAt!).inHours;
    return hoursSinceLastBonus >= 12;
  }

  @override
  List<Object?> get props => [
        lessonId,
        isCompleted,
        timesCompleted,
        bestScore,
        totalXpEarned,
        firstCompletedAt,
        lastCompletedAt,
        lastReplayBonusAt,
      ];
}

// ============================================================================
// Attempt Log (for spaced repetition)
// ============================================================================

@HiveType(typeId: 3)
class AttemptLog extends Equatable {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final String questionId;

  @HiveField(2)
  final String lessonId;

  @HiveField(3)
  final bool isCorrect;

  @HiveField(4)
  final int responseTimeMs;

  @HiveField(5)
  final DateTime attemptedAt;

  @HiveField(6)
  final int spacedRepetitionInterval;

  @HiveField(7)
  final DateTime? nextReviewDate;

  const AttemptLog({
    required this.id,
    required this.questionId,
    required this.lessonId,
    required this.isCorrect,
    required this.responseTimeMs,
    required this.attemptedAt,
    this.spacedRepetitionInterval = 1,
    this.nextReviewDate,
  });

  AttemptLog copyWith({
    String? id,
    String? questionId,
    String? lessonId,
    bool? isCorrect,
    int? responseTimeMs,
    DateTime? attemptedAt,
    int? spacedRepetitionInterval,
    DateTime? nextReviewDate,
  }) {
    return AttemptLog(
      id: id ?? this.id,
      questionId: questionId ?? this.questionId,
      lessonId: lessonId ?? this.lessonId,
      isCorrect: isCorrect ?? this.isCorrect,
      responseTimeMs: responseTimeMs ?? this.responseTimeMs,
      attemptedAt: attemptedAt ?? this.attemptedAt,
      spacedRepetitionInterval:
          spacedRepetitionInterval ?? this.spacedRepetitionInterval,
      nextReviewDate: nextReviewDate ?? this.nextReviewDate,
    );
  }

  // Spaced repetition grade based on performance
  SpacedRepetitionGrade get grade {
    if (!isCorrect) return SpacedRepetitionGrade.again;
    if (responseTimeMs < 3000) return SpacedRepetitionGrade.easy;
    return SpacedRepetitionGrade.good;
  }

  @override
  List<Object?> get props => [
        id,
        questionId,
        lessonId,
        isCorrect,
        responseTimeMs,
        attemptedAt,
        spacedRepetitionInterval,
        nextReviewDate,
      ];
}

enum SpacedRepetitionGrade {
  again,
  good,
  easy,
}

// ============================================================================
// Notification Preferences
// ============================================================================

@HiveType(typeId: 4)
class NotificationPrefs extends Equatable {
  @HiveField(0)
  final bool enableNotifications;

  @HiveField(1)
  final String quietHoursStart;

  @HiveField(2)
  final String quietHoursEnd;

  @HiveField(3)
  final List<int> reminderDays; // 1-7 for Mon-Sun

  @HiveField(4)
  final String reminderTime;

  @HiveField(5)
  final bool learningReminders;

  @HiveField(6)
  final bool ahimsaPrompts;

  @HiveField(7)
  final bool reflectionPrompts;

  @HiveField(8)
  final bool streakRiskAlerts;

  const NotificationPrefs({
    this.enableNotifications = true,
    this.quietHoursStart = '22:00',
    this.quietHoursEnd = '07:00',
    this.reminderDays = const [1, 2, 3, 4, 5, 6, 7],
    this.reminderTime = '19:30',
    this.learningReminders = true,
    this.ahimsaPrompts = true,
    this.reflectionPrompts = true,
    this.streakRiskAlerts = true,
  });

  NotificationPrefs copyWith({
    bool? enableNotifications,
    String? quietHoursStart,
    String? quietHoursEnd,
    List<int>? reminderDays,
    String? reminderTime,
    bool? learningReminders,
    bool? ahimsaPrompts,
    bool? reflectionPrompts,
    bool? streakRiskAlerts,
  }) {
    return NotificationPrefs(
      enableNotifications: enableNotifications ?? this.enableNotifications,
      quietHoursStart: quietHoursStart ?? this.quietHoursStart,
      quietHoursEnd: quietHoursEnd ?? this.quietHoursEnd,
      reminderDays: reminderDays ?? this.reminderDays,
      reminderTime: reminderTime ?? this.reminderTime,
      learningReminders: learningReminders ?? this.learningReminders,
      ahimsaPrompts: ahimsaPrompts ?? this.ahimsaPrompts,
      reflectionPrompts: reflectionPrompts ?? this.reflectionPrompts,
      streakRiskAlerts: streakRiskAlerts ?? this.streakRiskAlerts,
    );
  }

  @override
  List<Object?> get props => [
        enableNotifications,
        quietHoursStart,
        quietHoursEnd,
        reminderDays,
        reminderTime,
        learningReminders,
        ahimsaPrompts,
        reflectionPrompts,
        streakRiskAlerts,
      ];
}

// ============================================================================
// Badge Model
// ============================================================================

class Badge extends Equatable {
  final String id;
  final String name;
  final String description;
  final String iconPath;
  final String trigger;

  const Badge({
    required this.id,
    required this.name,
    required this.description,
    required this.iconPath,
    required this.trigger,
  });

  @override
  List<Object?> get props => [id, name, description, iconPath, trigger];
}
