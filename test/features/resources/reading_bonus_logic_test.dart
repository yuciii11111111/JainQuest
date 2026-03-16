import 'package:flutter_test/flutter_test.dart';
import 'package:jainquest/features/resources/data/reading_bonus_logic.dart';

void main() {
  test('daily reading reward grants one heart on the tenth unique page', () {
    var progress = const DailyReadingProgress(
      pageIndices: [],
      hasEarnedHeart: false,
    );
    DailyReadingRewardUpdate update = const DailyReadingRewardUpdate(
      pageIndices: [],
      hasEarnedHeart: false,
      countedPage: false,
      heartsEarned: 0,
    );

    for (var page = 0; page < 10; page++) {
      update = ReadingBonusLogic.registerDailyPageVisit(
        progress: progress,
        pageIndex: page,
        pagesRequired: 10,
        canEarnHeart: true,
      );
      progress = DailyReadingProgress(
        pageIndices: update.pageIndices,
        hasEarnedHeart: update.hasEarnedHeart,
      );
    }

    expect(update.pagesRead, 10);
    expect(update.heartsEarned, 1);
    expect(update.hasEarnedHeart, isTrue);
  });

  test(
      'daily reading reward can trigger later if the goal was reached while hearts were full',
      () {
    final progressAtGoal = DailyReadingProgress(
      pageIndices: List<int>.generate(10, (index) => index),
      hasEarnedHeart: false,
    );

    final noCapacityUpdate = ReadingBonusLogic.registerDailyPageVisit(
      progress: progressAtGoal,
      pageIndex: 9,
      pagesRequired: 10,
      canEarnHeart: false,
    );
    final laterCapacityUpdate = ReadingBonusLogic.registerDailyPageVisit(
      progress: DailyReadingProgress(
        pageIndices: noCapacityUpdate.pageIndices,
        hasEarnedHeart: noCapacityUpdate.hasEarnedHeart,
      ),
      pageIndex: 9,
      pagesRequired: 10,
      canEarnHeart: true,
    );

    expect(noCapacityUpdate.heartsEarned, 0);
    expect(noCapacityUpdate.hasEarnedHeart, isFalse);
    expect(laterCapacityUpdate.countedPage, isFalse);
    expect(laterCapacityUpdate.heartsEarned, 1);
    expect(laterCapacityUpdate.hasEarnedHeart, isTrue);
  });
}
