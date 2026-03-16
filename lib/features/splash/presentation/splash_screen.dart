import 'dart:async';
import 'dart:math' as math;

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../core/localization/app_strings.dart';
import '../../../core/providers/app_providers.dart';
import '../../../core/navigation/app_navigator.dart';
import '../../../core/services/storage_service.dart';
import '../../../core/theme/app_motion.dart';
import '../../../core/widgets/liquid_glass.dart';
import '../../auth/presentation/create_account_screen.dart';
import '../../home/presentation/home_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  static const Duration _writeDuration = Duration(milliseconds: 3200);
  static const int _languageCycleMilliseconds = 3200 + 1400;
  static const Duration _languageCycleDuration = Duration(
    milliseconds: _languageCycleMilliseconds,
  );

  late final AnimationController _animationController;
  late final Animation<double> _writeAnimation;

  Timer? _languageTimer;
  int _languageIndex = 0;
  bool _navigating = false;
  bool _isProceeding = false;
  bool _isRestoringSession = false;

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
      curve: AppMotion.enterCurve,
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
    setState(() {
      _isProceeding = true;
      _isRestoringSession = authUser != null;
    });
    if (authUser == null) {
      if (!mounted) return;
      Navigator.of(context).pushReplacementUltraSmooth(
        const CreateAccountScreen(),
      );
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
      backgroundColor: Colors.transparent,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
          child: Column(
            children: [
              const SizedBox(height: 8),
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    AnimatedSwitcher(
                      duration: AppMotion.screenEnter,
                      switchInCurve: AppMotion.enterCurve,
                      switchOutCurve: AppMotion.exitCurve,
                      child: _BrandReveal(
                        key: ValueKey('brand_reveal_$_languageIndex'),
                        animationController: _animationController,
                        writeAnimation: _writeAnimation,
                        message: _languageMessages[_languageIndex],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: SafeArea(
        minimum: const EdgeInsets.fromLTRB(24, 0, 24, 24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            AnimatedSize(
              duration: AppMotion.standard,
              curve: AppMotion.enterCurve,
              child: _isRestoringSession
                  ? const Padding(
                      padding: EdgeInsets.only(bottom: 12),
                      child: _AutoLoginStatusCard(),
                    )
                  : const SizedBox.shrink(),
            ),
            SizedBox(
              height: 56,
              child: LiquidGlassContainer(
                onTap: _isProceeding ? null : _navigateAfterSplash,
                borderRadius: BorderRadius.circular(28),
                tintColor: Colors.white,
                tintOpacity: _isProceeding ? 0.22 : 0.15,
                borderColor: Colors.white.withValues(
                  alpha: _isProceeding ? 0.48 : 0.3,
                ),
                child: Center(
                  child: AnimatedSwitcher(
                    duration: AppMotion.standard,
                    switchInCurve: AppMotion.enterCurve,
                    switchOutCurve: AppMotion.exitCurve,
                    transitionBuilder: (child, animation) {
                      return FadeTransition(
                        opacity: animation,
                        child: SlideTransition(
                          position: Tween<Offset>(
                            begin: const Offset(0, 0.12),
                            end: Offset.zero,
                          ).animate(animation),
                          child: child,
                        ),
                      );
                    },
                    child: _isProceeding
                        ? _SplashFooterLabel(
                            key: const ValueKey('splash-loading'),
                            label: context.t('please_wait'),
                            isLoading: true,
                          )
                        : _SplashFooterLabel(
                            key: const ValueKey('splash-next'),
                            label: context.t('next'),
                          ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _AutoLoginStatusCard extends StatelessWidget {
  const _AutoLoginStatusCard();

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return LiquidGlassContainer(
      borderRadius: BorderRadius.circular(24),
      tintColor: Colors.white,
      tintOpacity: 0.12,
      borderColor: Colors.white.withValues(alpha: 0.24),
      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 14),
      child: Row(
        children: [
          const SizedBox(
            width: 18,
            height: 18,
            child: CircularProgressIndicator(
              strokeWidth: 2.2,
              valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  context.t('auto_logging_in'),
                  style: textTheme.titleSmall?.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  context.t('restoring_progress'),
                  style: textTheme.bodySmall?.copyWith(
                    color: Colors.white.withValues(alpha: 0.78),
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _SplashFooterLabel extends StatelessWidget {
  final String label;
  final bool isLoading;

  const _SplashFooterLabel({
    super.key,
    required this.label,
    this.isLoading = false,
  });

  @override
  Widget build(BuildContext context) {
    final textStyle = Theme.of(context).textTheme.titleMedium?.copyWith(
          color: Colors.white,
          fontWeight: FontWeight.w700,
        );

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        if (isLoading) ...[
          const SizedBox(
            width: 16,
            height: 16,
            child: CircularProgressIndicator(
              strokeWidth: 2,
              valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
            ),
          ),
          const SizedBox(width: 12),
        ],
        Text(label, style: textStyle),
      ],
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
