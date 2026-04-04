import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';
import 'package:uuid/uuid.dart';

import '../gamification/gamification_rules.dart';

DateTime? _readDateTime(dynamic value) {
  if (value == null) return null;
  if (value is Timestamp) return value.toDate();
  if (value is DateTime) return value;
  if (value is String) return DateTime.tryParse(value);
  return null;
}

List<DateTime> _readDateTimes(dynamic value) {
  if (value is! List) return const <DateTime>[];
  final timestamps = value.map(_readDateTime).whereType<DateTime>().toList()
    ..sort((a, b) => a.compareTo(b));
  return timestamps;
}

// ============================================================================
// User Profile
// ============================================================================

class UserProfile extends Equatable {
  final String id;

  final String? displayName;

  final int totalXp;

  final int level;

  final int currentStreak;

  final int longestStreak;

  final int hearts;

  final List<DateTime> heartLossTimestamps;

  final DateTime? lastActivityDate;

  final int streakFreezes;

  final DateTime createdAt;

  final int? age;

  final String? email;

  final String? avatarEmoji;

  final String? avatarUrl;

  final bool showGuidedTour;

  final String preferredLanguageCode;

  const UserProfile({
    required this.id,
    this.displayName,
    this.totalXp = 0,
    this.level = 1,
    this.currentStreak = 0,
    this.longestStreak = 0,
    this.hearts = 5,
    this.heartLossTimestamps = const [],
    this.lastActivityDate,
    this.streakFreezes = 1,
    required this.createdAt,
    this.age,
    this.email,
    this.avatarEmoji,
    this.avatarUrl,
    this.showGuidedTour = false,
    this.preferredLanguageCode = 'en',
  });

  UserProfile copyWith({
    String? id,
    String? displayName,
    int? totalXp,
    int? level,
    int? currentStreak,
    int? longestStreak,
    int? hearts,
    List<DateTime>? heartLossTimestamps,
    DateTime? lastActivityDate,
    int? streakFreezes,
    DateTime? createdAt,
    int? age,
    String? email,
    String? avatarEmoji,
    String? avatarUrl,
    bool? showGuidedTour,
    String? preferredLanguageCode,
  }) {
    return UserProfile(
      id: id ?? this.id,
      displayName: displayName ?? this.displayName,
      totalXp: totalXp ?? this.totalXp,
      level: level ?? this.level,
      currentStreak: currentStreak ?? this.currentStreak,
      longestStreak: longestStreak ?? this.longestStreak,
      hearts: hearts ?? this.hearts,
      heartLossTimestamps: heartLossTimestamps ?? this.heartLossTimestamps,
      lastActivityDate: lastActivityDate ?? this.lastActivityDate,
      streakFreezes: streakFreezes ?? this.streakFreezes,
      createdAt: createdAt ?? this.createdAt,
      age: age ?? this.age,
      email: email ?? this.email,
      avatarEmoji: avatarEmoji ?? this.avatarEmoji,
      avatarUrl: avatarUrl ?? this.avatarUrl,
      showGuidedTour: showGuidedTour ?? this.showGuidedTour,
      preferredLanguageCode:
          preferredLanguageCode ?? this.preferredLanguageCode,
    );
  }

  static const int maxHearts = HeartsSystem.maxHearts;

  int get xpForNextLevel => LevelSystem.getXpForLevel(level + 1);
  int get xpProgressInLevel => totalXp - LevelSystem.getXpForLevel(level);
  int get xpNeededForLevel =>
      LevelSystem.getXpNeededForNextLevel(level, totalXp);
  double get levelProgress => LevelSystem.getLevelProgress(level, totalXp);

  bool get isProfileComplete {
    return (displayName?.trim().isNotEmpty ?? false) &&
        (email?.trim().isNotEmpty ?? false) &&
        (age ?? 0) > 0;
  }

