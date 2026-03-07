import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/widgets/common_widgets.dart';
import '../../../core/widgets/glass_slider.dart';
import '../../../core/widgets/typewriter_text.dart';

class ReadingScreen extends StatefulWidget {
  const ReadingScreen({super.key});

  @override
  State<ReadingScreen> createState() => _ReadingScreenState();
}

class _ReadingScreenState extends State<ReadingScreen> {
  final PageController _pageController = PageController();
  List<String> _pages = [];
  int _currentPage = 0;
  bool _isLoading = true;
  double _fontSize = 16;
  bool _darkMode = false;

  @override
  void initState() {
    super.initState();
    _loadBook();
  }

  Future<void> _loadBook() async {
    final rawText = await rootBundle.loadString('assets/content/fundjain.txt');
    final cleaned = rawText
        .replaceAll('\r\n', '\n')
        .replaceAll('\r', '\n')
        .replaceAll(RegExp(r'\n{3,}'), '\n\n')
        .trim();

    // Drop the very first intro chunk so we start at the content.
    final sections = cleaned.split('\n\n');
    final trimmedContent =
        sections.length > 1 ? sections.skip(1).join('\n\n').trim() : cleaned;

    const pageSize = 1200;
    final words = trimmedContent.split(RegExp(r'\s+'));
    final pages = <String>[];
    final buffer = StringBuffer();
    for (final word in words) {
      if (buffer.length + word.length + 1 > pageSize) {
        pages.add(buffer.toString().trim());
        buffer.clear();
      }
      buffer.write(word);
      buffer.write(' ');
    }
    if (buffer.isNotEmpty) {
      pages.add(buffer.toString().trim());
    }

    if (mounted) {
      setState(() {
        _pages = pages;
        _isLoading = false;
      });
    }
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: SafeArea(
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
                    icon: const Icon(Icons.arrow_back_rounded),
                    onPressed: () => Navigator.of(context).pop(),
                  ),
                  const SizedBox(width: AppSpacing.sm),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'FundJain Reader',
                          style: Theme.of(context).textTheme.titleLarge?.copyWith(
                                color: _darkMode ? AppColors.softCream : null,
                              ),
                        ),
                        Text(
                          'Read a knowledgeable book teaching the fundamentals of Jainism in great depth',
                          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                color: _darkMode ? AppColors.textSecondary : scheme.onSurfaceVariant,
                              ),
                        ),
                      ],
                    ),
                  ),
                  if (_pages.isNotEmpty)
                    Text(
                      '${_currentPage + 1}/${_pages.length}',
                      style: Theme.of(context).textTheme.labelSmall?.copyWith(
                            color: _darkMode ? AppColors.softCream : null,
                          ),
                    ),
                ],
              ),
            ),
            if (_pages.isNotEmpty)
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppSpacing.lg,
                  vertical: AppSpacing.xs,
                ),
                child: GlassSlider(
                  min: 0,
                  max: (_pages.length - 1).toDouble(),
                  value: _currentPage.toDouble(),
                  divisions: _pages.length > 1 ? _pages.length - 1 : null,
                  label: 'Page ${_currentPage + 1}',
                  onChanged: (v) {
                    final targetPage = v.round().clamp(0, _pages.length - 1);
                    _pageController.jumpToPage(targetPage);
                    setState(() => _currentPage = targetPage);
                  },
                ),
              ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
              child: Row(
                children: [
                  Expanded(
                    child: Row(
                      children: [
                        const Icon(Icons.text_fields_rounded, size: 18),
                        Expanded(
                          child: GlassSlider(
                            min: 14,
                            max: 22,
                            value: _fontSize,
                            divisions: 8,
                            label: 'Font ${_fontSize.toStringAsFixed(0)}',
                            onChanged: (v) => setState(() => _fontSize = v),
                          ),
                        ),
                        Text(_fontSize.toStringAsFixed(0)),
                      ],
                    ),
                  ),
                  const SizedBox(width: AppSpacing.md),
                  FloatingActionButton.small(
                    heroTag: 'themeToggle',
                    backgroundColor: _darkMode ? AppColors.softCream : AppColors.inkBlack,
                    onPressed: () => setState(() => _darkMode = !_darkMode),
                    child: Icon(
                      _darkMode ? Icons.light_mode_rounded : Icons.dark_mode_rounded,
                      color: _darkMode ? AppColors.inkBlack : AppColors.softCream,
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: _isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : PageView.builder(
                      controller: _pageController,
                      onPageChanged: (index) {
                        setState(() => _currentPage = index);
                      },
                      itemCount: _pages.length,
                      itemBuilder: (context, index) {
                        return Padding(
                          key: ValueKey(index),
                          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
                          child: Container(
                            decoration: BoxDecoration(
                              color: _darkMode ? AppColors.inkBlack : scheme.surface,
                              borderRadius: BorderRadius.circular(AppRadius.card),
                              border: Border.all(color: scheme.outline),
                            ),
                            padding: const EdgeInsets.all(AppSpacing.lg),
                            child: GlassScrollbar(
                              child: SingleChildScrollView(
                                child: TypewriterText(
                                  text: _pages[index],
                                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                                    height: 1.7,
                                    fontSize: _fontSize,
                                      color: _darkMode ? AppColors.textSecondary : null,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        );
                      },
                    ),
            ),
            SafeArea(
              top: false,
              child: Padding(
                padding: const EdgeInsets.all(AppSpacing.lg),
                child: Row(
                  children: [
                    Expanded(
                      child: SecondaryButton(
                        label: 'Previous',
                        icon: Icons.chevron_left_rounded,
                        onPressed: _currentPage > 0
                            ? () {
                                _pageController.animateToPage(
                                  _currentPage - 1,
                                  duration: const Duration(milliseconds: 420),
                                  curve: Curves.easeInOutCubic,
                                );
                              }
                            : null,
                      ),
                    ),
                    const SizedBox(width: AppSpacing.md),
                    Expanded(
                      child: PrimaryButton(
                        label: _currentPage == _pages.length - 1 ? 'Finish' : 'Next',
                        icon: Icons.chevron_right_rounded,
                        onPressed: _currentPage < _pages.length - 1
                            ? () {
                                _pageController.animateToPage(
                                  _currentPage + 1,
                                  duration: const Duration(milliseconds: 420),
                                  curve: Curves.easeInOutCubic,
                                );
                              }
                            : () => Navigator.of(context).pop(),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
