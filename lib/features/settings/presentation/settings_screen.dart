import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/providers/app_providers.dart';
import '../../../core/providers/theme_provider.dart';
import '../../../core/services/storage_service.dart';
import '../../../core/services/notification_service.dart';

class SettingsScreen extends ConsumerStatefulWidget {
  const SettingsScreen({super.key});

  @override
  ConsumerState<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends ConsumerState<SettingsScreen> {
  Future<void> _requestNotificationPermission() async {
    final granted = await NotificationService.requestPermission();
    if (granted) {
      await ref.read(notificationPrefsProvider.notifier).toggleNotifications(true);
      await NotificationService.scheduleAllNotifications();
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Notifications enabled')),
        );
      }
    } else {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Permission denied')),
        );
      }
    }
  }

  Future<void> _showTimePickerDialog(String currentTime) async {
    final parts = currentTime.split(':');
    final initialTime = TimeOfDay(
      hour: int.parse(parts[0]),
      minute: int.parse(parts[1]),
    );

    final picked = await showTimePicker(
      context: context,
      initialTime: initialTime,
    );

    if (picked != null) {
      final newTime =
          '${picked.hour.toString().padLeft(2, '0')}:${picked.minute.toString().padLeft(2, '0')}';
      await ref.read(notificationPrefsProvider.notifier).setReminderTime(newTime);
      await NotificationService.scheduleAllNotifications();
    }
  }

  Future<void> _showResetConfirmation() async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppRadius.card),
        ),
        title: const Text('Reset Progress?'),
        content: const Text(
          'This will delete all your progress, XP, streaks, and badges. This action cannot be undone.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: const Text(
              'Reset',
              style: TextStyle(color: AppColors.danger),
            ),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      await StorageService.resetAllProgress();
      ref.read(userProfileProvider.notifier).refresh();
      ref.read(progressProvider.notifier).refresh();
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Progress reset')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final notifPrefs = ref.watch(notificationPrefsProvider);
    final themeMode = ref.watch(themeModeProvider);

    return Scaffold(
      backgroundColor: Colors.transparent,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(AppSpacing.lg),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
            // Header
            Row(
              children: [
                IconButton(
                  icon: const Icon(Icons.arrow_back_rounded),
                  color: scheme.onSurfaceVariant,
                  onPressed: () => Navigator.of(context).maybePop(),
                ),
                const SizedBox(width: AppSpacing.sm),
                Text(
                  'Settings',
                  style: Theme.of(context).textTheme.displaySmall,
                ),
              ],
            ),
            const SizedBox(height: AppSpacing.xl),

            const _SectionHeader(title: 'Appearance'),
            const SizedBox(height: AppSpacing.md),
            _SettingsCard(
              children: [
                _SwitchTile(
                  icon: themeMode == ThemeMode.dark
                      ? Icons.dark_mode_rounded
                      : Icons.light_mode_rounded,
                  title: 'Dark mode',
                  subtitle: themeMode == ThemeMode.dark ? 'Enabled' : 'Disabled',
                  value: themeMode == ThemeMode.dark,
                  onChanged: (value) async {
                    await ref
                        .read(themeModeProvider.notifier)
                        .setThemeMode(value ? ThemeMode.dark : ThemeMode.light);
                  },
                ),
              ],
            ),
            const SizedBox(height: AppSpacing.lg),

            // Notifications section
            const _SectionHeader(title: 'Notifications'),
            const SizedBox(height: AppSpacing.md),

            _SettingsCard(
              children: [
                _SwitchTile(
                  icon: Icons.notifications_rounded,
                  title: 'Enable Notifications',
                  subtitle: 'Get reminders to learn and practice',
                  value: notifPrefs.enableNotifications,
                  onChanged: (value) async {
                    if (value) {
                      await _requestNotificationPermission();
                    } else {
                      await ref
                          .read(notificationPrefsProvider.notifier)
                          .toggleNotifications(false);
                      await NotificationService.cancelAllNotifications();
                    }
                  },
                ),
                const Divider(height: 1),
                _TapTile(
                  icon: Icons.schedule_rounded,
                  title: 'Reminder Time',
                  subtitle: notifPrefs.reminderTime,
                  enabled: notifPrefs.enableNotifications,
                  onTap: () => _showTimePickerDialog(notifPrefs.reminderTime),
                ),
                const Divider(height: 1),
                _TapTile(
                  icon: Icons.nightlight_round,
                  title: 'Quiet Hours',
                  subtitle: '${notifPrefs.quietHoursStart} - ${notifPrefs.quietHoursEnd}',
                  enabled: notifPrefs.enableNotifications,
                  onTap: () {
                    // Could implement quiet hours picker
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Quiet hours: 10 PM - 7 AM'),
                      ),
                    );
                  },
                ),
              ],
            ),
            const SizedBox(height: AppSpacing.lg),

            // Notification types
            if (notifPrefs.enableNotifications) ...[
              const _SectionHeader(title: 'Notification Types'),
              const SizedBox(height: AppSpacing.md),

              _SettingsCard(
                children: [
                  _SwitchTile(
                    icon: Icons.school_rounded,
                    title: 'Learning Reminders',
                    subtitle: 'Daily lesson reminders',
                    value: notifPrefs.learningReminders,
                    onChanged: (value) async {
                      final newPrefs = notifPrefs.copyWith(learningReminders: value);
                      await ref
                          .read(notificationPrefsProvider.notifier)
                          .updatePrefs(newPrefs);
                      await NotificationService.scheduleAllNotifications();
                    },
                  ),
                  const Divider(height: 1),
                  _SwitchTile(
                    icon: Icons.self_improvement_rounded,
                    title: 'Ahimsa Prompts',
                    subtitle: 'Mindful practice check-ins',
                    value: notifPrefs.ahimsaPrompts,
                    onChanged: (value) async {
                      final newPrefs = notifPrefs.copyWith(ahimsaPrompts: value);
                      await ref
                          .read(notificationPrefsProvider.notifier)
                          .updatePrefs(newPrefs);
                      await NotificationService.scheduleAllNotifications();
                    },
                  ),
                  const Divider(height: 1),
                  _SwitchTile(
                    icon: Icons.wb_twilight_rounded,
                    title: 'Reflection Prompts',
                    subtitle: 'Evening reflection reminders',
                    value: notifPrefs.reflectionPrompts,
                    onChanged: (value) async {
                      final newPrefs = notifPrefs.copyWith(reflectionPrompts: value);
                      await ref
                          .read(notificationPrefsProvider.notifier)
                          .updatePrefs(newPrefs);
                      await NotificationService.scheduleAllNotifications();
                    },
                  ),
                  const Divider(height: 1),
                  _SwitchTile(
                    icon: Icons.local_fire_department_rounded,
                    title: 'Streak Alerts',
                    subtitle: 'Warnings when your streak is at risk',
                    value: notifPrefs.streakRiskAlerts,
                    onChanged: (value) async {
                      final newPrefs = notifPrefs.copyWith(streakRiskAlerts: value);
                      await ref
                          .read(notificationPrefsProvider.notifier)
                          .updatePrefs(newPrefs);
                      await NotificationService.scheduleAllNotifications();
                    },
                  ),
                ],
              ),
              const SizedBox(height: AppSpacing.lg),
            ],

            // Data section
            const _SectionHeader(title: 'Data'),
            const SizedBox(height: AppSpacing.md),

            _SettingsCard(
              children: [
                _TapTile(
                  icon: Icons.delete_forever_rounded,
                  title: 'Reset Progress',
                  subtitle: 'Delete all progress and start over',
                  onTap: _showResetConfirmation,
                  isDestructive: true,
                ),
              ],
            ),
            const SizedBox(height: AppSpacing.lg),

            // About section
            const _SectionHeader(title: 'About'),
            const SizedBox(height: AppSpacing.md),

            const _SettingsCard(
              children: [
                _InfoTile(
                  icon: Icons.info_outline_rounded,
                  title: 'Version',
                  value: '1.0.0',
                ),
                Divider(height: 1),
                _InfoTile(
                  icon: Icons.code_rounded,
                  title: 'Built with',
                  value: 'Flutter',
                ),
              ],
            ),
            const SizedBox(height: AppSpacing.xl),

            // App description
            Container(
              padding: const EdgeInsets.all(AppSpacing.lg),
              decoration: BoxDecoration(
                color: AppColors.primary.withOpacityValue(0.1),
                borderRadius: BorderRadius.circular(AppRadius.card),
              ),
              child: Column(
                children: [
                  const Icon(
                    Icons.favorite_rounded,
                    color: AppColors.primary,
                    size: 32,
                  ),
                  const SizedBox(height: AppSpacing.md),
                  Text(
                    'JainQuest',
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          color: AppColors.primary,
                        ),
                  ),
                  const SizedBox(height: AppSpacing.sm),
                  Text(
                    'Gamified Jain learning for teens. Calm, modern, non-preachy.',
                    style: Theme.of(context).textTheme.bodyMedium,
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),

              const SizedBox(height: AppSpacing.xxl),
            ],
          ),
        ),
      ),
    );
  }
}

