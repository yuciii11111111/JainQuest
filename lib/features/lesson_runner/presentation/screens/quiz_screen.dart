import 'package:flutter/material.dart';
import 'package:vibration/vibration.dart';
import '../../../../core/localization/app_strings.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/models/lesson_models.dart';
import '../../../../core/widgets/common_widgets.dart';
import '../../../../core/widgets/glass_card.dart';
import '../../../../core/widgets/gradient_button.dart';
import '../../../../core/widgets/liquid_glass.dart';
import '../../../../core/widgets/motion_pressable.dart';
import '../../../../core/widgets/tr_text.dart';

class QuizScreenWidget extends StatefulWidget {
  final QuizScreen screen;
  final int currentQuestionIndex;
  final int hearts;
  final Future<void> Function(bool isCorrect) onAnswer;
  final VoidCallback onNextQuestion;
  final Future<void> Function() onComplete;

  const QuizScreenWidget({
    super.key,
    required this.screen,
    required this.currentQuestionIndex,
    required this.hearts,
    required this.onAnswer,
    required this.onNextQuestion,
    required this.onComplete,
  });

  @override
  State<QuizScreenWidget> createState() => _QuizScreenWidgetState();
}

class _QuizScreenWidgetState extends State<QuizScreenWidget> {
  String? selectedChoiceId;
  bool showFeedback = false;
  bool? isCorrectAnswer;

