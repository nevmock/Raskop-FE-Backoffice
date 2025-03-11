// ignore_for_file: public_member_api_docs

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:iconify_flutter/iconify_flutter.dart';
import 'package:iconify_flutter/icons/eva.dart';
import 'package:iconify_flutter/icons/ic.dart';
import 'package:intl/intl.dart';
import 'package:raskop_fe_backoffice/res/assets.dart';
import 'package:raskop_fe_backoffice/res/paths.dart';
import 'package:raskop_fe_backoffice/res/strings.dart';
import 'package:raskop_fe_backoffice/shared/const.dart';
import 'package:raskop_fe_backoffice/src/common/widgets/custom_loading_indicator_widget.dart';
import 'package:raskop_fe_backoffice/src/menu/application/menu_controller.dart';
import 'package:raskop_fe_backoffice/src/menu/domain/entities/menu_entity.dart';
import 'package:raskop_fe_backoffice/src/order/presentation/widgets/dynamic_height_grid_view_widget.dart';
import 'package:raskop_fe_backoffice/src/order/presentation/widgets/group_button_widget.dart';

/// Menu Type Filter
enum MenuType { all, food, coffee, nonCoffee, desert, other }

const List<(MenuType, String)> menuTypeOptions = <(MenuType, String)>[
  (MenuType.all, 'All'),
  (MenuType.food, 'Food'),
  (MenuType.coffee, 'Coffee'),
  (MenuType.nonCoffee, 'Non-Coffee'),
  (MenuType.desert, 'Desert'),
  (MenuType.other, 'Other'),
];

///
class InputMenuScreen extends ConsumerStatefulWidget {
  ///
  const InputMenuScreen({
    required this.orderId,
    required this.orderList,
    required this.onBack,
    required this.isInput,
    required this.orderMenu,
    super.key,
  });

  final VoidCallback onBack;

  final bool isInput;

  final List<(String, double, int, String)> orderMenu;

  final List<Map<String, dynamic>> orderList;

  final String orderId;

  @override
  ConsumerState<InputMenuScreen> createState() => _InputMenuScreenState();
}

class _InputMenuScreenState extends ConsumerState<InputMenuScreen> {
  AsyncValue<List<MenuEntity>> get menus => ref.watch(menuControllerProvider);
  TextEditingController notes = TextEditingController();
  TextEditingController search = TextEditingController();
  int qty = 1;
  double grandTotal = 0;
  bool isLastStep = false;
  final List<bool> toggleMenuType =
      MenuType.values.map((MenuType e) => e == MenuType.all).toList();

  List<bool> isExpanded = [];

  void toggleExpansion(int index) {
    setState(() {
      // Toggle Expand and Collapsed Menu Item
      for (var i = 0; i < 20; i++) {
        if (i == index) {
          isExpanded[i] = !isExpanded[i];
        } else {
          isExpanded[i] = i == index;
        }
      }
      qty = 1;
      notes.value = TextEditingValue.empty;
    });
  }

  @override
  void initState() {
    super.initState();
    grandTotal = widget.orderMenu.fold(
      0,
      (a, b) => a + (b.$2 * b.$3),
    );
  }

  void onSearch() {
    ref.read(menuControllerProvider.notifier).onSearch(
      advSearch: {
        'withDeleted': false,
        'isActive': true,
        'name': search.text,
        if (double.tryParse(search.text) != null)
          'price': double.tryParse(search.text),
      },
    );
  }

  bool isScrollableSheetDisplayed = false;
  void displayScrollableSheet() {
    setState(() {
      isScrollableSheetDisplayed = true;
    });
  }

  Timer? debounceTimer;

