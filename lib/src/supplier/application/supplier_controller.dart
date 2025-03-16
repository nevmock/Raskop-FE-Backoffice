import 'dart:async';

import 'package:flutter/material.dart';
import 'package:raskop_fe_backoffice/core/core.dart';
import 'package:raskop_fe_backoffice/shared/extension/cache_extension.dart';
import 'package:raskop_fe_backoffice/src/supplier/domain/entities/supplier_entity.dart';
import 'package:raskop_fe_backoffice/src/supplier/supplier_provider.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'supplier_controller.g.dart';

@riverpod

///
class SupplierController extends _$SupplierController {
  ///
  final controller = ScrollController();

  ///
  bool isLoading = false;

  ///
  bool hasMore = true;

  ///
  List<SupplierEntity> suppliers = [];

  ///
  int start = 1;

  ///
  int length = 10;

  ///
  String column = 'name';

  ///
  String direction = 'ASC';

  ///
  Map<String, dynamic> advSearch = {};

  ///
  String search = '';
  @override

  /// auto build widget when calling the controller
  FutureOr<List<SupplierEntity>> build() async {
    _setupScrollListener();
    ref.cacheFor(const Duration(minutes: 1));
    return fetchSuppliers();
  }

  void _setupScrollListener() {
    controller.addListener(() {
      if (controller.position.pixels >=
              controller.position.maxScrollExtent * 0.9 &&
          !isLoading &&
          hasMore) {
        fetchSuppliers();
      }
    });
  }

  /// Refresh data controller
  void refresh() {
    start = 1;
    hasMore = true;
    suppliers.clear();

    state = const AsyncValue.loading();

    fetchSuppliers(isRefresh: true);
  }

  /// 🛠️ Function untuk Fetch Data dengan Filter
  Future<List<SupplierEntity>> fetchSuppliers({
    bool isRefresh = false,
  }) async {
    if (isLoading || !hasMore) return suppliers;

    if (isRefresh) {
      start = 1;
      hasMore = true;
      suppliers.clear();
      state = const AsyncValue.loading();
    }

    isLoading = true;

    final res = await ref.read(supplierRepositoryProvider).getAllSupplierData(
          start: start,
          length: length,
          advSearch: advSearch.isEmpty ? null : advSearch,
          search: search.isEmpty ? null : search,
          order: column == '' || direction == ''
              ? null
              : [
                  <String, dynamic>{
                    'column': column,
                    'direction': direction,
                  },
                ],
        );

    return res.fold(
      (l) {
        state = AsyncValue.error(l, StackTrace.current);
        isLoading = false;
        return suppliers;
      },
      (r) {
        if (isRefresh) {
          suppliers = r;
        } else {
          suppliers.addAll(r);
        }

        if (r.length < length) hasMore = false;
        state = AsyncValue.data([...suppliers]);
        start += length;

        isLoading = false;
        return suppliers;
      },
    );
  }

  /// can be called using riverpod notifier
  Future<SupplierEntity> getByID({required String id}) async {
    final res =
        await ref.read(supplierRepositoryProvider).getSupplierDataByID(id: id);
    return res.fold(
      (l) => throw l,
      (r) => r,
    );
  }

  /// can be called using riverpod notifier
  FutureVoid createNew({required SupplierEntity request}) async {
    final res = await ref
        .read(supplierRepositoryProvider)
        .createNewSupplier(request: request);
    res.fold(
      (l) => throw l,
      (r) {
        refresh();
        return r;
      },
    );
  }

  ///
  FutureVoid updateData({
    required SupplierEntity request,
    required String id,
  }) async {
    final res = await ref
        .read(supplierRepositoryProvider)
        .updateCurrentSupplier(request: request, id: id);
    res.fold(
      (l) => throw l,
      (r) {
        refresh();
        return r;
      },
    );
  }

  ///
  FutureVoid deleteData({
    required String id,
    required bool deletePermanent,
  }) async {
    final res = await ref.read(supplierRepositoryProvider).deleteSupplier(
          id: id,
          deletePermanent: deletePermanent,
        );
    res.fold(
      (l) => throw l,
      (r) {
        refresh();
        return r;
      },
    );
  }

  ///
  Future<bool> toggleSupplierStatus({
    required SupplierEntity request,
    required String id,
    required bool currentStatus,
  }) async {
    state = AsyncData([
      for (final SupplierEntity supplier in state.value ?? [])
        if (supplier.id == id)
          supplier.copyWith(isActive: !currentStatus)
        else
          supplier,
    ]);
    final res = await ref
        .read(supplierRepositoryProvider)
        .updateSupplierStatus(request: request, id: id, status: !currentStatus);
    return res.fold(
      (failure) {
        state = AsyncData([
          for (final SupplierEntity supplier in state.value ?? [])
            if (supplier.id == id)
              supplier.copyWith(isActive: currentStatus)
            else
              supplier,
        ]);
        return false;
      },
      (success) => true,
    );
  }

  ///
  void onSort({required String column, required String direction}) {
    this.column = column;
    this.direction = direction;
    fetchSuppliers(isRefresh: true);
  }

  ///
  void onSearch(
      {required Map<String, dynamic> advSearch, required String search}) {
    if (this.advSearch == advSearch) return;
    this.advSearch = advSearch;
    this.search = search;

    refresh();
  }
}
