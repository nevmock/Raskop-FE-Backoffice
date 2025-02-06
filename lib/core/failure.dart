// UNUSED-CODE
// SAFE TO DELETE?

/// Failure Class for returning error in development
class Failure implements Exception {
  /// Failure Constructor
  Failure({required this.message, this.stackTrace = StackTrace.empty});

  /// Failure Messages
  final String message;

  /// Stacktrace variable
  final StackTrace stackTrace;
}
