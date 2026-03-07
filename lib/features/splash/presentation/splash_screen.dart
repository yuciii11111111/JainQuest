import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../home/presentation/home_screen.dart';
import '../../auth/presentation/create_account_screen.dart';
import '../../../core/providers/app_providers.dart';
import '../../../core/services/storage_service.dart';
import '../../../core/widgets/animated_gradient_background.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late final AnimationController _animationController;
  late final Animation<double> _writeAnimation;
  late final Animation<double> _fadeOutAnimation;
  bool _navigating = false;

  @override
  void initState() {
    super.initState();

    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 3600),
    );
    _writeAnimation = CurvedAnimation(
      parent: _animationController,
      curve: const Interval(0, 0.72, curve: Curves.easeInOutCubic),
    );
    _fadeOutAnimation = Tween<double>(begin: 1, end: 0).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: const Interval(0.78, 1, curve: Curves.easeInOut),
      ),
    );

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _startJourney();
    });
  }

  Future<void> _startJourney() async {
    await _animationController.forward(from: 0);
    if (!mounted) {
      return;
    }
    await _navigateAfterSplash();
  }

  Future<void> _navigateAfterSplash() async {
    if (_navigating) {
      return;
    }
    _navigating = true;
    final authUser = FirebaseAuth.instance.currentUser;
    if (authUser == null) {
      if (!mounted) return;
      Navigator.of(context).pushReplacement(
        _buildFadeRoute(const CreateAccountScreen()),
      );
      return;
    }

    await StorageService.init(user: authUser);
    if (!mounted) return;
    final container = ProviderScope.containerOf(context, listen: false);
    container.read(userProfileProvider.notifier).refresh();
    container.read(progressProvider.notifier).refresh();
    if (!mounted) return;
    Navigator.of(context).pushReplacement(
      _buildFadeRoute(const HomeScreen()),
    );
  }

  PageRouteBuilder<void> _buildFadeRoute(Widget screen) {
    return PageRouteBuilder<void>(
      pageBuilder: (_, __, ___) => screen,
      transitionsBuilder: (_, animation, __, child) => FadeTransition(
        opacity: CurvedAnimation(parent: animation, curve: Curves.easeInOut),
        child: child,
      ),
      transitionDuration: const Duration(milliseconds: 500),
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AnimatedGradientBackground(
        forceDark: true,
        initialCycleDelay: const Duration(milliseconds: 700),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
            child: Center(
              child: AnimatedSwitcher(
                duration: const Duration(milliseconds: 360),
                switchInCurve: Curves.easeOutCubic,
                switchOutCurve: Curves.easeInCubic,
                child: _BrandReveal(
                  key: const ValueKey('brand_reveal'),
                  animationController: _animationController,
                  writeAnimation: _writeAnimation,
                  fadeOutAnimation: _fadeOutAnimation,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _BrandReveal extends StatelessWidget {
  final AnimationController animationController;
  final Animation<double> writeAnimation;
  final Animation<double> fadeOutAnimation;

  const _BrandReveal({
    super.key,
    required this.animationController,
    required this.writeAnimation,
    required this.fadeOutAnimation,
  });

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: fadeOutAnimation,
      child: AnimatedBuilder(
        animation: animationController,
        builder: (context, _) {
          return Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: math.min(MediaQuery.of(context).size.width * 0.94, 900),
                height: 170,
                alignment: Alignment.center,
                child: ClipRect(
                  child: Align(
                    alignment: Alignment.centerLeft,
                    widthFactor: writeAnimation.value,
                    child: FittedBox(
                      fit: BoxFit.scaleDown,
                      alignment: Alignment.centerLeft,
                      child: Text(
                        'Welcome to Jain Quest',
                        maxLines: 1,
                        style: GoogleFonts.cormorantGaramond(
                          color: Colors.white,
                          fontSize: 84,
                          fontWeight: FontWeight.w700,
                          height: 1.0,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
