class XpRewards {
  XpRewards._();

  static const int warmup = 2;
  static const int quiz = 3;
  static const int perfect = 5;
  static const int firstCompletion = 5;
  static const int streakBonus = 10;
  static const int practice = 2;
}

class LevelSystem {
  LevelSystem._();

  static const List<int> xpGates = [
    0,
    50,
    150,
    300,
    500,
    750,
    1000,
    1500,
    2000,
    3000,
  ];

  static const List<String> levelTitles = [
    'Beginner',
    'Explorer',
    'Seeker',
    'Student',
    'Learner',
    'Practitioner',
    'Scholar',
    'Master',
    'Sage',
    'Jina',
  ];

  static int getLevelFromXp(int totalXp) {
    for (int i = xpGates.length - 1; i >= 0; i--) {
      if (totalXp >= xpGates[i]) {
        return i + 1;
      }
    }
    return 1;
  }

  static int getXpForLevel(int level) {
    if (level <= 1) return 0;
    if (level > xpGates.length) return xpGates.last;
    return xpGates[level - 1];
  }

  static int getXpNeededForNextLevel(int currentLevel, int totalXp) {
    if (currentLevel >= xpGates.length) return 0;
    final nextLevelXp = xpGates[currentLevel];
    return (nextLevelXp - totalXp).clamp(0, double.infinity).toInt();
  }

  static String getLevelTitle(int level) {
    if (level < 1 || level > levelTitles.length) {
      return levelTitles.first;
    }
    return levelTitles[level - 1];
  }

  static double getLevelProgress(int currentLevel, int totalXp) {
    if (currentLevel < 1) return 0.0;
    if (currentLevel >= xpGates.length) return 1.0;
    final currentLevelXp = xpGates[currentLevel - 1];
    final nextLevelXp = xpGates[currentLevel];
    final xpNeeded = nextLevelXp - currentLevelXp;
    if (xpNeeded <= 0) return 0.0;
    final xpInLevel = totalXp - currentLevelXp;
    return (xpInLevel / xpNeeded).clamp(0.0, 1.0);
  }
}

class HeartsSystem {
  HeartsSystem._();

  static const int maxHearts = 5;
  static const int heartRegenMinutes = 30;
  static const Duration heartRegenDuration =
      Duration(minutes: heartRegenMinutes);
  static const int practiceHeartReward = 1;
  static const int readingPagesPerHeart = 5;
  static const int dailyReadingPagesForHeart = 10;

  static int calculateHeartsRegenerated(DateTime? lastActivityDate) {
    if (lastActivityDate == null) return 0;
    final now = DateTime.now();
    final minutesPassed = now.difference(lastActivityDate).inMinutes;
    return (minutesPassed / heartRegenMinutes).floor().clamp(0, maxHearts);
  }
}
