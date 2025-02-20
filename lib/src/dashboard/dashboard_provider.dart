import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;
import 'package:raskop_fe_backoffice/core/client.dart';
import 'package:raskop_fe_backoffice/res/paths.dart';
import 'package:raskop_fe_backoffice/src/dashboard/repositories/dashboard_repository.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'dashboard_provider.g.dart';

@riverpod

///
DashboardRepository dashboardRepository(Ref ref) {
  final client = http.Client();
  final baseClient = ref.watch(
    apiClientProvider(
      baseUrl: BasePaths.baseAPIDashboardURL,
    ),
  );
  return DashboardRepository(client: client, baseClient: baseClient);
}
