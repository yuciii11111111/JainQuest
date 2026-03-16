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
import '../data/fundjain_book_data.dart';
import 'reading_quiz_session_screen.dart';

class ReadingScreen extends ConsumerStatefulWidget {
  const ReadingScreen({super.key});

  @override
  ConsumerState<ReadingScreen> createState() => _ReadingScreenState();
}

class _ReadingScreenState extends ConsumerState<ReadingScreen> {
  static const String _bookId = 'fundjain';

  final PageController _pageController = PageController();

  List<FundJainReaderEntry> _entries = [];
  List<int> _bookmarks = [];
  int _currentPage = 0;
  int _pagesTowardNextHeart = StorageService.getReadingPagesTowardNextHeart();
  int _dailyPagesRead = StorageService.getReadingDailyPagesRead(_bookId);
  bool _dailyHeartEarned = StorageService.hasEarnedReadingDailyHeart(_bookId);
  bool _isLoading = true;
  double _fontSize = 16;
  bool _darkMode = false;

  @override
  void initState() {
    super.initState();
    _loadBookmarks();
    _loadBook();
  }

  FundJainReaderEntry? get _currentEntry {
    if (_entries.isEmpty ||
        _currentPage < 0 ||
        _currentPage >= _entries.length) {
      return null;
    }
    return _entries[_currentPage];
  }

  FundJainTextEntry? get _currentTextEntry {
    final entry = _currentEntry;
    return entry is FundJainTextEntry ? entry : null;
  }

  FundJainQuizEntry? get _currentQuizEntry {
    final entry = _currentEntry;
    return entry is FundJainQuizEntry ? entry : null;
  }

  bool get _isCurrentPageBookmarked =>
      _currentTextEntry != null && _bookmarks.contains(_currentPage);

  int get _pagesUntilNextHeart {
    final progress = _pagesTowardNextHeart % HeartsSystem.readingPagesPerHeart;
    return HeartsSystem.readingPagesPerHeart - progress;
  }

  Future<void> _loadBookmarks() async {
    final bookmarks = StorageService.getReadingBookmarks(_bookId);
    if (mounted) {
      setState(() => _bookmarks = bookmarks);
    }
  }

  Future<void> _toggleCurrentPageBookmark() async {
    if (_currentTextEntry == null) return;
    await StorageService.toggleReadingBookmark(
      bookId: _bookId,
      pageIndex: _currentPage,
    );
    await _loadBookmarks();
  }

  Future<void> _loadBook() async {
    final rawText = await rootBundle.loadString('assets/content/fundjain.txt');
    final result = FundJainBookData.buildReader(rawText);

    if (mounted) {
      setState(() {
        _entries = result.entries;
        _isLoading = false;
      });
      _registerPageVisit(_currentPage);
    }
  }

