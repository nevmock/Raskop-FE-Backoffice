import 'package:intl/intl.dart';
import 'package:raskop_fe_backoffice/shared/extension/cache_extension.dart';
import 'package:raskop_fe_backoffice/src/dashboard/dashboard_provider.dart';
import 'package:raskop_fe_backoffice/src/dashboard/domain/entities/fav_menu_entity.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'dashboard_controller.g.dart';

@riverpod

///
class DashboardController extends _$DashboardController {
  @override

  // auto build widget when calling the controller
  FutureOr<List<FavMenuEntity>> build() async {
    ref.cacheFor(const Duration(minutes: 10));
    return getFavouriteMenus(
      DateFormat('yyyy-MM-dd').format(DateTime.now()),
      DateFormat('yyyy-MM-dd').format(DateTime.now()),
    );
  }

  /// 🛠️ Function untuk Fetch Data dengan Filter
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
}
