import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_composer/composer/composer.dart';

void main() {
  group('Composer', () {
    test('should define and check if widget is defined', () {
      final composer = Composer();
      composer.define('test', (context) => const Text('test'));
      expect(composer.isDefined('test'), true);
      expect(composer.isDefined('nonexistent'), false);
    });

    test('should undefine a widget', () {
      final composer = Composer();
      composer.define('test', (context) => const Text('test'));
      expect(composer.isDefined('test'), true);

      composer.undefine('test');
      expect(composer.isDefined('test'), false);
    });

    test('should clear all definitions', () {
      final composer = Composer();
      composer.define('test1', (context) => const Text('test1'));
      composer.define('test2', (context) => const Text('test2'));
      expect(composer.definedNames.length, 2);

      composer.clear();
      expect(composer.definedNames.length, 0);
    });

    test('should list all defined names', () {
      final composer = Composer();
      composer.define('widget1', (context) => const Text('1'));
      composer.define('widget2', (context) => const Text('2'));

      final names = composer.definedNames;
      expect(names, contains('widget1'));
      expect(names, contains('widget2'));
      expect(names.length, 2);
    });

    test('should return immutable list of defined names', () {
      final composer = Composer();
      composer.define('test', (context) => const Text('test'));
      final names = composer.definedNames;

      expect(() => names.add('new'), throwsUnsupportedError);
    });

    test('should throw ArgumentError when recalling undefined widget', () {
      final composer = Composer();
      expect(
        () => composer.recall('undefined', context: Context()),
        throwsArgumentError,
      );
    });
  });

  group('Composer isolation', () {
    test('tests should not interfere with each other - test 1', () {
      final composer = Composer();
      composer.define('isolated1', (context) => const Text('1'));
      expect(composer.isDefined('isolated1'), true);
    });

    test('tests should not interfere with each other - test 2', () {
      final composer = Composer();
      expect(composer.isDefined('isolated1'), false);
      composer.define('isolated2', (context) => const Text('2'));
      expect(composer.isDefined('isolated2'), true);
    });
  });
}
