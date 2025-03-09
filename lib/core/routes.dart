import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:raskop_fe_backoffice/res/strings.dart';
import 'package:raskop_fe_backoffice/src/common/error_screen.dart';
import 'package:raskop_fe_backoffice/src/common/home_screen.dart';
import 'package:raskop_fe_backoffice/src/dashboard/presentation/screens/dashboard_screen.dart';
import 'package:raskop_fe_backoffice/src/menu/presentation/screens/menu_screen.dart';
import 'package:raskop_fe_backoffice/src/order/presentation/screens/order_screen.dart';
import 'package:raskop_fe_backoffice/src/order/presentation/screens/webview_payment_screen.dart';
import 'package:raskop_fe_backoffice/src/reservation/presentation/screens/reservation_screen.dart';
import 'package:raskop_fe_backoffice/src/supplier/presentation/screens/supplier_screen.dart';
import 'package:raskop_fe_backoffice/src/table/presentation/screens/table_screen.dart';

final _rootNavigatorKey = GlobalKey<NavigatorState>(debugLabel: 'root');

/// MAIN ROUTER
final router = GoRouter(
  navigatorKey: _rootNavigatorKey,
  initialLocation: '/${DashboardScreen.route}',
  routes: [
    StatefulShellRoute.indexedStack(
      builder: (context, state, navigationShell) => HomeScreen(
        navigationShell: navigationShell,
      ),
      branches: [
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: '/${DashboardScreen.route}',
              name: DashboardScreen.route,
              builder: (context, state) => const DashboardScreen(),
            ),
          ],
        ),
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: '/${OrderScreen.route}',
              name: OrderScreen.route,
              builder: (context, state) => const OrderScreen(),
              routes: [
                GoRoute(
                  path: WebviewPaymentScreen.route,
                  name: WebviewPaymentScreen.route,
                  builder: (context, state) => WebviewPaymentScreen(
                    redirectUrl: state.extra! as String,
                  ),
                ),
              ],
            ),
          ],
        ),
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: '/${MenuScreen.route}',
              name: MenuScreen.route,
              builder: (context, state) => const MenuScreen(),
            ),
          ],
        ),
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: '/${ReservationScreen.route}',
              name: ReservationScreen.route,
              builder: (context, state) => const ReservationScreen(),
              routes: [
                GoRoute(
                  path: WebviewPaymentScreen.route,
                  name: '${WebviewPaymentScreen.route}-reserve',
                  builder: (context, state) => WebviewPaymentScreen(
                    redirectUrl: state.extra! as String,
                  ),
                ),
              ],
            ),
          ],
        ),
        StatefulShellBranch(
          routes: [
            GoRoute(
              // path: '/${TableScreen.route}',
              // name: TableScreen.route,
              path: '/table',
              name: 'table',
              builder: (context, state) => const TableScreen(),
            ),
          ],
        ),
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: '/${SupplierScreen.route}',
              name: SupplierScreen.route,
              builder: (context, state) => const SupplierScreen(),
            ),
          ],
        ),
      ],
    ),
  ],
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
