import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/gamification/gamification_rules.dart';
import '../../../core/localization/app_strings.dart';
import '../../../core/providers/app_providers.dart';
import '../../../core/services/storage_service.dart';
import '../../../core/theme/app_motion.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/widgets/common_widgets.dart';
import '../../../core/widgets/glass_slider.dart';
import '../../../core/widgets/motion_pressable.dart';
import '../../../core/widgets/typewriter_text.dart';

class ReadingScreen extends ConsumerStatefulWidget {
  const ReadingScreen({super.key});

  @override
  ConsumerState<ReadingScreen> createState() => _ReadingScreenState();
}

class _ReadingScreenState extends ConsumerState<ReadingScreen> {
  static const String _bookId = 'fundjain';
  final PageController _pageController = PageController();
  List<String> _pages = [];
  List<int> _bookmarks = [];
  int _currentPage = 0;
  int _pagesTowardNextHeart = StorageService.getReadingPagesTowardNextHeart();
  bool _isLoading = true;
  double _fontSize = 16;
  bool _darkMode = false;

  @override
  void initState() {
    super.initState();
    _loadBookmarks();
    _loadBook();
  }

  Future<void> _loadBookmarks() async {
    final bookmarks = StorageService.getReadingBookmarks(_bookId);
    if (mounted) {
      setState(() => _bookmarks = bookmarks);
    }
  }

  Future<void> _toggleCurrentPageBookmark() async {
    final page = _currentPage;
    await StorageService.toggleReadingBookmark(
      bookId: _bookId,
      pageIndex: page,
    );
    await _loadBookmarks();
  }

  bool get _isCurrentPageBookmarked => _bookmarks.contains(_currentPage);

