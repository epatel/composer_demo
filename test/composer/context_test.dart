import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_composer/composer/composer.dart';

void main() {
  group('Context', () {
    test('should create empty context', () {
      final context = Context.empty();
      expect(context.isEmpty, true);
      expect(context.parent, null);
    });

    test('should create context with data', () {
      final context = Context(data: {'key': 'value'});
      expect(context['key'], 'value');
    });

    test('should get and set values using operators', () {
      final context = Context();
      context['name'] = 'Flutter';
      expect(context['name'], 'Flutter');
    });

    test('should get typed values', () {
      final context = Context(
        data: {
          'name': 'Flutter',
          'count': 42,
          'isActive': true,
        },
      );

      expect(context.get<String>('name'), 'Flutter');
      expect(context.get<int>('count'), 42);
      expect(context.get<bool>('isActive'), true);
    });

    test('should return null for missing keys', () {
      final context = Context();
      expect(context['missing'], null);
      expect(context.get<String>('missing'), null);
    });

    test('should support parent context', () {
      final parent = Context(data: {'inherited': 'from parent'});
      final child = Context(data: {'own': 'value'}, parent: parent);

      expect(child['own'], 'value');
      expect(child['inherited'], 'from parent');
    });

    test('child values should override parent values', () {
      final parent = Context(data: {'key': 'parent value'});
      final child = Context(data: {'key': 'child value'}, parent: parent);

      expect(child['key'], 'child value');
    });

    test('should throw ContextTypeMismatchError when getting wrong type', () {
      final context = Context();
      context['name'] = 'Flutter';

      expect(() => context.get<int>('name'), 
        throwsA(isA<ContextTypeMismatchError>()));
    });

    test('should allow correct type retrieval', () {
      final context = Context();
      context['name'] = 'Flutter';
      context['count'] = 42;

      expect(context.get<String>('name'), 'Flutter');
      expect(context.get<int>('count'), 42);
    });

    test('should handle type checking with parent context', () {
      final parent = Context(data: {'parentValue': 'text'});
      final child = Context(parent: parent);

      expect(child.get<String>('parentValue'), 'text');
      expect(() => child.get<int>('parentValue'), 
        throwsA(isA<ContextTypeMismatchError>()));
    });

    test('should provide helpful error message on type mismatch', () {
      final context = Context();
      context['name'] = 'Flutter';

      try {
        context.get<int>('name');
        fail('Should have thrown ContextTypeMismatchError');
      } catch (e) {
        expect(e, isA<ContextTypeMismatchError>());
        final error = e as ContextTypeMismatchError;
        expect(error.key, 'name');
        expect(error.expectedType, int);
        expect(error.actualType, String);
        expect(error.toString(), 
          contains('Type mismatch for key "name"'));
        expect(error.toString(), contains('expected int'));
        expect(error.toString(), contains('but got String'));
      }
    });
  });

  group('Context Extensions', () {
    test('should set and get name', () {
      final context = Context();
      context.setName('Flutter');
      expect(context.name, 'Flutter');
    });

    test('should set and get title', () {
      final context = Context();
      context.setTitle('My Title');
      expect(context.title, 'My Title');
    });

    test('should set and get count', () {
      final context = Context();
      context.setCount(42);
      expect(context.count, 42);
    });

    test('should set and get isActive', () {
      final context = Context();
      context.setIsActive(true);
      expect(context.isActive, true);
    });

    test('should set and get text', () {
      final context = Context();
      context.setText('Hello World');
      expect(context.text, 'Hello World');
    });

    test('should set multiple values with setData', () {
      final context = Context();
      context.setData({'name': 'Flutter', 'count': 10});

      expect(context.name, 'Flutter');
      expect(context.count, 10);
    });

    test('should return default sizes when not set', () {
      final context = Context();
      final sizes = context.sizes;

      expect(sizes.sm, 8.0);
      expect(sizes.md, 16.0);
      expect(sizes.lg, 32.0);
    });

    test('should return default colors when not set', () {
      final context = Context();
      final colors = context.colors;

      expect(colors.primary, isNotNull);
      expect(colors.secondary, isNotNull);
      expect(colors.accent, isNotNull);
    });

    test('should support chaining setters', () {
      final context = Context()
        ..setName('Flutter')
        ..setTitle('Title')
        ..setCount(5);

      expect(context.name, 'Flutter');
      expect(context.title, 'Title');
      expect(context.count, 5);
    });
  });
}
