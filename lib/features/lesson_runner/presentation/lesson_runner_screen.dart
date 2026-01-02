import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:confetti/confetti.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/providers/app_providers.dart';
import '../../../core/widgets/common_widgets.dart';
import 'screens/question_intro_screen.dart';
import 'screens/short_text_screen.dart';
import 'screens/youtube_video_screen.dart';
import 'screens/explanation_screen.dart';
import 'screens/quiz_screen.dart';
import 'screens/lesson_complete_screen.dart';

class LessonRunnerScreen extends ConsumerStatefulWidget {
  const LessonRunnerScreen({super.key});

  @override
  ConsumerState<LessonRunnerScreen> createState() => _LessonRunnerScreenState();
}

class _LessonRunnerScreenState extends ConsumerState<LessonRunnerScreen> {
  late ConfettiController _confettiController;

  @override
  void initState() {
    super.initState();
    _confettiController = ConfettiController(duration: const Duration(seconds: 3));
  }

  @override
  void dispose() {
    _confettiController.dispose();
    super.dispose();
  }

  void _showExitDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppRadius.card),
        ),
        title: const Text('Leave lesson?'),
        content: const Text(
          'Your progress in this lesson will not be saved.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Stay'),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              ref.read(lessonRunnerProvider.notifier).endLesson();
              Navigator.of(context).pop();
            },
            child: const Text(
              'Leave',
              style: TextStyle(color: AppColors.danger),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final lessonState = ref.watch(lessonRunnerProvider);
    final user = ref.watch(userProfileProvider);

    if (lessonState == null) {
      return const Scaffold(
        body: Center(child: Text('No lesson loaded')),
      );
    }

    double overallProgress;
    switch (lessonState.currentScreenType) {
      case LessonScreenType.questionIntro:
        overallProgress = 0.0;
        break;
      case LessonScreenType.shortText:
        overallProgress = 0.16;
        break;
      case LessonScreenType.youtubeVideo:
        overallProgress = 0.33;
        break;
      case LessonScreenType.explanation:
        overallProgress = 0.5;
        break;
      case LessonScreenType.quiz:
        final quizProgress = lessonState.quizProgress;
        overallProgress = 0.66 + (quizProgress * 0.17);
        break;
      case LessonScreenType.lessonComplete:
        overallProgress = 1.0;
        break;
    }

    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) {
        if (!didPop) {
          if (lessonState.currentScreenType == LessonScreenType.lessonComplete) {
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
                              ref.read(lessonRunnerProvider.notifier).endLesson();
                              Navigator.of(context).pop();
                            } else {
                              _showExitDialog();
                            }
                          },
                          icon: const Icon(Icons.close_rounded),
                          color: AppColors.textSecondary,
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
                  child: AnimatedSwitcher(
                    duration: const Duration(milliseconds: 500),
                    transitionBuilder: (child, animation) {
                      return FadeTransition(
                        opacity: animation,
                        child: SlideTransition(
                          position: Tween<Offset>(
                            begin: const Offset(0.04, 0),
                            end: Offset.zero,
                          ).animate(animation),
                          child: child,
                        ),
                      );
                    },
                    child: _buildCurrentScreen(lessonState, user),
                  ),
                ),
              ],
            ),
            Align(
              alignment: Alignment.topCenter,
              child: ConfettiWidget(
                confettiController: _confettiController,
                blastDirectionality: BlastDirectionality.explosive,
                shouldLoop: false,
                colors: const [
                  AppColors.primary,
                  AppColors.secondary,
                  AppColors.success,
                  Colors.blue,
                  Colors.purple,
                ],
                numberOfParticles: 30,
              ),
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
            ref.read(lessonRunnerProvider.notifier).answerWarmup(isCorrect);
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
      case LessonScreenType.youtubeVideo:
        return YoutubeVideoScreenWidget(
          key: const ValueKey('youtube_video'),
          screen: state.lesson.screens.youtubeVideo,
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
            ref.read(lessonRunnerProvider.notifier).answerQuizQuestion(isCorrect);
          },
          onNextQuestion: () {
            ref.read(lessonRunnerProvider.notifier).advanceQuizQuestion();
          },
          onComplete: () async {
            await ref.read(lessonRunnerProvider.notifier).completeLesson();
            ref.read(lessonRunnerProvider.notifier).nextScreen();
            _confettiController.play();
          },
        );
      case LessonScreenType.lessonComplete:
        return LessonCompleteScreenWidget(
          key: const ValueKey('lesson_complete'),
          screen: state.lesson.screens.lessonComplete,
          xpEarned: state.totalXpEarned,
          isPerfect: state.isPerfectQuiz,
          streak: user.currentStreak,
          onContinue: () {
            ref.read(lessonRunnerProvider.notifier).endLesson();
            Navigator.of(context).pop();
          },
        );
    }
  }
}
