import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/services.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:jainquest/firebase_options.dart';

import 'core/theme/app_theme.dart';
import 'core/services/notification_service.dart';
import 'core/services/storage_service.dart';
import 'core/providers/theme_provider.dart';
import 'core/widgets/animated_gradient_background.dart';
import 'core/widgets/guided_tour_overlay.dart';
import 'core/widgets/video_background.dart';
import 'features/splash/presentation/splash_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  // Initialize Firestore-backed storage
  await StorageService.init();

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
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: themeMode,
      builder: (context, child) {
        return VideoBackground(
          child: AnimatedGradientBackground(
            child: Stack(
              children: [
                child ?? const SizedBox.shrink(),
                const GuidedTourOverlay(),
              ],
            ),
          ),
        );
      },
      home: const SplashScreen(),
    );
  }
}
