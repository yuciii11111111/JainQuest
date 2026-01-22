import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

class VideoBackground extends StatelessWidget {
  final Widget child;

  const VideoBackground({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final backgroundColor =
        isDark ? AppColors.backgroundBase : AppColors.lightBackground;

    return ColoredBox(
      color: backgroundColor,
      child: child,
    );
  }
}
