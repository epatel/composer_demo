import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';
import 'context.dart';

typedef WidgetBuilder = Widget Function(Context context);

class Composer {
  static Composer _instance = Composer._internal();

  factory Composer() => _instance;

  Composer._internal();

  final Map<String, WidgetBuilder> _definitions = {};

  void define(String name, WidgetBuilder builder) {
    _definitions[name] = builder;
  }

  Widget recall(String name, {Context? context}) {
    final builder = _definitions[name];
    if (builder == null) {
      throw ArgumentError('No widget defined with name: $name');
    }
    return Builder(
      builder: (buildContext) =>
          builder(context ?? buildContext.read<Context>()),
    );
  }

  bool isDefined(String name) => _definitions.containsKey(name);

  void undefine(String name) {
    _definitions.remove(name);
  }

  void clear() {
    _definitions.clear();
  }

  List<String> get definedNames => List.unmodifiable(_definitions.keys);

  @visibleForTesting
  static void resetForTest() {
    _instance = Composer._internal();
  }
}

final Composer composer = Composer();
