import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';
import '../models/user_models.dart';

class StorageService {
  static final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  static final FirebaseAuth _auth = FirebaseAuth.instance;
  static const _uuid = Uuid();

  static late String _userId;
  static bool _isInitialized = false;
  static UserProfile _userProfile =
      UserProfile(id: _uuid.v4(), createdAt: DateTime.now());
  static ProgressState _progressState = const ProgressState();
  static NotificationPrefs _notificationPrefs = const NotificationPrefs();
  static List<AttemptLog> _attemptLogs = [];
  static ThemeMode _themeMode = ThemeMode.dark;
  static Map<String, List<int>> _readingBookmarks = {};

  static Future<void> init({User? user}) async {
    final currentUser = user ?? _auth.currentUser;
    if (currentUser == null) {
      return;
    }
    _userId = currentUser.uid;
    _userProfile = UserProfile(id: _userId, createdAt: DateTime.now());

    await _ensureDocumentsExist();
    await _loadCachedData();
    _isInitialized = true;
  }

  static bool get isInitialized => _isInitialized;

  static DocumentReference<Map<String, dynamic>> _userDoc() {
    return _firestore.collection('users').doc(_userId);
  }

  static DocumentReference<Map<String, dynamic>> _progressDoc() {
    return _userDoc().collection('progress').doc('state');
  }

  static DocumentReference<Map<String, dynamic>> _notificationDoc() {
    return _userDoc().collection('notifications').doc('prefs');
  }

  static DocumentReference<Map<String, dynamic>> _settingsDoc() {
    return _userDoc().collection('settings').doc('theme');
  }

  static DocumentReference<Map<String, dynamic>> _readingDoc() {
    return _userDoc().collection('settings').doc('reading');
  }

  static CollectionReference<Map<String, dynamic>> _attemptsCollection() {
    return _userDoc().collection('attempts');
  }

  static Future<void> _ensureDocumentsExist() async {
    final userSnap = await _userDoc().get();
    if (!userSnap.exists) {
      final newUser = UserProfile(
        id: _userId,
        createdAt: DateTime.now(),
        showGuidedTour: true,
      );
      await _userDoc().set(newUser.toMap());
    }

    final progressSnap = await _progressDoc().get();
    if (!progressSnap.exists) {
      await _progressDoc().set(const ProgressState().toMap());
    }

    final prefsSnap = await _notificationDoc().get();
    if (!prefsSnap.exists) {
      await _notificationDoc().set(const NotificationPrefs().toMap());
    }

    final themeSnap = await _settingsDoc().get();
    if (!themeSnap.exists) {
      await _settingsDoc().set({'isDarkMode': true});
    }
  }

  static Future<void> _loadCachedData() async {
    final userSnap = await _userDoc().get();
    if (userSnap.exists && userSnap.data() != null) {
      _userProfile = UserProfile.fromMap(userSnap.data()!, fallbackId: _userId);
    }

    final progressSnap = await _progressDoc().get();
    if (progressSnap.exists && progressSnap.data() != null) {
      _progressState = ProgressState.fromMap(progressSnap.data()!);
    }

    final prefsSnap = await _notificationDoc().get();
    if (prefsSnap.exists && prefsSnap.data() != null) {
      _notificationPrefs = NotificationPrefs.fromMap(prefsSnap.data()!);
    }

    final themeSnap = await _settingsDoc().get();
    if (themeSnap.exists && themeSnap.data() != null) {
      final isDark = themeSnap.data()!['isDarkMode'] as bool? ?? true;
      _themeMode = isDark ? ThemeMode.dark : ThemeMode.light;
    }

    final readingSnap = await _readingDoc().get();
    if (readingSnap.exists && readingSnap.data() != null) {
      final rawBookmarks =
          readingSnap.data()!['bookmarks'] as Map<String, dynamic>? ?? {};
      _readingBookmarks = rawBookmarks.map(
        (bookId, pages) {
          final values = List<dynamic>.from(pages as List<dynamic>? ?? const [])
              .whereType<num>()
              .map((value) => value.toInt())
              .where((value) => value >= 0)
              .toSet()
              .toList()
            ..sort();
          return MapEntry(bookId, values);
        },
      );
    } else {
      _readingBookmarks = {};
    }

    final attemptsSnap = await _attemptsCollection().get();
    _attemptLogs = attemptsSnap.docs
        .map((doc) => AttemptLog.fromMap(doc.data(), fallbackId: doc.id))
        .toList();
  }

  // =========================================================================
  // User Profile
  // =========================================================================

  static UserProfile getUserProfile() {
    return _userProfile;
  }

  static Future<void> saveUserProfile(UserProfile profile) async {
    _userProfile = profile;
    await _userDoc().set(profile.toMap(), SetOptions(merge: true));
  }

