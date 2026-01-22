import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/providers/app_providers.dart';
import '../../../core/widgets/common_widgets.dart';
import '../../../core/models/lesson_models.dart';

class PracticeSessionScreen extends ConsumerStatefulWidget {
  const PracticeSessionScreen({super.key});

  @override
  ConsumerState<PracticeSessionScreen> createState() => _PracticeSessionScreenState();
}

class _PracticeSessionScreenState extends ConsumerState<PracticeSessionScreen> {
  String? selectedChoiceId;
  bool showFeedback = false;
  bool? isCorrectAnswer;

  void _selectChoice(String choiceId) {
    if (showFeedback) return;
    setState(() {
      selectedChoiceId = choiceId;
    });
  }

  void _checkAnswer(QuizQuestion question) {
    bool isCorrect;

    if (question.format == QuestionFormat.trueFalse) {
      isCorrect = selectedChoiceId == question.answerKey;
    } else {
      final correctChoice = question.choices?.firstWhere(
        (c) => c.isCorrect,
        orElse: () => question.choices!.first,
      );
      isCorrect = selectedChoiceId == correctChoice?.choiceId;
    }

    setState(() {
      showFeedback = true;
      isCorrectAnswer = isCorrect;
    });

    ref.read(practiceProvider.notifier).answerQuestion(isCorrect);
  }

  void _nextQuestion() {
    final practiceState = ref.read(practiceProvider);
    
    if (practiceState != null && practiceState.isComplete) {
      // Show completion
      ref.read(practiceProvider.notifier).completePractice();
      _showCompletionDialog();
    } else {
      setState(() {
        selectedChoiceId = null;
        showFeedback = false;
        isCorrectAnswer = null;
      });
    }
  }

