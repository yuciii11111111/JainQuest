import '../models/user_models.dart' as user_models;

// ============================================================================
// XP Rewards
// ============================================================================

class XpRewards {
  XpRewards._();

  static const int warmup = 2;
  static const int quiz = 3;
  static const int perfect = 5;
  static const int firstCompletion = 5;
  static const int streakBonus = 10;
  static const int practice = 2;
}

// ============================================================================
// Level System
// ============================================================================

class LevelSystem {
  LevelSystem._();

  static const List<int> xpGates = [
    0,    // Level 1: Beginner
    50,   // Level 2
    150,  // Level 3
    300,  // Level 4
    500,  // Level 5
    750,  // Level 6
    1000, // Level 7
    1500, // Level 8
    2000, // Level 9
    3000, // Level 10: Jina
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

// ============================================================================
// Badge System
// ============================================================================

class BadgeDefinitions {
  BadgeDefinitions._();

  static const List<user_models.Badge> allBadges = [
    user_models.Badge(
      id: 'first_steps',
      name: 'First Steps',
      description: 'Complete your first lesson',
      iconPath: 'assets/badges/first_steps.svg',
      trigger: 'complete_first_lesson',
    ),
    user_models.Badge(
      id: 'week_warrior',
      name: 'Week Warrior',
      description: 'Maintain a 7-day streak',
      iconPath: 'assets/badges/week_warrior.svg',
      trigger: 'streak_7_days',
    ),
    user_models.Badge(
      id: 'perfect_score',
      name: 'Perfect Score',
      description: 'Get 100% on a quiz',
      iconPath: 'assets/badges/perfect_score.svg',
      trigger: 'perfect_quiz',
    ),
    user_models.Badge(
      id: 'unit_master',
      name: 'Unit Master',
      description: 'Complete an entire unit',
      iconPath: 'assets/badges/unit_master.svg',
      trigger: 'complete_unit',
    ),
    user_models.Badge(
      id: 'guru_seeker',
      name: 'Guru Seeker',
      description: 'Ask 10 questions to the Guru',
      iconPath: 'assets/badges/guru_seeker.svg',
      trigger: 'ask_10_questions',
    ),
    user_models.Badge(
      id: 'streak_legend',
      name: 'Streak Legend',
      description: 'Maintain a 30-day streak',
      iconPath: 'assets/badges/streak_legend.svg',
      trigger: 'streak_30_days',
    ),
  ];

  static user_models.Badge? getBadgeById(String id) {
    try {
      return allBadges.firstWhere((badge) => badge.id == id);
    } catch (e) {
      return null;
    }
  }
}

// ============================================================================
// Hearts System
// ============================================================================

class HeartsSystem {
  HeartsSystem._();

  static const int maxHearts = 5;
  static const int heartRegenMinutes = 30;
  static const int practiceHeartReward = 1;

  static int calculateHeartsRegenerated(DateTime? lastActivityDate) {
    if (lastActivityDate == null) return 0;
    final now = DateTime.now();
    final minutesPassed = now.difference(lastActivityDate).inMinutes;
    return (minutesPassed / heartRegenMinutes).floor().clamp(0, maxHearts);
  }
}
