import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:raskop_fe_backoffice/res/strings.dart';
import 'package:raskop_fe_backoffice/src/common/error_screen.dart';
import 'package:raskop_fe_backoffice/src/common/home_screen.dart';

/// MAIN ROUTER
final router = GoRouter(
  routes: [
    GoRoute(
      path: '/${HomeScreen.route}',
      name: HomeScreen.route,
      builder: (context, state) => const HomeScreen(title: AppStrings.appName),
    ),
  ],
  initialLocation: '/${HomeScreen.route}',
  redirect: (context, state) {
    return '/${HomeScreen.route}';
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
