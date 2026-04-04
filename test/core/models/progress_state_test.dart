import 'package:flutter_test/flutter_test.dart';
import 'package:jainquest/core/models/user_models.dart';

void main() {
  group('ProgressState.completedLessonsOn', () {
    test('counts only lessons completed on the requested calendar day', () {
      final progress = ProgressState(
        lessonProgress: {
          'lesson_today_a': LessonProgress(
            lessonId: 'lesson_today_a',
            lastCompletedAt: DateTime(2026, 3, 15, 9, 30),
          ),
          'lesson_today_b': LessonProgress(
            lessonId: 'lesson_today_b',
            lastCompletedAt: DateTime(2026, 3, 15, 18, 45),
          ),
          'lesson_yesterday': LessonProgress(
            lessonId: 'lesson_yesterday',
            lastCompletedAt: DateTime(2026, 3, 14, 20, 0),
          ),
          'lesson_without_completion': const LessonProgress(
            lessonId: 'lesson_without_completion',
          ),
        },
      );

      expect(progress.completedLessonsOn(DateTime(2026, 3, 15)), 2);
    });

    test('returns zero when no lessons were completed on that day', () {
      final progress = ProgressState(
        lessonProgress: {
          'lesson_old': LessonProgress(
            lessonId: 'lesson_old',
            lastCompletedAt: DateTime(2026, 3, 10, 12, 0),
          ),
        },
      );

      expect(progress.completedLessonsOn(DateTime(2026, 3, 15)), 0);
    });
  });

  group('ProgressState defaults and migration', () {
    test('starts new learners at the first lesson', () {
      const progress = ProgressState();

      expect(
        progress.unlockedLessons,
        contains(ProgressState.initialUnlockedLessonId),
      );
      expect(
        progress.unlockedLessons.first,
        ProgressState.initialUnlockedLessonId,
      );
    });

    test('migrates the legacy fresh state to the first lesson', () {
      final progress = ProgressState.fromMap(const {
        'lessonProgress': <String, dynamic>{},
        'completedLessons': <String>[],
        'unlockedLessons': <String>['U01_L05'],
        'earnedBadges': <String>[],
      });

      expect(
        progress.unlockedLessons,
        const [ProgressState.initialUnlockedLessonId],
      );
    });
  });
}
