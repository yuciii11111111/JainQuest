import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../guide/guide_keys.dart';
import '../navigation/app_navigator.dart';
import '../providers/app_providers.dart';
import '../services/storage_service.dart';
import '../theme/app_theme.dart';
import '../../features/path/presentation/unit_path_screen.dart';
import '../../features/lesson_runner/presentation/lesson_runner_screen.dart';
import 'floating_guide_overlay.dart';
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
    void pushRoute(Widget page) {
      final navigator = appNavigatorKey.currentState;
      if (navigator == null) {
        return;
      }
      navigator.push(MaterialPageRoute(builder: (_) => page));
    }

    void setHomeTab(int index) {
      container.read(homeTabIndexProvider.notifier).state = index;
    }

    return [
      _TourStep(
        key: GuideKeys.continueLearningButton,
        title: 'Start Learning',
        message: 'Open your learning path to begin the tour.',
        onTap: () {
          setHomeTab(0);
          pushRoute(const UnitPathScreen());
        },
      ),
      _TourStep(
        key: GuideKeys.whatIsJainismLesson,
        title: 'What Is Jainism',
        message: 'Start with this first lesson.',
        onTap: () {
          final unit = container.read(unit1Provider);
          if (unit.lessons.isEmpty) {
            return;
          }
          container
              .read(lessonRunnerProvider.notifier)
              .startLesson(unit.lessons.first);
          pushRoute(const LessonRunnerScreen());
        },
      ),
      _TourStep(
        key: GuideKeys.lessonCompleteContinueButton,
        title: 'Finish The First Lesson',
        message:
            'Complete all lesson screens and quiz. When this Continue button appears, move on.',
        requiresFirstLessonCompleted: true,
        onTap: () {
          final navigator = appNavigatorKey.currentState;
          container.read(lessonRunnerProvider.notifier).endLesson();
          navigator?.maybePop();
          Future<void>.delayed(const Duration(milliseconds: 120), () {
            navigator?.maybePop();
          });
          setHomeTab(1);
        },
      ),
      _TourStep(
        key: GuideKeys.resourcesNavItem,
        title: 'Reading',
        message: 'Resources is your reading hub.',
        onTap: () => setHomeTab(1),
      ),
      _TourStep(
        key: GuideKeys.askGuruNavItem,
        title: 'Ask Guru',
        message: 'Use Ask Guru whenever you need help.',
        onTap: () => setHomeTab(2),
      ),
      _TourStep(
        key: GuideKeys.communityNavItem,
        title: 'Community',
        message: 'Join conversations with other learners here.',
        onTap: () => setHomeTab(3),
      ),
      _TourStep(
        key: GuideKeys.profileNavItem,
        title: 'Profile',
        message: 'Track your progress, badges, and settings.',
        onTap: () => setHomeTab(4),
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
      if (!progress.isLessonCompleted('U01_L01')) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Finish "What is Jainism" first, then continue.'),
          ),
        );
        return;
      }
    }

    step.onTap();
    await Future<void>.delayed(const Duration(milliseconds: 350));
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
    final screenSize = MediaQuery.of(context).size;
    final tooltipWidth = min(260.0, screenSize.width - 32);
    const tooltipHeight = 96.0;
    final placeBelow = overlayRect.center.dy < screenSize.height * 0.55;
    final tooltipLeft = (overlayRect.center.dx - tooltipWidth / 2)
        .clamp(16.0, screenSize.width - tooltipWidth - 16.0);
    final tooltipTop = placeBelow
        ? overlayRect.bottom + 16
        : overlayRect.top - tooltipHeight - 16;
    final guideOffset = placeBelow
        ? Offset(tooltipLeft - 40, tooltipTop - 28)
        : Offset(tooltipLeft - 36, tooltipTop + tooltipHeight - 24);

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
          duration: const Duration(milliseconds: 500),
          curve: Curves.easeInOut,
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
          duration: const Duration(milliseconds: 500),
          curve: Curves.easeInOut,
          left: overlayRect.left,
          top: overlayRect.top,
          width: overlayRect.width,
          height: overlayRect.height,
          child: Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: () => _advanceStep(step),
              borderRadius: BorderRadius.circular(22),
            ),
          ),
        ),
        AnimatedPositioned(
          duration: const Duration(milliseconds: 500),
          curve: Curves.easeOutCubic,
          left: tooltipLeft,
          top: tooltipTop,
          width: tooltipWidth,
          height: tooltipHeight,
          child: AnimatedSwitcher(
            duration: const Duration(milliseconds: 420),
            switchInCurve: Curves.easeOutCubic,
            switchOutCurve: Curves.easeInCubic,
            transitionBuilder: (child, animation) {
              final slide = Tween<Offset>(
                begin: const Offset(0, 0.08),
                end: Offset.zero,
              ).animate(animation);
              return FadeTransition(
                opacity: animation,
                child: SlideTransition(position: slide, child: child),
              );
            },
            child: Container(
              key: ValueKey(_currentIndex),
              padding: const EdgeInsets.all(AppSpacing.md),
              decoration: BoxDecoration(
                color: scheme.surface.withOpacityValue(0.95),
                borderRadius: BorderRadius.circular(AppRadius.card),
                border: Border.all(color: scheme.outline),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  TypewriterText(
                    key: ValueKey('guide-title-$_currentIndex'),
                    text: step.title,
                    enabled: true,
                    speed: const Duration(milliseconds: 14),
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
                    speed: const Duration(milliseconds: 10),
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
        AnimatedPositioned(
          duration: const Duration(milliseconds: 600),
          curve: Curves.easeInOutBack,
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
          child: TextButton(
            onPressed: () async {
              await StorageService.markGuidedTourSeen();
              ref.read(userProfileProvider.notifier).refresh();
              if (!mounted) return;
              setState(() => _tourActive = false);
            },
            child: Text(
              'Skip',
              style: Theme.of(context).textTheme.labelLarge?.copyWith(
                    color: scheme.onSurfaceVariant,
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
  final VoidCallback onTap;
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
