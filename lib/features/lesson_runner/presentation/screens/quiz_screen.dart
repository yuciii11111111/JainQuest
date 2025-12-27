import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:vibration/vibration.dart';
import 'package:confetti/confetti.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/models/lesson_models.dart';
import '../../../../core/widgets/common_widgets.dart';
import '../../../../core/widgets/glass_card.dart';
import '../../../../core/widgets/gradient_button.dart';

class QuizScreenWidget extends StatefulWidget {
  final QuizScreen screen;
  final int currentQuestionIndex;
  final Function(bool isCorrect) onAnswer;
  final VoidCallback onComplete;

  const QuizScreenWidget({
    super.key,
    required this.screen,
    required this.currentQuestionIndex,
    required this.onAnswer,
    required this.onComplete,
  });

  @override
  State<QuizScreenWidget> createState() => _QuizScreenWidgetState();
}

class _QuizScreenWidgetState extends State<QuizScreenWidget> {
  String? selectedChoiceId;
  bool showFeedback = false;
  bool? isCorrectAnswer;
  late ConfettiController _confettiController;

  @override
  void initState() {
    super.initState();
    _confettiController = ConfettiController(duration: const Duration(seconds: 2));
  }

  @override
  void dispose() {
    _confettiController.dispose();
    super.dispose();
  }

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
      if (await Vibration.hasVibrator() ?? false) {
        Vibration.vibrate(duration: 50);
      }
    } catch (_) {
      // Ignore vibration errors
    }
    setState(() {
      selectedChoiceId = choiceId;
    });
  }

  void _checkAnswer() async {
    if (currentQuestion == null) return;

    bool isCorrect;

    if (currentQuestion!.format == QuestionFormat.trueFalse) {
      isCorrect = selectedChoiceId == currentQuestion!.answerKey;
    } else {
      final correctChoice = currentQuestion!.choices?.firstWhere(
        (c) => c.isCorrect,
        orElse: () => currentQuestion!.choices!.first,
      );
      isCorrect = selectedChoiceId == correctChoice?.choiceId;
    }

    setState(() {
      showFeedback = true;
      isCorrectAnswer = isCorrect;
    });

    // Haptic feedback and confetti for correct answers
    try {
      if (await Vibration.hasVibrator() ?? false) {
        if (isCorrect) {
          Vibration.vibrate(pattern: [0, 50, 100, 50]);
          // Trigger confetti for correct answer
          _confettiController.play();
        } else {
          Vibration.vibrate(duration: 200);
        }
      }
    } catch (_) {
      // Ignore vibration errors
      if (isCorrect) {
        _confettiController.play();
      }
    }

    widget.onAnswer(isCorrect);
  }

  void _continueToNext() {
    if (widget.currentQuestionIndex >= widget.screen.questions.length - 1) {
      widget.onComplete();
    } else {
      // Reset state for next question
      setState(() {
        selectedChoiceId = null;
        showFeedback = false;
        isCorrectAnswer = null;
      });
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
                      color: AppColors.textSecondary,
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
                            'Question ${widget.currentQuestionIndex + 1} of ${widget.screen.questions.length}',
                            style: Theme.of(context).textTheme.labelSmall,
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: AppSpacing.sm),
                    HeartsPill(hearts: 5),
                  ],
                ),
              ),
              const SizedBox(height: AppSpacing.sm),
              Container(
                width: 72,
                height: 72,
                decoration: BoxDecoration(
                  gradient: AppGradients.primary,
                  shape: BoxShape.circle,
                  boxShadow: AppShadows.glowing,
                ),
                child: const Icon(Icons.emoji_emotions_rounded, color: Colors.white, size: 38),
              ),
              const SizedBox(height: AppSpacing.lg),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
                child: GlassCard(
                  padding: const EdgeInsets.all(AppSpacing.lg),
                  child: Text(
                    question.prompt,
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.headlineSmall?.copyWith(height: 1.3),
                  ),
                ),
              ),
              const SizedBox(height: AppSpacing.lg),
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
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
                        label: widget.currentQuestionIndex >= widget.screen.questions.length - 1
                            ? 'Complete Quiz'
                            : 'Next Question',
                        icon: Icons.arrow_forward_rounded,
                        onPressed: _continueToNext,
                        width: double.infinity,
                      )
                    : GradientButton(
                        label: 'Check Answer',
                        icon: Icons.check_rounded,
                        onPressed: selectedChoiceId != null ? _checkAnswer : null,
                        width: double.infinity,
                      ),
              ),
            ],
          ),
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
              Colors.green,
            ],
            numberOfParticles: 50,
            gravity: 0.1,
          ),
        ),
      ],
    );
  }

  Widget _buildTrueFalseOptions(QuizQuestion question) {
    return Column(
      children: [
        _TrueFalseButton(
          label: 'True',
          isSelected: selectedChoiceId == 'true',
          state: _getTrueFalseState('true', question),
          onTap: showFeedback ? null : () => _selectChoice('true'),
        ),
        const SizedBox(height: AppSpacing.md),
        _TrueFalseButton(
          label: 'False',
          isSelected: selectedChoiceId == 'false',
          state: _getTrueFalseState('false', question),
          onTap: showFeedback ? null : () => _selectChoice('false'),
        ),
      ],
    );
  }

  ChoiceState _getTrueFalseState(String value, QuizQuestion question) {
    if (!showFeedback) {
      return selectedChoiceId == value ? ChoiceState.selected : ChoiceState.normal;
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
          ? 'That\'s right!'
          : 'The correct answer is ${question.answerKey}.';
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
    Color borderColor;
    Color textColor;
    Color bgColor = AppColors.backgroundCard;

    switch (state) {
      case ChoiceState.normal:
        borderColor = AppColors.glassBorder;
        textColor = AppColors.textPrimary;
        break;
      case ChoiceState.selected:
        borderColor = AppColors.primary;
        textColor = AppColors.textPrimary;
        break;
      case ChoiceState.correct:
        borderColor = AppColors.success;
        textColor = AppColors.success;
        break;
      case ChoiceState.incorrect:
        borderColor = AppColors.danger;
        textColor = AppColors.danger;
        break;
    }

    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md, vertical: AppSpacing.md),
        decoration: BoxDecoration(
          color: bgColor,
          borderRadius: BorderRadius.circular(AppRadius.card),
          border: Border.all(color: borderColor, width: 2),
        ),
        child: Row(
          children: [
            Container(
              width: 32,
              height: 32,
              decoration: BoxDecoration(
                color: borderColor.withOpacity(0.15),
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
              child: Text(
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
    Color backgroundColor;
    Color borderColor;
    Color textColor;
    IconData? icon;

    switch (state) {
      case ChoiceState.normal:
        backgroundColor = AppColors.backgroundCard;
        borderColor = AppColors.glassBorder;
        textColor = AppColors.textPrimary;
        break;
      case ChoiceState.selected:
        backgroundColor = AppColors.backgroundCard;
        borderColor = AppColors.primary;
        textColor = AppColors.textPrimary;
        break;
      case ChoiceState.correct:
        backgroundColor = AppColors.backgroundCard;
        borderColor = AppColors.success;
        textColor = AppColors.success;
        icon = Icons.check_circle_rounded;
        break;
      case ChoiceState.incorrect:
        backgroundColor = AppColors.backgroundCard;
        borderColor = AppColors.danger;
        textColor = AppColors.danger;
        icon = Icons.cancel_rounded;
        break;
    }

    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.lg,
          vertical: AppSpacing.md,
        ),
        decoration: BoxDecoration(
          color: backgroundColor,
          borderRadius: BorderRadius.circular(AppRadius.button),
          border: Border.all(color: borderColor, width: 2),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (icon != null) ...[
              Icon(icon, color: textColor, size: 24),
              const SizedBox(width: AppSpacing.sm),
            ],
            Text(
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
