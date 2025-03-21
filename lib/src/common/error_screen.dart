import 'package:flutter/material.dart';

/// Default error page
class ErrorScreen extends StatelessWidget {
  /// Default constructor for the [ErrorScreen]
  const ErrorScreen({required this.message, super.key});

  /// Error message displayed on the [ErrorScreen]
  final String message;

  @override
  Widget build(BuildContext context) {
    // TODO(Someone): let's stylize it at some point.
    return Scaffold(
      body: Center(child: Text(message)),
    );
  }
}
