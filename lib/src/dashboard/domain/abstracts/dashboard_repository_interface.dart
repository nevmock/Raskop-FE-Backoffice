import 'package:raskop_fe_backoffice/core/type_def.dart';
import 'package:raskop_fe_backoffice/src/dashboard/domain/entities/fav_menu_entity.dart';

///
abstract class DashboardRepositoryInterface {
  ///
  FutureEither<List<FavMenuEntity>> getFavouriteMenus({
    required String start,
    required String end,
  });

  ///
  FutureEither<List<Map<String, dynamic>>> getSalesPerformance({
    required String start,
    required String end,
  });
}
