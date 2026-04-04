import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../gamification/gamification_rules.dart';
import '../gamification/gamification_service.dart';
import '../models/user_models.dart';
import '../models/lesson_models.dart';
import '../models/badge_definition.dart';
import '../services/storage_service.dart';
import '../content/unit1_content.dart';

Future<void> _recordQuestionAttempt({
  required String lessonId,
  required String questionId,
  required bool isCorrect,
}) async {
  final now = DateTime.now();
  final previousAttempts = StorageService.getAttemptsForQuestion(questionId);
  final latestAttempt =
      previousAttempts.isEmpty ? null : previousAttempts.first;
  final intervalDays = isCorrect
      ? (latestAttempt != null && latestAttempt.isCorrect
          ? (latestAttempt.spacedRepetitionInterval * 2).clamp(1, 14)
          : 1)
      : 0;

  try {
    await StorageService.logAttempt(
      AttemptLog(
        id: '${questionId}_${now.microsecondsSinceEpoch}',
        questionId: questionId,
        lessonId: lessonId,
        isCorrect: isCorrect,
        responseTimeMs: isCorrect ? 4000 : 6000,
        attemptedAt: now,
        spacedRepetitionInterval: intervalDays,
        nextReviewDate: isCorrect ? now.add(Duration(days: intervalDays)) : now,
      ),
    );
  } catch (_) {
    // Attempt logging should never block the main learning flow.
  }
}

String? _lessonIdForQuestion(Iterable<Lesson> lessons, String questionId) {
  for (final lesson in lessons) {
    final containsQuestion = lesson.screens.quiz.questions
        .any((question) => question.questionId == questionId);
    if (containsQuestion) {
      return lesson.lessonId;
    }
  }
  return null;
}

bool _isAttemptDue(AttemptLog attempt, DateTime now) {
  final nextReviewDate = attempt.nextReviewDate;
  return nextReviewDate != null && !nextReviewDate.isAfter(now);
}

// ============================================================================
// User Profile Provider
// ============================================================================

class UserProfileNotifier extends StateNotifier<UserProfile> {
  UserProfileNotifier() : super(StorageService.getUserProfile()) {
    Future<void>.microtask(syncHearts);
    _heartSyncTimer = Timer.periodic(
      const Duration(seconds: 15),
      (_) => syncHearts(),
    );
  }

  Timer? _heartSyncTimer;

  void refresh() {
    state = StorageService.getUserProfile();
  }

  Future<UserProfile> syncHearts() async {
    final updatedUser = await StorageService.syncHearts();
    state = updatedUser;
    return updatedUser;
  }

  Future<UserProfile> addXp(int xp) async {
    final updatedUser = await StorageService.addXp(xp);
    state = updatedUser;
    return updatedUser;
  }

  Future<UserProfile> loseHeart() async {
    final updatedUser = await StorageService.loseHeart();
    state = updatedUser;
    return updatedUser;
  }

  Future<UserProfile> refillHeart({int amount = 1}) async {
    final updatedUser = await StorageService.refillHeart(amount: amount);
    state = updatedUser;
    return updatedUser;
  }

  Future<UserProfile> updateStreak() async {
    final updatedUser = await StorageService.updateStreak();
    state = updatedUser;
    return updatedUser;
  }

  Future<ReadingHeartRewardResult> registerReadingPage({
    required String bookId,
    required int pageIndex,
  }) async {
    final result = await StorageService.registerReadingPage(
      bookId: bookId,
      pageIndex: pageIndex,
    );
    state = result.user;
    return result;
  }

  Future<void> updateDisplayName(String displayName) async {
    final updatedUser = state.copyWith(displayName: displayName);
    await StorageService.saveUserProfile(updatedUser);
    state = updatedUser;
  }

  Future<void> updatePreferredLanguage(String languageCode) async {
    final updatedUser = state.copyWith(preferredLanguageCode: languageCode);
    await StorageService.saveUserProfile(updatedUser);
    state = updatedUser;
  }

  @override
  void dispose() {
    _heartSyncTimer?.cancel();
    super.dispose();
  }
}

final userProfileProvider =
    StateNotifierProvider<UserProfileNotifier, UserProfile>((ref) {
  return UserProfileNotifier();
});

// ============================================================================
// Progress State Provider
// ============================================================================

class ProgressNotifier extends StateNotifier<ProgressState> {
  ProgressNotifier() : super(StorageService.getProgressState());

  void refresh() {
    state = StorageService.getProgressState();
  }

