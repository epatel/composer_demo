import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:flutter_composer/composer/composer.dart';
import 'package:flutter_composer/data/initilizers.dart';
import 'package:flutter_composer/data/extensions.dart';

void main() {
  group('Composer Widget Tests', () {
    late Composer composer;

    setUp(() {
      composer = Composer();
    });
    testWidgets('should recall widget with explicit context', (tester) async {
      composer.define('greeting', (context) {
        return Text('Hello ${context.name ?? "World"}');
      });

      final testContext = Context()..setName('Flutter');

      await tester.pumpWidget(
        Provider<Composer>.value(
          value: composer,
          child: MaterialApp(
            home: Scaffold(
              body: composer.recall('greeting', context: testContext),
            ),
          ),
        ),
      );

      expect(find.text('Hello Flutter'), findsOneWidget);
    });

    testWidgets('should recall widget from Provider context', (tester) async {
      composer.define('info', (context) {
        return Text('Title: ${context.title ?? "No title"}');
      });

      final testContext = Context()..setTitle('Test Title');

      await tester.pumpWidget(
        Provider<Composer>.value(
          value: composer,
          child: MaterialApp(
            home: Scaffold(
              body: ProvideContext(
                context: testContext,
                child: composer.recall('info'),
              ),
            ),
          ),
        ),
      );

      expect(find.text('Title: Test Title'), findsOneWidget);
    });

    testWidgets('should support nested contexts', (tester) async {
      composer.define('display', (context) {
        return Text('${context.name} - ${context.title}');
      });

      final parent = Context()..setName('Parent Name');
      final child = Context(parent: parent)..setTitle('Child Title');

      await tester.pumpWidget(
        Provider<Composer>.value(
          value: composer,
          child: MaterialApp(
            home: Scaffold(
              body: composer.recall('display', context: child),
            ),
          ),
        ),
      );

      expect(find.text('Parent Name - Child Title'), findsOneWidget);
    });

    testWidgets('should use composer extensions', (tester) async {
      composer.define('greeting', (context) {
        return Text('Hello ${context.name}');
      });

      final testContext = Context()..setName('Test');

      await tester.pumpWidget(
        Provider<Composer>.value(
          value: composer,
          child: MaterialApp(
            home: Scaffold(
              body: ProvideContext(
                context: testContext,
                child: composer.greeting(),
              ),
            ),
          ),
        ),
      );

      expect(find.text('Hello Test'), findsOneWidget);
    });

    testWidgets('should compose widgets that recall other widgets', (
      tester,
    ) async {
      composer.define('text', (context) {
        return Text(context.text ?? '<Missing text>');
      });

      composer.define('card', (context) {
        return Card(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: composer.recall(
              'text',
              context: Context()..setText('Card Content'),
            ),
          ),
        );
      });

      await tester.pumpWidget(
        Provider<Composer>.value(
          value: composer,
          child: MaterialApp(
            home: Scaffold(
              body: composer.recall('card', context: Context()),
            ),
          ),
        ),
      );

      expect(find.text('Card Content'), findsOneWidget);
      expect(find.byType(Card), findsOneWidget);
    });

    testWidgets('should work with context sizes and colors', (tester) async {
      composer.define('styled', (context) {
        return Text(
          'Styled Text',
          style: TextStyle(
            color: context.colors.primary,
            fontSize: context.sizes.lg,
          ),
        );
      });

      await tester.pumpWidget(
        Provider<Composer>.value(
          value: composer,
          child: MaterialApp(
            home: Scaffold(
              body: composer.recall('styled', context: Context()),
            ),
          ),
        ),
      );

      expect(find.text('Styled Text'), findsOneWidget);
    });

    testWidgets('should update when context changes', (tester) async {
      composer.define('counter', (context) {
        return Text('Count: ${context.count ?? 0}');
      });

      final testContext = Context()..setCount(0);

      await tester.pumpWidget(
        Provider<Composer>.value(
          value: composer,
          child: MaterialApp(
            home: Scaffold(
              body: ProvideContext(
                context: testContext,
                child: Consumer<Context>(
                  builder: (context, ctx, child) {
                    return Text('Count: ${ctx.count ?? 0}');
                  },
                ),
              ),
            ),
          ),
        ),
      );

      expect(find.text('Count: 0'), findsOneWidget);

      testContext.setCount(5);
      testContext.notifyListeners();
      await tester.pump();

      expect(find.text('Count: 5'), findsOneWidget);
    });

    testWidgets('ProvideContext should provide context to descendants', (
      tester,
    ) async {
      final testContext = Context()..setName('Provided Name');

      await tester.pumpWidget(
        Provider<Composer>.value(
          value: composer,
          child: MaterialApp(
            home: Scaffold(
              body: ProvideContext(
                context: testContext,
                child: Builder(
                  builder: (buildContext) {
                    final ctx = buildContext.read<Context>();
                    return Text(ctx.name ?? 'No name');
                  },
                ),
              ),
            ),
          ),
        ),
      );

      expect(find.text('Provided Name'), findsOneWidget);
    });

    testWidgets('should handle missing context gracefully', (tester) async {
      composer.define('safe', (context) {
        return Text(context.name ?? 'Default Value');
      });

      await tester.pumpWidget(
        Provider<Composer>.value(
          value: composer,
          child: MaterialApp(
            home: Scaffold(
              body: composer.recall('safe', context: Context()),
            ),
          ),
        ),
      );

      expect(find.text('Default Value'), findsOneWidget);
    });
  });

  group('Initializer Tests', () {
    late Composer composer;

    setUp(() {
      composer = Composer();
      initializeComposer(composer);
    });

    testWidgets('initialized widgets should work', (tester) async {
      final testContext = Context()
        ..setName('Flutter')
        ..setTitle('Composer');

      await tester.pumpWidget(
        Provider<Composer>.value(
          value: composer,
          child: MaterialApp(
            home: Scaffold(
              body: ProvideContext(
                context: testContext,
                child: Column(
                  children: [
                    composer.greeting(),
                    composer.info(),
                    composer.recallSpacing(),
                  ],
                ),
              ),
            ),
          ),
        ),
      );

      expect(find.textContaining('Hello'), findsOneWidget);
      expect(find.textContaining('Title'), findsOneWidget);
      expect(find.byType(SizedBox), findsOneWidget);
    });

    testWidgets('recallText should work with custom text', (tester) async {
      await tester.pumpWidget(
        Provider<Composer>.value(
          value: composer,
          child: MaterialApp(
            home: Scaffold(
              body: ProvideContext(
                context: Context(),
                child: composer.recallText('Custom Text'),
              ),
            ),
          ),
        ),
      );

      expect(find.text('Custom Text'), findsOneWidget);
    });
  });
}
