import 'package:raskop_fe_backoffice/core/core.dart';
import 'package:raskop_fe_backoffice/src/order/domain/entities/create_order_response_entity.dart';
import 'package:raskop_fe_backoffice/src/order/domain/entities/update_status_order_request_entity.dart';
import 'package:raskop_fe_backoffice/src/reservation/domain/entities/create_reservation_request_entity.dart';
import 'package:raskop_fe_backoffice/src/reservation/domain/entities/reservation_entity.dart';
import 'package:raskop_fe_backoffice/src/reservation/domain/entities/table_suggestion_entity.dart';
import 'package:raskop_fe_backoffice/src/reservation/domain/entities/table_suggestion_request_entity.dart';

///
abstract class ReservationRepositoryInterface {
  /// Get, All
  FutureEither<List<ReservationEntity>> getAllReservation();

  /// Get, By ID
  FutureEither<ReservationEntity> getReservationByID({required String id});

  /// Post, Create New
  FutureEither<CreateOrderResponseEntity> createNewReservation({
    required CreateReservationRequestEntity request,
  });

  /// Post, Update Current
  FutureEitherVoid updateCurrentReservation({
    required UpdateStatusOrderRequestEntity request,
  });

  /// POST, Cancel By ID
  FutureEitherVoid cancelReservation({
    required Map<String, dynamic> id,
  });

  /// POST, get Table Suggestion
  FutureEither<List<TableSuggestionEntity>> getTableSuggestion({
    required TableSuggestionRequestEntity request,
  });
}
