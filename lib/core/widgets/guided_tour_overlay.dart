import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../guide/guide_keys.dart';
import '../localization/app_strings.dart';
import '../navigation/app_navigator.dart';
import '../providers/app_providers.dart';
import '../services/storage_service.dart';
import '../theme/app_motion.dart';
import '../theme/app_theme.dart';
import '../../features/lesson_runner/presentation/lesson_runner_screen.dart';
import 'floating_guide_overlay.dart';
import 'heart_lock_dialog.dart';
import 'motion_pressable.dart';
import 'tr_text.dart';
import 'typewriter_text.dart';

class GuidedTourOverlay extends ConsumerStatefulWidget {
  const GuidedTourOverlay({super.key});

  @override
  ConsumerState<GuidedTourOverlay> createState() => _GuidedTourOverlayState();
}

class _GuidedTourOverlayState extends ConsumerState<GuidedTourOverlay> {
  static const _guideAsset = 'assets/images/duo_guide.png';

  int _currentIndex = 0;
  bool _tourActive = true;
  Rect? _targetRect;

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  List<_TourStep> _stepsFor(BuildContext context) {
    final container = ProviderScope.containerOf(context, listen: false);
    final unit = container.read(unit1Provider);
    final firstLessonTitle =
        unit.lessons.isNotEmpty ? unit.lessons.first.title : 'First Lesson';
    void pushRoute(Widget page) {
      final navigator = appNavigatorKey.currentState;
      if (navigator == null) {
        return;
      }
      navigator.pushUltraSmooth(page);
    }

    void setHomeTab(int index) {
      container.read(homeTabIndexProvider.notifier).state = index;
    }

    return [
      _TourStep(
        key: GuideKeys.currentLessonCard,
        title: firstLessonTitle,
        message: context.t('guided_start_message'),
        onTap: () async {
          if (unit.lessons.isEmpty) {
            return false;
          }
          final updatedUser =
              await container.read(userProfileProvider.notifier).syncHearts();
          if (!context.mounted) {
            return false;
          }
          if (!updatedUser.hasHeartsAvailable) {
            await showHeartLockDialog(context, user: updatedUser);
            return false;
          }
          container
              .read(lessonRunnerProvider.notifier)
              .startLesson(unit.lessons.first);
          pushRoute(const LessonRunnerScreen());
          return true;
        },
      ),
      _TourStep(
        key: GuideKeys.lessonCompleteContinueButton,
        title: context.t('guided_finish_title'),
        message: context.t('guided_finish_message'),
        requiresFirstLessonCompleted: true,
        onTap: () async {
          final navigator = appNavigatorKey.currentState;
          container.read(lessonRunnerProvider.notifier).endLesson();
          navigator?.maybePop();
          Future<void>.delayed(const Duration(milliseconds: 120), () {
            navigator?.maybePop();
          });
          setHomeTab(1);
          return true;
        },
      ),
      _TourStep(
        key: GuideKeys.resourcesNavItem,
        title: context.t('guided_reading_title'),
        message: context.t('guided_reading_message'),
        onTap: () async {
          setHomeTab(1);
          return true;
        },
      ),
      _TourStep(
        key: GuideKeys.askGuruNavItem,
        title: context.t('ask_guru'),
        message: context.t('guided_ask_guru_message'),
        onTap: () async {
          setHomeTab(2);
          return true;
        },
      ),
      _TourStep(
        key: GuideKeys.communityNavItem,
        title: context.t('guided_community_title'),
        message: context.t('guided_community_message'),
        onTap: () async {
          setHomeTab(3);
          return true;
        },
      ),
      _TourStep(
        key: GuideKeys.profileNavItem,
        title: context.t('guided_profile_title'),
        message: context.t('guided_profile_message'),
        onTap: () async {
          setHomeTab(4);
          return true;
        },
      ),
    ];
  }

