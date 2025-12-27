import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../../core/theme/app_theme.dart';
import '../../home/presentation/home_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _particleController;

  @override
  void initState() {
    super.initState();
    _particleController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 3),
    )..repeat();

    // Navigate to home after animation
    Future.delayed(const Duration(seconds: 3), () {
      if (mounted) {
        Navigator.of(context).pushReplacement(
          PageRouteBuilder(
            pageBuilder: (context, animation, secondaryAnimation) =>
                const HomeScreen(),
            transitionsBuilder: (context, animation, secondaryAnimation, child) {
              return FadeTransition(
                opacity: animation,
                child: child,
              );
            },
            transitionDuration: const Duration(milliseconds: 500),
          ),
        );
      }
    });
  }

  @override
  void dispose() {
    _particleController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              AppColors.backgroundBase,
              Color(0xFF1A1730),
              AppColors.backgroundBase,
            ],
          ),
        ),
        child: Stack(
          children: [
            // Floating particles
            ...List.generate(20, (index) {
              return Positioned(
                left: (index * 37.0) % MediaQuery.of(context).size.width,
                top: (index * 23.0) % MediaQuery.of(context).size.height,
                child: _FloatingParticle(
                  controller: _particleController,
                  delay: Duration(milliseconds: index * 100),
                ),
              );
            }),

            // Main content
            Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Logo
                  Container(
                    width: 120,
                    height: 120,
                    decoration: BoxDecoration(
                      gradient: AppGradients.primary,
                      shape: BoxShape.circle,
                      boxShadow: AppShadows.glowing,
                    ),
                    child: const Icon(
                      Icons.auto_stories_rounded,
                      size: 64,
                      color: Colors.white,
                    ),
                  )
                      .animate()
                      .fadeIn(duration: 600.ms)
                      .scale(
                        begin: const Offset(0.5, 0.5),
                        end: const Offset(1, 1),
                        duration: 800.ms,
                        curve: Curves.easeOutBack,
                      ),

                  const SizedBox(height: AppSpacing.xl),

                  // App Name
                  Text(
                    'JainQuest',
                    style: Theme.of(context).textTheme.displayLarge?.copyWith(
                          foreground: Paint()
                            ..shader = AppGradients.primary.createShader(
                              const Rect.fromLTWH(0, 0, 200, 70),
                            ),
                          fontWeight: FontWeight.w900,
                        ),
                  )
                      .animate()
                      .fadeIn(delay: 300.ms, duration: 600.ms)
                      .slideY(
                        begin: 0.2,
                        end: 0,
                        duration: 600.ms,
                        curve: Curves.easeOutCubic,
                      ),

                  const SizedBox(height: AppSpacing.sm),

                  // Tagline
                  Text(
                    'Your Journey to Wisdom',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          color: AppColors.textSecondary,
                        ),
                  )
                      .animate()
                      .fadeIn(delay: 500.ms, duration: 600.ms)
                      .slideY(
                        begin: 0.2,
                        end: 0,
                        duration: 600.ms,
                        curve: Curves.easeOutCubic,
                      ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _FloatingParticle extends StatelessWidget {
  final AnimationController controller;
  final Duration delay;

  const _FloatingParticle({
    required this.controller,
    required this.delay,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: controller,
      builder: (context, child) {
        final animation = Curves.easeInOut.transform(
          ((controller.value * 2 + delay.inMilliseconds / 3000) % 2.0) / 2.0,
        );
        return Opacity(
          opacity: (1 - animation).clamp(0.0, 1.0),
          child: Transform.translate(
            offset: Offset(0, -50 * animation),
            child: Container(
              width: 4,
            height: 4,
            decoration: BoxDecoration(
              color: AppColors.primary.withOpacityValue(0.6),
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: AppColors.primary.withOpacityValue(0.4),
                  blurRadius: 8,
                  spreadRadius: 2,
                ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}

