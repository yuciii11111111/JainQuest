import 'package:url_launcher/url_launcher.dart';
import 'package:flutter/material.dart';
import '../../../core/services/storage_service.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/navigation/app_navigator.dart';
import '../../../core/widgets/floating_card.dart';
import '../../../core/widgets/gradient_button.dart';
import '../../../core/widgets/typewriter_sequence.dart';
import '../../resources/data/resource_data.dart';
import 'reading_screen.dart';

class ResourcesScreen extends StatefulWidget {
  const ResourcesScreen({super.key});

  @override
  State<ResourcesScreen> createState() => _ResourcesScreenState();
}

class _ResourcesScreenState extends State<ResourcesScreen> {
  static const List<_QuickGuide> _quickGuides = [
    _QuickGuide(
      id: 'ahimsa_daily_life',
      title: 'Ahimsa in Daily Life',
      description:
          'A simple checklist for practicing non-violence in speech, thought, and action.',
      body:
          'Pause before you speak. Swap harsh words with kindness. Choose plant-based meals today. Notice tiny lives around you.',
      icon: Icons.spa_rounded,
    ),
    _QuickGuide(
      id: 'jiva_vs_ajiva',
      title: 'Jiva vs Ajiva',
      description:
          'A quick way to spot living vs non-living using the senses ladder.',
      body:
          'Living beings sense, breathe, and move in subtle ways. Ajiva is matter and time - supporting life but not alive.',
      icon: Icons.bubble_chart_rounded,
    ),
    _QuickGuide(
      id: 'karma_and_emotion',
      title: 'Karma & Emotion',
      description:
          'How emotions affect karmic binding and how to slow the chain.',
      body:
          'Strong emotions bind karma quickly. Slow down with breath, gratitude, and gentle speech.',
      icon: Icons.bolt_rounded,
    ),
  ];

  Map<String, bool> _guideCompletions = {};

  @override
  void initState() {
    super.initState();
    _guideCompletions = StorageService.getQuickGuideCompletions();
  }

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
                        Navigator.of(context).pushUltraSmooth(const ReadingScreen());
                      },
                      width: double.infinity,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: AppSpacing.lg),
              Text('Quick Guides',
                  style: Theme.of(context).textTheme.titleLarge),
              const SizedBox(height: AppSpacing.sm),
              ..._quickGuides.asMap().entries.map((entry) {
                final index = entry.key;
                final guide = entry.value;
                return Padding(
                  padding: EdgeInsets.only(
                    bottom:
                        index == _quickGuides.length - 1 ? 0 : AppSpacing.md,
                  ),
                  child: _ResourceTile(
                    title: guide.title,
                    description: guide.description,
                    icon: guide.icon,
                    isCompleted: _guideCompletions[guide.id] ?? false,
                    onTap: () => _openGuide(guide),
                  ),
                );
              }),
              const SizedBox(height: AppSpacing.xl),
              const SizedBox(height: AppSpacing.lg),
              Text('Video Library',
                  style: Theme.of(context).textTheme.titleLarge),
              const SizedBox(height: AppSpacing.sm),
              ...ResourceData.categories.map((category) {
                return Padding(
                  padding: const EdgeInsets.only(bottom: AppSpacing.md),
                  child: _CategoryTile(category: category),
                );
              }),
              const SizedBox(height: AppSpacing.xl),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _openGuide(_QuickGuide guide) async {
    final isCompleted = _guideCompletions[guide.id] ?? false;
    final scheme = Theme.of(context).colorScheme;
    final markedComplete = await showModalBottomSheet<bool>(
      context: context,
      backgroundColor: scheme.surface,
      shape: const RoundedRectangleBorder(
        borderRadius:
            BorderRadius.vertical(top: Radius.circular(AppRadius.card)),
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
                  Text(
                    guide.title,
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  const Spacer(),
                  IconButton(
                    icon: const Icon(Icons.close_rounded),
                    onPressed: () => Navigator.of(context).pop(),
                  ),
                ],
              ),
              const SizedBox(height: AppSpacing.sm),
              Text(
                guide.body,
                style: Theme.of(context)
                    .textTheme
                    .bodyMedium
                    ?.copyWith(height: 1.6),
              ),
              const SizedBox(height: AppSpacing.sm),
              if (isCompleted)
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppSpacing.sm,
                    vertical: AppSpacing.xs,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.green.withOpacityValue(0.15),
                    borderRadius: BorderRadius.circular(AppRadius.small),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(Icons.check_circle_rounded,
                          size: 16, color: Colors.green),
                      const SizedBox(width: 6),
                      Text(
                        'Completed',
                        style: Theme.of(context).textTheme.labelMedium,
                      ),
                    ],
                  ),
                ),
              const SizedBox(height: AppSpacing.md),
              if (!isCompleted)
                OutlinedButton.icon(
                  onPressed: () => Navigator.of(context).pop(true),
                  icon: const Icon(Icons.check_circle_outline_rounded),
                  label: const Text('Mark as Completed'),
                ),
              if (!isCompleted) const SizedBox(height: AppSpacing.sm),
              GradientButton(
                label: 'Open Reader',
                icon: Icons.auto_stories_rounded,
                onPressed: () {
                  Navigator.of(context).pop();
                  Navigator.of(context).pushUltraSmooth(const ReadingScreen());
                },
                width: double.infinity,
              ),
            ],
          ),
        );
      },
    );

    if (markedComplete == true && mounted) {
      await StorageService.markQuickGuideCompleted(guide.id);
      setState(() {
        _guideCompletions[guide.id] = true;
      });
    }
  }
}

