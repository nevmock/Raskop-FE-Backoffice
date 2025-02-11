import 'dart:async';

import 'package:raskop_fe_backoffice/core/core.dart';
import 'package:raskop_fe_backoffice/shared/extension/cache_extension.dart';
import 'package:raskop_fe_backoffice/src/supplier/domain/entities/supplier_entity.dart';
import 'package:raskop_fe_backoffice/src/supplier/supplier_provider.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'supplier_controller.g.dart';

@riverpod

///
class SupplierController extends _$SupplierController {
  @override

  /// auto build widget when calling the controller
  FutureOr<List<SupplierEntity>> build() async {
    ref.cacheFor(const Duration(minutes: 10));
    return fetchSuppliers();
  }

  /// 🛠️ Function untuk Fetch Data dengan Filter
  Future<List<SupplierEntity>> fetchSuppliers({
    int? length,
    String? search,
    Map<String, dynamic>? advSearch,
    List<Map<String, dynamic>>? order,
  }) async {
    state = const AsyncValue.loading();
    final res = await ref.read(supplierRepositoryProvider).getAllSupplierData(
          length: length,
          search: search,
          advSearch: advSearch,
          order: order,
        );

    return res.fold(
      (l) {
        state = AsyncValue.error(l, StackTrace.current);
        throw l;
      },
      (r) {
        state = AsyncValue.data(r);
        return r;
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
      (l) => state = AsyncError(l, StackTrace.current),
      (r) => r,
    );
    ref.invalidateSelf();
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
      (l) => state = AsyncError(l, StackTrace.current),
      (r) => r,
    );
    ref.invalidateSelf();
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
      (l) => state = AsyncError(l, StackTrace.current),
      (r) => r,
    );
    ref.invalidateSelf();
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
}
