import 'package:flutter/material.dart';
import 'package:raskop_fe_backoffice/core/core.dart';
import 'package:raskop_fe_backoffice/shared/extension/cache_extension.dart';
import 'package:raskop_fe_backoffice/src/order/domain/entities/create_order_response_entity.dart';
import 'package:raskop_fe_backoffice/src/order/domain/entities/update_status_order_request_entity.dart';
import 'package:raskop_fe_backoffice/src/reservation/domain/entities/create_reservation_request_entity.dart';
import 'package:raskop_fe_backoffice/src/reservation/domain/entities/reservation_entity.dart';
import 'package:raskop_fe_backoffice/src/reservation/domain/entities/table_suggestion_entity.dart';
import 'package:raskop_fe_backoffice/src/reservation/domain/entities/table_suggestion_request_entity.dart';
import 'package:raskop_fe_backoffice/src/reservation/reservation_provider.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'reservation_controller.g.dart';

@riverpod

/// Reservation Controller
class ReservationController extends _$ReservationController {
  ///
  final controller = ScrollController();

  ///
  bool isLoading = false;

  ///
  bool hasMore = true;

  ///
  List<ReservationEntity> reservations = [];

  ///
  int start = 1;

  ///
  int length = 10;

  ///
  String column = 'reserveBy';

  ///
  String direction = '';

  ///
  Map<String, dynamic> advSearch = {};
  @override
  FutureOr<List<ReservationEntity>> build() async {
    _setupScrollListener();
    ref.cacheFor(const Duration(minutes: 10));
    return fetchReservations();
  }

  ///
  Future<List<ReservationEntity>> fetchReservations({
    bool isRefresh = false,
  }) async {
    if (isLoading || !hasMore) return reservations;

    if (isRefresh) {
      start = 1;
      hasMore = true;
      reservations.clear();

      state = const AsyncValue.loading();
    }

    isLoading = true;

    final res = await ref.read(reservationRepositoryProvider).getAllReservation(
          start: start,
          length: length,
          advSearch: advSearch.isEmpty ? null : advSearch,
          order: column == '' || direction == ''
              ? null
              : [
                  <String, dynamic>{
                    'column': column,
                    'direction': direction,
                  }
                ],
        );
    return res.fold(
      (l) {
        state = AsyncError(l, StackTrace.current);
        isLoading = false;
        return reservations;
      },
      (r) {
        if (isRefresh) {
          reservations = r;
        } else {
          reservations.addAll(r);
        }

        if (r.length < length) hasMore = false;
        state = AsyncData([...reservations]);
        start += length;

        isLoading = false;
        return reservations;
      },
    );
  }

  void _setupScrollListener() {
    controller.addListener(() {
      if (controller.position.pixels >=
              controller.position.maxScrollExtent * 0.9 &&
          !isLoading &&
          hasMore) {
        fetchReservations();
      }
    });
  }

  /// Refresh data controller
  void refresh() {
    start = 1;
    hasMore = true;
    reservations.clear();

    state = const AsyncValue.loading();

    fetchReservations(isRefresh: true);
  }

  ///
  Future<ReservationEntity> getReservationByID({
    required String id,
  }) async {
    final res = await ref
        .read(reservationRepositoryProvider)
        .getReservationByID(id: id);
    return res.fold(
      (l) => throw l,
      (r) => r,
    );
  }

  ///
  Future<CreateOrderResponseEntity> createNew({
    required CreateReservationRequestEntity request,
  }) async {
    final res = await ref
        .read(reservationRepositoryProvider)
        .createNewReservation(request: request);
    return res.fold(
      (l) {
        // state = AsyncError(l, StackTrace.current);
        throw l;
      },
      (r) {
        refresh();
        return r;
      },
    );
  }

  ///
  FutureVoid updateStatus({
    required UpdateStatusOrderRequestEntity request,
  }) async {
    final res = await ref
        .read(reservationRepositoryProvider)
        .updateCurrentReservation(request: request);
    res.fold(
      (l) => throw l,
      (r) {
        refresh();
        return r;
      },
    );
  }

  ///
  FutureVoid cancelReservation({
    required Map<String, dynamic> id,
  }) async {
    final res =
        await ref.read(reservationRepositoryProvider).cancelReservation(id: id);
    res.fold(
      (l) => state = AsyncError(l, StackTrace.current),
      (r) {
        refresh();
        return r;
      },
    );
  }

  ///
  Future<List<TableSuggestionEntity>> getTableSuggestion({
    required TableSuggestionRequestEntity request,
  }) async {
    final res = await ref
        .read(reservationRepositoryProvider)
        .getTableSuggestion(request: request);
    return res.fold(
      (l) {
        state = AsyncError(l, StackTrace.current);
        throw l;
      },
      (r) => r,
    );
  }

  ///
  void onSort({required String column, required String direction}) {
    this.column = column;
    this.direction = direction;
    fetchReservations(isRefresh: true);
  }

  ///
  void onSearch({required Map<String, dynamic> advSearch}) {
    if (this.advSearch == advSearch) return;
    this.advSearch = advSearch;

    refresh();
  }
}