class _QuickGuide {
  final String id;
  final String title;
  final String description;
  final String body;
  final IconData icon;

  const _QuickGuide({
    required this.id,
    required this.title,
    required this.description,
    required this.body,
    required this.icon,
  });
}

class _ResourceTile extends StatelessWidget {
  final String title;
  final String description;
  final IconData icon;
  final bool isCompleted;
  final VoidCallback? onTap;

  const _ResourceTile({
    required this.title,
    required this.description,
    required this.icon,
    this.isCompleted = false,
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
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        title,
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                    ),
                    if (isCompleted)
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: AppSpacing.sm,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.green.withOpacityValue(0.15),
                          borderRadius: BorderRadius.circular(AppRadius.small),
                        ),
                        child: Text(
                          'Completed',
                          style: Theme.of(context)
                              .textTheme
                              .labelSmall
                              ?.copyWith(color: Colors.green.shade800),
                        ),
                      ),
                  ],
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

class _CategoryTile extends StatelessWidget {
  final ResourceCategory category;

  const _CategoryTile({required this.category});

  Future<void> _launchUrl(BuildContext context, String urlString) async {
    final Uri url = Uri.parse(urlString);
    try {
      if (!await launchUrl(url, mode: LaunchMode.externalApplication)) {
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Could not open link')),
          );
        }
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: $e')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Card(
      child: ExpansionTile(
        leading: Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: AppColors.primary.withOpacityValue(0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(category.icon, color: AppColors.primary),
        ),
        title: Text(
          category.title,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        childrenPadding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.md, vertical: AppSpacing.sm),
        children: category.links.map((link) {
          return ListTile(
            leading: Icon(
              link.isSearch ? Icons.search_rounded : Icons.explore_rounded,
              color: link.isSearch ? scheme.onSurfaceVariant : Colors.redAccent,
              size: 20,
            ),
            title: Text(
              link.title,
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            onTap: () => _launchUrl(context, link.url),
            dense: true,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(AppRadius.small),
            ),
            contentPadding: EdgeInsets.zero,
            visualDensity: VisualDensity.compact,
          );
        }).toList(),
      ),
    );
  }
}
