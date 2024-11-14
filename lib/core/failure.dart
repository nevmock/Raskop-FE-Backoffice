/// Failure Class
class Failure {
  /// Failure Constructor
  Failure({required this.message, this.stackTrace = StackTrace.empty});

  /// Failure Messages
  final String message;

  /// Stacktrace variable
  final StackTrace stackTrace;
}
