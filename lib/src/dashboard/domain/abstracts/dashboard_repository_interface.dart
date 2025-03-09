import 'package:raskop_fe_backoffice/core/type_def.dart';
import 'package:raskop_fe_backoffice/src/dashboard/domain/entities/fav_menu_entity.dart';
import 'package:raskop_fe_backoffice/src/dashboard/domain/entities/sales_performance_entity.dart';

///
abstract class DashboardRepositoryInterface {
  ///
  FutureEither<List<FavMenuEntity>> getFavouriteMenus({
    required String start,
    required String end,
  });

  ///
  FutureEither<List<SalesPerformanceEntity>> getSalesPerformance({
    required String start,
    required String end,
  });
}
