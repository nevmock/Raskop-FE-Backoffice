import 'package:http/http.dart' as http;
import 'package:raskop_fe_backoffice/core/core.dart';
import 'package:raskop_fe_backoffice/res/endpoints.dart';
import 'package:raskop_fe_backoffice/res/paths.dart';
import 'package:raskop_fe_backoffice/src/dashboard/domain/abstracts/dashboard_repository_interface.dart';
import 'package:raskop_fe_backoffice/src/dashboard/domain/entities/fav_menu_entity.dart';
import 'package:raskop_fe_backoffice/src/dashboard/domain/entities/sales_performance_entity.dart';

///
class DashboardRepository implements DashboardRepositoryInterface {
  /// Menu Repository Constructor
  DashboardRepository({required this.client, required this.baseClient});

  ///
  final http.Client client;

  ///
  final ApiClient baseClient;

  /// Base API URL
  final url = BasePaths.baseAPIDashboardURL;

  /// Endpoint
  final favMenu = Endpoints.menuFavorites;

  /// Endpoint
  final salesPerformance = Endpoints.salesPerformance;

  @override
  FutureEither<List<FavMenuEntity>> getFavouriteMenus({
    required String start,
    required String end,
  }) {
    return baseClient.request<List<FavMenuEntity>>(
      action: 'fetch',
      endpoint: favMenu,
      fromJson: (json) => (json['data'] as List<dynamic>)
          .map((e) => FavMenuEntity.fromJson(e as Map<String, dynamic>))
          .toList(),
      queryParameters: {
        'start_date': start,
        'end_date': end,
      },
    );
  }

  @override
  FutureEither<List<SalesPerformanceEntity>> getSalesPerformance({
    required String start,
    required String end,
  }) {
    return baseClient.request<List<SalesPerformanceEntity>>(
      action: 'fetch',
      endpoint: salesPerformance,
      fromJson: (json) => (json['data'] as List<dynamic>)
          .map(
            (e) => SalesPerformanceEntity.fromJson(e as Map<String, dynamic>),
          )
          .toList(),
      queryParameters: {
        'start_date': start,
        'end_date': end,
      },
    );
  }
}
