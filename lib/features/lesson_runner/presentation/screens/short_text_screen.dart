import 'package:flutter/material.dart';
import '../../../../core/localization/app_strings.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/models/lesson_models.dart';
import '../../../../core/widgets/common_widgets.dart';
import '../../../../core/widgets/liquid_glass.dart';
import '../../../../core/widgets/tr_text.dart';

class ShortTextScreenWidget extends StatefulWidget {
  final ShortTextScreen screen;
  final VoidCallback onContinue;

  const ShortTextScreenWidget({
    super.key,
    required this.screen,
    required this.onContinue,
  });

  @override
  State<ShortTextScreenWidget> createState() => _ShortTextScreenWidgetState();
}

class _ShortTextScreenWidgetState extends State<ShortTextScreenWidget> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _nextCard() {
    if (_currentPage < widget.screen.cards.length - 1) {
      _pageController.jumpToPage(_currentPage + 1);
    } else {
      widget.onContinue();
    }
  }

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final cards = widget.screen.cards;

    return Column(
      children: [
        // Page indicator
        Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.lg,
            vertical: AppSpacing.md,
          ),
          child: Row(
            children: List.generate(
              cards.length,
              (index) => Expanded(
                child: Container(
                  height: 4,
                  margin: EdgeInsets.only(
                    right: index < cards.length - 1 ? AppSpacing.xs : 0,
                  ),
                  decoration: BoxDecoration(
                    color: index <= _currentPage
                        ? AppColors.primary
                        : scheme.outline,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
            ),
          ),
        ),

        // Read time indicator
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
          child: Row(
            children: [
              Icon(
                Icons.schedule_rounded,
                size: 16,
                color: scheme.onSurfaceVariant,
              ),
              const SizedBox(width: AppSpacing.xs),
              Text(
                context.t('min_read', args: {'count': cards.length.toString()}),
                style: Theme.of(context).textTheme.bodySmall,
              ),
            ],
          ),
        ),
        const SizedBox(height: AppSpacing.md),

        // Cards
        Expanded(
          child: PageView.builder(
            controller: _pageController,
            onPageChanged: (page) {
              setState(() {
                _currentPage = page;
              });
            },
            itemCount: cards.length,
            itemBuilder: (context, index) {
              final card = cards[index];
              return SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
                child: _TextCardWidget(card: card),
              );
            },
          ),
        ),

        // Navigation
        SafeArea(
          top: false,
          child: Padding(
            padding: const EdgeInsets.all(AppSpacing.lg),
            child: Row(
              children: [
                // Previous button
                if (_currentPage > 0)
                  Expanded(
                    child: SecondaryButton(
                      label: context.t('back'),
                      icon: Icons.arrow_back_rounded,
                      onPressed: () {
                        _pageController.jumpToPage(_currentPage - 1);
                      },
                    ),
                  ),
                if (_currentPage > 0) const SizedBox(width: AppSpacing.md),

                // Next button
                Expanded(
                  child: PrimaryButton(
                    label: _currentPage < cards.length - 1
                        ? context.t('next')
                        : context.t('continue'),
                    icon: Icons.arrow_forward_rounded,
                    onPressed: _nextCard,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class _TextCardWidget extends StatelessWidget {
  final TextCard card;

  const _TextCardWidget({required this.card});

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return LiquidGlassContainer(
      padding: const EdgeInsets.all(AppSpacing.lg),
      borderRadius: BorderRadius.circular(AppRadius.card),
      borderColor: scheme.outline.withOpacityValue(0.75),
      borderWidth: 1.2,
      tintColor: scheme.surface,
      tintOpacity: 0.3,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TrText(
                card.title,
                style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                      color: scheme.onSurface,
                    ),
              ),
              const SizedBox(height: AppSpacing.md),
              Container(
                width: 48,
                height: 4,
                decoration: BoxDecoration(
                  color: AppColors.primary,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              const SizedBox(height: AppSpacing.lg),
              TrText(
                card.body,
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                      color: scheme.onSurface.withOpacityValue(0.95),
                      height: 1.6,
                    ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