  void debounceSearch() {
    if (debounceTimer?.isActive ?? false) debounceTimer!.cancel();
    debounceTimer = Timer(const Duration(milliseconds: 500), onSearch);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: LayoutBuilder(
        builder: (context, constraints) {
          if (constraints.maxWidth > 500) {
            return Padding(
              padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 10.h),
              child: Row(
                children: [
                  AnimatedContainer(
                    width: MediaQuery.of(context).size.width * 0.55,
                    duration: const Duration(milliseconds: 10),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Card(
                          elevation: 3,
                          color: Colors.white,
                          child: Padding(
                            padding: EdgeInsets.symmetric(
                              horizontal: 10.w,
                              vertical: 10.h,
                            ),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                Material(
                                  type: MaterialType.button,
                                  borderRadius: const BorderRadius.all(
                                    Radius.circular(50),
                                  ),
                                  color: Colors.white,
                                  elevation: 5,
                                  child: BackButton(
                                    color: Colors.black,
                                    onPressed: widget.onBack,
                                  ),
                                ),
                                Expanded(
                                  flex: 2,
                                  child: Image.asset(
                                    ImageAssets.raskop,
                                    width: 100.w,
                                    height: 50.h,
                                    scale: 1 / 5,
                                  ),
                                ),
                                Expanded(
                                  flex: 6,
                                  child: Container(
                                    padding: EdgeInsets.symmetric(
                                      horizontal: 15.w,
                                    ),
                                    decoration: BoxDecoration(
                                      border: Border.all(
                                        color: hexToColor('#E1E1E1'),
                                      ),
                                      borderRadius: const BorderRadius.all(
                                        Radius.circular(30),
                                      ),
                                    ),
                                    child: TextFormField(
                                      controller: search,
                                      onChanged: (val) {
                                        debounceSearch();
                                      },
                                      onFieldSubmitted: (val) {
                                        onSearch();
                                      },
                                      textAlignVertical:
                                          TextAlignVertical.center,
                                      decoration: InputDecoration(
                                        filled: false,
                                        border: InputBorder.none,
                                        suffixIcon: Icon(
                                          Icons.search,
                                          size: 20.sp,
                                        ),
                                        hintText: 'Temukan Menu...',
                                        hintStyle: TextStyle(
                                          color: Colors.black.withOpacity(0.3),
                                          fontWeight: FontWeight.w400,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 10.h,
                        ),
                        SizedBox(
                          height: 35,
                          child: GroupButton(
                            isSelected: toggleMenuType,
                            onPressed: (int idx) {
                              setState(() {
                                for (var i = 0;
                                    i < toggleMenuType.length;
                                    i++) {
                                  toggleMenuType[i] = i == idx;
                                }
                                if (menuTypeOptions.elementAt(idx).$1 ==
                                    MenuType.all) {
                                  ref
                                      .read(menuControllerProvider.notifier)
                                      .onSearch(
                                    advSearch: {
                                      'withDeleted': false,
                                      'isActive': true,
                                    },
                                  );
                                } else {
                                  ref
                                      .read(menuControllerProvider.notifier)
                                      .onSearch(
                                    advSearch: {
                                      'category':
                                          menuTypeOptions.elementAt(idx).$2,
                                      'withDeleted': false,
                                      'isActive': true,
                                    },
                                  );
                                }
                              });
                            },
                            borderRadius:
                                const BorderRadius.all(Radius.circular(50)),
                            children: menuTypeOptions
                                .map(
                                  ((MenuType, String) menu) => Padding(
                                    padding: EdgeInsets.symmetric(
                                      horizontal: 10.w,
                                    ),
                                    child: Center(
                                      child: Text(
                                        menu.$2,
                                        textAlign: TextAlign.center,
                                        maxLines: 2,
                                        style: TextStyle(
                                          fontSize: 12.sp,
                                          color: Colors.white,
                                        ),
                                      ),
                                    ),
                                  ),
                                )
                                .toList(),
                          ),
                        ),
                        SizedBox(
                          height: 10.h,
                        ),
                        Expanded(
                          child: SizedBox(
                            height: MediaQuery.of(context).size.height,
                            child: menus.when(
                              data: (data) {
                                if (isExpanded.isEmpty ||
                                    isExpanded.length !=
                                        data
                                            .where(
                                              (element) => element.isActive!,
                                            )
                                            .length) {
                                  isExpanded = List<bool>.generate(
                                    data
                                        .where(
                                          (element) => element.isActive!,
                                        )
                                        .length,
                                    (_) => false,
                                  );
                                }
                                return DynamicHeightGridView(
                                  physics:
                                      const AlwaysScrollableScrollPhysics(),
                                  itemCount: data
                                      .where((element) => element.isActive!)
                                      .length,
                                  crossAxisCount: 2,
                                  crossAxisSpacing: 20,
                                  mainAxisSpacing: 20,
                                  builder: (context, idx) {
                                    final menuActive = data
                                        .where(
                                          (element) => element.isActive!,
                                        )
                                        .toList();
                                    final menu = menuActive[idx];
                                    return GestureDetector(
                                      onTap: () {
                                        setState(() {
                                          // Toggle Expand and Collapsed Menu Item
                                          for (var i = 0;
                                              i <
                                                  data
                                                      .where(
                                                        (element) =>
                                                            element.isActive!,
                                                      )
                                                      .length;
                                              i++) {
                                            if (i == idx) {
                                              isExpanded[i] = !isExpanded[i];
                                            } else {
                                              isExpanded[i] = i == idx;
                                            }
                                          }
                                          qty = 1;
                                          notes.clear();
                                        });
                                      },
                                      child: AnimatedSwitcher(
                                        duration:
                                            const Duration(milliseconds: 300),
                                        transitionBuilder: (child, animation) {
                                          return ScaleTransition(
                                            scale: animation,
                                            child: child,
                                          );
                                        },
                                        child: widget.isInput
                                            ? isExpanded[idx]
                                                ? buildExpandedMenuItem(
                                                    index: idx,
                                                    menuName: menu.name,
                                                    menuPrice: menu.price,
                                                    imageUri: menu.imageUri,
                                                    qty: qty,
                                                    onDecrement: () {
                                                      setState(() {
                                                        if (qty == 1) {
                                                          qty = 1;
                                                        } else {
                                                          qty--;
                                                        }
                                                      });
                                                    },
                                                    onIncrement: () {
                                                      setState(() {
                                                        qty++;
                                                      });
                                                    },
                                                    onAdd: () {
                                                      setState(() {
                                                        // if (widget.orderMenu.isNotEmpty && widget.orderList.isNotEmpty) {
                                                        //   // widget.orderList.where((e) => );
                                                        // }
                                                        // widget.orderMenu.add(
                                                        //   (
                                                        //     menu.name,
                                                        //     menu.price,
                                                        //     qty,
                                                        //     notes.text
                                                        //   ),
                                                        // );
                                                        // widget.orderList.add({
                                                        //   'id': menu.id,
                                                        //   'quantity': qty,
                                                        //   if (notes
                                                        //       .text.isNotEmpty)
                                                        //     'note': notes.text,
                                                        // });

                                                        // 1. Cek apakah menu sudah ada di orderMenu berdasarkan nama menu
                                                        final menuIndex = widget
                                                            .orderMenu
                                                            .indexWhere(
                                                          (e) =>
                                                              e.$1 == menu.name,
                                                        );

                                                        if (menuIndex != -1) {
                                                          // Jika menu sudah ada, update quantity dan notes
                                                          widget.orderMenu[
                                                              menuIndex] = (
                                                            menu.name,
                                                            menu.price,
                                                            widget
                                                                    .orderMenu[
                                                                        menuIndex]
                                                                    .$3 +
                                                                qty, // Tambahkan qty lama dengan yang baru
                                                            notes.text
                                                                    .isNotEmpty
                                                                ? notes.text
                                                                : widget
                                                                    .orderMenu[
                                                                        menuIndex]
                                                                    .$4
                                                          );
                                                        } else {
                                                          // Jika belum ada, tambahkan menu baru
                                                          widget.orderMenu.add(
                                                            (
                                                              menu.name,
                                                              menu.price,
                                                              qty,
                                                              notes.text
                                                            ),
                                                          );
                                                        }

                                                        // 2. Cek apakah menu sudah ada di orderList berdasarkan id
                                                        final orderIndex =
                                                            widget.orderList
                                                                .indexWhere(
                                                          (e) =>
                                                              e['id'] ==
                                                              menu.id,
                                                        );

                                                        if (orderIndex != -1) {
                                                          // Jika menu sudah ada, update quantity dan notes
                                                          // ignore: avoid_dynamic_calls
                                                          widget.orderList[
                                                                  orderIndex][
                                                              'quantity'] += qty;
                                                          if (notes.text
                                                              .isNotEmpty) {
                                                            widget.orderList[
                                                                        orderIndex]
                                                                    ['note'] =
                                                                notes.text;
                                                          }
                                                        } else {
                                                          // Jika belum ada, tambahkan menu baru
                                                          widget.orderList.add({
                                                            'id': menu.id,
                                                            'quantity': qty,
                                                            if (notes.text
                                                                .isNotEmpty)
                                                              'note':
                                                                  notes.text,
                                                          });
                                                        }
                                                        grandTotal = widget
                                                            .orderMenu
                                                            .fold(
                                                          0,
                                                          (a, b) =>
                                                              a + (b.$2 * b.$3),
                                                        );
                                                      });
                                                    },
                                                    notes: notes,
                                                    context: context,
                                                    isWideScreen: true,
                                                    onNotesTap: () {},
                                                  )
                                                : buildCollapsedMenuItem(
                                                    index: idx,
                                                    context: context,
                                                    isWideScreen: true,
                                                    menuName: menu.name,
                                                    imageUri: menu.imageUri,
                                                    price: menu.price,
                                                  )
                                            : buildCollapsedMenuItem(
                                                index: idx,
                                                context: context,
                                                isWideScreen: true,
                                                menuName: menu.name,
                                                imageUri: menu.imageUri,
                                                price: menu.price,
                                              ),
                                      ),
                                    );
                                  },
                                );
                              },
                              error: (error, stackTrace) => Center(
                                child: Text(
                                  error.toString() + stackTrace.toString(),
                                ),
                              ),
                              loading: () =>
                                  const Center(child: CustomLoadingIndicator()),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const Spacer(),
                  AnimatedContainer(
                    width: MediaQuery.of(context).size.width * 0.32,
                    duration: const Duration(milliseconds: 10),
                    child: Material(
                      color: Colors.white,
                      type: MaterialType.card,
                      shadowColor: Colors.black38,
                      shape: Border(
                        left: BorderSide(
                          color: hexToColor('#E1E1E1'),
                          width: 1.2,
                        ),
                      ),
                      child: Padding(
                        padding: EdgeInsets.symmetric(
                          horizontal: 20.w,
                          vertical: 10.h,
                        ),
                        child: Column(
                          children: [
                            Row(
                              children: [
                                Text(
                                  'Nomor ID',
                                  style: TextStyle(fontSize: 14.sp),
                                ),
                                const Spacer(),
                                Flexible(
                                  flex: 5,
                                  child: Text(
                                    maxLines: 2,
                                    widget.isInput
                                        ? 'auto-generated after create'
                                        : widget.orderId,
                                    style: TextStyle(
                                      color: hexToColor('#8E8E8E'),
                                      overflow: TextOverflow.ellipsis,
                                      fontSize: 14.sp,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(
                              height: 30.h,
                            ),
                            Expanded(
                              child: SizedBox(
                                child: widget.orderMenu.isNotEmpty
                                    ? ListView.builder(
                                        itemCount: widget.orderMenu.isEmpty
                                            ? 0
                                            : widget.orderMenu.length,
                                        itemBuilder: (ctx, idx) {
                                          return itemCard(
                                            menuName: widget.orderMenu[idx].$1,
                                            price: widget.orderMenu[idx].$2,
                                            qty: widget.orderMenu[idx].$3,
                                            notes: widget.orderMenu[idx].$4,
                                            context: context,
                                            onRemoved: () {
                                              setState(() {
                                                widget.orderMenu.removeAt(idx);
                                                widget.orderList.removeAt(idx);
                                                grandTotal =
                                                    widget.orderMenu.fold(
                                                  0,
                                                  (a, b) => a + (b.$2 * b.$3),
                                                );
                                              });
                                            },
                                            isWideScreen: true,
                                            isInput: widget.isInput,
                                          );
                                        },
                                      )
                                    : null,
                              ),
                            ),
                            SizedBox(
                              height: 5.h,
                            ),
                            Card(
                              shape: RoundedRectangleBorder(
                                side: BorderSide(color: hexToColor('#E1E1E1')),
                                borderRadius:
                                    const BorderRadius.all(Radius.circular(50)),
                              ),
                              color: Colors.white,
                              child: Padding(
                                padding: EdgeInsets.symmetric(
                                  horizontal: 15.w,
                                  vertical: 12.h,
                                ),
                                child: Row(
                                  children: [
                                    Text(
                                      'Total\t ',
                                      style: TextStyle(
                                        fontWeight: FontWeight.w400,
                                        color: Colors.black,
                                        fontSize: 14.sp,
                                        overflow: TextOverflow.fade,
                                      ),
                                    ),
                                    const Spacer(),
                                    Text(
                                      NumberFormat.simpleCurrency(
                                        locale: 'id-ID',
                                        name: 'Rp',
                                        decimalDigits: 2,
                                      ).format(grandTotal),
                                      style: TextStyle(
                                        fontWeight: FontWeight.w400,
                                        color: Colors.black,
                                        fontSize: 14.sp,
                                        overflow: TextOverflow.fade,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            Card(
                              shape: const RoundedRectangleBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(50)),
                              ),
                              color: hexToColor('#1F4940'),
                              child: InkWell(
                                borderRadius:
                                    const BorderRadius.all(Radius.circular(50)),
                                onTap: widget.onBack,
                                child: Padding(
                                  padding: EdgeInsets.symmetric(
                                    horizontal: 15.w,
                                    vertical: 12.h,
                                  ),
                                  child: Row(
                                    children: [
                                      Text(
                                        widget.isInput
                                            ? 'Simpan\t'
                                            : 'Kembali\t',
                                        style: TextStyle(
                                          fontWeight: FontWeight.w400,
                                          color: Colors.white,
                                          fontSize: 14.sp,
                                          overflow: TextOverflow.fade,
                                        ),
                                      ),
                                      const Spacer(),
                                      Icon(
                                        Icons.arrow_forward_ios_rounded,
                                        color: Colors.white,
                                        size: 14.sp,
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            );
          } else {
            return Padding(
              padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 5.h),
              child: Stack(
                children: [
                  Positioned(
                    top: 0,
                    left: 0,
                    right: 0,
                    child: AnimatedContainer(
                      width: MediaQuery.of(context).size.width,
                      duration: const Duration(milliseconds: 10),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Card(
                            elevation: 3,
                            color: Colors.white,
                            child: Padding(
                              padding: EdgeInsets.symmetric(
                                horizontal: 5.w,
                                vertical: 5.h,
                              ),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [
                                  Material(
                                    type: MaterialType.button,
                                    borderRadius: const BorderRadius.all(
                                      Radius.circular(50),
                                    ),
                                    color: Colors.white,
                                    elevation: 5,
                                    child: BackButton(
                                      color: Colors.black,
                                      onPressed: widget.onBack,
                                    ),
                                  ),
                                  Expanded(
                                    flex: 2,
                                    child: Image.asset(
                                      ImageAssets.raskop,
                                      width: 100.w,
                                      height: 50.h,
                                      scale: 1 / 5,
                                      fit: BoxFit.contain,
                                    ),
                                  ),
                                  Expanded(
                                    flex: 6,
                                    child: Container(
                                      margin:
                                          EdgeInsets.symmetric(horizontal: 5.w),
                                      padding: EdgeInsets.symmetric(
                                        horizontal: 15.w,
                                      ),
                                      decoration: BoxDecoration(
                                        border: Border.all(
                                          color: hexToColor('#E1E1E1'),
                                        ),
                                        borderRadius: const BorderRadius.all(
                                          Radius.circular(30),
                                        ),
                                      ),
                                      child: TextFormField(
                                        controller: search,
                                        onChanged: (val) {
                                          debounceSearch();
                                        },
                                        onFieldSubmitted: (val) {
                                          onSearch();
                                        },
                                        textAlignVertical:
                                            TextAlignVertical.center,
                                        decoration: InputDecoration(
                                          filled: false,
                                          border: InputBorder.none,
                                          suffixIcon: Icon(
                                            Icons.search,
                                            size: 20.sp,
                                          ),
                                          hintText: 'Temukan Menu...',
                                          hintStyle: TextStyle(
                                            color:
                                                Colors.black.withOpacity(0.3),
                                            fontWeight: FontWeight.w400,
                                            fontSize: 12.sp,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          SizedBox(
                            height: 10.h,
                          ),
                          GroupButton(
                            isSelected: toggleMenuType,
                            onPressed: (int idx) {
                              setState(() {
                                for (var i = 0;
                                    i < toggleMenuType.length;
                                    i++) {
                                  toggleMenuType[i] = i == idx;
                                }
                                if (menuTypeOptions.elementAt(idx).$1 ==
                                    MenuType.all) {
                                  ref
                                      .read(menuControllerProvider.notifier)
                                      .onSearch(
                                    advSearch: {
                                      'withDeleted': false,
                                      'isActive': true,
                                    },
                                  );
                                } else {
                                  ref
                                      .read(menuControllerProvider.notifier)
                                      .onSearch(
                                    advSearch: {
                                      'category':
                                          menuTypeOptions.elementAt(idx).$2,
                                      'withDeleted': false,
                                      'isActive': true,
                                    },
                                  );
                                }
                              });
                            },
                            borderRadius:
                                const BorderRadius.all(Radius.circular(50)),
                            children: menuTypeOptions
                                .map(
                                  ((MenuType, String) menu) => Padding(
                                    padding: EdgeInsets.symmetric(
                                      horizontal: 10.w,
                                    ),
                                    child: Center(
                                      child: Text(
                                        menu.$2,
                                        textAlign: TextAlign.center,
                                        maxLines: 2,
                                        style: TextStyle(
                                          fontSize: 12.sp,
                                          color: Colors.white,
                                        ),
                                      ),
                                    ),
                                  ),
                                )
                                .toList(),
                          ),
                          SizedBox(
                            height: 10.h,
                          ),
                          SizedBox(
                            height: MediaQuery.of(context).size.height * 0.8,
                            child: menus.when(
                              data: (data) {
                                if (isExpanded.isEmpty ||
                                    isExpanded.length !=
                                        data
                                            .where(
                                              (element) => element.isActive!,
                                            )
                                            .length) {
                                  isExpanded = List<bool>.generate(
                                    data
                                        .where(
                                          (element) => element.isActive!,
                                        )
                                        .length,
                                    (_) => false,
                                  );
                                }
                                return DynamicHeightGridView(
                                  itemCount: data
                                      .where(
                                        (element) => element.isActive!,
                                      )
                                      .length,
                                  crossAxisCount: 1,
                                  crossAxisSpacing: 20,
                                  mainAxisSpacing: 20,
                                  builder: (context, idx) {
                                    final menuActive = data
                                        .where(
                                          (element) => element.isActive!,
                                        )
                                        .toList();
                                    final menu = menuActive[idx];
                                    return GestureDetector(
                                      onTap: () {
                                        setState(() {
                                          // Toggle Expand and Collapsed Menu Item
                                          for (var i = 0;
                                              i <
                                                  data
                                                      .where(
                                                        (element) =>
                                                            element.isActive!,
                                                      )
                                                      .length;
                                              i++) {
                                            if (i == idx) {
                                              isExpanded[i] = !isExpanded[i];
                                            } else {
                                              isExpanded[i] = i == idx;
                                            }
                                          }
                                          qty = 1;
                                          notes.clear();
                                        });
                                      },
                                      child: AnimatedSwitcher(
                                        duration:
                                            const Duration(milliseconds: 300),
                                        transitionBuilder: (child, animation) {
                                          return ScaleTransition(
                                            scale: animation,
                                            child: child,
                                          );
                                        },
                                        child: widget.isInput
                                            ? isExpanded[idx]
                                                ? buildExpandedMenuItem(
                                                    index: idx,
                                                    menuName: menu.name,
                                                    menuPrice: menu.price,
                                                    imageUri: menu.imageUri,
                                                    qty: qty,
                                                    onDecrement: () {
                                                      setState(() {
                                                        if (qty == 1) {
                                                          qty = 1;
                                                        } else {
                                                          qty--;
                                                        }
                                                      });
                                                    },
                                                    onIncrement: () {
                                                      setState(() {
                                                        qty++;
                                                      });
                                                    },
                                                    onAdd: () {
                                                      setState(() {
                                                        widget.orderMenu.add(
                                                          (
                                                            menu.name,
                                                            menu.price,
                                                            qty,
                                                            notes.text
                                                          ),
                                                        );
                                                        widget.orderList.add({
                                                          'id': menu.id,
                                                          'quantity': qty,
                                                          if (notes
                                                              .text.isNotEmpty)
                                                            'note': notes.text,
                                                        });

                                                        grandTotal = widget
                                                            .orderMenu
                                                            .fold(
                                                          0,
                                                          (a, b) =>
                                                              a + (b.$2 * b.$3),
                                                        );
                                                      });
                                                    },
                                                    notes: notes,
                                                    context: context,
                                                    isWideScreen: false,
                                                    onNotesTap: () {},
                                                  )
                                                : buildCollapsedMenuItem(
                                                    index: idx,
                                                    context: context,
                                                    isWideScreen: false,
                                                    menuName: menu.name,
                                                    imageUri: menu.imageUri,
                                                    price: menu.price,
                                                  )
                                            : buildCollapsedMenuItem(
                                                index: idx,
                                                context: context,
                                                isWideScreen: false,
                                                menuName: menu.name,
                                                imageUri: menu.imageUri,
                                                price: menu.price,
                                              ),
                                      ),
                                    );
                                  },
                                );
                              },
                              error: (error, stackTrace) => Center(
                                child: Text(
                                  error.toString() + stackTrace.toString(),
                                ),
                              ),
                              loading: () =>
                                  const Center(child: CustomLoadingIndicator()),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Positioned(
                    bottom: isScrollableSheetDisplayed ? null : 0,
                    left: isScrollableSheetDisplayed
                        ? null
                        : MediaQuery.of(context).size.width * 0.32,
                    child: isScrollableSheetDisplayed
                        ? DraggableScrollableSheet(
                            initialChildSize: 0.15,
                            minChildSize: 0.15,
                            builder: (context, scrollController) {
                              return Material(
                                color: Colors.white,
                                elevation: 10,
                                shape: RoundedRectangleBorder(
                                  side: BorderSide(
                                    color: hexToColor('#E1E1E1'),
                                  ),
                                  borderRadius: const BorderRadius.only(
                                    topLeft: Radius.circular(30),
                                    topRight: Radius.circular(30),
                                  ),
                                ),
                                child: SingleChildScrollView(
                                  controller: scrollController,
                                  child: Padding(
                                    padding: EdgeInsets.symmetric(
                                      horizontal: 20.w,
                                      vertical: 10.h,
                                    ),
                                    child: Column(
                                      children: [
                                        SizedBox(
                                          width: double.infinity,
                                          child: Align(
                                            alignment: Alignment.topCenter,
                                            child: Container(
                                              margin:
                                                  const EdgeInsets.symmetric(
                                                vertical: 8,
                                              ),
                                              width: 100,
                                              height: 10,
                                              decoration: BoxDecoration(
                                                color: hexToColor('#8E8E8E'),
                                                borderRadius:
                                                    BorderRadius.circular(8),
                                              ),
                                            ),
                                          ),
                                        ),
                                        Row(
                                          children: [
                                            Text(
                                              'Nomor ID',
                                              style: TextStyle(fontSize: 14.sp),
                                            ),
                                            const Spacer(),
                                            Flexible(
                                              flex: 5,
                                              child: Text(
                                                maxLines: 2,
                                                widget.isInput
                                                    ? 'auto-generated after create'
                                                    : widget.orderId,
                                                style: TextStyle(
                                                  color: hexToColor('#8E8E8E'),
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                  fontSize: 14.sp,
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                        SizedBox(
                                          height: 30.h,
                                        ),
                                        SizedBox(
                                          height: MediaQuery.of(context)
                                                  .size
                                                  .height *
                                              0.5,
                                          child: widget.orderMenu.isNotEmpty
                                              ? ListView.builder(
                                                  itemCount: widget
                                                          .orderMenu.isEmpty
                                                      ? 0
                                                      : widget.orderMenu.length,
                                                  itemBuilder: (ctx, idx) {
                                                    return itemCard(
                                                      menuName: widget
                                                          .orderMenu[idx].$1,
                                                      price: widget
                                                          .orderMenu[idx].$2,
                                                      qty: widget
                                                          .orderMenu[idx].$3,
                                                      notes: widget
                                                          .orderMenu[idx].$4,
                                                      context: context,
                                                      onRemoved: () {
                                                        setState(() {
                                                          widget.orderMenu
                                                              .removeAt(
                                                            idx,
                                                          );
                                                          widget.orderList
                                                              .removeAt(idx);
                                                          grandTotal = widget
                                                              .orderMenu
                                                              .fold(
                                                            0,
                                                            (a, b) =>
                                                                a +
                                                                (b.$2 * b.$3),
                                                          );
                                                        });
                                                      },
                                                      isWideScreen: false,
                                                      isInput: widget.isInput,
                                                    );
                                                  },
                                                )
                                              : null,
                                        ),
                                        SizedBox(
                                          height: 5.h,
                                        ),
                                        Card(
                                          shape: RoundedRectangleBorder(
                                            side: BorderSide(
                                              color: hexToColor('#E1E1E1'),
                                            ),
                                            borderRadius:
                                                const BorderRadius.all(
                                              Radius.circular(50),
                                            ),
                                          ),
                                          color: Colors.white,
                                          child: Padding(
                                            padding: EdgeInsets.symmetric(
                                              horizontal: 15.w,
                                              vertical: 12.h,
                                            ),
                                            child: Row(
                                              children: [
                                                Text(
                                                  'Total\t ',
                                                  style: TextStyle(
                                                    fontWeight: FontWeight.w400,
                                                    color: Colors.black,
                                                    fontSize: 14.sp,
                                                    overflow: TextOverflow.fade,
                                                  ),
                                                ),
                                                const Spacer(),
                                                Text(
                                                  NumberFormat.simpleCurrency(
                                                    locale: 'id-ID',
                                                    name: 'Rp',
                                                    decimalDigits: 2,
                                                  ).format(grandTotal),
                                                  style: TextStyle(
                                                    fontWeight: FontWeight.w400,
                                                    color: Colors.black,
                                                    fontSize: 14.sp,
                                                    overflow: TextOverflow.fade,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                        Card(
                                          shape: const RoundedRectangleBorder(
                                            borderRadius: BorderRadius.all(
                                              Radius.circular(50),
                                            ),
                                          ),
                                          color: hexToColor('#1F4940'),
                                          child: InkWell(
                                            borderRadius:
                                                const BorderRadius.all(
                                              Radius.circular(50),
                                            ),
                                            onTap: widget.onBack,
                                            child: Padding(
                                              padding: EdgeInsets.symmetric(
                                                horizontal: 15.w,
                                                vertical: 12.h,
                                              ),
                                              child: Row(
                                                children: [
                                                  Text(
                                                    widget.isInput
                                                        ? 'Simpan\t'
                                                        : 'Kembali\t',
                                                    style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.w400,
                                                      color: Colors.white,
                                                      fontSize: 14.sp,
                                                      overflow:
                                                          TextOverflow.fade,
                                                    ),
                                                  ),
                                                  const Spacer(),
                                                  Icon(
                                                    Icons
                                                        .arrow_forward_ios_rounded,
                                                    color: Colors.white,
                                                    size: 14.sp,
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              );
                            },
                          )
                        : ClipRRect(
                            child: TextButton(
                              onPressed: displayScrollableSheet,
                              style: TextButton.styleFrom(
                                backgroundColor: hexToColor('#1F4940'),
                              ),
                              child: Center(
                                child: Text(
                                  'Lihat Pesanan',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    fontSize: 12.sp,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ),
                          ),
                  ),
                ],
              ),
            );
          }
        },
      ),
    );
  }
}

Widget itemCard({
  required String menuName,
  required double price,
  required int qty,
  required VoidCallback onRemoved,
  required BuildContext context,
  required bool isWideScreen,
  required bool isInput,
  String? notes,
}) {
  final currency = NumberFormat.simpleCurrency(
    locale: 'id_ID',
    name: 'Rp',
    decimalDigits: 2,
  );
  return Card(
    color: Colors.white,
    shape: RoundedRectangleBorder(
      side: BorderSide(color: hexToColor('#E1E1E1')),
      borderRadius: const BorderRadius.all(Radius.circular(70)),
    ),
    child: Padding(
      padding: EdgeInsets.symmetric(horizontal: 5.w, vertical: 5.h),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Expanded(
            flex: 6,
            child: Padding(
              padding: const EdgeInsets.only(left: 10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    menuName,
                    maxLines: 2,
                    style: TextStyle(
                      fontSize: 14.sp,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  Text.rich(
                    maxLines: 2,
                    TextSpan(
                      children: [
                        TextSpan(
                          text: currency.format(price),
                          style: TextStyle(fontSize: 10.sp),
                        ),
                        TextSpan(
                          text: ' x ',
                          style: TextStyle(fontSize: 10.sp),
                        ),
                        TextSpan(
                          text: qty.toString(),
                          style: TextStyle(fontSize: 10.sp),
                        ),
                        TextSpan(
                          text: ' = ',
                          style: TextStyle(fontSize: 10.sp),
                        ),
                        TextSpan(
                          text: currency.format(price * qty),
                          style: TextStyle(fontSize: 10.sp),
                        ),
                      ],
                    ),
                  ),
                  if (notes!.isNotEmpty)
                    Text(
                      notes,
                      style: TextStyle(fontSize: 10.sp),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                ],
              ),
            ),
          ),
          Flexible(
            flex: 2,
            child: isInput
                ? IconButton(
                    onPressed: onRemoved,
                    icon: Center(
                      child: Container(
                        width: isWideScreen
                            ? MediaQuery.of(context).size.width * 0.05
                            : MediaQuery.of(context).size.width * 0.2,
                        height: isWideScreen
                            ? MediaQuery.of(context).size.width * 0.05
                            : MediaQuery.of(context).size.width * 0.14,
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          borderRadius: const BorderRadius.all(
                            Radius.circular(30),
                          ),
                          color: hexToColor('#F64C4C'),
                        ),
                        child: const Iconify(
                          Eva.trash_fill,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  )
                : const SizedBox(),
          ),
        ],
      ),
    ),
  );
}

Widget buildCollapsedMenuItem({
  required int index,
  required BuildContext context,
  required bool isWideScreen,
  required String menuName,
  required String? imageUri,
  required double price,
}) {
  return PhysicalModel(
    borderRadius: const BorderRadius.all(Radius.circular(15)),
    color: hexToColor('#E1E1E1'),
    child: Card(
      color: Colors.white,
      elevation: 6,
      clipBehavior: Clip.antiAliasWithSaveLayer,
      child: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: 10.w,
          vertical: 10.h,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
              width: isWideScreen
                  ? MediaQuery.of(context).size.width * 0.1
                  : MediaQuery.of(context).size.width * 0.3,
              height: MediaQuery.of(context).size.height * 0.14,
              child: Container(
                decoration: const BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(20)),
                ),
                clipBehavior: Clip.hardEdge,
                child: imageUri == null || imageUri == ''
                    ? const Center(child: Text('Gambar Belum Diunggah'))
                    : imageUri.contains('https://')
                        ? Image.network(
                            imageUri,
                            fit: BoxFit.cover, // Menggunakan BoxFit.cover
                            loadingBuilder: (
                              BuildContext context,
                              Widget child,
                              ImageChunkEvent? loadingProgress,
                            ) {
                              if (loadingProgress == null) return child;
                              return Center(
                                child: CircularProgressIndicator(
                                  value: loadingProgress.expectedTotalBytes !=
                                          null
                                      ? loadingProgress.cumulativeBytesLoaded /
                                          (loadingProgress.expectedTotalBytes ??
                                              1)
                                      : null,
                                ),
                              );
                            },
                            errorBuilder: (
                              BuildContext context,
                              Object error,
                              StackTrace? stackTrace,
                            ) {
                              return Center(
                                child: Text('Failed to load image: $error'),
                              );
                            },
                          )
                        : Image.network(
                            'https://${BasePaths.baseAPIURL}/$imageUri',
                            fit: BoxFit.cover, // Menggunakan BoxFit.cover
                            loadingBuilder: (
                              BuildContext context,
                              Widget child,
                              ImageChunkEvent? loadingProgress,
                            ) {
                              if (loadingProgress == null) return child;
                              return Center(
                                child: CircularProgressIndicator(
                                  value: loadingProgress.expectedTotalBytes !=
                                          null
                                      ? loadingProgress.cumulativeBytesLoaded /
                                          (loadingProgress.expectedTotalBytes ??
                                              1)
                                      : null,
                                ),
                              );
                            },
                            errorBuilder: (
                              BuildContext context,
                              Object error,
                              StackTrace? stackTrace,
                            ) {
                              return Center(
                                child: Text('Failed to load image: $error'),
                              );
                            },
                          ),
              ),
            ),
            SizedBox(
              width: 10.w,
            ),
            Expanded(
              flex: 5,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    menuName,
                    maxLines: 2,
                    style: TextStyle(
                      fontSize: 16.sp,
                      fontWeight: FontWeight.w500,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  Text(
                    NumberFormat.simpleCurrency(
                      locale: 'id-ID',
                      name: 'Rp',
                      decimalDigits: 2,
                    ).format(price),
                    style: TextStyle(
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    ),
  );
}

Widget buildExpandedMenuItem({
  required int index,
  required int qty,
  required VoidCallback onDecrement,
  required VoidCallback onIncrement,
  required VoidCallback onAdd,
  required TextEditingController notes,
  required BuildContext context,
  required bool isWideScreen,
  required String? imageUri,
  required String menuName,
  required double menuPrice,
  required VoidCallback onNotesTap,
}) {
  return Card(
    shadowColor: hexToColor('#000000'),
    shape: RoundedRectangleBorder(
      side: BorderSide(color: hexToColor('#B6714A'), width: 3),
      borderRadius: const BorderRadius.all(Radius.circular(20)),
    ),
    color: hexToColor('#FCF4EF'),
    elevation: 4.5,
    clipBehavior: Clip.antiAliasWithSaveLayer,
    child: Padding(
      padding: EdgeInsets.symmetric(
        horizontal: 15.w,
        vertical: 15.h,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(
                width: isWideScreen
                    ? MediaQuery.of(context).size.width * 0.1
                    : MediaQuery.of(context).size.width * 0.3,
                height: MediaQuery.of(context).size.height * 0.15,
                child: Container(
                  decoration: const BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(20)),
                  ),
                  clipBehavior: Clip.hardEdge,
                  child: imageUri == null || imageUri == ''
                      ? const Center(child: Text('Gambar Belum Diunggah'))
                      : imageUri.contains('https://')
                          ? Image.network(
                              imageUri,
                              fit: BoxFit.cover, // Menggunakan BoxFit.cover
                              loadingBuilder: (
                                BuildContext context,
                                Widget child,
                                ImageChunkEvent? loadingProgress,
                              ) {
                                if (loadingProgress == null) return child;
                                return Center(
                                  child: CircularProgressIndicator(
                                    value: loadingProgress.expectedTotalBytes !=
                                            null
                                        ? loadingProgress
                                                .cumulativeBytesLoaded /
                                            (loadingProgress
                                                    .expectedTotalBytes ??
                                                1)
                                        : null,
                                  ),
                                );
                              },
                              errorBuilder: (
                                BuildContext context,
                                Object error,
                                StackTrace? stackTrace,
                              ) {
                                return Center(
                                  child: Text(
                                    'Failed to load image: $error',
                                  ),
                                );
                              },
                            )
                          : Image.network(
                              'https://${BasePaths.baseAPIURL}/$imageUri',
                              fit: BoxFit.cover, // Menggunakan BoxFit.cover
                              loadingBuilder: (
                                BuildContext context,
                                Widget child,
                                ImageChunkEvent? loadingProgress,
                              ) {
                                if (loadingProgress == null) return child;
                                return Center(
                                  child: CircularProgressIndicator(
                                    value: loadingProgress.expectedTotalBytes !=
                                            null
                                        ? loadingProgress
                                                .cumulativeBytesLoaded /
                                            (loadingProgress
                                                    .expectedTotalBytes ??
                                                1)
                                        : null,
                                  ),
                                );
                              },
                              errorBuilder: (
                                BuildContext context,
                                Object error,
                                StackTrace? stackTrace,
                              ) {
                                return Center(
                                  child: Text(
                                    'Failed to load image: $error',
                                  ),
                                );
                              },
                            ),
                ),
              ),
              SizedBox(
                width: 10.w,
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      menuName,
                      maxLines: 2,
                      style: TextStyle(
                        fontSize: 16.sp,
                        fontWeight: FontWeight.w500,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    Text(
                      NumberFormat.simpleCurrency(
                        locale: 'id-ID',
                        name: 'Rp',
                        decimalDigits: 2,
                      ).format(menuPrice),
                      style: TextStyle(
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          SizedBox(
            height: 10.h,
          ),
          Text(
            'Jumlah',
            style: TextStyle(fontSize: 14.sp, fontWeight: FontWeight.w600),
          ),
          SizedBox(
            height: 10.h,
          ),
          Row(
            children: [
              IconButton(
                onPressed: onDecrement,
                style: TextButton.styleFrom(
                  backgroundColor: hexToColor('#E38D5D'),
                ),
                icon: const Iconify(
                  Ic.round_minus,
                  color: Colors.white,
                  size: 25,
                ),
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 15.w),
                child: Text(
                  qty.toString(),
                  style: TextStyle(fontSize: 16.sp),
                ),
              ),
              IconButton(
                onPressed: onIncrement,
                style: TextButton.styleFrom(
                  backgroundColor: hexToColor('#E38D5D'),
                ),
                icon: const Icon(
                  Icons.add,
                  color: Colors.white,
                  size: 25,
                ),
              ),
              const Spacer(),
              TextButton(
                onPressed: onAdd,
                style: TextButton.styleFrom(
                  backgroundColor: hexToColor('#E38D5D'),
                ),
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 10.w),
                  child: Text(
                    AppStrings.tambahBtn,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ),
            ],
          ),
          SizedBox(
            height: 10.h,
          ),
          Container(
            padding: EdgeInsets.symmetric(
              horizontal: 8.w,
            ),
            decoration: BoxDecoration(
              border: Border.all(
                color: hexToColor('#E1E1E1'),
              ),
              borderRadius: const BorderRadius.all(
                Radius.circular(15),
              ),
              color: Colors.white,
            ),
            child: TextFormField(
              onTap: onNotesTap,
              controller: notes,
              decoration: InputDecoration(
                filled: false,
                border: InputBorder.none,
                hintText: 'Masukkan Catatan (opsional)...',
                hintStyle: TextStyle(
                  color: Colors.black.withOpacity(0.3),
                  fontWeight: FontWeight.w400,
                ),
              ),
            ),
          ),
        ],
      ),
    ),
  );
}
