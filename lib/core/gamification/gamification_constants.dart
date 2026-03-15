import '../models/user_models.dart' as user_models;

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
