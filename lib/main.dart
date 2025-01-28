// ignore_for_file: avoid_redundant_argument_values

import 'package:device_preview_plus/device_preview_plus.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:raskop_fe_backoffice/core/app.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(
    DevicePreview(
      enabled: kDebugMode,
      builder: (ctx) => const ProviderScope(child: RasKopBackOfficeApp()),
    ),
  );
}