  Future<void> completeLesson(
    String lessonId, {
    required int score,
    required int xpEarned,
    String? nextLessonId,
  }) async {
    state = await StorageService.completeLesson(
      lessonId,
      score: score,
      xpEarned: xpEarned,
      nextLessonId: nextLessonId,
    );
  }

  Future<void> earnBadge(String badgeId) async {
    state = await StorageService.earnBadge(badgeId);
  }
}

final progressProvider =
    StateNotifierProvider<ProgressNotifier, ProgressState>((ref) {
  return ProgressNotifier();
});

// ============================================================================
// Notification Preferences Provider
// ============================================================================

class NotificationPrefsNotifier extends StateNotifier<NotificationPrefs> {
  NotificationPrefsNotifier() : super(StorageService.getNotificationPrefs());

  void refresh() {
    state = StorageService.getNotificationPrefs();
  }

  Future<void> updatePrefs(NotificationPrefs prefs) async {
    await StorageService.saveNotificationPrefs(prefs);
    state = prefs;
  }

  Future<void> toggleNotifications(bool enabled) async {
    final newPrefs = state.copyWith(enableNotifications: enabled);
    await updatePrefs(newPrefs);
  }

  Future<void> setReminderTime(String time) async {
    final newPrefs = state.copyWith(reminderTime: time);
    await updatePrefs(newPrefs);
  }

  Future<void> setQuietHours(String start, String end) async {
    final newPrefs = state.copyWith(quietHoursStart: start, quietHoursEnd: end);
    await updatePrefs(newPrefs);
  }
}

final notificationPrefsProvider =
    StateNotifierProvider<NotificationPrefsNotifier, NotificationPrefs>((ref) {
  return NotificationPrefsNotifier();
});

// ============================================================================
// Content Providers
// ============================================================================

final unit1Provider = Provider<Unit>((ref) {
  return Unit1Content.unit;
});

final lessonsProvider = Provider<List<Lesson>>((ref) {
  return Unit1Content.unit.lessons;
});

final lessonByIdProvider = Provider.family<Lesson?, String>((ref, lessonId) {
  final lessons = ref.watch(lessonsProvider);
  try {
    return lessons.firstWhere((l) => l.lessonId == lessonId);
  } catch (_) {
    return null;
  }
});

final badgesProvider = Provider<List<BadgeDefinition>>((ref) {
  return Unit1Content.badges;
});

// ============================================================================
// Lesson Runner State
// ============================================================================

enum LessonScreenType {
  questionIntro,
  shortText,
  explanation,
  quiz,
  lessonComplete,
}

class LessonRunnerState {
  final Lesson lesson;
  final int currentScreenIndex;
  final LessonScreenType currentScreenType;
  final int warmupXp;
  final int quizXp;
  final int totalCorrect;
  final int totalQuestions;
  final bool warmupAnswered;
  final int currentQuizQuestionIndex;
  final List<bool> quizAnswers;
  final LessonCompletionSummary? completionSummary;

  const LessonRunnerState({
    required this.lesson,
    this.currentScreenIndex = 0,
    this.currentScreenType = LessonScreenType.questionIntro,
    this.warmupXp = 0,
    this.quizXp = 0,
    this.totalCorrect = 0,
    this.totalQuestions = 0,
    this.warmupAnswered = false,
    this.currentQuizQuestionIndex = 0,
    this.quizAnswers = const [],
    this.completionSummary,
  });

  LessonRunnerState copyWith({
    Lesson? lesson,
    int? currentScreenIndex,
    LessonScreenType? currentScreenType,
    int? warmupXp,
    int? quizXp,
    int? totalCorrect,
    int? totalQuestions,
    bool? warmupAnswered,
    int? currentQuizQuestionIndex,
    List<bool>? quizAnswers,
    LessonCompletionSummary? completionSummary,
  }) {
    return LessonRunnerState(
      lesson: lesson ?? this.lesson,
      currentScreenIndex: currentScreenIndex ?? this.currentScreenIndex,
      currentScreenType: currentScreenType ?? this.currentScreenType,
      warmupXp: warmupXp ?? this.warmupXp,
      quizXp: quizXp ?? this.quizXp,
      totalCorrect: totalCorrect ?? this.totalCorrect,
      totalQuestions: totalQuestions ?? this.totalQuestions,
      warmupAnswered: warmupAnswered ?? this.warmupAnswered,
      currentQuizQuestionIndex:
          currentQuizQuestionIndex ?? this.currentQuizQuestionIndex,
      quizAnswers: quizAnswers ?? this.quizAnswers,
      completionSummary: completionSummary ?? this.completionSummary,
    );
  }

