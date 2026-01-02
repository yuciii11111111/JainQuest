import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:confetti/confetti.dart';
import 'package:share_plus/share_plus.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/models/lesson_models.dart';
import '../../../../core/widgets/common_widgets.dart';
import '../../../../core/widgets/gradient_button.dart';
import '../../../../core/widgets/floating_card.dart';

class LessonCompleteScreenWidget extends StatefulWidget {
  final LessonCompleteScreen screen;
  final int xpEarned;
  final bool isPerfect;
  final String? badgeEarned;
  final int streak;
  final VoidCallback onContinue;

  const LessonCompleteScreenWidget({
    super.key,
    required this.screen,
    required this.xpEarned,
    required this.isPerfect,
    this.badgeEarned,
    required this.streak,
    required this.onContinue,
  });

  @override
  State<LessonCompleteScreenWidget> createState() =>
      _LessonCompleteScreenWidgetState();
}

class _LessonCompleteScreenWidgetState
    extends State<LessonCompleteScreenWidget>
    with TickerProviderStateMixin {
  late ConfettiController _confettiController;
  late AnimationController _xpController;
  late AnimationController _badgeController;
  int _displayedXp = 0;

  @override
  void initState() {
    super.initState();
    _confettiController = ConfettiController(duration: const Duration(seconds: 3));
    _xpController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    );
    _badgeController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );

    // Start animations
    _confettiController.play();
    _xpController.forward();
    _badgeController.forward();

    // Animate XP count-up
    _xpController.addListener(() {
      setState(() {
        _displayedXp = (widget.xpEarned * _xpController.value).round();
      });
    });
  }

  @override
  void dispose() {
    _confettiController.dispose();
    _xpController.dispose();
    _badgeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // Confetti
        Align(
          alignment: Alignment.topCenter,
          child: ConfettiWidget(
            confettiController: _confettiController,
            blastDirection: 3.14 / 2,
            maxBlastForce: 5,
            minBlastForce: 2,
            emissionFrequency: 0.05,
            numberOfParticles: 20,
            gravity: 0.1,
            colors: const [
              AppColors.primary,
              AppColors.secondary,
              AppColors.success,
              AppColors.achievementGold,
            ],
          ),
        ),

        // Content
        SingleChildScrollView(
          padding: const EdgeInsets.all(AppSpacing.lg),
          child: Column(
            children: [
              const SizedBox(height: AppSpacing.xl),

              // Mascot celebration
              const MascotWidget(
                state: MascotState.complete,
                size: 120,
              )
                  .animate()
                  .scale(
                    begin: const Offset(0.5, 0.5),
                    end: const Offset(1, 1),
                    duration: 600.ms,
                    curve: Curves.easeOutBack,
              )
              .then()
              .shimmer(duration: 2000.ms, color: AppColors.achievementGold.withOpacityValue(0.3)),

              const SizedBox(height: AppSpacing.xl),

              // Title
              Text(
                widget.screen.title,
                style: Theme.of(context).textTheme.displaySmall?.copyWith(
                      foreground: Paint()
                        ..shader = AppGradients.success.createShader(
                          const Rect.fromLTWH(0, 0, 300, 70),
                        ),
                      fontWeight: FontWeight.w900,
                    ),
                textAlign: TextAlign.center,
              )
                  .animate()
                  .fadeIn(delay: 200.ms, duration: 500.ms)
                  .slideY(begin: 0.2, end: 0, duration: 500.ms),

              const SizedBox(height: AppSpacing.lg),

              // XP Earned Card
              FloatingCard(
                padding: const EdgeInsets.all(AppSpacing.lg),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(
                          Icons.star_rounded,
                          size: 40,
                          color: AppColors.achievementGold,
                        )
                            .animate(onPlay: (controller) => controller.repeat())
                            .scale(
                              begin: const Offset(1, 1),
                              end: const Offset(1.2, 1.2),
                              duration: 500.ms,
                              curve: Curves.easeInOut,
                            )
                            .then()
                            .scale(
                              begin: const Offset(1.2, 1.2),
                              end: const Offset(1, 1),
                              duration: 500.ms,
                              curve: Curves.easeInOut,
                            ),
                        const SizedBox(width: AppSpacing.sm),
                        Text(
                          '+$_displayedXp XP',
                          style: Theme.of(context).textTheme.displayMedium?.copyWith(
                                foreground: Paint()
                                  ..shader = AppGradients.warm.createShader(
                                    const Rect.fromLTWH(0, 0, 200, 70),
                                  ),
                                fontWeight: FontWeight.w900,
                              ),
                        ),
                      ],
                    ),
                    if (widget.isPerfect) ...[
                      const SizedBox(height: AppSpacing.md),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: AppSpacing.md,
                          vertical: AppSpacing.sm,
                        ),
                        decoration: BoxDecoration(
                          gradient: AppGradients.success,
                          borderRadius: BorderRadius.circular(AppRadius.pill),
                          boxShadow: AppShadows.glowing,
                        ),
                        child: const Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              Icons.emoji_events_rounded,
                              size: 20,
                              color: Colors.white,
                            ),
                            SizedBox(width: AppSpacing.xs),
                            Text(
                              'Perfect Score Bonus!',
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w700,
                                color: Colors.white,
                              ),
                            ),
                          ],
                        ),
                      )
                          .animate()
                          .fadeIn(delay: 1000.ms, duration: 500.ms)
                          .scale(begin: const Offset(0.8, 0.8), end: const Offset(1, 1)),
                    ],
                  ],
                ),
              )
                  .animate(delay: 400.ms)
                  .fadeIn(duration: 500.ms)
                  .scale(begin: const Offset(0.9, 0.9), end: const Offset(1, 1)),

              const SizedBox(height: AppSpacing.lg),

              // Badge Earned
              if (widget.badgeEarned != null)
                FloatingCard(
                  padding: const EdgeInsets.all(AppSpacing.lg),
                  child: Column(
                    children: [
                      Container(
                        width: 80,
                        height: 80,
                        decoration: BoxDecoration(
                          gradient: AppGradients.accent,
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: AppColors.secondary,
                            width: 4,
                          ),
                          boxShadow: AppShadows.glowing,
                        ),
                        child: const Icon(
                          Icons.workspace_premium_rounded,
                          size: 48,
                          color: Colors.white,
                        ),
                      )
                          .animate()
                          .scale(
                            begin: const Offset(0, 0),
                            end: const Offset(1, 1),
                            duration: 800.ms,
                            curve: Curves.easeOutBack,
                          )
                          .then()
                      .shimmer(
                        duration: 2000.ms,
                        color: AppColors.secondary.withOpacityValue(0.5),
                      ),
                      const SizedBox(height: AppSpacing.md),
                      Text(
                        'Badge Earned!',
                        style: Theme.of(context).textTheme.titleLarge?.copyWith(
                              color: AppColors.secondary,
                              fontWeight: FontWeight.w700,
                            ),
                      ),
                      const SizedBox(height: AppSpacing.xs),
                      Text(
                        widget.screen.rewardText,
                        style: Theme.of(context).textTheme.bodyMedium,
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                )
                    .animate(delay: 600.ms)
                    .fadeIn(duration: 500.ms)
                    .scale(begin: const Offset(0.8, 0.8), end: const Offset(1, 1)),

              // Streak Update
              if (widget.streak > 0)
                Padding(
                  padding: const EdgeInsets.only(top: AppSpacing.lg),
                  child: FloatingCard(
                    padding: const EdgeInsets.all(AppSpacing.md),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(
                          Icons.local_fire_department_rounded,
                          color: AppColors.warning,
                          size: 32,
                        )
                            .animate(onPlay: (controller) => controller.repeat())
                            .scale(
                              begin: const Offset(1, 1),
                              end: const Offset(1.15, 1.15),
                              duration: 500.ms,
                              curve: Curves.easeInOut,
                            )
                            .then()
                            .scale(
                              begin: const Offset(1.15, 1.15),
                              end: const Offset(1, 1),
                              duration: 500.ms,
                              curve: Curves.easeInOut,
                            ),
                        const SizedBox(width: AppSpacing.sm),
                        Text(
                          '${widget.streak} Day Streak!',
                          style: Theme.of(context).textTheme.titleLarge?.copyWith(
                                color: AppColors.warning,
                                fontWeight: FontWeight.w800,
                              ),
                        ),
                      ],
                    ),
                  )
                      .animate(delay: 800.ms)
                      .fadeIn(duration: 500.ms)
                      .slideX(begin: -0.1, end: 0, duration: 500.ms),
                ),

              const SizedBox(height: AppSpacing.xl),

              // Continue Button
              GradientButton(
                label: 'Continue',
                icon: Icons.arrow_forward_rounded,
                onPressed: widget.onContinue,
                width: double.infinity,
              )
                  .animate(delay: 1000.ms)
                  .fadeIn(duration: 500.ms)
                  .slideY(begin: 0.2, end: 0, duration: 500.ms),

              const SizedBox(height: AppSpacing.md),

              // Share Button
              GradientButton(
                label: 'Share Achievement',
                icon: Icons.share_rounded,
                onPressed: () {
                  Share.share(
                    'I just earned ${widget.xpEarned} XP in JainQuest!',
                  );
                },
                gradient: AppGradients.accent,
                width: double.infinity,
              )
                  .animate(delay: 1100.ms)
                  .fadeIn(duration: 500.ms)
                  .slideY(begin: 0.2, end: 0, duration: 500.ms),

              const SizedBox(height: AppSpacing.xl),
            ],
          ),
        ),
      ],
    );
  }
}

