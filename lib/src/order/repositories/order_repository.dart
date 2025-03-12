import 'dart:convert';

import 'package:raskop_fe_backoffice/core/core.dart';
import 'package:raskop_fe_backoffice/res/endpoints.dart';
import 'package:raskop_fe_backoffice/src/common/success/response_success.dart';
import 'package:raskop_fe_backoffice/src/order/domain/abstracts/order_repository_interface.dart';
import 'package:raskop_fe_backoffice/src/order/domain/entities/create_order_request_entity.dart';
import 'package:raskop_fe_backoffice/src/order/domain/entities/create_order_response_entity.dart';
import 'package:raskop_fe_backoffice/src/order/domain/entities/order_entity.dart';
import 'package:raskop_fe_backoffice/src/order/domain/entities/update_status_order_request_entity.dart';

/// Order Repository
class OrderRepository implements OrderRepositoryInterface {
  /// Constructor
  OrderRepository({required this.client});

  /// http client request
  final ApiClient client;

  /// Order Endpoint
  final endpoint = Endpoints.order;

  @override
  FutureEither<List<OrderEntity>> getAllOrders({
    int? start,
    int? length,
    Map<String, dynamic>? advSearch,
    List<Map<String, dynamic>>? order,
  }) async {
    return client.request<List<OrderEntity>>(
      endpoint: endpoint,
      action: 'fetch',
      fromJson: (json) => (json['data'] as List<dynamic>)
          .map(
            (e) => OrderEntity.fromJson(e as Map<String, dynamic>),
          )
          .toList(),
      queryParameters: {
        if (start != null) 'start': start.toString(),
        if (length != null) 'length': length.toString(),
        if (advSearch != null)
          'advSearch': jsonEncode(advSearch)
        else
          'advSearch': jsonEncode(
            {
              'withDeleted': false,
              'withRelation': true,
              'withReservasi': false,
            },
          ),
        if (order != null) 'order': jsonEncode(order),
      },
    );
  }

  @override
  FutureEither<OrderEntity> getOrderByID({required String id}) {
    return client.request<OrderEntity>(
      action: 'fetch',
      endpoint: '$endpoint/$id',
      fromJson: (json) => OrderEntity.fromJson(
        json['data'] as Map<String, dynamic>,
      ),
    );
  }

  @override
  FutureEither<CreateOrderResponseEntity> createNewOrder({
    required CreateOrderRequestEntity orderRequest,
  }) {
    return client.request<CreateOrderResponseEntity>(
      endpoint: endpoint,
      action: 'create',
      method: 'POST',
      headers: {'Content-Type': 'application/json'},
      body: orderRequest.toJson(),
      fromJson: (json) => CreateOrderResponseEntity.fromJson(
        json['data'] as Map<String, dynamic>,
      ),
    );
  }

  @override
  FutureEitherVoid updateOrderStatus({
    required UpdateStatusOrderRequestEntity request,
  }) {
    return client.request<ResponseSuccess>(
      endpoint: '$endpoint/${request.id}/update-status',
      action: 'edit',
      method: 'POST',
      headers: {'Content-Type': 'application/json'},
      body: request.toJson(),
    );
  }

  // @override
  // FutureEitherVoid deleteOrder({
  //   required String id,
  //   required bool deletePermanent,
  // }) {
  //   throw UnimplementedError();
  // }
}
