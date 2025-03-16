import 'dart:async';

import 'package:flutter/material.dart';
import 'package:raskop_fe_backoffice/core/core.dart';
import 'package:raskop_fe_backoffice/shared/extension/cache_extension.dart';
import 'package:raskop_fe_backoffice/src/menu/domain/entities/menu_entity.dart';
import 'package:raskop_fe_backoffice/src/menu/menu_provider.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'menu_controller.g.dart';

@riverpod

///
class MenuController extends _$MenuController {
  ///
  final controller = ScrollController();

  ///
  bool isLoading = false;

  ///
  bool hasMore = true;

  ///
  List<MenuEntity> menus = [];

  ///
  int start = 1;

  ///
  int length = 10;

  ///
  String column = '';

  ///
  String direction = '';

  ///
  Map<String, dynamic> advSearch = {};
  @override

  /// auto build widget when calling the controller
  FutureOr<List<MenuEntity>> build() async {
    _setupScrollListener();
    ref.cacheFor(const Duration(seconds: 5));
    return fetchMenus();
  }

  void _setupScrollListener() {
    controller.addListener(() {
      if (controller.position.pixels >=
              controller.position.maxScrollExtent * 0.9 &&
          !isLoading &&
          hasMore) {
        fetchMenus();
      }
    });
  }

  /// Refresh data controller
  void refresh() {
    start = 1;
    hasMore = true;
    menus.clear();

    state = const AsyncValue.loading();

    fetchMenus(isRefresh: true);
  }

  /// 🛠️ Function untuk Fetch Data dengan Filter
  Future<List<MenuEntity>> fetchMenus({
    bool isRefresh = false,
  }) async {
    if (isLoading || !hasMore) return menus;

    if (isRefresh) {
      start = 1;
      hasMore = true;
      menus.clear();
      state = const AsyncValue.loading();
    }

    isLoading = true;

    state = const AsyncValue.loading();

    final res = await ref.read(menuRepositoryProvider).getAllMenuData(
          start: start,
          length: length,
          advSearch: advSearch.isEmpty ? null : advSearch,
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
        return menus;
      },
      (r) {
        if (isRefresh) {
          menus = r;
        } else {
          menus.addAll(r);
        }

        if (r.length < length) hasMore = false;
        state = AsyncValue.data([...menus]);
        start += length;

        isLoading = false;
        return menus;
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
      (l) => throw l,
      (r) {
        refresh();
        return r;
      },
    );
  }

  ///
  FutureVoid updateData(
      {required MenuEntity request,
      required String id,
      String? imageFile}) async {
    final res = await ref
        .read(menuRepositoryProvider)
        .updateCurrentMenu(request: request, id: id, imageFile: imageFile);
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
    final res = await ref.read(menuRepositoryProvider).deleteMenu(
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

  ///
  void onSort({required String column, required String direction}) {
    this.column = column;
    this.direction = direction;
    fetchMenus(isRefresh: true);
  }

  ///
  void onSearch({required Map<String, dynamic> advSearch}) {
    if (this.advSearch == advSearch) return;
    this.advSearch = advSearch;

    refresh();
  }
}