  Future<void> _registerPageVisit(int pageIndex) async {
    if (_entries.isEmpty || pageIndex < 0 || pageIndex >= _entries.length) {
      return;
    }

    final entry = _entries[pageIndex];
    if (entry is! FundJainTextEntry) {
      return;
    }

    final result =
        await ref.read(userProfileProvider.notifier).registerReadingPage(
              bookId: _bookId,
              pageIndex: pageIndex,
            );
    if (!mounted) return;

    setState(() {
      _pagesTowardNextHeart = result.pagesTowardNextHeart;
      _dailyPagesRead = result.dailyPagesRead;
      _dailyHeartEarned = result.dailyHeartEarned;
    });

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

  Future<void> _openQuiz(FundJainQuizDefinition quiz) async {
    final completed = await Navigator.of(context).push<bool>(
      MaterialPageRoute(
        builder: (context) => ReadingQuizSessionScreen(
          quiz: quiz,
          hearts: ref.read(userProfileProvider).hearts,
        ),
      ),
    );

    if (completed != true) return;

    await StorageService.markReadingQuizCompleted(quiz.id);
    if (!mounted) return;

    setState(() {});
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(context.t('quiz_completed_snackbar'))),
    );
  }

  void _goToPage(int pageIndex) {
    if (_entries.isEmpty || pageIndex < 0 || pageIndex >= _entries.length) {
      return;
    }
    _pageController.animateToPage(
      pageIndex,
      duration: AppMotion.standard,
      curve: AppMotion.enterCurve,
    );
  }

  void _handlePrimaryAction() {
    final quizEntry = _currentQuizEntry;
    if (quizEntry != null) {
      final isCompleted =
          StorageService.isReadingQuizCompleted(quizEntry.quiz.id);
      if (!isCompleted) {
        _openQuiz(quizEntry.quiz);
        return;
      }
    }

    if (_currentPage < _entries.length - 1) {
      _goToPage(_currentPage + 1);
      return;
    }

    Navigator.of(context).pop();
  }

  String _primaryButtonLabel(BuildContext context) {
    final quizEntry = _currentQuizEntry;
    if (quizEntry != null &&
        !StorageService.isReadingQuizCompleted(quizEntry.quiz.id)) {
      return context.t('start_quiz');
    }
    return _currentPage == _entries.length - 1
        ? context.t('finish')
        : context.t('next');
  }

  Widget _buildReaderEntry(
    BuildContext context,
    FundJainReaderEntry entry,
    ColorScheme scheme,
  ) {
    if (entry is FundJainTextEntry) {
      return Padding(
        key: ValueKey(entry.id),
        padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
        child: Container(
          decoration: BoxDecoration(
            color: _darkMode ? AppColors.inkBlack : scheme.surface,
            borderRadius: BorderRadius.circular(AppRadius.card),
            border: Border.all(color: scheme.outline),
          ),
          padding: const EdgeInsets.all(AppSpacing.lg),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                entry.title,
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      color: _darkMode ? AppColors.softCream : null,
                    ),
              ),
              const SizedBox(height: AppSpacing.xs),
              Text(
                entry.isFrontMatter
                    ? context.t('reader_desc')
                    : context.t(
                        'chapter_progress',
                        args: {
                          'current': '${entry.pageNumber}',
                          'total': '${entry.totalChapterPages}',
                        },
                      ),
                style: Theme.of(context).textTheme.labelSmall?.copyWith(
                      color: _darkMode
                          ? AppColors.textSecondary
                          : scheme.onSurfaceVariant,
                    ),
              ),
              const SizedBox(height: AppSpacing.md),
              Expanded(
                child: GlassScrollbar(
                  child: SingleChildScrollView(
                    child: TypewriterText(
                      text: entry.body,
                      style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                            height: 1.7,
                            fontSize: _fontSize,
                            color: _darkMode ? AppColors.textSecondary : null,
                          ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      );
    }

    final quizEntry = entry as FundJainQuizEntry;
    final isCompleted =
        StorageService.isReadingQuizCompleted(quizEntry.quiz.id);

    return Padding(
      key: ValueKey(quizEntry.id),
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
      child: Container(
        decoration: BoxDecoration(
          color: _darkMode ? AppColors.inkBlack : scheme.surface,
          borderRadius: BorderRadius.circular(AppRadius.card),
          border: Border.all(
            color: isCompleted ? AppColors.primary : scheme.outline,
            width: 1.5,
          ),
        ),
        padding: const EdgeInsets.all(AppSpacing.xl),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  width: 56,
                  height: 56,
                  decoration: BoxDecoration(
                    color: AppColors.primary.withOpacityValue(0.14),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    quizEntry.quiz.isFinalQuiz
                        ? Icons.workspace_premium_rounded
                        : Icons.quiz_rounded,
                    color: AppColors.primary,
                    size: 28,
                  ),
                ),
                const SizedBox(width: AppSpacing.md),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        context.t('quiz_checkpoint'),
                        style:
                            Theme.of(context).textTheme.labelMedium?.copyWith(
                                  color: AppColors.primary,
                                  fontWeight: FontWeight.w700,
                                ),
                      ),
                      const SizedBox(height: AppSpacing.xs),
                      Text(
                        quizEntry.title,
                        style:
                            Theme.of(context).textTheme.headlineSmall?.copyWith(
                                  color: _darkMode ? AppColors.softCream : null,
                                ),
                      ),
                    ],
                  ),
                ),
                if (isCompleted)
                  Chip(
                    label: Text(context.t('completed')),
                    backgroundColor: AppColors.primary.withOpacityValue(0.12),
                    side: BorderSide.none,
                  ),
              ],
            ),
            const SizedBox(height: AppSpacing.lg),
            Text(
              quizEntry.quiz.description,
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                    height: 1.6,
                    color:
                        _darkMode ? AppColors.textSecondary : scheme.onSurface,
                  ),
            ),
            const SizedBox(height: AppSpacing.md),
            Text(
              context.t('quiz_no_heart_cost'),
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: AppColors.primary,
                  ),
            ),
            const SizedBox(height: AppSpacing.xl),
            PrimaryButton(
              label: isCompleted
                  ? context.t('retake_quiz')
                  : context.t('start_quiz'),
              icon: isCompleted
                  ? Icons.refresh_rounded
                  : Icons.play_arrow_rounded,
              onPressed: () => _openQuiz(quizEntry.quiz),
            ),
            const SizedBox(height: AppSpacing.md),
            Text(
              isCompleted
                  ? context.t('quiz_completed_snackbar')
                  : context.t('complete_this_quiz'),
              style: Theme.of(context).textTheme.labelMedium?.copyWith(
                    color: _darkMode
                        ? AppColors.textSecondary
                        : scheme.onSurfaceVariant,
                  ),
            ),
          ],
        ),
      ),
    );
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
    final currentEntry = _currentEntry;
    final sliderLabel = currentEntry is FundJainTextEntry
        ? context.t('page_label', args: {'num': '${_currentPage + 1}'})
        : context.t('quiz_checkpoint');

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
                        Padding(
                          padding: const EdgeInsets.only(top: AppSpacing.xs),
                          child: Text(
                            _dailyHeartEarned
                                ? context.t('daily_reading_earned')
                                : context.t(
                                    'daily_reading_progress',
                                    args: {
                                      'count': '$_dailyPagesRead',
                                      'target':
                                          '${HeartsSystem.dailyReadingPagesForHeart}',
                                    },
                                  ),
                            style: Theme.of(context)
                                .textTheme
                                .labelSmall
                                ?.copyWith(
                                  color: AppColors.primary,
                                ),
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
                  if (_entries.isNotEmpty)
                    Text(
                      '${_currentPage + 1}/${_entries.length}',
                      style: Theme.of(context).textTheme.labelSmall?.copyWith(
                            color: _darkMode ? AppColors.softCream : null,
                          ),
                    ),
                  const SizedBox(width: AppSpacing.xs),
                  MotionPressable(
                    enabled: _currentTextEntry != null,
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
                      onPressed: _currentTextEntry == null
                          ? null
                          : _toggleCurrentPageBookmark,
                    ),
                  ),
                ],
              ),
            ),
            if (_entries.isNotEmpty)
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppSpacing.lg,
                  vertical: AppSpacing.xs,
                ),
                child: GlassSlider(
                  min: 0,
                  max: (_entries.length - 1).toDouble(),
                  value: _currentPage.toDouble(),
                  divisions: _entries.length > 1 ? _entries.length - 1 : null,
                  label: sliderLabel,
                  onChanged: (value) {
                    final targetPage =
                        value.round().clamp(0, _entries.length - 1);
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
                            label: context.t(
                              'font_label',
                              args: {'size': _fontSize.toStringAsFixed(0)},
                            ),
                            onChanged: (value) =>
                                setState(() => _fontSize = value),
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
                    children: _bookmarks
                        .where((bookmark) =>
                            bookmark >= 0 && bookmark < _entries.length)
                        .map((bookmark) {
                      return MotionPressable(
                        child: ActionChip(
                          label: Text(
                            context.t(
                              'page_abbreviated',
                              args: {'num': '${bookmark + 1}'},
                            ),
                          ),
                          onPressed: () => _goToPage(bookmark),
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
                      itemCount: _entries.length,
                      itemBuilder: (context, index) {
                        return _buildReaderEntry(
                            context, _entries[index], scheme);
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
                            ? () => _goToPage(_currentPage - 1)
                            : null,
                      ),
                    ),
                    const SizedBox(width: AppSpacing.md),
                    Expanded(
                      child: PrimaryButton(
                        label: _primaryButtonLabel(context),
                        icon: Icons.chevron_right_rounded,
                        onPressed:
                            _entries.isEmpty ? null : _handlePrimaryAction,
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
