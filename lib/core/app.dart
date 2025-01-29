// ignore_for_file: deprecated_member_use

import 'package:device_preview_plus/device_preview_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:raskop_fe_backoffice/core/core.dart';
import 'package:raskop_fe_backoffice/res/strings.dart';

/// RasKop BackOffice App
class RasKopBackOfficeApp extends StatelessWidget {
  /// RasKop BackOffice Key Constructor
  const RasKopBackOfficeApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    final view = WidgetsBinding.instance.platformDispatcher.views.first;
    return ScreenUtilInit(
      designSize:
          Size(1194 / view.devicePixelRatio, 834 / view.devicePixelRatio),
      minTextAdapt: true,
      splitScreenMode: true,
      ensureScreenSize: true,
      useInheritedMediaQuery: true,
      enableScaleWH: () => false,
      // enableScaleText: () => false,
      builder: (context, child) => MaterialApp.router(
        useInheritedMediaQuery: true,
        builder: DevicePreview.appBuilder,
        locale: DevicePreview.locale(context),
        theme: ThemeData(
          fontFamily: 'Inter',
          visualDensity: VisualDensity.adaptivePlatformDensity,
          useMaterial3: true,
        ),
        title: AppStrings.appName,
        routeInformationParser: router.routeInformationParser,
        routerDelegate: router.routerDelegate,
        routeInformationProvider: router.routeInformationProvider,
      ),
    );
  }
}
