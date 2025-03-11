import 'package:cherry_toast/cherry_toast.dart';
import 'package:cherry_toast/resources/arrays.dart';
import 'package:flutter/material.dart';

///
class Toast {
  ///
  void showSuccessToast({
    required BuildContext context,
    required String title,
    String description = '',
    Duration duration = const Duration(seconds: 5),
  }) {
    CherryToast.success(
      animationType: AnimationType.fromTop,
      title: Text(
        title,
        style: const TextStyle(
          fontWeight: FontWeight.bold,
        ),
      ),
      description: Text(
        description,
        style: const TextStyle(
          fontWeight: FontWeight.bold,
        ),
      ),
      animationCurve: Curves.easeInOut,
      toastDuration: duration,
    ).show(context);
  }

  ///
  void showErrorToast({
    required BuildContext context,
    required String title,
    String description = '',
  }) {
    CherryToast.error(
      animationType: AnimationType.fromTop,
      title: Text(
        title,
        style: const TextStyle(
          fontWeight: FontWeight.bold,
        ),
      ),
      description: Text(
        description,
        style: const TextStyle(
          fontWeight: FontWeight.bold,
        ),
      ),
      animationCurve: Curves.easeInOut,
      autoDismiss: false,
    ).show(context);
  }

  ///
  void showWarningToast({
    required BuildContext context,
    required String title,
    String description = '',
  }) {
    CherryToast.warning(
      animationType: AnimationType.fromTop,
      title: Text(
        title,
        style: const TextStyle(
          fontWeight: FontWeight.bold,
        ),
      ),
      description: Text(
        description,
        style: const TextStyle(
          fontWeight: FontWeight.bold,
        ),
      ),
      animationCurve: Curves.easeInOut,
      autoDismiss: false,
    ).show(context);
  }
}
