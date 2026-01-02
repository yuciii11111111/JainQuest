import 'dart:io';

import 'package:flutter/services.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:path_provider/path_provider.dart';

import 'core/theme/app_theme.dart';
import 'core/services/notification_service.dart';
import 'core/services/storage_service.dart';
import 'core/providers/theme_provider.dart';
import 'features/splash/presentation/splash_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Initialize Hive for local storage
  final appDir = await getApplicationSupportDirectory();
  final hiveDir = Directory('${appDir.path}${Platform.pathSeparator}hive_data');
  await hiveDir.create(recursive: true);
  await Hive.initFlutter(hiveDir.path);
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
          statusBarIconBrightness: themeMode == ThemeMode.dark 
              ? Brightness.light 
              : Brightness.dark,
          systemNavigationBarColor: Colors.transparent,
          systemNavigationBarIconBrightness: themeMode == ThemeMode.dark 
              ? Brightness.light 
              : Brightness.dark,
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
        final isDark = themeMode == ThemeMode.dark;
        return AnimatedContainer(
          duration: const Duration(milliseconds: 600),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: isDark
                  ? const [
                      Color(0xFF0B1226),
                      Color(0xFF1B1A3A),
                      Color(0xFF0B7285),
                    ]
                  : const [
                      Color(0xFFE3F2FD),
                      Color(0xFFE0E7FF),
                      Color(0xFFE0F7FA),
                    ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
          child: ShaderMask(
            shaderCallback: (rect) => LinearGradient(
              colors: isDark
                  ? const [Colors.white70, Colors.white24]
                  : const [Colors.white, Colors.white54],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ).createShader(rect),
            blendMode: BlendMode.softLight,
            child: child ?? const SizedBox.shrink(),
          ),
        );
      },
      home: const SplashScreen(),
    );
  }
}
