import 'package:hive_flutter/hive_flutter.dart';
import 'package:uuid/uuid.dart';
import '../models/user_models.dart';

class StorageService {
  static const String _userBoxName = 'user_box';
  static const String _progressBoxName = 'progress_box';
  static const String _attemptsBoxName = 'attempts_box';
  static const String _notificationBoxName = 'notification_box';

  static late Box<UserProfile> _userBox;
  static late Box<ProgressState> _progressBox;
  static late Box<AttemptLog> _attemptsBox;
  static late Box<NotificationPrefs> _notificationBox;

  static const _uuid = Uuid();

  static Future<void> init() async {
    // Register adapters
    Hive.registerAdapter(UserProfileAdapter());
    Hive.registerAdapter(ProgressStateAdapter());
    Hive.registerAdapter(LessonProgressAdapter());
    Hive.registerAdapter(AttemptLogAdapter());
    Hive.registerAdapter(NotificationPrefsAdapter());

    // Open boxes
    _userBox = await Hive.openBox<UserProfile>(_userBoxName);

    _progressBox = await Hive.openBox<ProgressState>(_progressBoxName);
    _attemptsBox = await Hive.openBox<AttemptLog>(_attemptsBoxName);
    _notificationBox = await Hive.openBox<NotificationPrefs>(_notificationBoxName);

    // Initialize default user if needed
    await _ensureUserExists();
  }

  static Future<void> _ensureUserExists() async {
    if (_userBox.isEmpty) {
      final newUser = UserProfile(
        id: _uuid.v4(),
        createdAt: DateTime.now(),
      );
      await _userBox.put('current_user', newUser);
    }

    if (_progressBox.isEmpty) {
      const defaultProgress = ProgressState();
      await _progressBox.put('current_progress', defaultProgress);
    }

    if (_notificationBox.isEmpty) {
      const defaultPrefs = NotificationPrefs();
      await _notificationBox.put('notification_prefs', defaultPrefs);
    }
  }

  // =========================================================================
  // User Profile
  // =========================================================================

  static UserProfile getUserProfile() {
    return _userBox.get('current_user') ??
        UserProfile(id: _uuid.v4(), createdAt: DateTime.now());
  }

  static Future<void> saveUserProfile(UserProfile profile) async {
    await _userBox.put('current_user', profile);
  }

  static Future<UserProfile> addXp(int xp) async {
    final user = getUserProfile();
    var newTotalXp = user.totalXp + xp;
    var newLevel = user.level;

    // Check for level ups
    while (newTotalXp >= 50 * newLevel) {
      newLevel++;
    }

    final updatedUser = user.copyWith(
      totalXp: newTotalXp,
      level: newLevel,
      lastActivityDate: DateTime.now(),
    );
    await saveUserProfile(updatedUser);
    return updatedUser;
  }

  static Future<UserProfile> loseHeart() async {
    final user = getUserProfile();
    if (user.hearts > 0) {
      final updatedUser = user.copyWith(hearts: user.hearts - 1);
      await saveUserProfile(updatedUser);
      return updatedUser;
    }
    return user;
  }

  static Future<UserProfile> refillHeart({int amount = 1}) async {
    final user = getUserProfile();
    final newHearts = (user.hearts + amount).clamp(0, UserProfile.maxHearts);
    final updatedUser = user.copyWith(hearts: newHearts);
    await saveUserProfile(updatedUser);
    return updatedUser;
  }

  static Future<UserProfile> updateStreak() async {
    final user = getUserProfile();
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);

    if (user.lastActivityDate == null) {
      // First activity
      final updatedUser = user.copyWith(
        currentStreak: 1,
        longestStreak: 1,
        lastActivityDate: now,
      );
      await saveUserProfile(updatedUser);
      return updatedUser;
    }

    final lastDate = DateTime(
      user.lastActivityDate!.year,
      user.lastActivityDate!.month,
      user.lastActivityDate!.day,
    );

    final daysDifference = today.difference(lastDate).inDays;

