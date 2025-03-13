import 'dart:async';

import 'package:raskop_fe_backoffice/core/core.dart';
import 'package:raskop_fe_backoffice/shared/extension/cache_extension.dart';
import 'package:raskop_fe_backoffice/src/table/domain/entities/table_entity.dart';
import 'package:raskop_fe_backoffice/src/table/table_provider.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'table_controller.g.dart';

@riverpod

///
class TableController extends _$TableController {
  @override

  /// auto build widget when calling the controller
  FutureOr<List<TableEntity>> build() async {
    ref.cacheFor(const Duration(seconds: 5));
    return fetchTables();
  }

  /// 🛠️ Function untuk Fetch Data dengan Filter
  Future<List<TableEntity>> fetchTables() async {
    state = const AsyncValue.loading();
    final res = await ref.read(tableRepositoryProvider).getAllTableData();

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
  Future<TableEntity> getByID({required String id}) async {
    final res =
        await ref.read(tableRepositoryProvider).getTableDataByID(id: id);
    return res.fold(
      (l) => throw l,
      (r) => r,
    );
  }

  ///
  FutureVoid deleteData({
    required String id,
    required bool deletePermanent,
  }) async {
    final res = await ref.read(tableRepositoryProvider).deleteTable(
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
  Future<bool> toggleTableStatus({
    required TableEntity request,
    required String id,
    required bool currentStatus,
  }) async {
    state = AsyncData([
      for (final TableEntity table in state.value ?? [])
        if (table.id == id) table.copyWith(isActive: !currentStatus) else table,
    ]);
    final res = await ref
        .read(tableRepositoryProvider)
        .updateTableStatus(request: request, id: id, isActive: !currentStatus);
    return res.fold(
      (failure) {
        state = AsyncData([
          for (final TableEntity table in state.value ?? [])
            if (table.id == id)
              table.copyWith(isActive: currentStatus)
            else
              table,
        ]);
        return false;
      },
      (success) => true,
    );
  }

  ///
  Future<bool> toggleTableLocation({
    required TableEntity request,
    required String id,
    required bool currentLocation,
  }) async {
    state = AsyncData([
      for (final TableEntity table in state.value ?? [])
        if (table.id == id)
          table.copyWith(isOutdoor: !currentLocation)
        else
          table,
    ]);
    final res = await ref.read(tableRepositoryProvider).updateTableLocation(
          request: request,
          id: id,
          isOutdoor: !currentLocation,
        );
    return res.fold(
      (failure) {
        state = AsyncData([
          for (final TableEntity table in state.value ?? [])
            if (table.id == id)
              table.copyWith(isOutdoor: currentLocation)
            else
              table,
        ]);
        return false;
      },
      (success) => true,
    );
  }

  ///
  Future<bool> toggleTableDescription({
    required TableEntity request,
    required String id,
    required String newDescription,
  }) async {
    state = AsyncData([
      for (final TableEntity table in state.value ?? [])
        if (table.id == id)
          table.copyWith(description: newDescription)
        else
          table,
    ]);
    final res = await ref.read(tableRepositoryProvider).updateTableDescription(
        request: request, id: id, description: newDescription);

    return res.fold(
      (failure) {
        state = AsyncData([
          for (final TableEntity table in state.value ?? [])
            if (table.id == id)
              table.copyWith(description: request.description)
            else
              table,
        ]);
        return false;
      },
      (success) => true,
    );
  }

  ///
  Future<bool> toggleTableCapacity({
    required TableEntity request,
    required String id,
    required int minCapacity,
    required int maxCapacity,
  }) async {
    state = AsyncData([
      for (final TableEntity table in state.value ?? [])
        if (table.id == id)
          table.copyWith(minCapacity: minCapacity, maxCapacity: maxCapacity)
        else
          table,
    ]);
    final res = await ref.read(tableRepositoryProvider).updateTableCapacity(
          request: request,
          id: id,
          minCapacity: minCapacity,
          maxCapacity: maxCapacity,
        );

    return res.fold(
      (failure) {
        state = AsyncData([
          for (final TableEntity table in state.value ?? [])
            if (table.id == id)
              table.copyWith(
                minCapacity: request.minCapacity,
                maxCapacity: request.maxCapacity,
              )
            else
              table,
        ]);
        return false;
      },
      (success) => true,
    );
  }
}
