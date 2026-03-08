import 'package:flutter/material.dart';
import '../../../../core/localization/app_strings.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/models/lesson_models.dart';
import '../../../../core/widgets/common_widgets.dart';
import '../../../../core/widgets/tr_text.dart';

class QuestionIntroScreenWidget extends StatefulWidget {
  final QuestionIntroScreen screen;
  final Function(bool isCorrect) onAnswer;
  final VoidCallback onContinue;
  final bool isAnswered;

  const QuestionIntroScreenWidget({
    super.key,
    required this.screen,
    required this.onAnswer,
    required this.onContinue,
    required this.isAnswered,
  });

  @override
  State<QuestionIntroScreenWidget> createState() =>
      _QuestionIntroScreenWidgetState();
}

class _QuestionIntroScreenWidgetState extends State<QuestionIntroScreenWidget> {
  String? selectedChoiceId;
  bool showFeedback = false;
  Choice? selectedChoice;

  void _selectChoice(Choice choice) {
    if (widget.isAnswered) return;

    setState(() {
      selectedChoiceId = choice.choiceId;
      selectedChoice = choice;
    });
  }

  void _submitAnswer() {
    if (selectedChoice == null) return;

    setState(() {
      showFeedback = true;
    });

    widget.onAnswer(selectedChoice!.isCorrect);
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

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(AppSpacing.lg),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Mascot
          const Center(
            child: MascotWidget(
              state: MascotState.idle,
              size: 80,
            ),
          ),
          const SizedBox(height: AppSpacing.lg),

          // Title badge
          Container(
            padding: const EdgeInsets.symmetric(
              horizontal: AppSpacing.md,
              vertical: AppSpacing.sm,
            ),
            decoration: BoxDecoration(
              color: AppColors.primary.withOpacityValue(0.1),
              borderRadius: BorderRadius.circular(AppRadius.pill),
            ),
            child: TrText(
              widget.screen.title,
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w700,
                color: AppColors.primary,
              ),
            ),
          ),
          const SizedBox(height: AppSpacing.lg),
          TrText(
            widget.screen.prompt,
            style: Theme.of(context).textTheme.headlineSmall,
          ),
          const SizedBox(height: AppSpacing.xl),

          // Choice buttons
          ...widget.screen.choices.map((choice) {
            return Padding(
              padding: const EdgeInsets.only(bottom: AppSpacing.md),
              child: ChoiceButton(
                label: choice.label,
                state: _getChoiceState(choice),
                onTap: showFeedback ? null : () => _selectChoice(choice),
              ),
            );
          }),

          const SizedBox(height: AppSpacing.md),

          // Feedback banner
          if (showFeedback && selectedChoice != null)
            FeedbackBanner(
              isCorrect: selectedChoice!.isCorrect,
              message: selectedChoice!.isCorrect
                  ? selectedChoice!.feedbackCorrect
                  : selectedChoice!.feedbackWrong,
              onContinue: widget.onContinue,
            ),

          // Submit button (before answer)
          if (!showFeedback)
            PrimaryButton(
              label: context.t('check'),
              onPressed: selectedChoiceId != null ? _submitAnswer : null,
            ),

          const SizedBox(height: AppSpacing.xl),
        ],
      ),
    );
  }
}
