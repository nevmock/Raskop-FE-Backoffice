import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:raskop_fe_backoffice/core/core.dart';
import 'package:raskop_fe_backoffice/src/order/repositories/order_repository.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'order_provider.g.dart';

@riverpod

///
OrderRepository orderRepository(Ref ref) {
  final client = ref.watch(apiClientProvider());
  return OrderRepository(client: client);
}
