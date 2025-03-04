import 'dart:convert';

import 'package:raskop_fe_backoffice/core/core.dart';
import 'package:raskop_fe_backoffice/res/endpoints.dart';
import 'package:raskop_fe_backoffice/src/common/success/response_success.dart';
import 'package:raskop_fe_backoffice/src/order/domain/entities/create_order_response_entity.dart';
import 'package:raskop_fe_backoffice/src/order/domain/entities/update_status_order_request_entity.dart';
import 'package:raskop_fe_backoffice/src/reservation/domain/abstracts/reservation_repository_interface.dart';
import 'package:raskop_fe_backoffice/src/reservation/domain/entities/create_reservation_request_entity.dart';
import 'package:raskop_fe_backoffice/src/reservation/domain/entities/reservation_entity.dart';
import 'package:raskop_fe_backoffice/src/reservation/domain/entities/table_suggestion_entity.dart';
import 'package:raskop_fe_backoffice/src/reservation/domain/entities/table_suggestion_request_entity.dart';

/// Reservation Repository
class ReservationRepository implements ReservationRepositoryInterface {
  /// Constructor
  ReservationRepository({required this.client});

  /// http client request
  final ApiClient client;

  /// Order Endpoint
  final endpoint = Endpoints.reservasi;
  @override
  FutureEither<List<ReservationEntity>> getAllReservation({
    int? start,
    int? length,
    Map<String, dynamic>? advSearch,
    List<Map<String, dynamic>>? order,
  }) {
    return client.request<List<ReservationEntity>>(
      endpoint: endpoint,
      action: 'fetch',
      fromJson: (json) => (json['data'] as List<dynamic>)
          .map((e) => ReservationEntity.fromJson(e as Map<String, dynamic>))
          .toList(),
      queryParameters: {
        if (start != null) 'start': start.toString(),
        if (length != null) 'length': length.toString(),
        if (advSearch != null)
          'advSearch': jsonEncode(advSearch)
        else
          'advSearch': jsonEncode(
            {
              'withRelation': true,
              'withDeleted': true,
            },
          ),
        if (order != null) 'order': jsonEncode(order),
      },
    );
  }

  @override
  FutureEither<ReservationEntity> getReservationByID({required String id}) {
    return client.request<ReservationEntity>(
      endpoint: '$endpoint/$id',
      action: 'fetch',
      fromJson: (json) =>
          ReservationEntity.fromJson(json['data'] as Map<String, dynamic>),
    );
  }

  @override
  FutureEither<CreateOrderResponseEntity> createNewReservation({
    required CreateReservationRequestEntity request,
  }) {
    print(request.toJson());
    return client.request<CreateOrderResponseEntity>(
      endpoint: endpoint,
      action: 'create',
      method: 'POST',
      headers: {'Content-Type': 'application/json'},
      body: request.toJson(),
      fromJson: (json) => CreateOrderResponseEntity.fromJson(
        json['data'] as Map<String, dynamic>,
      ),
    );
  }

  @override
  FutureEitherVoid updateCurrentReservation({
    required UpdateStatusOrderRequestEntity request,
  }) {
    return client.request<ResponseSuccess>(
      endpoint: '$endpoint/update-status',
      action: 'edit',
      method: 'POST',
      headers: {'Content-Type': 'application/json'},
      body: request.toJson(),
    );
  }

  @override
  FutureEitherVoid cancelReservation({required Map<String, dynamic> id}) {
    return client.request<ResponseSuccess>(
      endpoint: '$endpoint/cancel',
      action: 'delete',
      method: 'POST',
      headers: {'Content-Type': 'application/json'},
      body: id,
    );
  }

  @override
  FutureEither<List<TableSuggestionEntity>> getTableSuggestion({
    required TableSuggestionRequestEntity request,
  }) {
    return client.request(
      endpoint: '${Endpoints.table}/suggestion',
      action: 'fetch',
      method: 'POST',
      headers: {'Content-Type': 'application/json'},
      body: request.toJson(),
      // ignore: avoid_dynamic_calls
      fromJson: (json) => (json['data']['tables'] as List<dynamic>)
          .map((e) => TableSuggestionEntity.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
  }

  @override
  FutureEither<CreateOrderResponseEntity> generatePayment({
    required String id,
    required String paymentMethod,
  }) {
    return client.request(
      endpoint: '${Endpoints.transaction}/generate-payment',
      action: 'create',
      method: 'POST',
      headers: {'Content-Type': 'application/json'},
      body: <String, dynamic>{'orderId': id, 'paymentMethod': paymentMethod},
      fromJson: (json) => CreateOrderResponseEntity.fromJson(
        json['data'] as Map<String, dynamic>,
      ),
    );
  }
}