  int get answerXpEarned => warmupXp + quizXp;
  int get totalXpEarned => completionSummary?.totalXp ?? answerXpEarned;

  double get quizProgress {
    if (lesson.screens.quiz.questions.isEmpty) return 0;
    return quizAnswers.length / lesson.screens.quiz.questions.length;
  }

  bool get isPerfectQuiz {
    return quizAnswers.isNotEmpty && quizAnswers.every((a) => a);
  }

  int get scorePercent {
    if (totalQuestions == 0) return 0;
    return ((totalCorrect / totalQuestions) * 100).round();
  }
}

class LessonRunnerNotifier extends StateNotifier<LessonRunnerState?> {
  final Ref ref;

  LessonRunnerNotifier(this.ref) : super(null);

  static const _screenOrder = [
    LessonScreenType.questionIntro,
    LessonScreenType.shortText,
    LessonScreenType.explanation,
    LessonScreenType.quiz,
    LessonScreenType.lessonComplete,
  ];

  void startLesson(Lesson lesson) {
    state = LessonRunnerState(
      lesson: lesson,
      totalQuestions: lesson.screens.quiz.questions.length + 1, // +1 for warmup
    );
  }

  void endLesson() {
    state = null;
  }

  void nextScreen() {
    if (state == null) return;

    final currentIndex = _screenOrder.indexOf(state!.currentScreenType);
    if (currentIndex < _screenOrder.length - 1) {
      state = state!.copyWith(
        currentScreenIndex: state!.currentScreenIndex + 1,
        currentScreenType: _screenOrder[currentIndex + 1],
      );
    }
  }

  Future<UserProfile?> answerWarmup(bool isCorrect) async {
    if (state == null || state!.warmupAnswered) return null;

    final lessonId = state!.lesson.lessonId;
    final questionId = '${lessonId}_warmup';
    final xp = isCorrect ? XpRewards.warmup : 0;
    state = state!.copyWith(
      warmupAnswered: true,
      warmupXp: xp,
      totalCorrect: state!.totalCorrect + (isCorrect ? 1 : 0),
    );
    await _recordQuestionAttempt(
      lessonId: lessonId,
      questionId: questionId,
      isCorrect: isCorrect,
    );

    if (isCorrect) {
      return ref.read(userProfileProvider.notifier).addXp(xp);
    } else {
      return ref.read(userProfileProvider.notifier).loseHeart();
    }
  }

  Future<UserProfile?> answerQuizQuestion(bool isCorrect) async {
    if (state == null) return null;

    final lessonId = state!.lesson.lessonId;
    final question =
        state!.lesson.screens.quiz.questions[state!.currentQuizQuestionIndex];
    final newAnswers = [...state!.quizAnswers, isCorrect];
    final xpGained = isCorrect ? XpRewards.quiz : 0;

    state = state!.copyWith(
      quizAnswers: newAnswers,
      quizXp: state!.quizXp + xpGained,
      totalCorrect: state!.totalCorrect + (isCorrect ? 1 : 0),
    );
    await _recordQuestionAttempt(
      lessonId: lessonId,
      questionId: question.questionId,
      isCorrect: isCorrect,
    );

    if (isCorrect) {
      return ref.read(userProfileProvider.notifier).addXp(xpGained);
    } else {
      return ref.read(userProfileProvider.notifier).loseHeart();
    }
  }

  void advanceQuizQuestion() {
    if (state == null) return;
    if (state!.currentQuizQuestionIndex >=
        state!.lesson.screens.quiz.questions.length - 1) {
      return;
    }
    state = state!.copyWith(
      currentQuizQuestionIndex: state!.currentQuizQuestionIndex + 1,
    );
  }

  Future<LessonCompletionSummary?> completeLesson() async {
    if (state == null) return null;

    final lesson = state!.lesson;
    final progress = ref.read(progressProvider);
    final summary = GamificationService.buildLessonCompletionSummary(
      answerXp: state!.answerXpEarned,
      isPerfectQuiz: state!.isPerfectQuiz,
      isFirstCompletion: !progress.isLessonCompleted(lesson.lessonId),
    );

    state = state!.copyWith(completionSummary: summary);

    if (summary.bonusXp > 0) {
      await ref.read(userProfileProvider.notifier).addXp(summary.bonusXp);
    }

    await ref.read(progressProvider.notifier).completeLesson(
          lesson.lessonId,
          score: state!.scorePercent,
          xpEarned: summary.totalXp,
          nextLessonId: lesson.screens.lessonComplete.nextLessonId,
        );

    await ref.read(userProfileProvider.notifier).updateStreak();

    final badgeId = _getBadgeForLesson(lesson.lessonId);
    if (badgeId != null) {
      await ref.read(progressProvider.notifier).earnBadge(badgeId);
    }

    return summary;
  }

