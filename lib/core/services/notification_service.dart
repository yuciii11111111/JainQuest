import 'dart:io';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:timezone/data/latest.dart' as tz_data;
import '../models/user_models.dart';
import 'storage_service.dart';

class NotificationService {
  static final FlutterLocalNotificationsPlugin _notifications =
      FlutterLocalNotificationsPlugin();

  static bool _isInitialized = false;

  // Notification channel IDs
  static const String _learningChannelId = 'jainquest_learning';
  static const String _ahimsaChannelId = 'jainquest_ahimsa';
  static const String _reflectionChannelId = 'jainquest_reflection';
  static const String _streakChannelId = 'jainquest_streak';

  // Notification IDs
  static const int _dailyLearningId = 1;
  static const int _streakRiskId = 2;
  static const int _ahimsaPromptId = 3;
  static const int _reflectionPromptId = 4;

  static Future<void> init() async {
    if (_isInitialized) return;

    tz_data.initializeTimeZones();

    const androidSettings = AndroidInitializationSettings('@mipmap/ic_launcher');
    const iosSettings = DarwinInitializationSettings(
      requestAlertPermission: false,
      requestBadgePermission: false,
      requestSoundPermission: false,
    );

    const initSettings = InitializationSettings(
      android: androidSettings,
      iOS: iosSettings,
    );

    await _notifications.initialize(
      initSettings,
      onDidReceiveNotificationResponse: _onNotificationTapped,
    );

    _isInitialized = true;
  }

  static void _onNotificationTapped(NotificationResponse response) {
    // Handle notification tap - could navigate to specific screen
    // This would typically use a navigation service or callback
  }

  // =========================================================================
  // Permission Handling
  // =========================================================================

  static Future<bool> requestPermission() async {
    if (Platform.isAndroid) {
      final androidPlugin = _notifications
          .resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>();
      if (androidPlugin != null) {
        final granted = await androidPlugin.requestNotificationsPermission();
        return granted ?? false;
      }
    } else if (Platform.isIOS) {
      final iosPlugin = _notifications
          .resolvePlatformSpecificImplementation<IOSFlutterLocalNotificationsPlugin>();
      if (iosPlugin != null) {
        final granted = await iosPlugin.requestPermissions(
          alert: true,
          badge: true,
          sound: true,
        );
        return granted ?? false;
      }
    }
    return false;
  }

  static Future<bool> checkPermission() async {
    if (Platform.isAndroid) {
      final androidPlugin = _notifications
          .resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>();
      if (androidPlugin != null) {
        return await androidPlugin.areNotificationsEnabled() ?? false;
      }
    }
    // For iOS, we assume permission is granted if we've reached here
    return true;
  }

  // =========================================================================
  // Schedule Notifications Based on Preferences
  // =========================================================================

  static Future<void> scheduleAllNotifications() async {
    final prefs = StorageService.getNotificationPrefs();

    // Cancel all existing notifications first
    await cancelAllNotifications();

    if (!prefs.enableNotifications) return;

    // Schedule learning reminders
    if (prefs.learningReminders) {
      await _scheduleDailyLearningReminder(prefs);
    }

    // Schedule streak risk alert
    if (prefs.streakRiskAlerts) {
      await _scheduleStreakRiskAlert(prefs);
    }

    // Schedule ahimsa prompts (morning)
    if (prefs.ahimsaPrompts) {
      await _scheduleAhimsaPrompt(prefs);
    }

    // Schedule reflection prompts (evening)
    if (prefs.reflectionPrompts) {
      await _scheduleReflectionPrompt(prefs);
    }
  }

  static Future<void> _scheduleDailyLearningReminder(NotificationPrefs prefs) async {
    final timeParts = prefs.reminderTime.split(':');
    final hour = int.parse(timeParts[0]);
    final minute = int.parse(timeParts[1]);

    // Schedule for each enabled day
    for (final day in prefs.reminderDays) {
      final scheduledDate = _nextInstanceOfDay(day, hour, minute);
      
      if (!_isInQuietHours(scheduledDate, prefs)) {
        await _notifications.zonedSchedule(
          _dailyLearningId + day,
          'Daily lesson reminder',
          'One short lesson today keeps your streak alive.',
          scheduledDate,
          NotificationDetails(
            android: AndroidNotificationDetails(
              _learningChannelId,
              'Learning Reminders',
              channelDescription: 'Daily reminders to complete lessons',
              importance: Importance.high,
              priority: Priority.high,
            ),
            iOS: const DarwinNotificationDetails(
              presentAlert: true,
              presentBadge: true,
              presentSound: true,
            ),
          ),
          androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
          uiLocalNotificationDateInterpretation:
              UILocalNotificationDateInterpretation.absoluteTime,
          matchDateTimeComponents: DateTimeComponents.dayOfWeekAndTime,
        );
      }
    }
  }

