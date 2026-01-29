import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

class AnimatedGradientBackground extends StatelessWidget {
  final Widget child;

  const AnimatedGradientBackground({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return DecoratedBox(
      decoration: isDark
          ? const BoxDecoration(color: AppColors.backgroundBase)
          : const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  Color(0xFFFDF6EC),
                  Color(0xFFF1F6FF),
                  Color(0xFFE8F7EF),
                  Color(0xFFFFF3D6),
                ],
                stops: [0.0, 0.35, 0.7, 1.0],
              ),
            ),
      child: child,
    );
  }
}
