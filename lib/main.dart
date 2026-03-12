import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/services.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:jainquest/firebase_options.dart';

import 'core/theme/app_theme.dart';
import 'core/services/notification_service.dart';
import 'core/services/storage_service.dart';
import 'core/providers/theme_provider.dart';
import 'core/widgets/guided_tour_overlay.dart';
import 'core/widgets/wave_background.dart';
import 'core/navigation/app_navigator.dart';
import 'features/splash/presentation/splash_screen.dart';
import 'core/localization/language_provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  // Initialize Firestore-backed storage when a user is already signed in.
  final currentUser = FirebaseAuth.instance.currentUser;
  if (currentUser != null) {
    await StorageService.init(user: currentUser);
  }

  // Initialize notifications
  await NotificationService.init();

  // Set preferred orientations
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  // Set system UI overlay style for dark theme
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.light,
      systemNavigationBarColor: Colors.transparent,
      systemNavigationBarIconBrightness: Brightness.light,
    ),
  );

  runApp(const ProviderScope(child: JainQuestApp()));
}

class JainQuestApp extends ConsumerWidget {
  const JainQuestApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeMode = ref.watch(themeModeProvider);
    final appLanguage = ref.watch(appLanguageProvider);

    // Update system UI overlay style based on theme
    WidgetsBinding.instance.addPostFrameCallback((_) {
      SystemChrome.setSystemUIOverlayStyle(
        SystemUiOverlayStyle(
          statusBarColor: Colors.transparent,
          statusBarIconBrightness:
              themeMode == ThemeMode.dark ? Brightness.light : Brightness.dark,
          systemNavigationBarColor: Colors.transparent,
          systemNavigationBarIconBrightness:
              themeMode == ThemeMode.dark ? Brightness.light : Brightness.dark,
        ),
      );
    });

    return MaterialApp(
      title: 'JainQuest',
      debugShowCheckedModeBanner: false,
      navigatorKey: appNavigatorKey,
      locale: appLanguage.locale,
      supportedLocales: const [Locale('en'), Locale('hi'), Locale('gu')],
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: themeMode,
      builder: (context, child) {
        return Stack(
          fit: StackFit.expand,
          children: [
            const WaveBackground(
              strokeColor: Color(0xD9FFFFFF),
              backgroundColor: Color(0xFF000000),
              pointerColor: Color(0xFFFFFFFF),
              pointerSize: 8,
              lineSpacingX: 12,
              lineSpacingY: 12,
            ),
            IgnorePointer(
              child: DecoratedBox(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Colors.black.withValues(alpha: 0.12),
                      Colors.black.withValues(alpha: 0.5),
                    ],
                  ),
                ),
              ),
            ),
            child ?? const SizedBox.shrink(),
            const GuidedTourOverlay(),
          ],
        );
      },
      home: const SplashScreen(),
    );
  }
}
