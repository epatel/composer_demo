import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_composer/composer/composer.dart';

void main() {
  setUp(() {
    Composer.resetForTest();
  });

  group('Composer', () {
    test('should be a singleton', () {
      final instance1 = Composer();
      final instance2 = Composer();
      expect(identical(instance1, instance2), true);
    });

    test('should define and check if widget is defined', () {
      composer.define('test', (context) => const Text('test'));
      expect(composer.isDefined('test'), true);
      expect(composer.isDefined('nonexistent'), false);
    });

    test('should undefine a widget', () {
      composer.define('test', (context) => const Text('test'));
      expect(composer.isDefined('test'), true);

      composer.undefine('test');
      expect(composer.isDefined('test'), false);
    });

    test('should clear all definitions', () {
      composer.define('test1', (context) => const Text('test1'));
      composer.define('test2', (context) => const Text('test2'));
      expect(composer.definedNames.length, 2);

      composer.clear();
      expect(composer.definedNames.length, 0);
    });

    test('should list all defined names', () {
      composer.define('widget1', (context) => const Text('1'));
      composer.define('widget2', (context) => const Text('2'));

      final names = composer.definedNames;
      expect(names, contains('widget1'));
      expect(names, contains('widget2'));
      expect(names.length, 2);
    });

    test('should return immutable list of defined names', () {
      composer.define('test', (context) => const Text('test'));
      final names = composer.definedNames;

      expect(() => names.add('new'), throwsUnsupportedError);
    });

    test('should throw ArgumentError when recalling undefined widget', () {
      expect(
        () => composer.recall('undefined', context: Context()),
        throwsArgumentError,
      );
    });

    test('resetForTest should create fresh instance', () {
      final comp = Composer();
      comp.define('test', (context) => const Text('test'));
      expect(comp.isDefined('test'), true);

      Composer.resetForTest();
      final freshComp = Composer();
      expect(freshComp.isDefined('test'), false);
    });
  });

  group('Composer isolation', () {
    test('tests should not interfere with each other - test 1', () {
      final comp = Composer();
      comp.define('isolated1', (context) => const Text('1'));
      expect(comp.isDefined('isolated1'), true);
    });

    test('tests should not interfere with each other - test 2', () {
      final comp = Composer();
      expect(comp.isDefined('isolated1'), false);
      comp.define('isolated2', (context) => const Text('2'));
      expect(comp.isDefined('isolated2'), true);
    });
  });
}
