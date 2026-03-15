import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/gamification/gamification_service.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/localization/app_strings.dart';
import '../../../core/providers/app_providers.dart';
import '../../../core/widgets/common_widgets.dart';
import 'screens/question_intro_screen.dart';
import 'screens/short_text_screen.dart';
import 'screens/explanation_screen.dart';
import 'screens/quiz_screen.dart';
import 'screens/lesson_complete_screen.dart';

class LessonRunnerScreen extends ConsumerStatefulWidget {
  const LessonRunnerScreen({super.key});

  @override
  ConsumerState<LessonRunnerScreen> createState() => _LessonRunnerScreenState();
}

class _LessonRunnerScreenState extends ConsumerState<LessonRunnerScreen> {
  _HeartLossAnimationState? _heartLossAnimation;
  int _heartLossAnimationId = 0;

  void _showExitDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppRadius.card),
        ),
        title: Text(context.t('leave_lesson')),
        content: Text(
          context.t('leave_lesson_warning'),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text(context.t('stay')),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              ref.read(lessonRunnerProvider.notifier).endLesson();
              Navigator.of(context).pop();
            },
            child: Text(
              context.t('leave'),
              style: const TextStyle(color: AppColors.danger),
            ),
          ),
        ],
      ),
    );
  }

  void _playHeartLossAnimation(int heartsBefore) {
    if (heartsBefore <= 0) return;
    setState(() {
      _heartLossAnimation = _HeartLossAnimationState(
        id: ++_heartLossAnimationId,
        heartsBefore: heartsBefore,
        heartsAfter: heartsBefore - 1,
      );
    });
  }

  Future<void> _handleWarmupAnswer(bool isCorrect, int heartsBefore) async {
    if (!isCorrect) {
      _playHeartLossAnimation(heartsBefore);
    }
    await ref.read(lessonRunnerProvider.notifier).answerWarmup(isCorrect);
  }

  Future<void> _handleQuizAnswer(bool isCorrect, int heartsBefore) async {
    if (!isCorrect) {
      _playHeartLossAnimation(heartsBefore);
    }
    await ref.read(lessonRunnerProvider.notifier).answerQuizQuestion(isCorrect);
  }

  Future<void> _handleLessonComplete() async {
    final summary =
        await ref.read(lessonRunnerProvider.notifier).completeLesson();
    if (!mounted || summary == null) return;
    ref.read(lessonRunnerProvider.notifier).nextScreen();
  }

  @override
  Widget build(BuildContext context) {
    final lessonState = ref.watch(lessonRunnerProvider);
    final user = ref.watch(userProfileProvider);

    if (lessonState == null) {
      return Scaffold(
        body: Center(child: Text(context.t('no_lesson_loaded'))),
      );
    }

    double overallProgress;
    switch (lessonState.currentScreenType) {
      case LessonScreenType.questionIntro:
        overallProgress = 0.0;
        break;
      case LessonScreenType.shortText:
        overallProgress = 0.25;
        break;
      case LessonScreenType.explanation:
        overallProgress = 0.5;
        break;
      case LessonScreenType.quiz:
        final quizProgress = lessonState.quizProgress;
        overallProgress = 0.75 + (quizProgress * 0.24);
        break;
      case LessonScreenType.lessonComplete:
        overallProgress = 1.0;
        break;
    }

    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) {
        if (!didPop) {
          if (lessonState.currentScreenType ==
              LessonScreenType.lessonComplete) {
            ref.read(lessonRunnerProvider.notifier).endLesson();
            Navigator.of(context).pop();
          } else {
            _showExitDialog();
          }
        }
      },
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: Stack(
          children: [
            Column(
              children: [
                SafeArea(
                  bottom: false,
                  child: Padding(
                    padding: const EdgeInsets.all(AppSpacing.md),
                    child: Row(
                      children: [
                        IconButton(
                          onPressed: () {
                            if (lessonState.currentScreenType ==
                                LessonScreenType.lessonComplete) {
                              ref
                                  .read(lessonRunnerProvider.notifier)
                                  .endLesson();
                              Navigator.of(context).pop();
                            } else {
                              _showExitDialog();
                            }
                          },
                          icon: const Icon(Icons.close_rounded),
                          color: Theme.of(context).colorScheme.onSurfaceVariant,
                        ),
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                              horizontal: AppSpacing.sm,
                            ),
                            child: AnimatedProgressBar(
                              progress: overallProgress,
                              height: 10,
                            ),
                          ),
                        ),
                        HeartsPill(hearts: user.hearts),
                      ],
                    ),
                  ),
                ),
                Expanded(
                  child: _buildCurrentScreen(lessonState, user),
                ),
              ],
            ),
            if (_heartLossAnimation != null)
              HeartLossOverlay(
                key: ValueKey(_heartLossAnimation!.id),
                heartsBefore: _heartLossAnimation!.heartsBefore,
                heartsAfter: _heartLossAnimation!.heartsAfter,
                onComplete: () {
                  if (!mounted) return;
                  setState(() {
                    _heartLossAnimation = null;
                  });
                },
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildCurrentScreen(LessonRunnerState state, dynamic user) {
    switch (state.currentScreenType) {
      case LessonScreenType.questionIntro:
        return QuestionIntroScreenWidget(
          key: const ValueKey('question_intro'),
          screen: state.lesson.screens.questionIntro,
          onAnswer: (isCorrect) {
            return _handleWarmupAnswer(isCorrect, user.hearts);
          },
          onContinue: () {
            ref.read(lessonRunnerProvider.notifier).nextScreen();
          },
          isAnswered: state.warmupAnswered,
        );
      case LessonScreenType.shortText:
        return ShortTextScreenWidget(
          key: const ValueKey('short_text'),
          screen: state.lesson.screens.shortText,
          onContinue: () {
            ref.read(lessonRunnerProvider.notifier).nextScreen();
          },
        );
      case LessonScreenType.explanation:
        return ExplanationScreenWidget(
          key: const ValueKey('explanation'),
          screen: state.lesson.screens.explanation,
          onContinue: () {
            ref.read(lessonRunnerProvider.notifier).nextScreen();
          },
        );
      case LessonScreenType.quiz:
        return QuizScreenWidget(
          key: const ValueKey('quiz'),
          screen: state.lesson.screens.quiz,
          currentQuestionIndex: state.currentQuizQuestionIndex,
          hearts: user.hearts,
          onAnswer: (isCorrect) {
            return _handleQuizAnswer(isCorrect, user.hearts);
          },
          onNextQuestion: () {
            ref.read(lessonRunnerProvider.notifier).advanceQuizQuestion();
          },
          onComplete: () async {
            await _handleLessonComplete();
          },
        );
      case LessonScreenType.lessonComplete:
        return LessonCompleteScreenWidget(
          key: const ValueKey('lesson_complete'),
          screen: state.lesson.screens.lessonComplete,
          summary: state.completionSummary ??
              LessonCompletionSummary(answerXp: state.answerXpEarned),
          streak: user.currentStreak,
          onContinue: () {
            ref.read(lessonRunnerProvider.notifier).endLesson();
            Navigator.of(context).pop();
          },
        );
    }
  }
}

class _HeartLossAnimationState {
  const _HeartLossAnimationState({
    required this.id,
    required this.heartsBefore,
    required this.heartsAfter,
  });

  final int id;
  final int heartsBefore;
  final int heartsAfter;
}
