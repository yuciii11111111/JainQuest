import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:jainquest/features/splash/presentation/splash_screen.dart';
import 'package:jainquest/main.dart';

void main() {
  testWidgets('JainQuest app boots into the splash screen', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(
      const ProviderScope(
        child: JainQuestApp(),
      ),
    );
    await tester.pump();

    expect(find.byType(JainQuestApp), findsOneWidget);
    expect(find.byType(SplashScreen), findsOneWidget);
    expect(find.byKey(const ValueKey('splash-next')), findsOneWidget);
  });
}
