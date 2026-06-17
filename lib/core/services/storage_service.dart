import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';
import '../gamification/gamification_rules.dart';
import '../gamification/gamification_service.dart';
import '../models/user_models.dart';
import '../../features/resources/data/reading_bonus_logic.dart';

class ReadingHeartRewardResult {
  const ReadingHeartRewardResult({
    required this.user,
    required this.countedPage,
    required this.heartsEarned,
    required this.pagesTowardNextHeart,
    required this.dailyPagesRead,
    required this.dailyHeartEarned,
  });

  final UserProfile user;
  final bool countedPage;
  final int heartsEarned;
  final int pagesTowardNextHeart;
  final int dailyPagesRead;
  final bool dailyHeartEarned;
}

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
  static Map<String, bool> _quickGuideCompletions = {};
  static Map<String, List<int>> _readingRewardPages = {};
  static Map<String, bool> _readingQuizCompletions = {};
  static Map<String, List<int>> _dailyReadingPages = {};
  static Map<String, bool> _dailyReadingHeartRewards = {};
  static int _readingPagesTowardNextHeart = 0;

  static Future<void> init({User? user}) async {
    final currentUser = user ?? _auth.currentUser;
    if (currentUser == null) {
      return;
    }
    _userId = currentUser.uid;
    _userProfile = UserProfile(id: _userId, createdAt: DateTime.now());

    await _loadAll();
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

  /// Reads every per-user document in a single parallel batch (instead of the
  /// previous ~10 sequential round-trips, 4 of which were duplicated between
  /// an "ensure exists" pass and a "load" pass). Missing documents are created
  /// from defaults in one batched write. This is on the splash -> home
  /// critical path, so the latency saved here is user-visible.
  static Future<void> _loadAll() async {
    final results = await Future.wait([
      _userDoc().get(),
      _progressDoc().get(),
      _notificationDoc().get(),
      _settingsDoc().get(),
      _readingDoc().get(),
      _attemptsCollection().get(),
    ]);

    final userSnap = results[0] as DocumentSnapshot<Map<String, dynamic>>;
    final progressSnap = results[1] as DocumentSnapshot<Map<String, dynamic>>;
    final prefsSnap = results[2] as DocumentSnapshot<Map<String, dynamic>>;
    final themeSnap = results[3] as DocumentSnapshot<Map<String, dynamic>>;
    final readingSnap = results[4] as DocumentSnapshot<Map<String, dynamic>>;
    final attemptsSnap = results[5] as QuerySnapshot<Map<String, dynamic>>;

    final batch = _firestore.batch();
    var hasMissingDocs = false;

    if (userSnap.exists && userSnap.data() != null) {
      _userProfile = UserProfile.fromMap(userSnap.data()!, fallbackId: _userId);
    } else {
      _userProfile = UserProfile(
        id: _userId,
        createdAt: DateTime.now(),
        showGuidedTour: true,
      );
      batch.set(_userDoc(), _userProfile.toMap());
      hasMissingDocs = true;
    }

    if (progressSnap.exists && progressSnap.data() != null) {
      _progressState = ProgressState.fromMap(progressSnap.data()!);
    } else {
      _progressState = const ProgressState();
      batch.set(_progressDoc(), _progressState.toMap());
      hasMissingDocs = true;
    }

    if (prefsSnap.exists && prefsSnap.data() != null) {
      _notificationPrefs = NotificationPrefs.fromMap(prefsSnap.data()!);
    } else {
      _notificationPrefs = const NotificationPrefs();
      batch.set(_notificationDoc(), _notificationPrefs.toMap());
      hasMissingDocs = true;
    }

    if (themeSnap.exists && themeSnap.data() != null) {
      final isDark = themeSnap.data()!['isDarkMode'] as bool? ?? true;
      _themeMode = isDark ? ThemeMode.dark : ThemeMode.light;
    } else {
      _themeMode = ThemeMode.dark;
      batch.set(_settingsDoc(), {'isDarkMode': true});
      hasMissingDocs = true;
    }

    if (readingSnap.exists && readingSnap.data() != null) {
      final readingData = readingSnap.data()!;
      final rawBookmarks =
          readingData['bookmarks'] as Map<String, dynamic>? ?? {};
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
      final rawGuideCompletions =
          readingData['quickGuideCompletions'] as Map<String, dynamic>? ?? {};
      _quickGuideCompletions = rawGuideCompletions.map(
        (guideId, completed) => MapEntry(guideId, completed == true),
      );
      final rawRewardPages =
          readingData['rewardPages'] as Map<String, dynamic>? ?? {};
      _readingRewardPages = rawRewardPages.map(
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
      final rawQuizCompletions =
          readingData['quizCompletions'] as Map<String, dynamic>? ?? {};
      _readingQuizCompletions = rawQuizCompletions.map(
        (quizId, completed) => MapEntry(quizId, completed == true),
      );
      final rawDailyReadingPages =
          readingData['dailyPages'] as Map<String, dynamic>? ?? {};
      _dailyReadingPages = rawDailyReadingPages.map(
        (dayKey, pages) {
          final values = List<dynamic>.from(pages as List<dynamic>? ?? const [])
              .whereType<num>()
              .map((value) => value.toInt())
              .where((value) => value >= 0)
              .toSet()
              .toList()
            ..sort();
          return MapEntry(dayKey, values);
        },
      );
      final rawDailyHeartRewards =
          readingData['dailyHeartRewards'] as Map<String, dynamic>? ?? {};
      _dailyReadingHeartRewards = rawDailyHeartRewards.map(
        (dayKey, completed) => MapEntry(dayKey, completed == true),
      );
      _readingPagesTowardNextHeart =
          (readingData['pagesTowardNextHeart'] as num?)?.toInt() ?? 0;
    } else {
      _readingBookmarks = {};
      _quickGuideCompletions = {};
      _readingRewardPages = {};
      _readingQuizCompletions = {};
      _dailyReadingPages = {};
      _dailyReadingHeartRewards = {};
      _readingPagesTowardNextHeart = 0;
    }

    _attemptLogs = attemptsSnap.docs
        .map((doc) => AttemptLog.fromMap(doc.data(), fallbackId: doc.id))
        .toList();

    if (hasMissingDocs) {
      await batch.commit();
    }
  }

  // =========================================================================
  // User Profile
  // =========================================================================

  static UserProfile getUserProfile() {
    _userProfile = GamificationService.syncHearts(_userProfile);
    return _userProfile;
  }

  static Future<void> saveUserProfile(UserProfile profile) async {
    _userProfile = profile;
    if (!_isInitialized || _auth.currentUser == null) {
      return;
    }
    await _userDoc().set(profile.toMap(), SetOptions(merge: true));
  }

  static Future<void> markGuidedTourSeen() async {
    final updatedUser = _userProfile.copyWith(showGuidedTour: false);
    await saveUserProfile(updatedUser);
  }

  static Future<UserProfile> addXp(int xp) async {
    final user = await syncHearts();
    final updatedUser = GamificationService.applyXp(user, xp);
    await saveUserProfile(updatedUser);
    return updatedUser;
  }

  static Future<UserProfile> syncHearts() async {
    final syncedUser = GamificationService.syncHearts(_userProfile);
    if (syncedUser == _userProfile) {
      return _userProfile;
    }
    await saveUserProfile(syncedUser);
    return syncedUser;
  }

  static Future<UserProfile> loseHeart() async {
    final user = await syncHearts();
    if (user.hearts > 0) {
      final updatedUser = GamificationService.applyHeartDelta(user, delta: -1);
      await saveUserProfile(updatedUser);
      return updatedUser;
    }
    return user;
  }

  static Future<UserProfile> refillHeart({int amount = 1}) async {
    final user = await syncHearts();
    final updatedUser =
        GamificationService.applyHeartDelta(user, delta: amount);
    await saveUserProfile(updatedUser);
    return updatedUser;
  }

  static Future<UserProfile> updateStreak() async {
    final user = await syncHearts();
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

  static Map<String, bool> getQuickGuideCompletions() {
    return Map<String, bool>.from(_quickGuideCompletions);
  }

  static int getReadingPagesTowardNextHeart() {
    return _readingPagesTowardNextHeart;
  }

  static int getReadingDailyPagesRead(
    String bookId, {
    DateTime? date,
  }) {
    final key = _readingDayKey(bookId, date ?? DateTime.now());
    return (_dailyReadingPages[key] ?? const <int>[]).length;
  }

  static bool hasEarnedReadingDailyHeart(
    String bookId, {
    DateTime? date,
  }) {
    final key = _readingDayKey(bookId, date ?? DateTime.now());
    return _dailyReadingHeartRewards[key] ?? false;
  }

  static bool isQuickGuideCompleted(String guideId) {
    return _quickGuideCompletions[guideId] ?? false;
  }

  static bool isReadingQuizCompleted(String quizId) {
    return _readingQuizCompletions[quizId] ?? false;
  }

  static Future<void> markQuickGuideCompleted(
    String guideId, {
    bool completed = true,
  }) async {
    _quickGuideCompletions[guideId] = completed;

    if (_isInitialized && _auth.currentUser != null) {
      await _readingDoc().set(
        {'quickGuideCompletions': _quickGuideCompletions},
        SetOptions(merge: true),
      );
    }
  }

  static Future<void> markReadingQuizCompleted(
    String quizId, {
    bool completed = true,
  }) async {
    _readingQuizCompletions[quizId] = completed;

    if (_isInitialized && _auth.currentUser != null) {
      await _readingDoc().set(
        {'quizCompletions': _readingQuizCompletions},
        SetOptions(merge: true),
      );
    }
  }

  static Future<ReadingHeartRewardResult> registerReadingPage({
    required String bookId,
    required int pageIndex,
  }) async {
    final user = await syncHearts();
    final rewardedPages =
        List<int>.from(_readingRewardPages[bookId] ?? const <int>[]);
    final alreadyCounted = rewardedPages.contains(pageIndex);
    var heartsEarned = 0;
    var updatedUser = user;
    var shouldPersistReadingData = false;

    if (!alreadyCounted && user.hearts < UserProfile.maxHearts) {
      rewardedPages.add(pageIndex);
      rewardedPages.sort();
      _readingRewardPages[bookId] = rewardedPages;
      _readingPagesTowardNextHeart += 1;
      shouldPersistReadingData = true;

      while (
          _readingPagesTowardNextHeart >= HeartsSystem.readingPagesPerHeart &&
              updatedUser.hearts < UserProfile.maxHearts) {
        _readingPagesTowardNextHeart -= HeartsSystem.readingPagesPerHeart;
        updatedUser =
            GamificationService.applyHeartDelta(updatedUser, delta: 1);
        heartsEarned += 1;
      }
    }

    final todayKey = _readingDayKey(bookId, DateTime.now());
    final previousDailyState = DailyReadingProgress(
      pageIndices:
          List<int>.from(_dailyReadingPages[todayKey] ?? const <int>[]),
      hasEarnedHeart: _dailyReadingHeartRewards[todayKey] ?? false,
    );
    final dailyUpdate = ReadingBonusLogic.registerDailyPageVisit(
      progress: previousDailyState,
      pageIndex: pageIndex,
      pagesRequired: HeartsSystem.dailyReadingPagesForHeart,
      canEarnHeart: updatedUser.hearts < UserProfile.maxHearts,
    );
    _dailyReadingPages[todayKey] = dailyUpdate.pageIndices;
    _dailyReadingHeartRewards[todayKey] = dailyUpdate.hasEarnedHeart;

    if (dailyUpdate.countedPage ||
        previousDailyState.hasEarnedHeart != dailyUpdate.hasEarnedHeart) {
      shouldPersistReadingData = true;
    }

    if (dailyUpdate.heartsEarned > 0) {
      updatedUser = GamificationService.applyHeartDelta(updatedUser,
          delta: dailyUpdate.heartsEarned);
      heartsEarned += dailyUpdate.heartsEarned;
    }

    if (updatedUser != user) {
      await saveUserProfile(updatedUser);
    }

    if (shouldPersistReadingData &&
        _isInitialized &&
        _auth.currentUser != null) {
      await _readingDoc().set(
        {
          'rewardPages': _readingRewardPages,
          'pagesTowardNextHeart': _readingPagesTowardNextHeart,
          'dailyPages': _dailyReadingPages,
          'dailyHeartRewards': _dailyReadingHeartRewards,
        },
        SetOptions(merge: true),
      );
    }

    return ReadingHeartRewardResult(
      user: updatedUser,
      countedPage: !alreadyCounted && user.hearts < UserProfile.maxHearts,
      heartsEarned: heartsEarned,
      pagesTowardNextHeart: _readingPagesTowardNextHeart,
      dailyPagesRead: dailyUpdate.pagesRead,
      dailyHeartEarned: dailyUpdate.hasEarnedHeart,
    );
  }

  static String _readingDayKey(String bookId, DateTime date) {
    final day = DateTime(date.year, date.month, date.day);
    final month = day.month.toString().padLeft(2, '0');
    final dayOfMonth = day.day.toString().padLeft(2, '0');
    return '$bookId-${day.year}-$month-$dayOfMonth';
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
    batch.set(_readingDoc(), {
      'bookmarks': <String, List<int>>{},
      'quickGuideCompletions': <String, bool>{},
      'rewardPages': <String, List<int>>{},
      'quizCompletions': <String, bool>{},
      'dailyPages': <String, List<int>>{},
      'dailyHeartRewards': <String, bool>{},
      'pagesTowardNextHeart': 0,
    });

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
    _quickGuideCompletions = {};
    _readingRewardPages = {};
    _readingQuizCompletions = {};
    _dailyReadingPages = {};
    _dailyReadingHeartRewards = {};
    _readingPagesTowardNextHeart = 0;
  }
}