    if (daysDifference == 0) {
      // Same day, no change
      return user;
    } else if (daysDifference == 1) {
      // Consecutive day
      final newStreak = user.currentStreak + 1;
      final updatedUser = user.copyWith(
        currentStreak: newStreak,
        longestStreak: newStreak > user.longestStreak ? newStreak : null,
        lastActivityDate: now,
      );
      await saveUserProfile(updatedUser);
      return updatedUser;
    } else {
      // Streak broken (but could use freeze)
      if (user.streakFreezes > 0 && daysDifference <= 2) {
        // Use streak freeze
        final updatedUser = user.copyWith(
          streakFreezes: user.streakFreezes - 1,
          lastActivityDate: now,
        );
        await saveUserProfile(updatedUser);
        return updatedUser;
      } else {
        // Reset streak
        final updatedUser = user.copyWith(
          currentStreak: 1,
          lastActivityDate: now,
        );
        await saveUserProfile(updatedUser);
        return updatedUser;
      }
    }
  }

  // =========================================================================
  // Progress State
  // =========================================================================

  static ProgressState getProgressState() {
    return _progressBox.get('current_progress') ?? const ProgressState();
  }

  static Future<void> saveProgressState(ProgressState progress) async {
    await _progressBox.put('current_progress', progress);
  }

  static Future<ProgressState> completeLesson(
    String lessonId, {
    required int score,
    required int xpEarned,
    String? nextLessonId,
  }) async {
    final progress = getProgressState();
    final now = DateTime.now();

    // Update lesson progress
    final existingProgress = progress.lessonProgress[lessonId];
    final isFirstCompletion = existingProgress == null || !existingProgress.isCompleted;

    final updatedLessonProgress = LessonProgress(
      lessonId: lessonId,
      isCompleted: true,
      timesCompleted: (existingProgress?.timesCompleted ?? 0) + 1,
      bestScore: score > (existingProgress?.bestScore ?? 0)
          ? score
          : existingProgress?.bestScore ?? score,
      totalXpEarned: (existingProgress?.totalXpEarned ?? 0) + xpEarned,
      firstCompletedAt: existingProgress?.firstCompletedAt ?? now,
      lastCompletedAt: now,
      lastReplayBonusAt: isFirstCompletion
          ? null
          : (existingProgress.canGetReplayBonus == true ? now : existingProgress.lastReplayBonusAt),
    );

    final newLessonProgressMap = Map<String, LessonProgress>.from(progress.lessonProgress);
    newLessonProgressMap[lessonId] = updatedLessonProgress;

    // Update completed lessons
    final newCompletedLessons = progress.completedLessons.contains(lessonId)
        ? progress.completedLessons
        : [...progress.completedLessons, lessonId];

    // Unlock next lesson
    List<String> newUnlockedLessons = progress.unlockedLessons;
    if (nextLessonId != null && !progress.unlockedLessons.contains(nextLessonId)) {
      newUnlockedLessons = [...progress.unlockedLessons, nextLessonId];
    }

    final updatedProgress = progress.copyWith(
      lessonProgress: newLessonProgressMap,
      completedLessons: newCompletedLessons,
      unlockedLessons: newUnlockedLessons,
    );

    await saveProgressState(updatedProgress);
    return updatedProgress;
  }

  static Future<ProgressState> earnBadge(String badgeId) async {
    final progress = getProgressState();
    if (!progress.earnedBadges.contains(badgeId)) {
      final updatedProgress = progress.copyWith(
        earnedBadges: [...progress.earnedBadges, badgeId],
      );
      await saveProgressState(updatedProgress);
      return updatedProgress;
    }
    return progress;
  }

  // =========================================================================
  // Attempt Logs (for spaced repetition)
  // =========================================================================

  static Future<void> logAttempt(AttemptLog attempt) async {
    await _attemptsBox.put(attempt.id, attempt);
  }

  static List<AttemptLog> getAttemptLogs() {
    return _attemptsBox.values.toList();
  }

  static List<AttemptLog> getAttemptsForQuestion(String questionId) {
    return _attemptsBox.values
        .where((a) => a.questionId == questionId)
        .toList()
      ..sort((a, b) => b.attemptedAt.compareTo(a.attemptedAt));
  }

  static List<AttemptLog> getQuestionsForReview() {
    final now = DateTime.now();
    return _attemptsBox.values
        .where((a) => a.nextReviewDate != null && a.nextReviewDate!.isBefore(now))
        .toList();
  }

  // =========================================================================
  // Notification Preferences
  // =========================================================================

  static NotificationPrefs getNotificationPrefs() {
    return _notificationBox.get('notification_prefs') ?? const NotificationPrefs();
  }

  static Future<void> saveNotificationPrefs(NotificationPrefs prefs) async {
    await _notificationBox.put('notification_prefs', prefs);
  }

  // =========================================================================
  // Reset
  // =========================================================================

  static Future<void> resetAllProgress() async {
    await _userBox.clear();
    await _progressBox.clear();
    await _attemptsBox.clear();
    await _ensureUserExists();
  }
}
