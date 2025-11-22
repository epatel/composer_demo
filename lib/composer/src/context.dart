import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';

class _TypedValue<T> {
  final T value;
  const _TypedValue(this.value);
}

/// Error thrown when attempting to retrieve a value from Context with a type
/// that doesn't match the stored value's type.
class ContextTypeMismatchError extends Error {
  /// The key that was accessed
  final String key;
  
  /// The type that was expected (requested by the caller)
  final Type expectedType;
  
  /// The actual type of the stored value
  final Type actualType;

  ContextTypeMismatchError(this.key, this.expectedType, this.actualType);

  @override
  String toString() =>
      'ContextTypeMismatchError: Type mismatch for key "$key": '
      'expected $expectedType but got $actualType';
}

class Context extends ChangeNotifier {
  final Context? parent;
  final Map<String, _TypedValue> _data;

  Context({Map<String, dynamic>? data, this.parent})
    : _data =
          data?.map((key, value) => MapEntry(key, _TypedValue(value))) ?? {};

  Context.empty() : _data = {}, parent = null;

  dynamic operator [](String key) {
    final value = _data[key];
    if (value != null) return value.value;
    return parent?[key];
  }

  void operator []=(String key, dynamic value) {
    _data[key] = _TypedValue(value);
    notifyListeners();
  }

  T? get<T>(String key) {
    final value = _data[key];
    if (value != null) {
      final unwrapped = value.value;
      if (unwrapped is! T && unwrapped != null) {
        throw ContextTypeMismatchError(key, T, unwrapped.runtimeType);
      }
      return unwrapped as T?;
    }
    return parent?.get<T>(key);
  }

  bool get isEmpty => _data.isEmpty;
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
