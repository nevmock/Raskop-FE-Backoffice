import 'dart:async';

import 'package:raskop_fe_backoffice/core/core.dart';
import 'package:raskop_fe_backoffice/shared/extension/cache_extension.dart';
import 'package:raskop_fe_backoffice/src/menu/domain/entities/menu_entity.dart';
import 'package:raskop_fe_backoffice/src/menu/menu_provider.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'menu_controller.g.dart';

@riverpod

///
class MenuController extends _$MenuController {
  @override

  /// auto build widget when calling the controller
  FutureOr<List<MenuEntity>> build() async {
    ref.cacheFor(const Duration(minutes: 10));
    return fetchMenus();
  }

  /// 🛠️ Function untuk Fetch Data dengan Filter
  Future<List<MenuEntity>> fetchMenus({
    int? length,
    String? search,
    Map<String, dynamic>? advSearch,
    List<Map<String, dynamic>>? order,
  }) async {
    state = const AsyncValue.loading();
    final res = await ref.read(menuRepositoryProvider).getAllMenuData(
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
  Future<MenuEntity> getByID({required String id}) async {
    final res = await ref.read(menuRepositoryProvider).getMenuDataByID(id: id);
    return res.fold(
      (l) => throw l,
      (r) => r,
    );
  }

  /// can be called using riverpod notifier
  FutureVoid createNew({required MenuEntity request, String? imageFile}) async {
    final res = await ref
        .read(menuRepositoryProvider)
        .createNewMenu(request: request, imageFile: imageFile);
    res.fold(
      (l) => state = AsyncError(l, StackTrace.current),
      (r) => r,
    );
    ref.invalidateSelf();
  }

  ///
  FutureVoid updateData({
    required MenuEntity request,
    required String id,
  }) async {
    final res = await ref
        .read(menuRepositoryProvider)
        .updateCurrentMenu(request: request, id: id);
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
    final res = await ref.read(menuRepositoryProvider).deleteMenu(
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
  Future<bool> toggleMenuStatus({
    required MenuEntity request,
    required String id,
    required bool currentStatus,
  }) async {
    state = AsyncData([
      for (final MenuEntity menu in state.value ?? [])
        if (menu.id == id) menu.copyWith(isActive: !currentStatus) else menu,
    ]);
    final res = await ref
        .read(menuRepositoryProvider)
        .updateMenuStatus(request: request, id: id, status: !currentStatus);
    return res.fold(
      (failure) {
        state = AsyncData([
          for (final MenuEntity menu in state.value ?? [])
            if (menu.id == id) menu.copyWith(isActive: currentStatus) else menu,
        ]);
        return false;
      },
      (success) => true,
    );
  }
}
