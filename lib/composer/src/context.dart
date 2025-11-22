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

/// Error thrown when transaction methods are called incorrectly.
class ContextTransactionError extends Error {
  /// The error message
  final String message;

  ContextTransactionError(this.message);

  @override
  String toString() => 'ContextTransactionError: $message';
}

class Context extends ChangeNotifier {
  final Context? parent;
  final Map<String, _TypedValue> _data;
  bool _inTransaction = false;

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
    if (!_inTransaction) {
      notifyListeners();
    }
  }

  /// Begins a transaction, deferring all notifications until [end] is called.
  ///
  /// This is useful when you need to update multiple values and want to avoid
  /// triggering multiple rebuilds. All updates between [begin] and [end] will
  /// only trigger a single notification.
  ///
  /// Example:
  /// ```dart
  /// context.begin();
  /// context['name'] = 'John';
  /// context['age'] = 30;
  /// context['city'] = 'NYC';
  /// context.end(); // Only one notification sent
  /// ```
  void begin() {
    _inTransaction = true;
  }

  /// Ends a transaction and notifies all listeners.
  ///
  /// This method must be called after [begin] to complete the transaction.
  /// Throws [ContextTransactionError] if called without a matching [begin].
  void end() {
    if (!_inTransaction) {
      throw ContextTransactionError('end() called without matching begin()');
    }
    _inTransaction = false;
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
