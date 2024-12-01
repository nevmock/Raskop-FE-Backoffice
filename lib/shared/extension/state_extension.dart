// ignore_for_file: inference_failure_on_function_return_type, public_member_api_docs

import 'package:flutter/material.dart';

extension XState on State {
  void safeRebuild(Function() fn) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      fn();
    });
  }
}
