import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/gamification/gamification_service.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/localization/app_strings.dart';
import '../../../core/providers/app_providers.dart';
import '../../../core/widgets/common_widgets.dart';
import '../../../core/models/lesson_models.dart';

class PracticeSessionScreen extends ConsumerStatefulWidget {
  const PracticeSessionScreen({super.key});

  @override
  ConsumerState<PracticeSessionScreen> createState() =>
      _PracticeSessionScreenState();
}

class _PracticeSessionScreenState extends ConsumerState<PracticeSessionScreen> {
  String? selectedChoiceId;
  bool showFeedback = false;
  bool? isCorrectAnswer;
  bool isCompletingPractice = false;

  void _selectChoice(String choiceId) {
    if (showFeedback) return;
    setState(() {
      selectedChoiceId = choiceId;
    });
  }

  Future<void> _checkAnswer(QuizQuestion question) async {
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

    await ref
        .read(practiceProvider.notifier)
        .answerQuestion(question, isCorrect);
  }

  Future<void> _nextQuestion() async {
    final practiceState = ref.read(practiceProvider);
    if (practiceState == null) return;

    if (practiceState.isOnLastQuestion) {
      setState(() {
        isCompletingPractice = true;
      });
      final summary =
          await ref.read(practiceProvider.notifier).completePractice();
      if (!mounted) return;
      if (summary == null) {
        setState(() {
          isCompletingPractice = false;
        });
        return;
      }
      _showCompletionDialog(summary);
      return;
    }

    ref.read(practiceProvider.notifier).advanceQuestion();
    setState(() {
      selectedChoiceId = null;
      showFeedback = false;
      isCorrectAnswer = null;
    });
  }

  void _showCompletionDialog(PracticeCompletionSummary summary) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
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
                context.t('practice_complete'),
                style: Theme.of(context).textTheme.headlineSmall,
              ),
              const SizedBox(height: AppSpacing.md),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.star_rounded, color: AppColors.secondary),
                  const SizedBox(width: AppSpacing.xs),
                  Text(
                    '+${summary.answerXp} ${context.t('xp')}',
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                      color: AppColors.secondary,
                    ),
                  ),
                ],
              ),
              if (summary.heartRefilled) ...[
                const SizedBox(height: AppSpacing.sm),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.favorite_rounded, color: AppColors.danger),
                    const SizedBox(width: AppSpacing.xs),
                    Text(
                      context.t('heart_refilled'),
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: AppColors.danger,
                      ),
                    ),
                  ],
                ),
              ],
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
                child: Text(context.t('done')),
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
                context.t('no_questions'),
                style: Theme.of(context).textTheme.titleLarge,
              ),
              const SizedBox(height: AppSpacing.lg),
              ElevatedButton(
                onPressed: () => Navigator.of(context).pop(),
                child: Text(context.t('go_back')),
              ),
            ],
          ),
        ),
      );
    }

    if (isCompletingPractice) {
      return const Scaffold(
        backgroundColor: Colors.transparent,
        body: Center(child: CircularProgressIndicator()),
      );
    }

    final question = practiceState.currentQuestion!;
    final progress =
        (practiceState.currentIndex + 1) / practiceState.questions.length;

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
                          ? context.t('review')
                          : context.t('weak_spots'),
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
                          ? context.t('great_job')
                          : context.t('keep_practicing'),
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
                      label: practiceState.isOnLastQuestion
                          ? context.t('finish')
                          : context.t('next'),
                      icon: Icons.arrow_forward_rounded,
                      onPressed: () {
                        _nextQuestion();
                      },
                    )
                  : PrimaryButton(
                      label: context.t('check'),
                      onPressed: selectedChoiceId != null
                          ? () {
                              _checkAnswer(question);
                            }
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
          label: context.t('true_label'),
          state: _getTrueFalseState('true', question),
          onTap: showFeedback ? null : () => _selectChoice('true'),
        ),
        const SizedBox(height: AppSpacing.md),
        ChoiceButton(
          label: context.t('false_label'),
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
