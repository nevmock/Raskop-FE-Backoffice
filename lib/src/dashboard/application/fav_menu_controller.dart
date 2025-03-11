import 'dart:developer';

import 'package:intl/intl.dart';
import 'package:raskop_fe_backoffice/src/dashboard/dashboard_provider.dart';
import 'package:raskop_fe_backoffice/src/dashboard/domain/entities/fav_menu_entity.dart';
// ignore: unused_import
import 'package:raskop_fe_backoffice/src/dashboard/domain/entities/sales_performance_entity.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'fav_menu_controller.g.dart';

@riverpod

///
class FavMenuController extends _$FavMenuController {
  @override
  FutureOr<List<FavMenuEntity>> build() async {
    final startDate = DateFormat('yyyy-MM-dd').format(DateTime.now());
    final endDate = DateFormat('yyyy-MM-dd').format(DateTime.now());

    return getFavouriteMenus(startDate, endDate);
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
        log('dataFold: $r');
        return r;
      },
    );
  }

  ///
  // Future<List<dynamic>> getSalesPerformance(
  //   String start,
  //   String end,
  // ) async {
  //   state = const AsyncValue.loading();
  //   final res = await ref
  //       .read(dashboardRepositoryProvider)
  //       .getSalesPerformance(start: start, end: end);

  //   return res.fold(
  //     (l) {
  //       state = AsyncValue.error(l, StackTrace.current);
  //       throw l;
  //     },
  //     (r) {
  //       state = AsyncValue.data(r);
  //       return r;
  //     },
  //   );
  // }
}
