import 'package:flutter/material.dart';
import 'package:raskop_fe_backoffice/core/core.dart';
import 'package:raskop_fe_backoffice/shared/extension/cache_extension.dart';
import 'package:raskop_fe_backoffice/src/order/domain/entities/create_order_request_entity.dart';
import 'package:raskop_fe_backoffice/src/order/domain/entities/create_order_response_entity.dart';
import 'package:raskop_fe_backoffice/src/order/domain/entities/order_entity.dart';
import 'package:raskop_fe_backoffice/src/order/domain/entities/update_status_order_request_entity.dart';
import 'package:raskop_fe_backoffice/src/order/order_provider.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'order_controller.g.dart';

@riverpod

///
class OrderController extends _$OrderController {
  ///
  final controller = ScrollController();

  ///
  bool isLoading = false;

  ///
  bool hasMore = true;

  ///
  List<OrderEntity> orders = [];

  ///
  int start = 1;

  ///
  int length = 10;

  ///
  String column = 'orderBy';

  ///
  String direction = '';

  ///
  Map<String, dynamic> advSearch = {};
  @override

  /// auto build widget when calling the controller
  FutureOr<List<OrderEntity>> build() async {
    _setupScrollListener();
    ref.cacheFor(const Duration(seconds: 5));
    return fetchOrders();
  }

  /// 🛠️ Function untuk Fetch Data Order dengan Filter
  Future<List<OrderEntity>> fetchOrders({
    bool isRefresh = false,
  }) async {
    if (isLoading || !hasMore) return orders;

    if (isRefresh) {
      start = 1;
      hasMore = true;
      orders.clear();

      state = const AsyncValue.loading();
    }

    isLoading = true;

    final res = await ref.read(orderRepositoryProvider).getAllOrders(
      start: start,
      length: length,
      advSearch: advSearch.isEmpty ? null : advSearch,
      order: [
        if (column != '' && direction != '')
          <String, dynamic>{
            'column': column,
            'direction': direction,
          },
        <String, dynamic>{
          'column': 'createdAt',
          'direction': 'DESC',
        }
      ],
    );
    return res.fold(
      (l) {
        state = AsyncValue.error(l, StackTrace.current);
        isLoading = false;
        return orders;
      },
      (r) {
        if (isRefresh) {
          orders = r;
        } else {
          orders.addAll(r);
        }

        if (r.length < length) hasMore = false;
        state = AsyncValue.data([...orders]);
        start += length;

        isLoading = false;
        return orders;
      },
    );
  }

  void _setupScrollListener() {
    controller.addListener(() {
      if (controller.position.pixels >=
              controller.position.maxScrollExtent * 0.9 &&
          !isLoading &&
          hasMore) {
        fetchOrders();
      }
    });
  }

  /// Refresh data controller
  void refresh() {
    start = 1;
    hasMore = true;
    orders.clear();

    state = const AsyncValue.loading();

    fetchOrders(isRefresh: true);
  }

  ///
  Future<CreateOrderResponseEntity> createNew({
    required CreateOrderRequestEntity request,
  }) async {
    final res = await ref
        .read(orderRepositoryProvider)
        .createNewOrder(orderRequest: request);
    return res.fold(
      (l) {
        state = AsyncError(l, StackTrace.current);
        throw l;
      },
      (r) {
        start = 1;
        hasMore = true;
        orders.clear();

        state = const AsyncValue.loading();

        fetchOrders(isRefresh: true);
        return r;
      },
    );
  }

  ///
  FutureVoid updateStatus({
    required UpdateStatusOrderRequestEntity request,
  }) async {
    final res = await ref
        .read(orderRepositoryProvider)
        .updateOrderStatus(request: request);
    res.fold(
      (l) {
        state = AsyncError(l, StackTrace.current);
        throw l;
      },
      (r) {
        refresh();
        return r;
      },
    );
  }

  ///
  void onSort({required String column, required String direction}) {
    this.column = column;
    this.direction = direction;
    fetchOrders(isRefresh: true);
  }

  ///
  void onSearch({required Map<String, dynamic> advSearch}) {
    if (this.advSearch == advSearch) return;
    this.advSearch = advSearch;

    refresh();
  }
}
