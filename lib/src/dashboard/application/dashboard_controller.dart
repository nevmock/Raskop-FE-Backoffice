import 'package:intl/intl.dart';
import 'package:raskop_fe_backoffice/shared/extension/cache_extension.dart';
import 'package:raskop_fe_backoffice/src/dashboard/dashboard_provider.dart';
import 'package:raskop_fe_backoffice/src/dashboard/domain/entities/fav_menu_entity.dart';
import 'package:raskop_fe_backoffice/src/dashboard/domain/entities/sales_performance_entity.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'dashboard_controller.g.dart';

@riverpod

///
class DashboardController extends _$DashboardController {
  @override
  FutureOr<List<dynamic>> build([String? startDate, String? endDate]) async {
    ref.cacheFor(const Duration(minutes: 10));

    startDate = DateFormat('yyyy-MM-dd').format(DateTime.now());
    endDate = DateFormat('yyyy-MM-dd').format(DateTime.now());

    final results = await Future.wait([
      getFavouriteMenus(startDate, endDate),
      getSalesPerformance(startDate, endDate),
    ]);

    return results;
  }

  ///
  Future<List<FavMenuEntity>> getFavouriteMenus(
    String start,
    String end,
  ) async {
    state = const AsyncValue.loading();
    final res = await ref
        .read(dashboardRepositoryProvider)
        .getFavouriteMenus(start: start, end: end);

    return res.fold(
      (l) {
        state = AsyncValue.error(l, StackTrace.current);
        throw l;
      },
      (r) {
        state = AsyncValue.data(r);
        return r;
      },
    );
  }

  ///
  Future<List<SalesPerformanceEntity>> getSalesPerformance(
    String start,
    String end,
  ) async {
    state = const AsyncValue.loading();
    final res = await ref
        .read(dashboardRepositoryProvider)
        .getSalesPerformance(start: start, end: end);

    return res.fold(
      (l) {
        state = AsyncValue.error(l, StackTrace.current);
        throw l;
      },
      (r) {
        state = AsyncValue.data(r);
        return r;
      },
    );
  }
}
