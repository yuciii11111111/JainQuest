import 'package:flutter/material.dart';

import '../theme/app_theme.dart';

class GlassSlider extends StatelessWidget {
  final double min;
  final double max;
  final double value;
  final ValueChanged<double>? onChanged;
  final int? divisions;
  final String? label;

  const GlassSlider({
    super.key,
    required this.min,
    required this.max,
    required this.value,
    this.onChanged,
    this.divisions,
    this.label,
  });

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final isLight = Theme.of(context).brightness == Brightness.light;

    return Theme(
      data: Theme.of(context).copyWith(
        sliderTheme: SliderTheme.of(context).copyWith(
          activeTrackColor: isLight ? const Color(0xAA6CC9B4) : scheme.primary,
          inactiveTrackColor:
              isLight ? Colors.white.withOpacity(0.55) : scheme.surfaceContainerHighest,
          thumbColor: isLight ? const Color(0xFF3E9D8A) : scheme.primary,
          overlayColor: (isLight ? const Color(0xFF6CC9B4) : scheme.primary)
              .withOpacity(0.18),
          trackHeight: 8,
          thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 10),
          overlayShape: const RoundSliderOverlayShape(overlayRadius: 18),
          valueIndicatorColor: isLight ? const Color(0xCC3E9D8A) : scheme.primary,
          valueIndicatorTextStyle: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: AppSpacing.sm, vertical: AppSpacing.xs),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(AppRadius.pill),
          border: Border.all(
            color: isLight
                ? scheme.outline.withOpacity(0.45)
                : scheme.outline.withOpacity(0.75),
          ),
          gradient: isLight
              ? const LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [Color(0xFFE0F7F1), Color(0xFFF9F7E8)],
                )
              : null,
          color: isLight ? null : scheme.surface.withOpacity(0.92),
          boxShadow: isLight
              ? [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.03),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ]
              : null,
        ),
        child: Slider(
          min: min,
          max: max,
          value: value.clamp(min, max),
          divisions: divisions,
          label: label,
          onChanged: onChanged,
        ),
      ),
    );
  }
}

class GlassScrollbar extends StatelessWidget {
  final Widget child;

  const GlassScrollbar({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final isLight = Theme.of(context).brightness == Brightness.light;

    return Theme(
      data: Theme.of(context).copyWith(
        scrollbarTheme: ScrollbarThemeData(
          thumbColor: WidgetStatePropertyAll(
            isLight ? const Color(0xAA6CC9B4) : scheme.primary.withOpacity(0.85),
          ),
          trackColor: WidgetStatePropertyAll(
            isLight ? Colors.white.withOpacity(0.4) : scheme.surfaceContainerHighest,
          ),
          trackBorderColor: WidgetStatePropertyAll(
            isLight ? scheme.outline.withOpacity(0.35) : scheme.outline,
          ),
          radius: const Radius.circular(999),
          thickness: const WidgetStatePropertyAll(9),
          thumbVisibility: const WidgetStatePropertyAll(true),
          trackVisibility: const WidgetStatePropertyAll(true),
        ),
      ),
      child: Scrollbar(child: child),
    );
  }
}
