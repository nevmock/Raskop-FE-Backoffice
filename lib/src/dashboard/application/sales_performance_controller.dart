import 'package:intl/intl.dart';
import 'package:raskop_fe_backoffice/src/dashboard/dashboard_provider.dart';
import 'package:raskop_fe_backoffice/src/dashboard/domain/entities/sales_performance_entity.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'sales_performance_controller.g.dart';

@riverpod

///
class SalesPerformanceController extends _$SalesPerformanceController {
  @override
  FutureOr<List<SalesPerformanceEntity>> build() async {
    final startDate = DateFormat('yyyy-MM-dd').format(DateTime.now());
    final endDate = DateFormat('yyyy-MM-dd').format(DateTime.now());

    return getSalesPerformance(startDate, endDate);
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
