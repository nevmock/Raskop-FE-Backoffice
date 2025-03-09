import 'package:raskop_fe_backoffice/core/core.dart';
import 'package:raskop_fe_backoffice/src/order/domain/entities/create_order_request_entity.dart';
import 'package:raskop_fe_backoffice/src/order/domain/entities/create_order_response_entity.dart';
import 'package:raskop_fe_backoffice/src/order/domain/entities/order_entity.dart';
import 'package:raskop_fe_backoffice/src/order/domain/entities/update_status_order_request_entity.dart';

/// Order Repo Interface
abstract class OrderRepositoryInterface {
  ///
  FutureEither<List<OrderEntity>> getAllOrders();

  ///
  FutureEither<OrderEntity> getOrderByID({required String id});

  ///
  FutureEither<CreateOrderResponseEntity> createNewOrder({
    required CreateOrderRequestEntity orderRequest,
  });

  ///
  FutureEitherVoid updateOrderStatus({
    required UpdateStatusOrderRequestEntity request,
  });

  // ///
  // FutureEitherVoid deleteOrder({
  //   required String id,
  //   required bool deletePermanent,
  // });
}