  static Future<void> markGuidedTourSeen() async {
    final updatedUser = _userProfile.copyWith(showGuidedTour: false);
    await saveUserProfile(updatedUser);
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
    return _progressState;
  }

  static Future<void> saveProgressState(ProgressState progress) async {
    _progressState = progress;
    await _progressDoc().set(progress.toMap(), SetOptions(merge: true));
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
    final isFirstCompletion =
        existingProgress == null || !existingProgress.isCompleted;

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
          : (existingProgress.canGetReplayBonus == true
              ? now
              : existingProgress.lastReplayBonusAt),
    );

    final newLessonProgressMap =
        Map<String, LessonProgress>.from(progress.lessonProgress);
    newLessonProgressMap[lessonId] = updatedLessonProgress;

    // Update completed lessons
    final newCompletedLessons = progress.completedLessons.contains(lessonId)
        ? progress.completedLessons
        : [...progress.completedLessons, lessonId];

    // Unlock next lesson
    List<String> newUnlockedLessons = progress.unlockedLessons;
    if (nextLessonId != null &&
        !progress.unlockedLessons.contains(nextLessonId)) {
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
    _attemptLogs.removeWhere((log) => log.id == attempt.id);
    _attemptLogs.add(attempt);
    await _attemptsCollection()
        .doc(attempt.id)
        .set(attempt.toMap(), SetOptions(merge: true));
  }

  static List<AttemptLog> getAttemptLogs() {
    return List<AttemptLog>.from(_attemptLogs);
  }

  static List<AttemptLog> getAttemptsForQuestion(String questionId) {
    return _attemptLogs.where((a) => a.questionId == questionId).toList()
      ..sort((a, b) => b.attemptedAt.compareTo(a.attemptedAt));
  }

  static List<AttemptLog> getQuestionsForReview() {
    final now = DateTime.now();
    return _attemptLogs
        .where(
            (a) => a.nextReviewDate != null && a.nextReviewDate!.isBefore(now))
        .toList();
  }

  // =========================================================================
  // Notification Preferences
  // =========================================================================

  static NotificationPrefs getNotificationPrefs() {
    return _notificationPrefs;
  }

  static Future<void> saveNotificationPrefs(NotificationPrefs prefs) async {
    _notificationPrefs = prefs;
    await _notificationDoc().set(prefs.toMap(), SetOptions(merge: true));
  }

  // =========================================================================
  // Theme
  // =========================================================================

  static ThemeMode getThemeMode() {
    return _themeMode;
  }

  static Future<void> saveThemeMode(ThemeMode mode) async {
    _themeMode = mode;

    if (!_isInitialized || _auth.currentUser == null) {
      return;
    }

    await _settingsDoc().set(
      {'isDarkMode': mode == ThemeMode.dark},
      SetOptions(merge: true),
    );
  }

  // =========================================================================
  // Reading Bookmarks
  // =========================================================================

  static List<int> getReadingBookmarks(String bookId) {
    final pages = _readingBookmarks[bookId] ?? const <int>[];
    final copy = List<int>.from(pages)..sort();
    return copy;
  }

  static Future<bool> toggleReadingBookmark({
    required String bookId,
    required int pageIndex,
  }) async {
    final pages = List<int>.from(_readingBookmarks[bookId] ?? const <int>[]);
    final exists = pages.contains(pageIndex);
    if (exists) {
      pages.remove(pageIndex);
    } else {
      pages.add(pageIndex);
    }
    pages.sort();
    _readingBookmarks[bookId] = pages;

    if (_isInitialized && _auth.currentUser != null) {
      await _readingDoc().set(
        {'bookmarks': _readingBookmarks},
        SetOptions(merge: true),
      );
    }

    return !exists;
  }

  // =========================================================================
  // Reset
  // =========================================================================

  static Future<void> resetAllProgress() async {
    final newUser = UserProfile(id: _userId, createdAt: DateTime.now());
    const defaultProgress = ProgressState();
    const defaultPrefs = NotificationPrefs();

    final batch = _firestore.batch();
    batch.set(_userDoc(), newUser.toMap());
    batch.set(_progressDoc(), defaultProgress.toMap());
    batch.set(_notificationDoc(), defaultPrefs.toMap());
    batch.set(_settingsDoc(), {'isDarkMode': _themeMode == ThemeMode.dark});
    batch.set(_readingDoc(), {'bookmarks': <String, List<int>>{}});

    final attemptsSnap = await _attemptsCollection().get();
    for (final doc in attemptsSnap.docs) {
      batch.delete(doc.reference);
    }

    await batch.commit();

    _userProfile = newUser;
    _progressState = defaultProgress;
    _notificationPrefs = defaultPrefs;
    _attemptLogs = [];
    _readingBookmarks = {};
  }
}