  bool get hasHeartsAvailable => hearts > 0;
  bool get isHeartRecoveryActive => heartLossTimestamps.isNotEmpty;

  DateTime? get nextHeartAvailableAt {
    if (heartLossTimestamps.isEmpty) return null;

    const regenDuration = HeartsSystem.heartRegenDuration;
    DateTime? nextRefillAt;
    for (final lostAt in heartLossTimestamps) {
      final candidate = lostAt.add(regenDuration);
      if (nextRefillAt == null || candidate.isBefore(nextRefillAt)) {
        nextRefillAt = candidate;
      }
    }
    return nextRefillAt;
  }

  Duration? timeUntilNextHeart({DateTime? now}) {
    final nextHeartAt = nextHeartAvailableAt;
    if (nextHeartAt == null) return null;

    final remaining = nextHeartAt.difference(now ?? DateTime.now());
    if (remaining.isNegative) {
      return Duration.zero;
    }
    return remaining;
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'displayName': displayName,
      'totalXp': totalXp,
      'level': level,
      'currentStreak': currentStreak,
      'longestStreak': longestStreak,
      'hearts': hearts,
      'heartLossTimestamps': heartLossTimestamps,
      'lastActivityDate': lastActivityDate,
      'streakFreezes': streakFreezes,
      'createdAt': createdAt,
      'age': age,
      'email': email,
      'avatarEmoji': avatarEmoji,
      'avatarUrl': avatarUrl,
      'showGuidedTour': showGuidedTour,
      'preferredLanguageCode': preferredLanguageCode,
    };
  }

  factory UserProfile.fromMap(Map<String, dynamic> data, {String? fallbackId}) {
    final storedHearts = (data['hearts'] as num?)?.toInt() ?? 5;
    final rawHeartLossTimestamps = _readDateTimes(data['heartLossTimestamps']);
    final hasStoredHeartLosses = data.containsKey('heartLossTimestamps');
    final migratedHeartLossTimestamps =
        rawHeartLossTimestamps.isNotEmpty || hasStoredHeartLosses
            ? rawHeartLossTimestamps
            : List<DateTime>.generate(
                (maxHearts - storedHearts).clamp(0, maxHearts),
                (_) => DateTime.now(),
              );
    final normalizedHearts =
        (maxHearts - migratedHeartLossTimestamps.length).clamp(0, maxHearts);

    return UserProfile(
      id: (data['id'] as String?) ?? fallbackId ?? const Uuid().v4(),
      displayName: data['displayName'] as String?,
      totalXp: (data['totalXp'] as num?)?.toInt() ?? 0,
      level: (data['level'] as num?)?.toInt() ?? 1,
      currentStreak: (data['currentStreak'] as num?)?.toInt() ?? 0,
      longestStreak: (data['longestStreak'] as num?)?.toInt() ?? 0,
      hearts: normalizedHearts,
      heartLossTimestamps: migratedHeartLossTimestamps,
      lastActivityDate: _readDateTime(data['lastActivityDate']),
      streakFreezes: (data['streakFreezes'] as num?)?.toInt() ?? 1,
      createdAt: _readDateTime(data['createdAt']) ?? DateTime.now(),
      age: (data['age'] as num?)?.toInt(),
      email: data['email'] as String?,
      avatarEmoji: data['avatarEmoji'] as String?,
      avatarUrl: data['avatarUrl'] as String?,
      showGuidedTour: data['showGuidedTour'] as bool? ?? false,
      preferredLanguageCode: data['preferredLanguageCode'] as String? ?? 'en',
    );
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
        heartLossTimestamps,
        lastActivityDate,
        streakFreezes,
        createdAt,
        age,
        email,
        avatarEmoji,
        avatarUrl,
        showGuidedTour,
        preferredLanguageCode,
      ];
}

// ============================================================================
// Progress State
// ============================================================================

class ProgressState extends Equatable {
  static const String initialUnlockedLessonId = 'U01_L01';

