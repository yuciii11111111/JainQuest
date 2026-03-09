import 'dart:async';
import 'dart:math' as math;

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../core/providers/app_providers.dart';
import '../../../core/navigation/app_navigator.dart';
import '../../../core/services/storage_service.dart';
import '../../../core/widgets/animated_gradient_background.dart';
import '../../../core/widgets/liquid_glass.dart';
import '../../auth/presentation/login_screen.dart';
import '../../home/presentation/home_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  static const Duration _writeDuration = Duration(milliseconds: 3200);
  static const Duration _holdAfterWrite = Duration(milliseconds: 1400);
  static const int _languageCycleMilliseconds = 3200 + 1400;
  static const Duration _languageCycleDuration = Duration(
    milliseconds: _languageCycleMilliseconds,
  );

  late final AnimationController _animationController;
  late final Animation<double> _writeAnimation;

  Timer? _languageTimer;
  int _languageIndex = 0;
  bool _navigating = false;

  static const _languageMessages = <_LocalizedWelcome>[
    _LocalizedWelcome(
      text: 'Welcome to Jain Quest',
      fontFamily: _WelcomeFont.cormorant,
    ),
    _LocalizedWelcome(
      text: 'जैन क्वेस्ट में स्वागत',
      fontFamily: _WelcomeFont.devanagari,
    ),
    _LocalizedWelcome(
      text: 'जैन क्वेस्टमध्ये स्वागत',
      fontFamily: _WelcomeFont.devanagari,
    ),
    _LocalizedWelcome(
      text: 'જૈન ક્વેસ્ટમાં સ્વાગત',
      fontFamily: _WelcomeFont.gujarati,
    ),
  ];

  @override
  void initState() {
    super.initState();

    _animationController = AnimationController(
      vsync: this,
      duration: _writeDuration,
    );
    _writeAnimation = CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOutCubic,
    );

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _startLanguageCycle();
    });
  }

  void _startLanguageCycle() {
    _playLanguageAnimation();
    _languageTimer = Timer.periodic(_languageCycleDuration, (_) {
      if (!mounted) return;
      setState(() {
        _languageIndex = (_languageIndex + 1) % _languageMessages.length;
      });
      _playLanguageAnimation();
    });
  }

  void _playLanguageAnimation() {
    _animationController.forward(from: 0);
  }

  Future<void> _navigateAfterSplash() async {
    if (_navigating) {
      return;
    }
    _navigating = true;
    final authUser = FirebaseAuth.instance.currentUser;
    if (authUser == null) {
      if (!mounted) return;
      Navigator.of(context).pushReplacementUltraSmooth(const LoginScreen());
      return;
    }

    await StorageService.init(user: authUser);
    if (!mounted) return;
    final container = ProviderScope.containerOf(context, listen: false);
    container.read(userProfileProvider.notifier).refresh();
    container.read(progressProvider.notifier).refresh();
    if (!mounted) return;
    Navigator.of(context).pushReplacementUltraSmooth(const HomeScreen());
  }

  @override
  void dispose() {
    _languageTimer?.cancel();
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
                  key: ValueKey('brand_reveal_$_languageIndex'),
                  animationController: _animationController,
                  writeAnimation: _writeAnimation,
                  message: _languageMessages[_languageIndex],
                ),
              ),
            ),
          ),
        ),
      ),
      bottomNavigationBar: SafeArea(
        minimum: const EdgeInsets.fromLTRB(24, 0, 24, 24),
        child: SizedBox(
          height: 56,
          child: LiquidGlassContainer(
            onTap: _navigateAfterSplash,
            borderRadius: BorderRadius.circular(28),
            tintColor: Colors.white,
            tintOpacity: 0.15,
            child: const Center(
              child: Text(
                'Next',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
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
  final _LocalizedWelcome message;

  const _BrandReveal({
    super.key,
    required this.animationController,
    required this.writeAnimation,
    required this.message,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
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
                      message.text,
                      maxLines: 1,
                      style: _resolveWelcomeTextStyle(message.fontFamily),
                    ),
                  ),
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  TextStyle _resolveWelcomeTextStyle(_WelcomeFont fontFamily) {
    switch (fontFamily) {
      case _WelcomeFont.gujarati:
        return GoogleFonts.notoSansGujarati(
          color: Colors.white,
          fontSize: 72,
          fontWeight: FontWeight.w700,
          height: 1,
        );
      case _WelcomeFont.devanagari:
        return GoogleFonts.notoSansDevanagari(
          color: Colors.white,
          fontSize: 70,
          fontWeight: FontWeight.w700,
          height: 1,
        );
      case _WelcomeFont.cormorant:
        return GoogleFonts.cormorantGaramond(
          color: Colors.white,
          fontSize: 84,
          fontWeight: FontWeight.w700,
          height: 1,
        );
    }
  }
}

class _LocalizedWelcome {
  final String text;
  final _WelcomeFont fontFamily;

  const _LocalizedWelcome({required this.text, required this.fontFamily});
}

enum _WelcomeFont { cormorant, devanagari, gujarati }