  void _scheduleTargetUpdate() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) {
        return;
      }
      final rect = _calculateTargetRect();
      if (rect != _targetRect) {
        setState(() => _targetRect = rect);
        return;
      }
      if (rect == null && _targetRect == null) {
        Future<void>.delayed(const Duration(milliseconds: 250), () {
          if (mounted) {
            setState(() {});
          }
        });
      }
    });
  }

  Rect? _calculateTargetRect() {
    final steps = _stepsFor(context);
    if (_currentIndex >= steps.length) {
      return null;
    }
    final targetContext = steps[_currentIndex].key.currentContext;
    if (targetContext == null) {
      return null;
    }
    final renderBox = targetContext.findRenderObject() as RenderBox?;
    if (renderBox == null || !renderBox.hasSize) {
      return null;
    }
    final topLeft = renderBox.localToGlobal(Offset.zero);
    return topLeft & renderBox.size;
  }

  Future<void> _advanceStep(_TourStep step) async {
    if (step.requiresFirstLessonCompleted) {
      final progress = ref.read(progressProvider);
      final firstLessonId = ref.read(unit1Provider).lessons.first.lessonId;
      if (!progress.isLessonCompleted(firstLessonId)) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(context.t('guided_finish_first')),
          ),
        );
        return;
      }
    }

    final completedStep = await step.onTap();
    if (!completedStep) {
      return;
    }
    await Future<void>.delayed(AppMotion.standard);
    if (!mounted) {
      return;
    }
    final steps = _stepsFor(context);
    final isLastStep = _currentIndex >= steps.length - 1;
    if (isLastStep) {
      await StorageService.markGuidedTourSeen();
      ref.read(userProfileProvider.notifier).refresh();
      if (!mounted) return;
      setState(() {
        _tourActive = false;
        _targetRect = null;
      });
      return;
    }
    setState(() {
      _currentIndex = (_currentIndex + 1) % steps.length;
    });
  }

  @override
  Widget build(BuildContext context) {
    final user = ref.watch(userProfileProvider);
    if (user.showGuidedTour && !_tourActive) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (!mounted) return;
        setState(() {
          _tourActive = true;
          _currentIndex = 0;
          _targetRect = null;
        });
      });
      return const SizedBox.shrink();
    }

    if (!user.showGuidedTour) {
      return const SizedBox.shrink();
    }

    if (!_tourActive) {
      return const FloatingGuideOverlay();
    }

    _scheduleTargetUpdate();
    final steps = _stepsFor(context);
    final step = steps[_currentIndex];
    final targetRect = _targetRect;
    final scheme = Theme.of(context).colorScheme;

    if (targetRect == null) {
      return const SizedBox.shrink();
    }

    final overlayRect = targetRect.inflate(14);
    final mediaQuery = MediaQuery.of(context);
    final screenSize = mediaQuery.size;
    final safePadding = mediaQuery.padding;
    const tooltipGap = 16.0;
    const screenInset = 16.0;
    final tooltipWidth = min(260.0, screenSize.width - (screenInset * 2));
    final placeBelow = overlayRect.center.dy < screenSize.height * 0.55;
    final tooltipLeft = (overlayRect.center.dx - tooltipWidth / 2).clamp(
      screenInset,
      screenSize.width - tooltipWidth - screenInset,
    );
    final tooltipTop = placeBelow ? overlayRect.bottom + tooltipGap : null;
    final tooltipBottom =
        placeBelow ? null : screenSize.height - overlayRect.top + tooltipGap;
    final tooltipMaxHeight = max(
      96.0,
      placeBelow
          ? screenSize.height -
              overlayRect.bottom -
              safePadding.bottom -
              tooltipGap -
              screenInset
          : overlayRect.top - safePadding.top - tooltipGap - screenInset,
    );
    final guideOffset = placeBelow
        ? Offset(tooltipLeft - 40, overlayRect.bottom - 12)
        : Offset(tooltipLeft - 36, overlayRect.top - 40);

    return Stack(
      children: [
        Positioned.fill(
          child: CustomPaint(
            painter: _SpotlightPainter(
              target: overlayRect,
              radius: 20,
              color: Colors.black.withOpacityValue(0.7),
            ),
          ),
        ),
        AnimatedPositioned(
          duration: AppMotion.screenEnter,
          curve: AppMotion.enterCurve,
          left: overlayRect.left,
          top: overlayRect.top,
          width: overlayRect.width,
          height: overlayRect.height,
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(22),
              border: Border.all(
                color: AppColors.highlight.withOpacityValue(0.9),
                width: 2,
              ),
            ),
          ),
        ),
        AnimatedPositioned(
          duration: AppMotion.screenEnter,
          curve: AppMotion.enterCurve,
          left: overlayRect.left,
          top: overlayRect.top,
          width: overlayRect.width,
          height: overlayRect.height,
          child: MotionPressable(
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                onTap: () => _advanceStep(step),
                borderRadius: BorderRadius.circular(22),
              ),
            ),
          ),
        ),
        AnimatedPositioned(
          duration: AppMotion.screenEnter,
          curve: AppMotion.enterCurve,
          left: tooltipLeft,
          top: tooltipTop,
          bottom: tooltipBottom,
          width: tooltipWidth,
          child: AnimatedSwitcher(
            duration: AppMotion.standard,
            switchInCurve: AppMotion.enterCurve,
            switchOutCurve: AppMotion.exitCurve,
            transitionBuilder: (child, animation) {
              final slide = Tween<Offset>(
                begin: AppMotion.tooltipOffset,
                end: Offset.zero,
              ).animate(animation);
              return FadeTransition(
                opacity: animation,
                child: SlideTransition(position: slide, child: child),
              );
            },
            child: Container(
              key: ValueKey(_currentIndex),
              constraints: BoxConstraints(maxHeight: tooltipMaxHeight),
              padding: const EdgeInsets.all(AppSpacing.md),
              decoration: BoxDecoration(
                color: scheme.surface.withOpacityValue(0.95),
                borderRadius: BorderRadius.circular(AppRadius.card),
                border: Border.all(color: scheme.outline),
              ),
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    TrText(
                      key: ValueKey('guide-title-$_currentIndex'),
                      step.title,
                      style: Theme.of(context)
                          .textTheme
                          .titleMedium
                          ?.copyWith(color: scheme.onSurface),
                    ),
                    const SizedBox(height: 6),
                    TypewriterText(
                      key: ValueKey('guide-message-$_currentIndex'),
                      text: step.message,
                      enabled: true,
                      speed: const Duration(milliseconds: 6),
                      style: Theme.of(context)
                          .textTheme
                          .bodySmall
                          ?.copyWith(color: scheme.onSurfaceVariant),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
        AnimatedPositioned(
          duration: AppMotion.screenEnter,
          curve: AppMotion.enterCurve,
          left: guideOffset.dx,
          top: guideOffset.dy,
          child: Image.asset(
            _guideAsset,
            width: 80,
            height: 80,
          ),
        ),
        Positioned(
          right: 16,
          top: 40,
          child: MotionPressable(
            child: TextButton(
              onPressed: () async {
                await StorageService.markGuidedTourSeen();
                ref.read(userProfileProvider.notifier).refresh();
                if (!mounted) return;
                setState(() => _tourActive = false);
              },
              child: Text(
                context.t('skip'),
                style: Theme.of(context).textTheme.labelLarge?.copyWith(
                      color: scheme.onSurfaceVariant,
                    ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class _TourStep {
  final GlobalKey key;
  final String title;
  final String message;
  final Future<bool> Function() onTap;
  final bool requiresFirstLessonCompleted;

  const _TourStep({
    required this.key,
    required this.title,
    required this.message,
    required this.onTap,
    this.requiresFirstLessonCompleted = false,
  });
}

class _SpotlightPainter extends CustomPainter {
  final Rect target;
  final double radius;
  final Color color;

  const _SpotlightPainter({
    required this.target,
    required this.radius,
    required this.color,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..color = color;
    final background = Path()..addRect(Offset.zero & size);
    final hole = Path()
      ..addRRect(
        RRect.fromRectAndRadius(target, Radius.circular(radius)),
      );
    final overlay = Path.combine(
      PathOperation.difference,
      background,
      hole,
    );
    canvas.drawPath(overlay, paint);
  }

  @override
  bool shouldRepaint(covariant _SpotlightPainter oldDelegate) {
    return oldDelegate.target != target || oldDelegate.color != color;
  }
}