  @override
  void didUpdateWidget(QuizScreenWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.currentQuestionIndex != widget.currentQuestionIndex) {
      setState(() {
        selectedChoiceId = null;
        showFeedback = false;
        isCorrectAnswer = null;
      });
    }
  }

  QuizQuestion? get currentQuestion {
    if (widget.currentQuestionIndex >= widget.screen.questions.length) {
      return null;
    }
    return widget.screen.questions[widget.currentQuestionIndex];
  }

  void _selectChoice(String choiceId) async {
    if (showFeedback) return;
    // Safe vibration call
    try {
      if (await Vibration.hasVibrator()) {
        Vibration.vibrate(duration: 50);
      }
    } catch (_) {
      // Ignore vibration errors
    }
    setState(() {
      selectedChoiceId = choiceId;
    });
  }

  Future<void> _checkAnswer() async {
    if (currentQuestion == null) return;

    bool isCorrect;

    if (currentQuestion!.format == QuestionFormat.trueFalse) {
      isCorrect = selectedChoiceId == currentQuestion!.answerKey;
    } else {
      final correctChoice = currentQuestion!.choices?.firstWhere(
        (c) => c.isCorrect,
        orElse: () => currentQuestion!.choices!.first,
      );
      isCorrect = selectedChoiceId == correctChoice!.choiceId;
    }

    setState(() {
      showFeedback = true;
      isCorrectAnswer = isCorrect;
    });

    // Haptic feedback and confetti for correct answers
    try {
      if (await Vibration.hasVibrator()) {
        if (isCorrect) {
          Vibration.vibrate(pattern: [0, 50, 100, 50]);
        } else {
          Vibration.vibrate(duration: 200);
        }
      }
    } catch (_) {
      // Ignore vibration errors
    }

    await widget.onAnswer(isCorrect);
  }

  Future<void> _continueToNext() async {
    if (widget.currentQuestionIndex >= widget.screen.questions.length - 1) {
      await widget.onComplete();
    } else {
      widget.onNextQuestion();
    }
  }

  @override
  Widget build(BuildContext context) {
    if (currentQuestion == null) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    }

    final question = currentQuestion!;
    final progress =
        (widget.currentQuestionIndex + 1) / widget.screen.questions.length;

    return Stack(
      children: [
        SafeArea(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppSpacing.lg,
                  vertical: AppSpacing.md,
                ),
                child: Row(
                  children: [
                    IconButton(
                      icon: const Icon(Icons.close_rounded),
                      onPressed: () => Navigator.of(context).maybePop(),
                      color: Theme.of(context).colorScheme.onSurfaceVariant,
                    ),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          AnimatedProgressBar(
                            progress: progress,
                            height: 8,
                            progressColor: null,
                          ),
                          const SizedBox(height: AppSpacing.xs),
                          Text(
                            context.t(
                              'question_of',
                              args: {
                                'current': '${widget.currentQuestionIndex + 1}',
                                'total': '${widget.screen.questions.length}',
                              },
                            ),
                            style: Theme.of(context).textTheme.labelSmall,
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: AppSpacing.sm),
                    HeartsPill(hearts: widget.hearts),
                  ],
                ),
              ),
              const SizedBox(height: AppSpacing.sm),
              Container(
                width: 72,
                height: 72,
                decoration: const BoxDecoration(
                  color: AppColors.primary,
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.emoji_emotions_rounded,
                    color: Colors.white, size: 38),
              ),
              const SizedBox(height: AppSpacing.lg),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
                child: GlassCard(
                  padding: const EdgeInsets.all(AppSpacing.lg),
                  child: TrText(
                    question.prompt,
                    textAlign: TextAlign.center,
                    style: Theme.of(context)
                        .textTheme
                        .headlineSmall
                        ?.copyWith(height: 1.3),
                  ),
                ),
              ),
              const SizedBox(height: AppSpacing.lg),
              Expanded(
                child: SingleChildScrollView(
                  padding:
                      const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
                  child: Column(
                    children: [
                      if (question.format == QuestionFormat.trueFalse)
                        _buildTrueFalseOptions(question)
                      else
                        _buildMultipleChoiceOptions(question),
                      if (showFeedback) ...[
                        const SizedBox(height: AppSpacing.lg),
                        _buildFeedback(question),
                      ],
                      const SizedBox(height: AppSpacing.xl),
                    ],
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(AppSpacing.lg),
                child: showFeedback
                    ? GradientButton(
                        label: widget.currentQuestionIndex >=
                                widget.screen.questions.length - 1
                            ? context.t('complete_quiz')
                            : context.t('next_question'),
                        icon: Icons.arrow_forward_rounded,
                        onPressed: () {
                          _continueToNext();
                        },
                        width: double.infinity,
                      )
                    : GradientButton(
                        label: context.t('check_answer'),
                        icon: Icons.check_rounded,
                        onPressed: selectedChoiceId != null
                            ? () {
                                _checkAnswer();
                              }
                            : null,
                        width: double.infinity,
                      ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildTrueFalseOptions(QuizQuestion question) {
    return Column(
      children: [
        _TrueFalseButton(
          label: context.t('true_label'),
          isSelected: selectedChoiceId == 'true',
          state: _getTrueFalseState('true', question),
          onTap: showFeedback ? null : () => _selectChoice('true'),
        ),
        const SizedBox(height: AppSpacing.md),
        _TrueFalseButton(
          label: context.t('false_label'),
          isSelected: selectedChoiceId == 'false',
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
      children: List.generate(question.choices!.length, (index) {
        final choice = question.choices![index];
        return Padding(
          padding: const EdgeInsets.only(bottom: AppSpacing.md),
          child: _OptionTile(
            letter: String.fromCharCode(65 + index),
            label: choice.label,
            state: _getChoiceState(choice),
            onTap: showFeedback ? null : () => _selectChoice(choice.choiceId),
          ),
        );
      }),
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

  Widget _buildFeedback(QuizQuestion question) {
    String feedbackMessage;

    if (question.format == QuestionFormat.trueFalse) {
      feedbackMessage = isCorrectAnswer == true
          ? context.t('thats_right')
          : context.t(
              'correct_answer_is',
              args: {
                'answer': question.answerKey == 'true'
                    ? context.t('true_label')
                    : context.t('false_label'),
              },
            );
    } else {
      final selectedChoice = question.choices?.firstWhere(
        (c) => c.choiceId == selectedChoiceId,
        orElse: () => question.choices!.first,
      );
      feedbackMessage = selectedChoice?.feedback ?? '';
    }

    return FeedbackBanner(
      isCorrect: isCorrectAnswer ?? false,
      message: feedbackMessage,
    );
  }
}

class _OptionTile extends StatelessWidget {
  final String letter;
  final String label;
  final ChoiceState state;
  final VoidCallback? onTap;

  const _OptionTile({
    required this.letter,
    required this.label,
    required this.state,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    const correctColor = Color(0xFF2E7D32);
    const incorrectColor = Color(0xFFC62828);
    final scheme = Theme.of(context).colorScheme;
    Color borderColor;
    final Color textColor = scheme.onSurface;
    Color bgColor = scheme.surface;

    switch (state) {
      case ChoiceState.normal:
        borderColor = scheme.outline;
        break;
      case ChoiceState.selected:
        borderColor = AppColors.primary;
        break;
      case ChoiceState.correct:
        borderColor = correctColor;
        bgColor = correctColor.withOpacityValue(0.12);
        break;
      case ChoiceState.incorrect:
        borderColor = incorrectColor;
        bgColor = incorrectColor.withOpacityValue(0.12);
        break;
    }

    return MotionPressable(
      onTap: onTap,
      enabled: onTap != null,
      child: LiquidGlassContainer(
        padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.md, vertical: AppSpacing.md),
        borderRadius: BorderRadius.circular(AppRadius.card),
        borderColor: borderColor,
        borderWidth: 2,
        tintColor: bgColor,
        tintOpacity: 0.36,
        child: Row(
          children: [
            Container(
              width: 32,
              height: 32,
              decoration: BoxDecoration(
                color: borderColor.withOpacityValue(0.15),
                shape: BoxShape.circle,
                border: Border.all(color: borderColor, width: 2),
              ),
              child: Center(
                child: Text(
                  letter,
                  style: TextStyle(
                    fontWeight: FontWeight.w700,
                    color: textColor,
                  ),
                ),
              ),
            ),
            const SizedBox(width: AppSpacing.md),
            Expanded(
              child: TrText(
                label,
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                      color: textColor,
                    ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _TrueFalseButton extends StatelessWidget {
  final String label;
  final bool isSelected;
  final ChoiceState state;
  final VoidCallback? onTap;

  const _TrueFalseButton({
    required this.label,
    required this.isSelected,
    required this.state,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    const correctColor = Color(0xFF2E7D32);
    const incorrectColor = Color(0xFFC62828);
    final scheme = Theme.of(context).colorScheme;
    Color backgroundColor;
    Color borderColor;
    final Color textColor = scheme.onSurface;
    IconData? icon;

    switch (state) {
      case ChoiceState.normal:
        backgroundColor = scheme.surface;
        borderColor = scheme.outline;
        break;
      case ChoiceState.selected:
        backgroundColor = scheme.surface;
        borderColor = AppColors.primary;
        break;
      case ChoiceState.correct:
        backgroundColor = correctColor.withOpacityValue(0.12);
        borderColor = correctColor;
        icon = Icons.check_circle_rounded;
        break;
      case ChoiceState.incorrect:
        backgroundColor = incorrectColor.withOpacityValue(0.12);
        borderColor = incorrectColor;
        icon = Icons.cancel_rounded;
        break;
    }

    return MotionPressable(
      onTap: onTap,
      enabled: onTap != null,
      child: LiquidGlassContainer(
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.lg,
          vertical: AppSpacing.md,
        ),
        borderRadius: BorderRadius.circular(AppRadius.button),
        borderColor: borderColor,
        borderWidth: 2,
        tintColor: backgroundColor,
        tintOpacity: 0.36,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (icon != null) ...[
              Icon(icon, color: textColor, size: 24),
              const SizedBox(width: AppSpacing.sm),
            ],
            TrText(
              label,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w700,
                color: textColor,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
