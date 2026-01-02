import 'package:flutter/material.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/widgets/glass_card.dart';
import '../../../core/widgets/floating_card.dart';
import '../../../core/widgets/typewriter_text.dart';
import '../../../core/widgets/typewriter_sequence.dart';

class GuruScreen extends StatefulWidget {
  const GuruScreen({super.key});

  @override
  State<GuruScreen> createState() => _GuruScreenState();
}

class _GuruScreenState extends State<GuruScreen> {
  final List<String> _popularQuestions = [
    'What is Jainism?',
    'Why is Ahimsa important?',
    'Soul after death?',
    'How does karma work?',
    'Jain food rules?',
    'The 5 vows?',
    'Daily practice?',
    'What is Moksha?',
    'The Tirthankaras?',
  ];

  String? _selectedQuestion;
  String? _answerText;
  bool? _wasHelpful;

  String _generateResponse(String question) {
    if (question.toLowerCase().contains('ahimsa')) {
      return "Ahimsa is Jainism's core principle of non-violence - avoiding harm to any living being through thought, word, and deed.";
    } else if (question.toLowerCase().contains('karma')) {
      return 'Karma is seen as subtle matter that sticks to the soul based on actions and intentions, influencing future experiences until purified.';
    } else if (question.toLowerCase().contains('vows')) {
      return 'The five vows guide daily conduct: non-violence, truth, non-stealing, celibacy or fidelity, and non-attachment.';
    } else if (question.toLowerCase().contains('moksha')) {
      return 'Moksha is liberation - when the soul sheds all karma and attains infinite knowledge, bliss, and freedom.';
    }
    return 'Jainism teaches that every soul can reach liberation through right knowledge, right faith, and right conduct.';
  }

  void _selectQuestion(String question) {
    setState(() {
      _selectedQuestion = question;
      _answerText = _generateResponse(question);
      _wasHelpful = null;
    });
  }

  List<String> _keyPointsForAnswer() {
    return const [
      'Ahimsa (Non-violence) - Not harming any living being',
      'Satya (Truth) - Always being honest',
      'Aparigraha - Not being attached to material things',
      'Self-improvement through spiritual practice',
    ];
  }

