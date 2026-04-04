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
import '../../../core/localization/app_strings.dart';

class ResourcesScreen extends StatefulWidget {
  const ResourcesScreen({super.key});

  @override
  State<ResourcesScreen> createState() => _ResourcesScreenState();
}

class _ResourcesScreenState extends State<ResourcesScreen> {
  static const List<_QuickGuide> _quickGuides = [
    _QuickGuide(
      id: 'ahimsa_daily_life',
      titleKey: 'guide_ahimsa_title',
      descriptionKey: 'guide_ahimsa_desc',
      bodyKey: 'guide_ahimsa_body',
      icon: Icons.spa_rounded,
    ),
    _QuickGuide(
      id: 'jiva_vs_ajiva',
      titleKey: 'guide_jiva_title',
      descriptionKey: 'guide_jiva_desc',
      bodyKey: 'guide_jiva_body',
      icon: Icons.bubble_chart_rounded,
    ),
    _QuickGuide(
      id: 'karma_and_emotion',
      titleKey: 'guide_karma_title',
      descriptionKey: 'guide_karma_desc',
      bodyKey: 'guide_karma_body',
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
                    text: context.t('resources_header'),
                    style: Theme.of(context).textTheme.displaySmall?.copyWith(
                          fontWeight: FontWeight.w900,
                        ),
                    speed: const Duration(milliseconds: 14),
                  ),
                  TypewriterSequenceItem(
                    text: context.t('resources_desc'),
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
                      context.t('fundjain_reader'),
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                    const SizedBox(height: AppSpacing.sm),
                    Text(
                      context.t('reader_desc'),
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                    const SizedBox(height: AppSpacing.md),
                    GradientButton(
                      label: context.t('start_reading'),
                      icon: Icons.auto_stories_rounded,
                      onPressed: () {
                        Navigator.of(context)
                            .pushUltraSmooth(const ReadingScreen());
                      },
                      width: double.infinity,
                    ),
                    const SizedBox(height: AppSpacing.sm),
                    Text(
                      context.t('daily_reading_reward_hint'),
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: AppColors.primary,
                          ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: AppSpacing.lg),
              Text(context.t('quick_guides'),
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
                    title: context.t(guide.titleKey),
                    description: context.t(guide.descriptionKey),
                    icon: guide.icon,
                    isCompleted: _guideCompletions[guide.id] ?? false,
                    onTap: () => _openGuide(guide),
                  ),
                );
              }),
              const SizedBox(height: AppSpacing.xl),
              const SizedBox(height: AppSpacing.lg),
              Text(context.t('video_library'),
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
      isScrollControlled: true,
      useSafeArea: true,
      backgroundColor: scheme.surface,
      shape: const RoundedRectangleBorder(
        borderRadius:
            BorderRadius.vertical(top: Radius.circular(AppRadius.card)),
      ),
      builder: (_) {
        return DraggableScrollableSheet(
          expand: false,
          initialChildSize: 0.72,
          minChildSize: 0.45,
          maxChildSize: 0.92,
          builder: (context, scrollController) {
            return SingleChildScrollView(
              controller: scrollController,
              padding: const EdgeInsets.all(AppSpacing.lg),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          context.t(guide.titleKey),
                          style: Theme.of(context).textTheme.titleLarge,
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.close_rounded),
                        onPressed: () => Navigator.of(context).pop(),
                      ),
                    ],
                  ),
                  const SizedBox(height: AppSpacing.sm),
                  Text(
                    context.t(guide.bodyKey),
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
                          const Icon(
                            Icons.check_circle_rounded,
                            size: 16,
                            color: Colors.green,
                          ),
                          const SizedBox(width: 6),
                          Text(
                            context.t('completed'),
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
                      label: Text(context.t('mark_completed')),
                    ),
                  if (!isCompleted) const SizedBox(height: AppSpacing.sm),
                  GradientButton(
                    label: context.t('open_reader'),
                    icon: Icons.auto_stories_rounded,
                    onPressed: () {
                      Navigator.of(context).pop();
                      Navigator.of(context)
                          .pushUltraSmooth(const ReadingScreen());
                    },
                    width: double.infinity,
                  ),
                ],
              ),
            );
          },
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
  final String titleKey;
  final String descriptionKey;
  final String bodyKey;
  final IconData icon;

  const _QuickGuide({
    required this.id,
    required this.titleKey,
    required this.descriptionKey,
    required this.bodyKey,
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
                          context.t('completed'),
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
            SnackBar(content: Text(context.t('could_not_open'))),
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
