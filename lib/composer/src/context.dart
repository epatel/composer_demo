import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';

class Context extends ChangeNotifier {
  final Context? parent;
  final Map<String, dynamic> data;

  Context({Map<String, dynamic>? data, this.parent}) : data = data ?? {};

  Context.empty() : data = {}, parent = null;

  dynamic operator [](String key) => data[key] ?? parent?[key];

  void operator []=(String key, dynamic value) => data[key] = value;

  T? get<T>(String key) => data[key] as T? ?? parent?[key] as T?;
}

// ignore: non_constant_identifier_names
Widget ProvideContext({
  Key? key,
  required Context context,
  required Widget child,
}) => ChangeNotifierProvider.value(
  key: key,
  value: context,
  child: child,
);