  void _showCompletionDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        final practiceState = ref.read(practiceProvider);
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppRadius.card),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const MascotWidget(
                state: MascotState.complete,
                size: 80,
              ),
              const SizedBox(height: AppSpacing.lg),
              Text(
                'Practice Complete!',
                style: Theme.of(context).textTheme.headlineSmall,
              ),
              const SizedBox(height: AppSpacing.md),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.star_rounded, color: AppColors.secondary),
                  const SizedBox(width: AppSpacing.xs),
                  Text(
                    '+${practiceState?.xpEarned ?? 0} XP',
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                      color: AppColors.secondary,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: AppSpacing.sm),
              const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.favorite_rounded, color: AppColors.danger),
                  SizedBox(width: AppSpacing.xs),
                  Text(
                    '+1 Heart',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: AppColors.danger,
                    ),
                  ),
                ],
              ),
            ],
          ),
          actions: [
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.of(context).pop(); // Close dialog
                  Navigator.of(context).pop(); // Close practice screen
                },
                child: const Text('Done'),
              ),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final practiceState = ref.watch(practiceProvider);
    final user = ref.watch(userProfileProvider);

    if (practiceState == null || practiceState.questions.isEmpty) {
      return Scaffold(
        backgroundColor: Colors.transparent,
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.quiz_rounded,
                size: 64,
                color: scheme.onSurfaceVariant,
              ),
              const SizedBox(height: AppSpacing.md),
              Text(
                'No questions available',
                style: Theme.of(context).textTheme.titleLarge,
              ),
              const SizedBox(height: AppSpacing.lg),
              ElevatedButton(
                onPressed: () => Navigator.of(context).pop(),
                child: const Text('Go Back'),
              ),
            ],
          ),
        ),
      );
    }

    if (practiceState.isComplete) {
      // Auto-show completion
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _showCompletionDialog();
      });
      return const Scaffold(
        backgroundColor: Colors.transparent,
        body: Center(child: CircularProgressIndicator()),
      );
    }

    final question = practiceState.currentQuestion!;
    final progress = (practiceState.currentIndex + 1) / practiceState.questions.length;

    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Column(
        children: [
          // Top bar
          SafeArea(
            bottom: false,
            child: Padding(
              padding: const EdgeInsets.all(AppSpacing.md),
              child: Row(
                children: [
                  IconButton(
                    onPressed: () {
                      ref.read(practiceProvider.notifier).endPractice();
                      Navigator.of(context).pop();
                    },
                    icon: const Icon(Icons.close_rounded),
                    color: scheme.onSurfaceVariant,
                  ),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: AppSpacing.sm,
                      ),
                      child: AnimatedProgressBar(
                        progress: progress,
                        height: 10,
                        progressColor: AppColors.secondary,
                      ),
                    ),
                  ),
                  HeartsPill(hearts: user.hearts),
                ],
              ),
            ),
          ),

          // Question content
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(AppSpacing.lg),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Mode badge
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: AppSpacing.md,
                      vertical: AppSpacing.xs,
                    ),
                    decoration: BoxDecoration(
                      color: AppColors.secondary.withOpacityValue(0.1),
                      borderRadius: BorderRadius.circular(AppRadius.pill),
                    ),
                    child: Text(
                      practiceState.mode == PracticeMode.review
                          ? 'Review'
                          : 'Weak Spots',
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w700,
                        color: AppColors.secondary,
                      ),
                    ),
                  ),
                  const SizedBox(height: AppSpacing.lg),

                  // Mascot
                  if (showFeedback)
                    Center(
                      child: MascotWidget(
                        state: isCorrectAnswer == true
                            ? MascotState.correct
                            : MascotState.wrong,
                        size: 80,
                      ),
                    ),
                  if (showFeedback) const SizedBox(height: AppSpacing.lg),

                  // Question
                  Text(
                    question.prompt,
                    style: Theme.of(context).textTheme.headlineSmall,
                  ),
                  const SizedBox(height: AppSpacing.xl),

                  // Answer options
                  if (question.format == QuestionFormat.trueFalse)
                    _buildTrueFalseOptions(question)
                  else
                    _buildMultipleChoiceOptions(question),

                  // Feedback
                  if (showFeedback) ...[
                    const SizedBox(height: AppSpacing.lg),
                    FeedbackBanner(
                      isCorrect: isCorrectAnswer ?? false,
                      message: isCorrectAnswer == true
                          ? 'Great job!'
                          : 'Keep practicing!',
                    ),
                  ],
                ],
              ),
            ),
          ),

          // Action button
          SafeArea(
            top: false,
            child: Padding(
              padding: const EdgeInsets.all(AppSpacing.lg),
              child: showFeedback
                  ? PrimaryButton(
                      label: practiceState.currentIndex >=
                              practiceState.questions.length - 1
                          ? 'Finish'
                          : 'Next',
                      icon: Icons.arrow_forward_rounded,
                      onPressed: _nextQuestion,
                    )
                  : PrimaryButton(
                      label: 'Check',
                      onPressed: selectedChoiceId != null
                          ? () => _checkAnswer(question)
                          : null,
                    ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTrueFalseOptions(QuizQuestion question) {
    return Column(
      children: [
        ChoiceButton(
          label: 'True',
          state: _getTrueFalseState('true', question),
          onTap: showFeedback ? null : () => _selectChoice('true'),
        ),
        const SizedBox(height: AppSpacing.md),
        ChoiceButton(
          label: 'False',
          state: _getTrueFalseState('false', question),
          onTap: showFeedback ? null : () => _selectChoice('false'),
        ),
      ],
    );
  }

  ChoiceState _getTrueFalseState(String value, QuizQuestion question) {
    if (!showFeedback) {
      return selectedChoiceId == value
          ? ChoiceState.selected
          : ChoiceState.normal;
    }

    if (value == question.answerKey) {
      return ChoiceState.correct;
    }

    if (selectedChoiceId == value && value != question.answerKey) {
      return ChoiceState.incorrect;
    }

    return ChoiceState.normal;
  }

  Widget _buildMultipleChoiceOptions(QuizQuestion question) {
    return Column(
      children: question.choices!.map((choice) {
        return Padding(
          padding: const EdgeInsets.only(bottom: AppSpacing.md),
          child: ChoiceButton(
            label: choice.label,
            state: _getChoiceState(choice),
            onTap: showFeedback ? null : () => _selectChoice(choice.choiceId),
          ),
        );
      }).toList(),
    );
  }

  ChoiceState _getChoiceState(Choice choice) {
    if (!showFeedback) {
      return selectedChoiceId == choice.choiceId
          ? ChoiceState.selected
          : ChoiceState.normal;
    }

    if (choice.isCorrect) {
      return ChoiceState.correct;
    }

    if (selectedChoiceId == choice.choiceId && !choice.isCorrect) {
      return ChoiceState.incorrect;
    }

    return ChoiceState.normal;
  }
}
