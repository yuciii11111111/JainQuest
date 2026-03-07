import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../home/presentation/home_screen.dart';
import '../../auth/presentation/create_account_screen.dart';
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

  @override
  void initState() {
    super.initState();

    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2600),
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

    _animationController.forward();

    Future.delayed(const Duration(milliseconds: 2600), () {
      if (mounted) {
        final authUser = FirebaseAuth.instance.currentUser;
        if (authUser == null) {
          Navigator.of(context).pushReplacement(
            _buildFadeRoute(const CreateAccountScreen()),
          );
          return;
        }

        StorageService.init(user: authUser).then((_) {
          if (!mounted) return;
          Navigator.of(context).pushReplacement(
            _buildFadeRoute(const HomeScreen()),
          );
        });
      }
    });
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
    final scheme = Theme.of(context).colorScheme;
    return Scaffold(
      body: AnimatedGradientBackground(
        child: Center(
          child: FadeTransition(
            opacity: _fadeOutAnimation,
            child: AnimatedBuilder(
              animation: _animationController,
              builder: (context, _) {
                return Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      width: math.min(MediaQuery.of(context).size.width * 0.9, 430),
                      height: 130,
                      alignment: Alignment.centerLeft,
                      child: ClipRect(
                        child: Align(
                          alignment: Alignment.centerLeft,
                          widthFactor: _writeAnimation.value,
                          child: Text(
                            'Jain Quest',
                            maxLines: 1,
                            style: GoogleFonts.cormorantGaramond(
                              color: scheme.onSurface,
                              fontSize: 72,
                              fontWeight: FontWeight.w700,
                              height: 1.0,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}