  int get _pagesUntilNextHeart {
    final progress = _pagesTowardNextHeart % HeartsSystem.readingPagesPerHeart;
    return HeartsSystem.readingPagesPerHeart - progress;
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
      _registerPageVisit(_currentPage);
    }
  }

  Future<void> _registerPageVisit(int pageIndex) async {
    if (_pages.isEmpty || pageIndex < 0 || pageIndex >= _pages.length) {
      return;
    }

    final result =
        await ref.read(userProfileProvider.notifier).registerReadingPage(
              bookId: _bookId,
              pageIndex: pageIndex,
            );
    if (!mounted) return;

    if (_pagesTowardNextHeart != result.pagesTowardNextHeart) {
      setState(() {
        _pagesTowardNextHeart = result.pagesTowardNextHeart;
      });
    }

    if (result.heartsEarned > 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            context.t(
              'reading_heart_earned',
              args: {'count': '${result.heartsEarned}'},
            ),
          ),
        ),
      );
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
    final user = ref.watch(userProfileProvider);
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
                  MotionPressable(
                    child: IconButton(
                      icon: const Icon(Icons.arrow_back_rounded),
                      onPressed: () => Navigator.of(context).pop(),
                    ),
                  ),
                  const SizedBox(width: AppSpacing.sm),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          context.t('fundjain_reader'),
                          style: Theme.of(context)
                              .textTheme
                              .titleLarge
                              ?.copyWith(
                                color: _darkMode ? AppColors.softCream : null,
                              ),
                        ),
                        Text(
                          context.t('resources_desc'),
                          style:
                              Theme.of(context).textTheme.bodySmall?.copyWith(
                                    color: _darkMode
                                        ? AppColors.textSecondary
                                        : scheme.onSurfaceVariant,
                                  ),
                        ),
                        if (user.hearts < HeartsSystem.maxHearts)
                          Padding(
                            padding: const EdgeInsets.only(top: AppSpacing.xs),
                            child: Text(
                              context.t(
                                'read_pages_for_heart',
                                args: {'count': '$_pagesUntilNextHeart'},
                              ),
                              style: Theme.of(context)
                                  .textTheme
                                  .labelSmall
                                  ?.copyWith(color: AppColors.primary),
                            ),
                          ),
                      ],
                    ),
                  ),
                  HeartsPill(hearts: user.hearts),
                  const SizedBox(width: AppSpacing.xs),
                  if (_pages.isNotEmpty)
                    Text(
                      '${_currentPage + 1}/${_pages.length}',
                      style: Theme.of(context).textTheme.labelSmall?.copyWith(
                            color: _darkMode ? AppColors.softCream : null,
                          ),
                    ),
                  const SizedBox(width: AppSpacing.xs),
                  MotionPressable(
                    enabled: _pages.isNotEmpty,
                    child: IconButton(
                      tooltip: _isCurrentPageBookmarked
                          ? context.t('remove_bookmark')
                          : context.t('bookmark_page'),
                      icon: Icon(
                        _isCurrentPageBookmarked
                            ? Icons.bookmark_rounded
                            : Icons.bookmark_border_rounded,
                      ),
                      color: _isCurrentPageBookmarked
                          ? AppColors.primary
                          : (_darkMode
                              ? AppColors.softCream
                              : scheme.onSurfaceVariant),
                      onPressed:
                          _pages.isEmpty ? null : _toggleCurrentPageBookmark,
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
                  label: context
                      .t('page_label', args: {'num': '${_currentPage + 1}'}),
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
                            label: context.t('font_label',
                                args: {'size': _fontSize.toStringAsFixed(0)}),
                            onChanged: (v) => setState(() => _fontSize = v),
                          ),
                        ),
                        Text(_fontSize.toStringAsFixed(0)),
                      ],
                    ),
                  ),
                  const SizedBox(width: AppSpacing.md),
                  MotionPressable(
                    child: FloatingActionButton.small(
                      heroTag: 'themeToggle',
                      backgroundColor:
                          _darkMode ? AppColors.softCream : AppColors.inkBlack,
                      onPressed: () => setState(() => _darkMode = !_darkMode),
                      child: Icon(
                        _darkMode
                            ? Icons.light_mode_rounded
                            : Icons.dark_mode_rounded,
                        color: _darkMode
                            ? AppColors.inkBlack
                            : AppColors.softCream,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            if (_bookmarks.isNotEmpty)
              Padding(
                padding: const EdgeInsets.fromLTRB(
                  AppSpacing.lg,
                  AppSpacing.sm,
                  AppSpacing.lg,
                  0,
                ),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Wrap(
                    spacing: AppSpacing.sm,
                    runSpacing: AppSpacing.xs,
                    children: _bookmarks.map((bookmark) {
                      return MotionPressable(
                        child: ActionChip(
                          label: Text(context.t('page_abbreviated',
                              args: {'num': '${bookmark + 1}'})),
                          onPressed: () {
                            _pageController.animateToPage(
                              bookmark,
                              duration: AppMotion.standard,
                              curve: AppMotion.enterCurve,
                            );
                          },
                        ),
                      );
                    }).toList(),
                  ),
                ),
              ),
            Expanded(
              child: _isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : PageView.builder(
                      controller: _pageController,
                      onPageChanged: (index) {
                        setState(() => _currentPage = index);
                        _registerPageVisit(index);
                      },
                      itemCount: _pages.length,
                      itemBuilder: (context, index) {
                        return Padding(
                          key: ValueKey(index),
                          padding: const EdgeInsets.symmetric(
                              horizontal: AppSpacing.lg),
                          child: Container(
                            decoration: BoxDecoration(
                              color: _darkMode
                                  ? AppColors.inkBlack
                                  : scheme.surface,
                              borderRadius:
                                  BorderRadius.circular(AppRadius.card),
                              border: Border.all(color: scheme.outline),
                            ),
                            padding: const EdgeInsets.all(AppSpacing.lg),
                            child: GlassScrollbar(
                              child: SingleChildScrollView(
                                child: TypewriterText(
                                  text: _pages[index],
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodyLarge
                                      ?.copyWith(
                                        height: 1.7,
                                        fontSize: _fontSize,
                                        color: _darkMode
                                            ? AppColors.textSecondary
                                            : null,
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
                        label: context.t('previous'),
                        icon: Icons.chevron_left_rounded,
                        onPressed: _currentPage > 0
                            ? () {
                                _pageController.animateToPage(
                                  _currentPage - 1,
                                  duration: AppMotion.standard,
                                  curve: AppMotion.enterCurve,
                                );
                              }
                            : null,
                      ),
                    ),
                    const SizedBox(width: AppSpacing.md),
                    Expanded(
                      child: PrimaryButton(
                        label: _currentPage == _pages.length - 1
                            ? context.t('finish')
                            : context.t('next'),
                        icon: Icons.chevron_right_rounded,
                        onPressed: _currentPage < _pages.length - 1
                            ? () {
                                _pageController.animateToPage(
                                  _currentPage + 1,
                                  duration: AppMotion.standard,
                                  curve: AppMotion.enterCurve,
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
