import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_composer/composer/composer.dart';

void main() {
  setUp(() {
    Composer.resetForTest();
    initializeComposer();
  });

  group('Golden Tests - Text Widget', () {
    testWidgets('text widget with default styling', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          theme: ThemeData(fontFamily: 'Roboto'),
          home: Scaffold(
            body: Center(
              child: ProvideContext(
                context: Context()..setText('Hello Golden Test'),
                child: composer.recallText('Hello Golden Test'),
              ),
            ),
          ),
        ),
      );

      await expectLater(
        find.byType(Scaffold),
        matchesGoldenFile('goldens/text_default.png'),
      );
    });

    testWidgets('text widget with custom colors', (tester) async {
      final customColors = ContextColors()
        ..primary = Colors.red
        ..secondary = Colors.green
        ..accent = Colors.blue;

      await tester.pumpWidget(
        MaterialApp(
          theme: ThemeData(fontFamily: 'Roboto'),
          home: Scaffold(
            body: Center(
              child: ProvideContext(
                context: Context()
                  ..setText('Colored Text')
                  ..setColors(customColors),
                child: composer.recallText('Colored Text'),
              ),
            ),
          ),
        ),
      );

      await expectLater(
        find.byType(Scaffold),
        matchesGoldenFile('goldens/text_custom_colors.png'),
      );
    });
  });

  group('Golden Tests - Greeting Widget', () {
    testWidgets('greeting widget with name', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          theme: ThemeData(fontFamily: 'Roboto'),
          home: Scaffold(
            body: Center(
              child: ProvideContext(
                context: Context()..setName('Flutter'),
                child: composer.greeting(),
              ),
            ),
          ),
        ),
      );

      await expectLater(
        find.byType(Scaffold),
        matchesGoldenFile('goldens/greeting_with_name.png'),
      );
    });

    testWidgets('greeting widget without name', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          theme: ThemeData(fontFamily: 'Roboto'),
          home: Scaffold(
            body: Center(
              child: ProvideContext(
                context: Context(),
                child: composer.greeting(),
              ),
            ),
          ),
        ),
      );

      await expectLater(
        find.byType(Scaffold),
        matchesGoldenFile('goldens/greeting_without_name.png'),
      );
    });
  });

  group('Golden Tests - Info Widget', () {
    testWidgets('info widget with title', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          theme: ThemeData(fontFamily: 'Roboto'),
          home: Scaffold(
            body: Center(
              child: ProvideContext(
                context: Context()..setTitle('Composer Pattern'),
                child: composer.info(),
              ),
            ),
          ),
        ),
      );

      await expectLater(
        find.byType(Scaffold),
        matchesGoldenFile('goldens/info_with_title.png'),
      );
    });
  });

  group('Golden Tests - Full Composition', () {
    testWidgets('full composition with all widgets', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          theme: ThemeData(fontFamily: 'Roboto'),
          home: Scaffold(
            body: Center(
              child: ProvideContext(
                context: Context()
                  ..setName('Flutter Developer')
                  ..setTitle('Golden Test Example'),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    composer.greeting(),
                    composer.recallSpacing(),
                    composer.info(),
                    composer.recallSpacing(),
                    composer.recallText('Additional text'),
                  ],
                ),
              ),
            ),
          ),
        ),
      );

      await expectLater(
        find.byType(Scaffold),
        matchesGoldenFile('goldens/full_composition.png'),
      );
    });

    testWidgets('theme-styled composition', (tester) async {
      final customColors = ContextColors()
        ..primary = Colors.purple
        ..secondary = Colors.orange
        ..accent = Colors.teal;

      final customSizes = ContextSizes()
        ..sm = 6.0
        ..md = 20.0
        ..lg = 36.0;

      await tester.pumpWidget(
        MaterialApp(
          theme: ThemeData(fontFamily: 'Roboto'),
          home: Scaffold(
            backgroundColor: Colors.grey[100],
            body: Center(
              child: ProvideContext(
                context: Context()
                  ..setName('Styled User')
                  ..setTitle('Custom Theme')
                  ..setColors(customColors)
                  ..setSizes(customSizes),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    composer.greeting(),
                    composer.recallSpacing(),
                    composer.info(),
                  ],
                ),
              ),
            ),
          ),
        ),
      );

      await expectLater(
        find.byType(Scaffold),
        matchesGoldenFile('goldens/theme_styled.png'),
      );
    });
  });
}
