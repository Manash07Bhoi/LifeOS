import 'dart:developer' as developer;

class SecurityLogger {
  /// Logs a security-related error with an optional message and stack trace.
  /// Uses [developer.log] to ensure logs are handled securely in production
  /// environments while remaining accessible for debugging.
  static void logError(
    Object error, {
    StackTrace? stackTrace,
    String? message,
  }) {
    developer.log(
      message ?? 'Security error occurred',
      error: error,
      stackTrace: stackTrace,
      name: 'lifeos.security',
      level: 1000, // Severe
    );
  }

  /// Logs a security-related event.
  static void logEvent(String message) {
    developer.log(
      message,
      name: 'lifeos.security',
      level: 800, // Info
    );
  }
}
