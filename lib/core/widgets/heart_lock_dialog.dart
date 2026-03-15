import 'package:flutter/material.dart';

import '../gamification/gamification_rules.dart';
import '../localization/app_strings.dart';
import '../models/user_models.dart';
import '../theme/app_theme.dart';

String formatHeartCountdown(Duration duration) {
  final totalSeconds = duration.inSeconds.clamp(0, 359999);
  final minutes = totalSeconds ~/ 60;
  final seconds = totalSeconds % 60;

  if (minutes >= 60) {
    final hours = minutes ~/ 60;
    final remainingMinutes = minutes % 60;
    return '${hours}h ${remainingMinutes}m';
  }

  if (minutes > 0) {
    return '${minutes}m ${seconds.toString().padLeft(2, '0')}s';
  }

  return '${seconds}s';
}

Future<void> showHeartLockDialog(
  BuildContext context, {
  required UserProfile user,
}) {
  final timeUntilNextHeart =
      user.timeUntilNextHeart() ?? HeartsSystem.heartRegenDuration;
  final countdown = formatHeartCountdown(timeUntilNextHeart);

  return showDialog<void>(
    context: context,
    builder: (context) => AlertDialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppRadius.card),
      ),
      title: Text(context.t('out_of_hearts_title')),
      content: Text(
        context.t(
          'out_of_hearts_message',
          args: {
            'time': countdown,
            'pages': '${HeartsSystem.readingPagesPerHeart}',
          },
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: Text(context.t('done')),
        ),
      ],
    ),
  );
}