  String? _getBadgeForLesson(String lessonId) {
    switch (lessonId) {
      case 'U01_L01':
        return 'BADGE_INNER_MASTERY_STARTER';
      case 'U01_L02':
        return 'BADGE_LIFE_OBSERVER';
      case 'U01_L03':
        return 'BADGE_SOUL_EXPLORER';
      case 'U01_L04':
        return 'BADGE_KARMA_BASICS';
      case 'U01_L05':
        return 'BADGE_TIRTHANKARA_GUIDE';
      case 'U01_MASTER_TEST':
        return 'BADGE_UNIT_MASTER';
      default:
        return null;
    }
  }
}

final lessonRunnerProvider =
    StateNotifierProvider<LessonRunnerNotifier, LessonRunnerState?>((ref) {
  return LessonRunnerNotifier(ref);
});

// ============================================================================
// Practice State
// ============================================================================

enum PracticeMode {
  review,
  targetWeakSpots,
}

class PracticeState {
  final PracticeMode mode;
  final List<QuizQuestion> questions;
  final int currentIndex;
  final int correctCount;
  final int xpEarned;

  const PracticeState({
    required this.mode,
    required this.questions,
    this.currentIndex = 0,
    this.correctCount = 0,
    this.xpEarned = 0,
  });

  PracticeState copyWith({
    PracticeMode? mode,
    List<QuizQuestion>? questions,
    int? currentIndex,
    int? correctCount,
    int? xpEarned,
  }) {
    return PracticeState(
      mode: mode ?? this.mode,
      questions: questions ?? this.questions,
      currentIndex: currentIndex ?? this.currentIndex,
      correctCount: correctCount ?? this.correctCount,
      xpEarned: xpEarned ?? this.xpEarned,
    );
  }

  bool get isComplete => currentIndex >= questions.length;
  bool get isOnLastQuestion =>
      questions.isEmpty || currentIndex >= questions.length - 1;
  QuizQuestion? get currentQuestion =>
      currentIndex < questions.length ? questions[currentIndex] : null;
}

class PracticeNotifier extends StateNotifier<PracticeState?> {
  final Ref ref;

  PracticeNotifier(this.ref) : super(null);

  void startPractice(PracticeMode mode) {
    final progress = ref.read(progressProvider);
    final lessons = ref.read(lessonsProvider);
    final completedLessons = lessons
        .where((lesson) => progress.isLessonCompleted(lesson.lessonId))
        .toList();
    final allQuestions = completedLessons
        .expand((lesson) => lesson.screens.quiz.questions)
        .toList();

    final sessionQuestions = switch (mode) {
      PracticeMode.review =>
        (List<QuizQuestion>.from(allQuestions)..shuffle()).take(8).toList(),
      PracticeMode.targetWeakSpots => _buildWeakSpotQuestions(
          progress: progress,
          completedLessons: completedLessons,
          allQuestions: allQuestions,
        ),
    };

    state = PracticeState(
      mode: mode,
      questions: sessionQuestions,
    );
  }