  final Map<String, LessonProgress> lessonProgress;

  final List<String> completedLessons;

  final List<String> unlockedLessons;

  final List<String> earnedBadges;

  const ProgressState({
    this.lessonProgress = const {},
    this.completedLessons = const [],
    this.unlockedLessons = const [initialUnlockedLessonId],
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

  bool isLessonCompleted(String lessonId) =>
      completedLessons.contains(lessonId);
  bool isLessonUnlocked(String lessonId) => unlockedLessons.contains(lessonId);
  bool hasBadge(String badgeId) => earnedBadges.contains(badgeId);

  int completedLessonsOn(DateTime date) {
    final targetYear = date.year;
    final targetMonth = date.month;
    final targetDay = date.day;
    var count = 0;

    for (final lesson in lessonProgress.values) {
      final completedAt = lesson.lastCompletedAt;
      if (completedAt == null) {
        continue;
      }
      if (completedAt.year == targetYear &&
          completedAt.month == targetMonth &&
          completedAt.day == targetDay) {
        count += 1;
      }
    }

    return count;
  }

  Map<String, dynamic> toMap() {
    final progressMap = <String, dynamic>{};
    lessonProgress.forEach((key, value) {
      progressMap[key] = value.toMap();
    });
    return {
      'lessonProgress': progressMap,
      'completedLessons': completedLessons,
      'unlockedLessons': unlockedLessons,
      'earnedBadges': earnedBadges,
    };
  }

  factory ProgressState.fromMap(Map<String, dynamic> data) {
    final rawProgress = (data['lessonProgress'] as Map<String, dynamic>?) ?? {};
    final lessonProgress = <String, LessonProgress>{};
    rawProgress.forEach((key, value) {
      if (value is Map) {
        lessonProgress[key] = LessonProgress.fromMap(
          Map<String, dynamic>.from(value),
        );
      }
    });

    final completedLessons = (data['completedLessons'] as List?)
            ?.map((e) => e.toString())
            .toList() ??
        const <String>[];
    final unlockedLessons = _normalizeUnlockedLessons(
      (data['unlockedLessons'] as List?)?.map((e) => e.toString()).toList() ??
          const <String>[],
      completedLessons,
    );

    return ProgressState(
      lessonProgress: lessonProgress,
      completedLessons: completedLessons,
      unlockedLessons: unlockedLessons,
      earnedBadges:
          (data['earnedBadges'] as List?)?.map((e) => e.toString()).toList() ??
              const [],
    );
  }

  static List<String> _normalizeUnlockedLessons(
    List<String> unlockedLessons,
    List<String> completedLessons,
  ) {
    final normalized = <String>[];

    void addAllUnique(Iterable<String> values) {
      for (final value in values) {
        if (value.isEmpty || normalized.contains(value)) {
          continue;
        }
        normalized.add(value);
      }
    }

    addAllUnique(unlockedLessons);
    addAllUnique(completedLessons);

    final isLegacyFreshState = completedLessons.isEmpty &&
        normalized.length == 1 &&
        normalized.first == 'U01_L05';
    if (isLegacyFreshState) {
      return const [initialUnlockedLessonId];
    }

    if (normalized.isEmpty) {
      return const [initialUnlockedLessonId];
    }

    return normalized;
  }

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

class LessonProgress extends Equatable {
  final String lessonId;

  final bool isCompleted;

  final int timesCompleted;

  final int bestScore;

  final int totalXpEarned;

  final DateTime? firstCompletedAt;

  final DateTime? lastCompletedAt;

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

  Map<String, dynamic> toMap() {
    return {
      'lessonId': lessonId,
      'isCompleted': isCompleted,
      'timesCompleted': timesCompleted,
      'bestScore': bestScore,
      'totalXpEarned': totalXpEarned,
      'firstCompletedAt': firstCompletedAt,
      'lastCompletedAt': lastCompletedAt,
      'lastReplayBonusAt': lastReplayBonusAt,
    };
  }

  factory LessonProgress.fromMap(Map<String, dynamic> data) {
    return LessonProgress(
      lessonId: data['lessonId'] as String? ?? '',
      isCompleted: data['isCompleted'] as bool? ?? false,
      timesCompleted: (data['timesCompleted'] as num?)?.toInt() ?? 0,
      bestScore: (data['bestScore'] as num?)?.toInt() ?? 0,
      totalXpEarned: (data['totalXpEarned'] as num?)?.toInt() ?? 0,
      firstCompletedAt: _readDateTime(data['firstCompletedAt']),
      lastCompletedAt: _readDateTime(data['lastCompletedAt']),
      lastReplayBonusAt: _readDateTime(data['lastReplayBonusAt']),
    );
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

class AttemptLog extends Equatable {
  final String id;

  final String questionId;

  final String lessonId;

  final bool isCorrect;

  final int responseTimeMs;

  final DateTime attemptedAt;

  final int spacedRepetitionInterval;

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

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'questionId': questionId,
      'lessonId': lessonId,
      'isCorrect': isCorrect,
      'responseTimeMs': responseTimeMs,
      'attemptedAt': attemptedAt,
      'spacedRepetitionInterval': spacedRepetitionInterval,
      'nextReviewDate': nextReviewDate,
    };
  }

  factory AttemptLog.fromMap(Map<String, dynamic> data, {String? fallbackId}) {
    return AttemptLog(
      id: data['id'] as String? ?? fallbackId ?? const Uuid().v4(),
      questionId: data['questionId'] as String? ?? '',
      lessonId: data['lessonId'] as String? ?? '',
      isCorrect: data['isCorrect'] as bool? ?? false,
      responseTimeMs: (data['responseTimeMs'] as num?)?.toInt() ?? 0,
      attemptedAt: _readDateTime(data['attemptedAt']) ?? DateTime.now(),
      spacedRepetitionInterval:
          (data['spacedRepetitionInterval'] as num?)?.toInt() ?? 1,
      nextReviewDate: _readDateTime(data['nextReviewDate']),
    );
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

class NotificationPrefs extends Equatable {
  final bool enableNotifications;

  final String quietHoursStart;

  final String quietHoursEnd;

  final List<int> reminderDays; // 1-7 for Mon-Sun

  final String reminderTime;

  final bool learningReminders;

  final bool ahimsaPrompts;

  final bool reflectionPrompts;

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

  Map<String, dynamic> toMap() {
    return {
      'enableNotifications': enableNotifications,
      'quietHoursStart': quietHoursStart,
      'quietHoursEnd': quietHoursEnd,
      'reminderDays': reminderDays,
      'reminderTime': reminderTime,
      'learningReminders': learningReminders,
      'ahimsaPrompts': ahimsaPrompts,
      'reflectionPrompts': reflectionPrompts,
      'streakRiskAlerts': streakRiskAlerts,
    };
  }

  factory NotificationPrefs.fromMap(Map<String, dynamic> data) {
    return NotificationPrefs(
      enableNotifications: data['enableNotifications'] as bool? ?? true,
      quietHoursStart: data['quietHoursStart'] as String? ?? '22:00',
      quietHoursEnd: data['quietHoursEnd'] as String? ?? '07:00',
      reminderDays: (data['reminderDays'] as List?)
              ?.map((e) => (e as num).toInt())
              .toList() ??
          const [1, 2, 3, 4, 5, 6, 7],
      reminderTime: data['reminderTime'] as String? ?? '19:30',
      learningReminders: data['learningReminders'] as bool? ?? true,
      ahimsaPrompts: data['ahimsaPrompts'] as bool? ?? true,
      reflectionPrompts: data['reflectionPrompts'] as bool? ?? true,
      streakRiskAlerts: data['streakRiskAlerts'] as bool? ?? true,
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
