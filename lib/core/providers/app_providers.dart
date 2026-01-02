import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/user_models.dart';
import '../models/lesson_models.dart';
import '../models/badge_definition.dart';
import '../services/storage_service.dart';
import '../content/unit1_content.dart';

// ============================================================================
// User Profile Provider
// ============================================================================

class UserProfileNotifier extends StateNotifier<UserProfile> {
  UserProfileNotifier() : super(StorageService.getUserProfile());

  void refresh() {
    state = StorageService.getUserProfile();
  }

  Future<void> addXp(int xp) async {
    state = await StorageService.addXp(xp);
  }

  Future<void> loseHeart() async {
    state = await StorageService.loseHeart();
  }

  Future<void> refillHeart({int amount = 1}) async {
    state = await StorageService.refillHeart(amount: amount);
  }

  Future<void> updateStreak() async {
    state = await StorageService.updateStreak();
  }

  Future<void> updateDisplayName(String displayName) async {
    final updatedUser = state.copyWith(displayName: displayName);
    await StorageService.saveUserProfile(updatedUser);
    state = updatedUser;
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
  youtubeVideo,
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
      currentQuizQuestionIndex: currentQuizQuestionIndex ?? this.currentQuizQuestionIndex,
      quizAnswers: quizAnswers ?? this.quizAnswers,
    );
  }

  int get totalXpEarned => warmupXp + quizXp;

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
    LessonScreenType.youtubeVideo,
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

  void answerWarmup(bool isCorrect) {
    if (state == null || state!.warmupAnswered) return;

    final xp = isCorrect ? 2 : 0;
    state = state!.copyWith(
      warmupAnswered: true,
      warmupXp: xp,
      totalCorrect: state!.totalCorrect + (isCorrect ? 1 : 0),
    );

    // Update user XP and hearts
    if (isCorrect) {
      ref.read(userProfileProvider.notifier).addXp(xp);
    } else {
      ref.read(userProfileProvider.notifier).loseHeart();
    }
  }

  void answerQuizQuestion(bool isCorrect) {
    if (state == null) return;

    final newAnswers = [...state!.quizAnswers, isCorrect];
    final xpGained = isCorrect ? 3 : 0;

    state = state!.copyWith(
      quizAnswers: newAnswers,
      quizXp: state!.quizXp + xpGained,
      totalCorrect: state!.totalCorrect + (isCorrect ? 1 : 0),
    );

    // Update user XP and hearts
    if (isCorrect) {
      ref.read(userProfileProvider.notifier).addXp(xpGained);
    } else {
      ref.read(userProfileProvider.notifier).loseHeart();
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

  Future<void> completeLesson() async {
    if (state == null) return;

    final lesson = state!.lesson;
    var totalXp = state!.totalXpEarned;

    // Check for perfect quiz bonus
    if (state!.isPerfectQuiz) {
      totalXp += 5;
      await ref.read(userProfileProvider.notifier).addXp(5);
    }

    // Check for first time completion bonus
    final progress = ref.read(progressProvider);
    if (!progress.isLessonCompleted(lesson.lessonId)) {
      totalXp += 5;
      await ref.read(userProfileProvider.notifier).addXp(5);
    }

    // Complete lesson in progress
    await ref.read(progressProvider.notifier).completeLesson(
          lesson.lessonId,
          score: state!.scorePercent,
          xpEarned: totalXp,
          nextLessonId: lesson.screens.lessonComplete.nextLessonId,
        );

    // Update streak
    await ref.read(userProfileProvider.notifier).updateStreak();

    // Earn badge
    final badgeId = _getBadgeForLesson(lesson.lessonId);
    if (badgeId != null) {
      await ref.read(progressProvider.notifier).earnBadge(badgeId);
    }
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
  QuizQuestion? get currentQuestion =>
      currentIndex < questions.length ? questions[currentIndex] : null;
}

class PracticeNotifier extends StateNotifier<PracticeState?> {
  final Ref ref;

  PracticeNotifier(this.ref) : super(null);

  void startPractice(PracticeMode mode) {
    // Gather questions from completed lessons
    final progress = ref.read(progressProvider);
    final lessons = ref.read(lessonsProvider);

    final questions = <QuizQuestion>[];
    for (final lesson in lessons) {
      if (progress.isLessonCompleted(lesson.lessonId)) {
        questions.addAll(lesson.screens.quiz.questions);
      }
    }

    // Shuffle for review mode
    if (mode == PracticeMode.review) {
      questions.shuffle();
    }

    // Take 8 questions max
    final sessionQuestions = questions.take(8).toList();

    state = PracticeState(
      mode: mode,
      questions: sessionQuestions,
    );
  }

  void answerQuestion(bool isCorrect) {
    if (state == null) return;

    final xp = isCorrect ? 2 : 0;

    state = state!.copyWith(
      currentIndex: state!.currentIndex + 1,
      correctCount: state!.correctCount + (isCorrect ? 1 : 0),
      xpEarned: state!.xpEarned + xp,
    );

    if (isCorrect) {
      ref.read(userProfileProvider.notifier).addXp(xp);
    }
  }

  Future<void> completePractice() async {
    if (state == null) return;

    // Refill a heart for completing practice
    await ref.read(userProfileProvider.notifier).refillHeart();

    // Update streak
    await ref.read(userProfileProvider.notifier).updateStreak();

    state = null;
  }

  void endPractice() {
    state = null;
  }
}

final practiceProvider =
    StateNotifierProvider<PracticeNotifier, PracticeState?>((ref) {
  return PracticeNotifier(ref);
});
