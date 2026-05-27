import 'package:logger/logger.dart';

/// Scoped logging wrapper. Use this instead of `print()`.
///
/// NEVER pass passwords or auth tokens to these methods.
class AppLogger {
  AppLogger(this._scope);

  final String _scope;

  static final Logger _logger = Logger(
    printer: PrettyPrinter(
      methodCount: 0,
      errorMethodCount: 5,
      lineLength: 80,
      colors: true,
      printEmojis: true,
      dateTimeFormat: DateTimeFormat.onlyTimeAndSinceStart,
    ),
  );

  void d(String message) => _logger.d('[$_scope] $message');
  void i(String message) => _logger.i('[$_scope] $message');
  void w(String message) => _logger.w('[$_scope] $message');
  void e(String message, [Object? error, StackTrace? stackTrace]) =>
      _logger.e('[$_scope] $message', error: error, stackTrace: stackTrace);
}