  List<QuizQuestion> _buildWeakSpotQuestions({
    required ProgressState progress,
    required List<Lesson> completedLessons,
    required List<QuizQuestion> allQuestions,
  }) {
    if (allQuestions.isEmpty) {
      return const <QuizQuestion>[];
    }

    final now = DateTime.now();
    final lessonByQuestionId = <String, String>{};
    for (final lesson in completedLessons) {
      for (final question in lesson.screens.quiz.questions) {
        lessonByQuestionId[question.questionId] = lesson.lessonId;
      }
    }

    final attemptsByQuestionId = <String, List<AttemptLog>>{};
    for (final attempt in StorageService.getAttemptLogs()) {
      if (!lessonByQuestionId.containsKey(attempt.questionId)) {
        continue;
      }
      attemptsByQuestionId
          .putIfAbsent(attempt.questionId, () => [])
          .add(attempt);
    }

    for (final attempts in attemptsByQuestionId.values) {
      attempts.sort((a, b) => b.attemptedAt.compareTo(a.attemptedAt));
    }

    final lowScoreLessonIds = <String>{
      for (final lesson in completedLessons)
        if ((progress.lessonProgress[lesson.lessonId]?.bestScore ?? 100) < 100)
          lesson.lessonId,
    };

    int priorityFor(QuizQuestion question) {
      final attempts =
          attemptsByQuestionId[question.questionId] ?? const <AttemptLog>[];
      final hasIncorrectAttempts =
          attempts.any((attempt) => !attempt.isCorrect);
      final hasDueReview =
          attempts.any((attempt) => _isAttemptDue(attempt, now));
      final lessonId = lessonByQuestionId[question.questionId];
      final isFromLowScoreLesson =
          lessonId != null && lowScoreLessonIds.contains(lessonId);

      if (hasIncorrectAttempts && hasDueReview) return 0;
      if (hasIncorrectAttempts) return 1;
      if (isFromLowScoreLesson) return 2;
      if (hasDueReview) return 3;
      return 4;
    }

    final rankedQuestions = List<QuizQuestion>.from(allQuestions)
      ..sort((a, b) {
        final priorityComparison = priorityFor(a).compareTo(priorityFor(b));
        if (priorityComparison != 0) {
          return priorityComparison;
        }

        final incorrectCountA =
            (attemptsByQuestionId[a.questionId] ?? const <AttemptLog>[])
                .where((attempt) => !attempt.isCorrect)
                .length;
        final incorrectCountB =
            (attemptsByQuestionId[b.questionId] ?? const <AttemptLog>[])
                .where((attempt) => !attempt.isCorrect)
                .length;
        final incorrectComparison = incorrectCountB.compareTo(incorrectCountA);
        if (incorrectComparison != 0) {
          return incorrectComparison;
        }

        final attemptsA =
            attemptsByQuestionId[a.questionId] ?? const <AttemptLog>[];
        final attemptsB =
            attemptsByQuestionId[b.questionId] ?? const <AttemptLog>[];
        final latestA = attemptsA.isEmpty ? null : attemptsA.first.attemptedAt;
        final latestB = attemptsB.isEmpty ? null : attemptsB.first.attemptedAt;
        if (latestA != null && latestB != null) {
          final recencyComparison = latestA.compareTo(latestB);
          if (recencyComparison != 0) {
            return recencyComparison;
          }
        } else if (latestA == null && latestB != null) {
          return -1;
        } else if (latestA != null && latestB == null) {
          return 1;
        }

        return a.questionId.compareTo(b.questionId);
      });

    final focusedQuestions = rankedQuestions
        .where((question) => priorityFor(question) < 4)
        .take(8)
        .toList();
    if (focusedQuestions.isNotEmpty) {
      return focusedQuestions;
    }

    final fallbackQuestions = List<QuizQuestion>.from(allQuestions)..shuffle();
    return fallbackQuestions.take(8).toList();
  }

  Future<void> answerQuestion(QuizQuestion question, bool isCorrect) async {
    if (state == null) return;

    final xp = isCorrect ? XpRewards.practice : 0;

    state = state!.copyWith(
      correctCount: state!.correctCount + (isCorrect ? 1 : 0),
      xpEarned: state!.xpEarned + xp,
    );
    final lessonId = _lessonIdForQuestion(
      ref.read(lessonsProvider),
      question.questionId,
    );
    if (lessonId != null) {
      await _recordQuestionAttempt(
        lessonId: lessonId,
        questionId: question.questionId,
        isCorrect: isCorrect,
      );
    }

    if (isCorrect) {
      await ref.read(userProfileProvider.notifier).addXp(xp);
    }
  }

  void advanceQuestion() {
    if (state == null || state!.isComplete) return;
    state = state!.copyWith(currentIndex: state!.currentIndex + 1);
  }

  Future<PracticeCompletionSummary?> completePractice() async {
    if (state == null) return null;

    final xpEarned = state!.xpEarned;
    final heartsBefore = ref.read(userProfileProvider).hearts;
    final updatedUser = await ref
        .read(userProfileProvider.notifier)
        .refillHeart(amount: HeartsSystem.practiceHeartReward);
    await ref.read(userProfileProvider.notifier).updateStreak();

    final summary = GamificationService.buildPracticeCompletionSummary(
      answerXp: xpEarned,
      heartsBefore: heartsBefore,
      heartsAfter: updatedUser.hearts,
    );

    state = null;
    return summary;
  }

  void endPractice() {
    state = null;
  }
}

final practiceProvider =
    StateNotifierProvider<PracticeNotifier, PracticeState?>((ref) {
  return PracticeNotifier(ref);
});

// ============================================================================
// Home Navigation
// ============================================================================

final homeTabIndexProvider = StateProvider<int>((ref) => 0);