  @override
  Widget build(BuildContext context) {
    final showingAnswer = _selectedQuestion != null;

    return Scaffold(
      backgroundColor: Colors.transparent,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(AppSpacing.lg),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  IconButton(
                    icon: const Icon(Icons.arrow_back_rounded),
                    color: AppColors.textSecondary,
                    onPressed: () => Navigator.of(context).maybePop(),
                  ),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        TypewriterSequence(
                          gap: 4,
                          pauseBetween: const Duration(milliseconds: 400),
                          crossAxisAlignment: CrossAxisAlignment.center,
                          items: [
                            TypewriterSequenceItem(
                              text: 'Ask Guru',
                              style: Theme.of(context).textTheme.headlineMedium,
                              speed: const Duration(milliseconds: 16),
                              punctuationDelay: const Duration(milliseconds: 180),
                              showCursor: true,
                              blinkCursor: true,
                            ),
                            TypewriterSequenceItem(
                              text: 'Your Jain learning guide',
                              style: Theme.of(context).textTheme.labelSmall,
                              speed: const Duration(milliseconds: 18),
                              punctuationDelay: const Duration(milliseconds: 160),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.refresh_rounded),
                    color: AppColors.textSecondary,
                    onPressed: () {
                      setState(() {
                        _selectedQuestion = null;
                        _answerText = null;
                        _wasHelpful = null;
                      });
                    },
                  ),
                ],
              ),
              const SizedBox(height: AppSpacing.md),
              if (!showingAnswer) ...[
                TypewriterSequence(
                  gap: AppSpacing.sm,
                  items: [
                    TypewriterSequenceItem(
                      text: 'Popular Questions',
                      style: Theme.of(context).textTheme.titleLarge,
                      speed: const Duration(milliseconds: 18),
                      punctuationDelay: const Duration(milliseconds: 160),
                    ),
                    ..._popularQuestions.map(
                      (question) => TypewriterSequenceItem(
                        text: question,
                        style: Theme.of(context).textTheme.bodyLarge,
                        speed: const Duration(milliseconds: 14),
                        punctuationDelay: const Duration(milliseconds: 120),
                      ),
                    ),
                  ],
                  itemBuilder: (context, child, index, item) {
                    if (index == 0) {
                      return child;
                    }
                    return Padding(
                      padding: const EdgeInsets.only(bottom: AppSpacing.sm),
                      child: FloatingCard(
                        onTap: () => _selectQuestion(item.text),
                        padding: const EdgeInsets.symmetric(
                          horizontal: AppSpacing.md,
                          vertical: AppSpacing.md,
                        ),
                        child: Row(
                          children: [
                            Expanded(child: child),
                            const Icon(
                              Icons.arrow_forward_ios_rounded,
                              size: 16,
                              color: AppColors.textSecondary,
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ] else ...[
                Center(
                  child: Column(
                    children: [
                      Container(
                        width: 90,
                        height: 90,
                        decoration: BoxDecoration(
                          gradient: AppGradients.primary,
                          shape: BoxShape.circle,
                          boxShadow: AppShadows.glowing,
                        ),
                        child: const Icon(Icons.auto_awesome_rounded, color: Colors.white, size: 46),
                      ),
                      const SizedBox(height: AppSpacing.sm),
                      Text('Guru', style: Theme.of(context).textTheme.titleLarge),
                      Text(
                        'Your Jain learning guide',
                        style: Theme.of(context).textTheme.labelSmall,
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: AppSpacing.md),
                if (_selectedQuestion != null)
                  Center(
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: AppSpacing.lg,
                        vertical: AppSpacing.sm,
                      ),
                      decoration: BoxDecoration(
                        color: AppColors.primary.withOpacityValue(0.15),
                        borderRadius: BorderRadius.circular(AppRadius.pill),
                        border: Border.all(color: AppColors.primary.withOpacityValue(0.3)),
                      ),
                      child: Text(
                        _selectedQuestion!,
                        style: Theme.of(context).textTheme.labelLarge,
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                const SizedBox(height: AppSpacing.md),
                GlassCard(
                  padding: const EdgeInsets.all(AppSpacing.lg),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          const Icon(Icons.psychology_alt_rounded, color: AppColors.highlight),
                          const SizedBox(width: AppSpacing.sm),
                          Text(
                            'Guru',
                            style: Theme.of(context).textTheme.titleMedium,
                          ),
                        ],
                      ),
                      const SizedBox(height: AppSpacing.md),
                      if (_answerText != null)
                        TypewriterText(
                          text: _answerText!,
                          style: Theme.of(context).textTheme.bodyMedium,
                          speed: const Duration(milliseconds: 18),
                          punctuationDelay: const Duration(milliseconds: 200),
                          showCursor: true,
                          blinkCursor: true,
                        ),
                      const SizedBox(height: AppSpacing.md),
                      TypewriterSequence(
                        gap: AppSpacing.xs,
                        items: _keyPointsForAnswer()
                            .map(
                              (point) => TypewriterSequenceItem(
                                text: point,
                                style: Theme.of(context).textTheme.bodySmall,
                                speed: const Duration(milliseconds: 16),
                                punctuationDelay: const Duration(milliseconds: 140),
                              ),
                            )
                            .toList(),
                        itemBuilder: (context, child, index, item) {
                          return Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                '- ',
                                style: TextStyle(
                                  color: AppColors.textPrimary,
                                  fontSize: 16,
                                ),
                              ),
                              Expanded(child: child),
                            ],
                          );
                        },
                      ),
                      const SizedBox(height: AppSpacing.md),
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(AppSpacing.md),
                        decoration: BoxDecoration(
                          color: AppColors.warning.withOpacityValue(0.2),
                          borderRadius: BorderRadius.circular(AppRadius.small),
                        ),
                        child: Row(
                          children: [
                            const Icon(Icons.lightbulb_rounded, color: AppColors.warning),
                            const SizedBox(width: AppSpacing.sm),
                            Expanded(
                              child: TypewriterText(
                                text:
                                    "Fun Fact: Jainism is over 2,500 years old, making it one of the world's oldest religions.",
                                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                      color: AppColors.warning,
                                    ),
                                speed: const Duration(milliseconds: 16),
                                punctuationDelay: const Duration(milliseconds: 180),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: AppSpacing.md),
                TypewriterText(
                  text: 'Was this helpful?',
                  style: Theme.of(context).textTheme.bodyMedium,
                  speed: const Duration(milliseconds: 18),
                  punctuationDelay: const Duration(milliseconds: 140),
                ),
                const SizedBox(height: AppSpacing.sm),
                Row(
                  children: [
                    Expanded(
                      child: FloatingCard(
                        onTap: () => setState(() => _wasHelpful = true),
                        padding: const EdgeInsets.symmetric(vertical: AppSpacing.md),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.thumb_up_rounded,
                                color: _wasHelpful == true ? AppColors.success : AppColors.textSecondary),
                            const SizedBox(width: AppSpacing.xs),
                            Text('Yes', style: Theme.of(context).textTheme.labelLarge),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(width: AppSpacing.md),
                    Expanded(
                      child: FloatingCard(
                        onTap: () => setState(() => _wasHelpful = false),
                        padding: const EdgeInsets.symmetric(vertical: AppSpacing.md),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.thumb_down_rounded,
                                color: _wasHelpful == false ? AppColors.danger : AppColors.textSecondary),
                            const SizedBox(width: AppSpacing.xs),
                            Text('No', style: Theme.of(context).textTheme.labelLarge),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: AppSpacing.lg),
                TypewriterText(
                  text: 'Related Questions',
                  style: Theme.of(context).textTheme.titleMedium,
                  speed: const Duration(milliseconds: 18),
                  punctuationDelay: const Duration(milliseconds: 160),
                ),
                const SizedBox(height: AppSpacing.sm),
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: _popularQuestions.take(5).map((q) {
                      return Padding(
                        padding: const EdgeInsets.only(right: AppSpacing.sm),
                        child: FloatingCard(
                          onTap: () => _selectQuestion(q),
                          padding: const EdgeInsets.symmetric(
                            horizontal: AppSpacing.md,
                            vertical: AppSpacing.sm,
                          ),
                          child: Text(
                            q,
                            style: Theme.of(context).textTheme.labelLarge,
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
