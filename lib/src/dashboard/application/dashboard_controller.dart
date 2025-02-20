import 'package:raskop_fe_backoffice/shared/extension/cache_extension.dart';
import 'package:raskop_fe_backoffice/src/dashboard/dashboard_provider.dart';
import 'package:raskop_fe_backoffice/src/dashboard/domain/entities/fav_menu_entity.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'dashboard_controller.g.dart';

@riverpod

///
class DashboardController extends _$DashboardController {
  @override

  // auto build widget when calling the controller
  FutureOr<List<FavMenuEntity>> build() async {
    ref.cacheFor(const Duration(minutes: 10));
    return getFavouriteMenus();
  }

  /// 🛠️ Function untuk Fetch Data dengan Filter
  Future<List<FavMenuEntity>> getFavouriteMenus() async {
    state = const AsyncValue.loading();
    final res = await ref
        .read(dashboardRepositoryProvider)
        .getFavouriteMenus(start: '2024-01-01', end: '2026-01-01');

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

  // /// can be called using riverpod notifier
  // Future<SupplierEntity> getByID({required String id}) async {
  //   final res =
  //       await ref.read(supplierRepositoryProvider).getSupplierDataByID(id: id);
  //   return res.fold(
  //     (l) => throw l,
  //     (r) => r,
  //   );
  // }

  // /// can be called using riverpod notifier
  // FutureVoid createNew({required SupplierEntity request}) async {
  //   final res = await ref
  //       .read(supplierRepositoryProvider)
  //       .createNewSupplier(request: request);
  //   res.fold(
  //     (l) => state = AsyncError(l, StackTrace.current),
  //     (r) => r,
  //   );
  //   ref.invalidateSelf();
  // }

  // ///
  // FutureVoid updateData({
  //   required SupplierEntity request,
  //   required String id,
  // }) async {
  //   final res = await ref
  //       .read(supplierRepositoryProvider)
  //       .updateCurrentSupplier(request: request, id: id);
  //   res.fold(
  //     (l) => state = AsyncError(l, StackTrace.current),
  //     (r) => r,
  //   );
  //   ref.invalidateSelf();
  // }

  // ///
  // FutureVoid deleteData({
  //   required String id,
  //   required bool deletePermanent,
  // }) async {
  //   final res = await ref.read(supplierRepositoryProvider).deleteSupplier(
  //         id: id,
  //         deletePermanent: deletePermanent,
  //       );
  //   res.fold(
  //     (l) => state = AsyncError(l, StackTrace.current),
  //     (r) => r,
  //   );
  //   ref.invalidateSelf();
  // }

  // ///
  // Future<bool> toggleSupplierStatus({
  //   required SupplierEntity request,
  //   required String id,
  //   required bool currentStatus,
  // }) async {
  //   state = AsyncData([
  //     for (final SupplierEntity supplier in state.value ?? [])
  //       if (supplier.id == id)
  //         supplier.copyWith(isActive: !currentStatus)
  //       else
  //         supplier,
  //   ]);
  //   final res = await ref
  //       .read(supplierRepositoryProvider)
  //       .updateSupplierStatus(request: request, id: id, status: !currentStatus);
  //   return res.fold(
  //     (failure) {
  //       state = AsyncData([
  //         for (final SupplierEntity supplier in state.value ?? [])
  //           if (supplier.id == id)
  //             supplier.copyWith(isActive: currentStatus)
  //           else
  //             supplier,
  //       ]);
  //       return false;
  //     },
  //     (success) => true,
  //   );
  // }
}
