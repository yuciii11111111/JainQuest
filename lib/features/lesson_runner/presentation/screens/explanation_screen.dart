import 'package:flutter/material.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/models/lesson_models.dart';
import '../../../../core/widgets/common_widgets.dart';
import '../../../../core/widgets/typewriter_sequence.dart';

class ExplanationScreenWidget extends StatelessWidget {
  final ExplanationScreen screen;
  final VoidCallback onContinue;

  const ExplanationScreenWidget({
    super.key,
    required this.screen,
    required this.onContinue,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(AppSpacing.lg),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header
                Row(
                  children: [
                    Container(
                      width: 48,
                      height: 48,
                      decoration: BoxDecoration(
                        color: AppColors.primary.withOpacityValue(0.1),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Icon(
                        Icons.lightbulb_rounded,
                        color: AppColors.primary,
                        size: 24,
                      ),
                    ),
                    const SizedBox(width: AppSpacing.md),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Deep Dive',
                            style: Theme.of(context).textTheme.titleLarge,
                          ),
                          const SizedBox(height: 4),
                          Text(
                            'Explore the concepts in detail',
                            style: Theme.of(context).textTheme.bodySmall,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: AppSpacing.xl),

                // Sections
                ...screen.sections.asMap().entries.map((entry) {
                  final index = entry.key;
                  final section = entry.value;
                  final isLast = index == screen.sections.length - 1;

                  return Padding(
                    padding: EdgeInsets.only(
                      bottom: isLast ? 0 : AppSpacing.lg,
                    ),
                    child: _ExplanationSectionCard(section: section),
                  );
                }),
              ],
            ),
          ),
        ),

        // Continue button
        SafeArea(
          top: false,
          child: Padding(
            padding: const EdgeInsets.all(AppSpacing.lg),
            child: PrimaryButton(
              label: 'Continue to Quiz',
              icon: Icons.arrow_forward_rounded,
              onPressed: onContinue,
            ),
          ),
        ),
      ],
    );
  }
}

class _ExplanationSectionCard extends StatelessWidget {
  final ExplanationSection section;

  const _ExplanationSectionCard({required this.section});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(AppRadius.card),
        border: Border.all(color: Theme.of(context).colorScheme.outline),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Main content
          Padding(
            padding: const EdgeInsets.all(AppSpacing.lg),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TypewriterSequence(
                  gap: AppSpacing.md,
                  items: [
                    TypewriterSequenceItem(
                      text: section.title,
                      style: Theme.of(context).textTheme.headlineSmall,
                      speed: const Duration(milliseconds: 16),
                    ),
                    TypewriterSequenceItem(
                      text: section.body,
                      style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                            height: 1.6,
                          ),
                      speed: const Duration(milliseconds: 12),
                    ),
                  ],
                ),
              ],
            ),
          ),

          // Scientific connection
          if (section.scientificConnection != null)
            _InfoBox(
              icon: Icons.science_rounded,
              title: 'Science Connection',
              content: section.scientificConnection!,
              color: Colors.blue,
            ),

          // Real life analogy
          if (section.realLifeAnalogy != null)
            _InfoBox(
              icon: Icons.emoji_objects_rounded,
              title: 'Real-Life Analogy',
              content: section.realLifeAnalogy!,
              color: AppColors.secondary,
            ),

        ],
      ),
    );
  }
}

class _InfoBox extends StatelessWidget {
  final IconData icon;
  final String title;
  final String content;
  final Color color;

  const _InfoBox({
    required this.icon,
    required this.title,
    required this.content,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.fromLTRB(
        AppSpacing.md,
        0,
        AppSpacing.md,
        AppSpacing.md,
      ),
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: color.withOpacityValue(0.08),
        borderRadius: BorderRadius.circular(AppRadius.small),
        border: Border.all(color: color.withOpacityValue(0.2)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 20, color: color),
          const SizedBox(width: AppSpacing.sm),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w700,
                    color: color,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  content,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        height: 1.5,
                      ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
