import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';

/// CacheForExtension, combined with controller
extension CacheForExtension on Ref {
  /// Keeps the provider alive for [duration].
  void cacheFor(Duration duration) {
    // Immediately prevent the state from getting destroyed.
    final link = keepAlive();
    // After duration has elapsed, we re-enable automatic disposal.
    final timer = Timer(duration, link.close);

    onDispose(timer.cancel);
  }
}
