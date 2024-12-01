import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:raskop_fe_backoffice/res/strings.dart';
import 'package:raskop_fe_backoffice/src/common/error_screen.dart';
import 'package:raskop_fe_backoffice/src/common/home_screen.dart';

/// MAIN ROUTER
final router = GoRouter(
  routes: [
    // Masih route template, nanti setelah bagi-bagi tiket kita ganti okeh!
    GoRoute(
      path: '/${MyHomePage.route}',
      name: MyHomePage.route,
      builder: (context, state) => const MyHomePage(title: AppStrings.appName),
    ),
  ],
  redirect: (context, state) {
    return '/${MyHomePage.route}';
  },
  observers: [
    routeObserver,
  ],
  debugLogDiagnostics: true,
  errorBuilder: (context, state) =>
      const ErrorScreen(message: FailureMessages.somethingWentWrong),
);

/// Route observer to use with RouteAware
final RouteObserver<ModalRoute<void>> routeObserver =
    RouteObserver<ModalRoute<void>>();