class _SectionHeader extends StatelessWidget {
  final String title;

  const _SectionHeader({required this.title});

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Text(
      title,
      style: Theme.of(context).textTheme.titleMedium?.copyWith(
            color: scheme.onSurfaceVariant,
          ),
    );
  }
}

class _SettingsCard extends StatelessWidget {
  final List<Widget> children;

  const _SettingsCard({required this.children});

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Container(
      decoration: BoxDecoration(
        color: scheme.surface,
        borderRadius: BorderRadius.circular(AppRadius.card),
        border: Border.all(color: scheme.outline),
      ),
      child: Column(children: children),
    );
  }
}

class _SwitchTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final bool value;
  final ValueChanged<bool> onChanged;

  const _SwitchTile({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.value,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(AppSpacing.md),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: AppColors.primary.withOpacityValue(0.1),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, color: AppColors.primary, size: 20),
          ),
          const SizedBox(width: AppSpacing.md),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: Theme.of(context).textTheme.titleSmall,
                ),
                Text(
                  subtitle,
                  style: Theme.of(context).textTheme.bodySmall,
                ),
              ],
            ),
          ),
          Switch(
            value: value,
            onChanged: onChanged,
            activeColor: AppColors.primary,
          ),
        ],
      ),
    );
  }
}

class _TapTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final VoidCallback onTap;
  final bool enabled;
  final bool isDestructive;

  const _TapTile({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.onTap,
    this.enabled = true,
    this.isDestructive = false,
  });

  @override
  Widget build(BuildContext context) {
    final color = isDestructive ? AppColors.danger : AppColors.primary;

    return InkWell(
      onTap: enabled ? onTap : null,
      child: Opacity(
        opacity: enabled ? 1.0 : 0.5,
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.md),
          child: Row(
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: color.withOpacityValue(0.1),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(icon, color: color, size: 20),
              ),
              const SizedBox(width: AppSpacing.md),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: Theme.of(context).textTheme.titleSmall?.copyWith(
                            color: isDestructive ? AppColors.danger : null,
                          ),
                    ),
                    Text(
                      subtitle,
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                  ],
                ),
              ),
              Icon(
                Icons.chevron_right_rounded,
                color: Theme.of(context).colorScheme.onSurfaceVariant,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _InfoTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final String value;

  const _InfoTile({
    required this.icon,
    required this.title,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Padding(
      padding: const EdgeInsets.all(AppSpacing.md),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: scheme.surfaceContainerHighest,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, color: scheme.onSurfaceVariant, size: 20),
          ),
          const SizedBox(width: AppSpacing.md),
          Expanded(
            child: Text(
              title,
              style: Theme.of(context).textTheme.titleSmall,
            ),
          ),
          Text(
            value,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: scheme.onSurfaceVariant,
                ),
          ),
        ],
      ),
    );
  }
}
