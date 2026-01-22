import 'package:flutter/material.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/widgets/floating_card.dart';
import '../../../core/widgets/gradient_button.dart';
import '../../../core/widgets/typewriter_sequence.dart';
import 'reading_screen.dart';

class ResourcesScreen extends StatelessWidget {
  const ResourcesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final onSurface = Theme.of(context).colorScheme.onSurface;
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(AppSpacing.lg),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TypewriterSequence(
                gap: AppSpacing.xs,
                items: [
                  TypewriterSequenceItem(
                    text: 'Resources',
                    style: Theme.of(context).textTheme.displaySmall?.copyWith(
                          fontWeight: FontWeight.w900,
                        ),
                    speed: const Duration(milliseconds: 14),
                  ),
                  TypewriterSequenceItem(
                    text:
                        'Read a knowledgeable book teaching the fundamentals of Jainism in great depth.',
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: onSurface.withOpacityValue(0.7),
                        ),
                    speed: const Duration(milliseconds: 16),
                  ),
                ],
              ),
              const SizedBox(height: AppSpacing.lg),
              FloatingCard(
                padding: const EdgeInsets.all(AppSpacing.lg),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'FundJain Reader',
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                    const SizedBox(height: AppSpacing.sm),
                    Text(
                      'Immersive reading with adjustable font, themes, and animated page turns.',
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                    const SizedBox(height: AppSpacing.md),
                    GradientButton(
                      label: 'Start Reading',
                      icon: Icons.auto_stories_rounded,
                      onPressed: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(builder: (_) => const ReadingScreen()),
                        );
                      },
                      width: double.infinity,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: AppSpacing.lg),
              Text('Quick Guides', style: Theme.of(context).textTheme.titleLarge),
              const SizedBox(height: AppSpacing.sm),
              _ResourceTile(
                title: 'Ahimsa in Daily Life',
                description:
                    'A simple checklist for practicing non-violence in speech, thought, and action.',
                icon: Icons.spa_rounded,
                onTap: () => _openGuide(context, 'Ahimsa in Daily Life',
                    'Pause before you speak. Swap harsh words with kindness. Choose plant-based meals today. Notice tiny lives around you.'),
              ),
              const SizedBox(height: AppSpacing.md),
              _ResourceTile(
                title: 'Jiva vs Ajiva',
                description:
                    'A quick way to spot living vs non-living using the senses ladder.',
                icon: Icons.bubble_chart_rounded,
                onTap: () => _openGuide(context, 'Jiva vs Ajiva',
                    'Living beings sense, breathe, and move in subtle ways. Ajiva is matter and time - supporting life but not alive.'),
              ),
              const SizedBox(height: AppSpacing.md),
              _ResourceTile(
                title: 'Karma & Emotion',
                description:
                    'How emotions affect karmic binding and how to slow the chain.',
                icon: Icons.bolt_rounded,
                onTap: () => _openGuide(context, 'Karma & Emotion',
                    'Strong emotions bind karma quickly. Slow down with breath, gratitude, and gentle speech.'),
              ),
              const SizedBox(height: AppSpacing.xl),
            ],
          ),
        ),
      ),
    );
  }

  void _openGuide(BuildContext context, String title, String body) {
    final scheme = Theme.of(context).colorScheme;
    showModalBottomSheet(
      context: context,
      backgroundColor: scheme.surface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(AppRadius.card)),
      ),
      builder: (_) {
        return Padding(
          padding: const EdgeInsets.all(AppSpacing.lg),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Text(title, style: Theme.of(context).textTheme.titleLarge),
                  const Spacer(),
                  IconButton(
                    icon: const Icon(Icons.close_rounded),
                    onPressed: () => Navigator.of(context).pop(),
                  ),
                ],
              ),
              const SizedBox(height: AppSpacing.sm),
              Text(
                body,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(height: 1.6),
              ),
              const SizedBox(height: AppSpacing.md),
              GradientButton(
                label: 'Open Reader',
                icon: Icons.auto_stories_rounded,
                onPressed: () {
                  Navigator.of(context).pop();
                  Navigator.of(context).push(MaterialPageRoute(builder: (_) => const ReadingScreen()));
                },
                width: double.infinity,
              ),
            ],
          ),
        );
      },
    );
  }
}

class _ResourceTile extends StatelessWidget {
  final String title;
  final String description;
  final IconData icon;
  final VoidCallback? onTap;

  const _ResourceTile({
    required this.title,
    required this.description,
    required this.icon,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return FloatingCard(
      onTap: onTap,
      padding: const EdgeInsets.all(AppSpacing.md),
      child: Row(
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: AppColors.primary,
              borderRadius: BorderRadius.circular(AppRadius.small),
            ),
            child: Icon(icon, color: Colors.white),
          ),
          const SizedBox(width: AppSpacing.md),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                const SizedBox(height: 2),
                Text(
                  description,
                  style: Theme.of(context).textTheme.bodySmall,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
