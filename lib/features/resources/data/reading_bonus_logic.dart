class DailyReadingProgress {
  const DailyReadingProgress({
    required this.pageIndices,
    required this.hasEarnedHeart,
  });

  final List<int> pageIndices;
  final bool hasEarnedHeart;
}

class DailyReadingRewardUpdate {
  const DailyReadingRewardUpdate({
    required this.pageIndices,
    required this.hasEarnedHeart,
    required this.countedPage,
    required this.heartsEarned,
  });

  final List<int> pageIndices;
  final bool hasEarnedHeart;
  final bool countedPage;
  final int heartsEarned;

  int get pagesRead => pageIndices.length;
}

class ReadingBonusLogic {
  const ReadingBonusLogic._();

  static DailyReadingRewardUpdate registerDailyPageVisit({
    required DailyReadingProgress progress,
    required int pageIndex,
    required int pagesRequired,
    required bool canEarnHeart,
  }) {
    final updatedPages = List<int>.from(progress.pageIndices);
    final countedPage = !updatedPages.contains(pageIndex);
    if (countedPage) {
      updatedPages.add(pageIndex);
      updatedPages.sort();
    }

    var hasEarnedHeart = progress.hasEarnedHeart;
    var heartsEarned = 0;
    if (!hasEarnedHeart &&
        updatedPages.length >= pagesRequired &&
        canEarnHeart) {
      hasEarnedHeart = true;
      heartsEarned = 1;
    }

    return DailyReadingRewardUpdate(
      pageIndices: updatedPages,
      hasEarnedHeart: hasEarnedHeart,
      countedPage: countedPage,
      heartsEarned: heartsEarned,
    );
  }
}