  static Future<void> _scheduleStreakRiskAlert(NotificationPrefs prefs) async {
    // Schedule at 20:00 local time
    final scheduledDate = _nextInstanceOfTime(20, 0);
    
    if (!_isInQuietHours(scheduledDate, prefs)) {
      await _notifications.zonedSchedule(
        _streakRiskId,
        'Streak reminder',
        'You are one session away from keeping your streak.',
        scheduledDate,
        NotificationDetails(
          android: AndroidNotificationDetails(
            _streakChannelId,
            'Streak Alerts',
            channelDescription: 'Alerts when your streak is at risk',
            importance: Importance.high,
            priority: Priority.high,
          ),
          iOS: const DarwinNotificationDetails(
            presentAlert: true,
            presentBadge: true,
            presentSound: true,
          ),
        ),
        androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
        uiLocalNotificationDateInterpretation:
            UILocalNotificationDateInterpretation.absoluteTime,
        matchDateTimeComponents: DateTimeComponents.time,
      );
    }
  }

  static Future<void> _scheduleAhimsaPrompt(NotificationPrefs prefs) async {
    // Schedule at 10:00 local time
    final scheduledDate = _nextInstanceOfTime(10, 0);
    
    if (!_isInQuietHours(scheduledDate, prefs)) {
      await _notifications.zonedSchedule(
        _ahimsaPromptId,
        'Ahimsa check-in',
        'Before your next reply today, pause for two seconds and choose a calmer response.',
        scheduledDate,
        NotificationDetails(
          android: AndroidNotificationDetails(
            _ahimsaChannelId,
            'Ahimsa Prompts',
            channelDescription: 'Mindful practice reminders',
            importance: Importance.defaultImportance,
            priority: Priority.defaultPriority,
          ),
          iOS: const DarwinNotificationDetails(
            presentAlert: true,
            presentSound: true,
          ),
        ),
        androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
        uiLocalNotificationDateInterpretation:
            UILocalNotificationDateInterpretation.absoluteTime,
        matchDateTimeComponents: DateTimeComponents.time,
      );
    }
  }

  static Future<void> _scheduleReflectionPrompt(NotificationPrefs prefs) async {
    // Schedule at 21:00 local time
    final scheduledDate = _nextInstanceOfTime(21, 0);
    
    if (!_isInQuietHours(scheduledDate, prefs)) {
      await _notifications.zonedSchedule(
        _reflectionPromptId,
        'Quick reflection',
        'Name one moment today where you chose patience over impulse.',
        scheduledDate,
        NotificationDetails(
          android: AndroidNotificationDetails(
            _reflectionChannelId,
            'Reflection Prompts',
            channelDescription: 'Evening reflection reminders',
            importance: Importance.defaultImportance,
            priority: Priority.defaultPriority,
          ),
          iOS: const DarwinNotificationDetails(
            presentAlert: true,
            presentSound: true,
          ),
        ),
        androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
        uiLocalNotificationDateInterpretation:
            UILocalNotificationDateInterpretation.absoluteTime,
        matchDateTimeComponents: DateTimeComponents.time,
      );
    }
  }

  // =========================================================================
  // Utility Methods
  // =========================================================================

  static tz.TZDateTime _nextInstanceOfTime(int hour, int minute) {
    final now = tz.TZDateTime.now(tz.local);
    var scheduled = tz.TZDateTime(tz.local, now.year, now.month, now.day, hour, minute);
    
    if (scheduled.isBefore(now)) {
      scheduled = scheduled.add(const Duration(days: 1));
    }
    
    return scheduled;
  }

  static tz.TZDateTime _nextInstanceOfDay(int dayOfWeek, int hour, int minute) {
    var date = _nextInstanceOfTime(hour, minute);
    
    while (date.weekday != dayOfWeek) {
      date = date.add(const Duration(days: 1));
    }
    
    return date;
  }

  static bool _isInQuietHours(tz.TZDateTime dateTime, NotificationPrefs prefs) {
    final startParts = prefs.quietHoursStart.split(':');
    final endParts = prefs.quietHoursEnd.split(':');
    
    final startHour = int.parse(startParts[0]);
    final startMinute = int.parse(startParts[1]);
    final endHour = int.parse(endParts[0]);
    final endMinute = int.parse(endParts[1]);
    
    final currentMinutes = dateTime.hour * 60 + dateTime.minute;
    final startMinutes = startHour * 60 + startMinute;
    final endMinutes = endHour * 60 + endMinute;
    
    if (startMinutes > endMinutes) {
      // Quiet hours span midnight
      return currentMinutes >= startMinutes || currentMinutes <= endMinutes;
    } else {
      return currentMinutes >= startMinutes && currentMinutes <= endMinutes;
    }
  }

  static Future<void> cancelAllNotifications() async {
    await _notifications.cancelAll();
  }

  static Future<void> cancelNotification(int id) async {
    await _notifications.cancel(id);
  }

  // Show immediate notification (for testing or special events)
  static Future<void> showNotification({
    required int id,
    required String title,
    required String body,
    String? payload,
  }) async {
    await _notifications.show(
      id,
      title,
      body,
      const NotificationDetails(
        android: AndroidNotificationDetails(
          _learningChannelId,
          'JainQuest',
          channelDescription: 'JainQuest notifications',
          importance: Importance.high,
          priority: Priority.high,
        ),
        iOS: DarwinNotificationDetails(
          presentAlert: true,
          presentBadge: true,
          presentSound: true,
        ),
      ),
      payload: payload,
    );
  }
}
