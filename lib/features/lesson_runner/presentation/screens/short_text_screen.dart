import 'package:flutter/material.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/models/lesson_models.dart';
import '../../../../core/widgets/common_widgets.dart';

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
      _pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOutCubic,
      );
    } else {
      widget.onContinue();
    }
  }

  @override
  Widget build(BuildContext context) {
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
                        : AppColors.glassBorder,
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
              const Icon(
                Icons.schedule_rounded,
                size: 16,
                color: AppColors.textSecondary,
              ),
              const SizedBox(width: AppSpacing.xs),
              Text(
                '${cards.length} min read',
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
                      label: 'Back',
                      icon: Icons.arrow_back_rounded,
                      onPressed: () {
                        _pageController.previousPage(
                          duration: const Duration(milliseconds: 300),
                          curve: Curves.easeOutCubic,
                        );
                      },
                    ),
                  ),
                if (_currentPage > 0) const SizedBox(width: AppSpacing.md),

                // Next button
                Expanded(
                  child: PrimaryButton(
                    label: _currentPage < cards.length - 1 ? 'Next' : 'Continue',
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
    return Container(
      padding: const EdgeInsets.all(AppSpacing.lg),
      decoration: BoxDecoration(
        color: AppColors.backgroundCard,
        borderRadius: BorderRadius.circular(AppRadius.card),
        border: Border.all(color: AppColors.glassBorder),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacityValue(0.04),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Title
          Text(
            card.title,
            style: Theme.of(context).textTheme.headlineMedium,
          ),
          const SizedBox(height: AppSpacing.md),

          // Divider
          Container(
            width: 48,
            height: 4,
            decoration: BoxDecoration(
              color: AppColors.primary,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          const SizedBox(height: AppSpacing.lg),

          // Body
          Text(
            card.body,
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                  height: 1.6,
                ),
          ),
        ],
      ),
    );
  }
}
