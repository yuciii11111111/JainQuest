// GENERATED CODE - DO NOT MODIFY BY HAND
// Run: flutter pub run build_runner build

part of 'user_models.dart';

// ============================================================================
// UserProfile Adapter
// ============================================================================

class UserProfileAdapter extends TypeAdapter<UserProfile> {
  @override
  final int typeId = 0;

  @override
  UserProfile read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return UserProfile(
      id: fields[0] as String,
      displayName: fields[1] as String?,
      totalXp: fields[2] as int? ?? 0,
      level: fields[3] as int? ?? 1,
      currentStreak: fields[4] as int? ?? 0,
      longestStreak: fields[5] as int? ?? 0,
      hearts: fields[6] as int? ?? 5,
      lastActivityDate: fields[7] as DateTime?,
      streakFreezes: fields[8] as int? ?? 1,
      createdAt: fields[9] as DateTime? ?? DateTime.now(),
    );
  }

  @override
  void write(BinaryWriter writer, UserProfile obj) {
    writer
      ..writeByte(10)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.displayName)
      ..writeByte(2)
      ..write(obj.totalXp)
      ..writeByte(3)
      ..write(obj.level)
      ..writeByte(4)
      ..write(obj.currentStreak)
      ..writeByte(5)
      ..write(obj.longestStreak)
      ..writeByte(6)
      ..write(obj.hearts)
      ..writeByte(7)
      ..write(obj.lastActivityDate)
      ..writeByte(8)
      ..write(obj.streakFreezes)
      ..writeByte(9)
      ..write(obj.createdAt);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is UserProfileAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

// ============================================================================
// ProgressState Adapter
// ============================================================================

class ProgressStateAdapter extends TypeAdapter<ProgressState> {
  @override
  final int typeId = 1;

  @override
  ProgressState read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return ProgressState(
      lessonProgress: (fields[0] as Map?)?.cast<String, LessonProgress>() ?? {},
      completedLessons: (fields[1] as List?)?.cast<String>() ?? [],
      unlockedLessons: (fields[2] as List?)?.cast<String>() ?? ['U01_L01'],
      earnedBadges: (fields[3] as List?)?.cast<String>() ?? [],
    );
  }

  @override
  void write(BinaryWriter writer, ProgressState obj) {
    writer
      ..writeByte(4)
      ..writeByte(0)
      ..write(obj.lessonProgress)
      ..writeByte(1)
      ..write(obj.completedLessons)
      ..writeByte(2)
      ..write(obj.unlockedLessons)
      ..writeByte(3)
      ..write(obj.earnedBadges);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ProgressStateAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

// ============================================================================
// LessonProgress Adapter
// ============================================================================

class LessonProgressAdapter extends TypeAdapter<LessonProgress> {
  @override
  final int typeId = 2;

  @override
  LessonProgress read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return LessonProgress(
      lessonId: fields[0] as String,
      isCompleted: fields[1] as bool? ?? false,
      timesCompleted: fields[2] as int? ?? 0,
      bestScore: fields[3] as int? ?? 0,
      totalXpEarned: fields[4] as int? ?? 0,
      firstCompletedAt: fields[5] as DateTime?,
      lastCompletedAt: fields[6] as DateTime?,
      lastReplayBonusAt: fields[7] as DateTime?,
    );
  }

  @override
  void write(BinaryWriter writer, LessonProgress obj) {
    writer
      ..writeByte(8)
      ..writeByte(0)
      ..write(obj.lessonId)
      ..writeByte(1)
      ..write(obj.isCompleted)
      ..writeByte(2)
      ..write(obj.timesCompleted)
      ..writeByte(3)
      ..write(obj.bestScore)
      ..writeByte(4)
      ..write(obj.totalXpEarned)
      ..writeByte(5)
      ..write(obj.firstCompletedAt)
      ..writeByte(6)
      ..write(obj.lastCompletedAt)
      ..writeByte(7)
      ..write(obj.lastReplayBonusAt);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is LessonProgressAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

// ============================================================================
// AttemptLog Adapter
// ============================================================================

class AttemptLogAdapter extends TypeAdapter<AttemptLog> {
  @override
  final int typeId = 3;

  @override
  AttemptLog read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return AttemptLog(
      id: fields[0] as String,
      questionId: fields[1] as String,
      lessonId: fields[2] as String,
      isCorrect: fields[3] as bool,
      responseTimeMs: fields[4] as int,
      attemptedAt: fields[5] as DateTime,
      spacedRepetitionInterval: fields[6] as int? ?? 1,
      nextReviewDate: fields[7] as DateTime?,
    );
  }

  @override
  void write(BinaryWriter writer, AttemptLog obj) {
    writer
      ..writeByte(8)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.questionId)
      ..writeByte(2)
      ..write(obj.lessonId)
      ..writeByte(3)
      ..write(obj.isCorrect)
      ..writeByte(4)
      ..write(obj.responseTimeMs)
      ..writeByte(5)
      ..write(obj.attemptedAt)
      ..writeByte(6)
      ..write(obj.spacedRepetitionInterval)
      ..writeByte(7)
      ..write(obj.nextReviewDate);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is AttemptLogAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

// ============================================================================
// NotificationPrefs Adapter
// ============================================================================

class NotificationPrefsAdapter extends TypeAdapter<NotificationPrefs> {
  @override
  final int typeId = 4;

  @override
  NotificationPrefs read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return NotificationPrefs(
      enableNotifications: fields[0] as bool? ?? true,
      quietHoursStart: fields[1] as String? ?? '22:00',
      quietHoursEnd: fields[2] as String? ?? '07:00',
      reminderDays: (fields[3] as List?)?.cast<int>() ?? [1, 2, 3, 4, 5, 6, 7],
      reminderTime: fields[4] as String? ?? '19:30',
      learningReminders: fields[5] as bool? ?? true,
      ahimsaPrompts: fields[6] as bool? ?? true,
      reflectionPrompts: fields[7] as bool? ?? true,
      streakRiskAlerts: fields[8] as bool? ?? true,
    );
  }

  @override
  void write(BinaryWriter writer, NotificationPrefs obj) {
    writer
      ..writeByte(9)
      ..writeByte(0)
      ..write(obj.enableNotifications)
      ..writeByte(1)
      ..write(obj.quietHoursStart)
      ..writeByte(2)
      ..write(obj.quietHoursEnd)
      ..writeByte(3)
      ..write(obj.reminderDays)
      ..writeByte(4)
      ..write(obj.reminderTime)
      ..writeByte(5)
      ..write(obj.learningReminders)
      ..writeByte(6)
      ..write(obj.ahimsaPrompts)
      ..writeByte(7)
      ..write(obj.reflectionPrompts)
      ..writeByte(8)
      ..write(obj.streakRiskAlerts);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is NotificationPrefsAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
