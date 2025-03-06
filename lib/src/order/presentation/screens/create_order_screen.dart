// ignore_for_file: public_member_api_docs

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:iconify_flutter/iconify_flutter.dart';
import 'package:iconify_flutter/icons/eva.dart';
import 'package:iconify_flutter/icons/ic.dart';
import 'package:intl/intl.dart';
import 'package:raskop_fe_backoffice/core/core.dart';
import 'package:raskop_fe_backoffice/res/assets.dart';
import 'package:raskop_fe_backoffice/res/paths.dart';
import 'package:raskop_fe_backoffice/res/strings.dart';
import 'package:raskop_fe_backoffice/shared/const.dart';
import 'package:raskop_fe_backoffice/shared/toast.dart';
import 'package:raskop_fe_backoffice/src/common/failure/response_failure.dart';
import 'package:raskop_fe_backoffice/src/common/widgets/custom_loading_indicator_widget.dart';
import 'package:raskop_fe_backoffice/src/menu/application/menu_controller.dart';
import 'package:raskop_fe_backoffice/src/menu/domain/entities/menu_entity.dart';
import 'package:raskop_fe_backoffice/src/order/application/order_controller.dart';
import 'package:raskop_fe_backoffice/src/order/domain/entities/create_order_request_entity.dart';
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
class CreateOrderScreen extends ConsumerStatefulWidget {
  ///
  const CreateOrderScreen({required this.onBack, super.key});

  final VoidCallback onBack;

  @override
  ConsumerState<CreateOrderScreen> createState() => _CreateOrderScreenState();
}

class _CreateOrderScreenState extends ConsumerState<CreateOrderScreen> {
  AsyncValue<List<MenuEntity>> get menus => ref.watch(menuControllerProvider);
  TextEditingController notes = TextEditingController();
  TextEditingController customerName = TextEditingController();
  TextEditingController customerPhone = TextEditingController();
  TextEditingController search = TextEditingController();
  int qty = 1;
  double grandTotal = 0;
  bool isLastStep = false;
  final List<bool> toggleMenuType =
      MenuType.values.map((MenuType e) => e == MenuType.all).toList();

  final formKey = GlobalKey<FormState>();

  /// Dummy List For Summary Ordered Item Widget Testing
  List<(String, double, int, String)> dummyItemList =
      <(String, double, int, String)>[];

  List<Map<String, dynamic>> itemList = [];

  String? paymentMethod;

  bool isLoading = false;

  List<bool> isExpanded = [];

  void setLastStep() {
    setState(() {
      isLastStep = true;
    });
  }

  bool isScrollableSheetDisplayed = false;
  void displayScrollableSheet() {
    setState(() {
      isScrollableSheetDisplayed = true;
    });
  }

  void onSearch() {
    ref.read(menuControllerProvider.notifier).fetchMenus(
      // search: search.text,
      advSearch: {
        'withDeleted': false,
        'isActive': true,
        'name': search.text,
        if (double.tryParse(search.text) != null)
          'price': double.tryParse(search.text),
      },
    );
  }

  Future<void> redirectToMidtransWebView(String redirectUrl) async {
    FocusScope.of(context).unfocus();
    await context.push('/order/payment', extra: redirectUrl);
  }

  Timer? debounceTimer;

  void debounceSearch() {
    if (debounceTimer?.isActive ?? false) debounceTimer!.cancel();
    debounceTimer = Timer(const Duration(milliseconds: 500), onSearch);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
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
                                    onPressed: () async {
                                      await showConfirmationDialog(
                                        context: context,
                                        title: 'Keluar halaman ini?',
                                        onConfirm: () {
                                          context.pop();
                                          widget.onBack();
                                        },
                                        content:
                                            'Halaman ini akan terhapus secara permanen.',
                                        isWideScreen: true,
                                      );
                                    },
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
                                        suffixIcon: Padding(
                                          padding: const EdgeInsets.symmetric(
                                            horizontal: 12,
                                            vertical: 12,
                                          ),
                                          child: Iconify(
                                            IconAssets.searchIcon,
                                            size: 20.sp,
                                          ),
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
                                      .fetchMenus(
                                    advSearch: {
                                      'withDeleted': false,
                                      'isActive': true,
                                    },
                                  );
                                } else {
                                  ref
                                      .read(menuControllerProvider.notifier)
                                      .fetchMenus(
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
                                        duration: const Duration(
                                          milliseconds: 300,
                                        ),
                                        transitionBuilder: (child, animation) {
                                          return ScaleTransition(
                                            scale: animation,
                                            child: child,
                                          );
                                        },
                                        child: isExpanded[idx]
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
                                                    dummyItemList.add(
                                                      (
                                                        menu.name,
                                                        menu.price,
                                                        qty,
                                                        notes.text
                                                      ),
                                                    );
                                                    itemList.add({
                                                      'id': menu.id,
                                                      'quantity': qty,
                                                      if (notes.text.isNotEmpty)
                                                        'note': notes.text,
                                                    });
                                                    grandTotal =
                                                        dummyItemList.fold(
                                                      0,
                                                      (a, b) =>
                                                          a + (b.$2 * b.$3),
                                                    );
                                                  });
                                                },
                                                notes: notes,
                                                context: context,
                                                isWideScreen: true,
                                                onNotesTap: () {
                                                  setState(() {});
                                                },
                                              )
                                            : buildCollapsedMenuItem(
                                                index: idx,
                                                menuName: menu.name,
                                                price: menu.price,
                                                imageUri: menu.imageUri,
                                                context: context,
                                                isWideScreen: true,
                                              ),
                                      ),
                                    );
                                  },
                                );
                              },
                              error: (error, stackTrace) {
                                final err = error as ResponseFailure;
                                final finalErr =
                                    err.allError as Map<String, dynamic>;
                                return Center(
                                  child: Column(
                                    children: [
                                      Text(
                                        '${finalErr['name']} - ${finalErr['message']}',
                                        textAlign: TextAlign.center,
                                      ),
                                      TextButton(
                                        onPressed: () {
                                          ref.invalidate(
                                            menuControllerProvider,
                                          );
                                        },
                                        style: TextButton.styleFrom(
                                          backgroundColor:
                                              hexToColor('#1F4940'),
                                          shape: RoundedRectangleBorder(
                                            side: BorderSide(
                                              color: hexToColor('#E1E1E1'),
                                            ),
                                            borderRadius:
                                                const BorderRadius.all(
                                              Radius.circular(50),
                                            ),
                                          ),
                                        ),
                                        child: const Center(
                                          child: Text(
                                            'Refresh',
                                            style: TextStyle(
                                              color: Colors.white,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                );
                              },
                              loading: () => const Center(
                                child: CustomLoadingIndicator(),
                              ),
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
                                Text(
                                  maxLines: 2,
                                  'auto-generated after create',
                                  style: TextStyle(
                                    fontStyle: FontStyle.italic,
                                    color: hexToColor('#8E8E8E'),
                                    overflow: TextOverflow.ellipsis,
                                    fontSize: 14.sp,
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(
                              height: 30.h,
                            ),
                            if (isLastStep)
                              Form(
                                key: formKey,
                                autovalidateMode: AutovalidateMode.onUnfocus,
                                child: Expanded(
                                  child: ListView(
                                    children: [
                                      _buildTextFieldForLastStep(
                                        'Nama Customer',
                                        'Masukkan nama customer...',
                                        customerName,
                                        TextInputType.name,
                                      ),
                                      SizedBox(
                                        height: 10.h,
                                      ),
                                      _buildTextFieldForLastStep(
                                        'Nomor Telepon',
                                        'Masukkan nomor telepon...',
                                        customerPhone,
                                        TextInputType.phone,
                                      ),
                                      SizedBox(
                                        height: 10.h,
                                      ),
                                      Text(
                                        'Metode Pembayaran',
                                        style: TextStyle(
                                          color: Colors.black,
                                          fontWeight: FontWeight.w500,
                                          fontSize: 14.sp,
                                        ),
                                      ),
                                      SizedBox(
                                        height: 10.h,
                                      ),
                                      Row(
                                        children: [
                                          Expanded(
                                            child: _customButton(
                                              child: Image.asset(
                                                ImageAssets.qris,
                                                fit: BoxFit.fill,
                                                width: 50,
                                                height: 20,
                                              ),
                                              color: Colors.white,
                                              onTap: () {
                                                setState(() {
                                                  paymentMethod = 'other_qris';
                                                });
                                              },
                                              borderRadius:
                                                  const BorderRadius.all(
                                                Radius.circular(
                                                  15,
                                                ),
                                              ),
                                              isWideScreen: true,
                                              padding: EdgeInsets.symmetric(
                                                vertical: MediaQuery.of(
                                                      context,
                                                    ).size.height *
                                                    0.018,
                                              ),
                                              borderColor:
                                                  paymentMethod == 'other_qris'
                                                      ? Colors.green
                                                      : Colors.black,
                                              borderWidth:
                                                  paymentMethod == 'other_qris'
                                                      ? 3
                                                      : 1,
                                            ),
                                          ),
                                          const SizedBox(
                                            width: 5,
                                          ),
                                          Expanded(
                                            child: _customButton(
                                              child: const Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                children: [
                                                  Iconify(
                                                    IconAssets.bankCard,
                                                    color: Colors.black,
                                                    size: 20,
                                                  ),
                                                  SizedBox(
                                                    width: 5,
                                                  ),
                                                  Text(
                                                    'Transfer',
                                                    style: TextStyle(
                                                      color: Colors.black,
                                                      fontSize: 14,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                              color: Colors.white,
                                              onTap: () {
                                                setState(() {
                                                  paymentMethod =
                                                      'bank_transfer';
                                                });
                                              },
                                              borderRadius:
                                                  const BorderRadius.all(
                                                Radius.circular(
                                                  15,
                                                ),
                                              ),
                                              isWideScreen: true,
                                              padding: EdgeInsets.symmetric(
                                                vertical: MediaQuery.of(
                                                      context,
                                                    ).size.height *
                                                    0.018,
                                              ),
                                              borderColor: paymentMethod ==
                                                      'bank_transfer'
                                                  ? Colors.green
                                                  : Colors.black,
                                              borderWidth: paymentMethod ==
                                                      'bank_transfer'
                                                  ? 3
                                                  : 1,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              )
                            else
                              Expanded(
                                child: SizedBox(
                                  child: dummyItemList.isNotEmpty
                                      ? ListView.builder(
                                          itemCount: dummyItemList.isEmpty
                                              ? 0
                                              : dummyItemList.length,
                                          itemBuilder: (ctx, idx) {
                                            return itemCard(
                                              menuName: dummyItemList[idx].$1,
                                              price: dummyItemList[idx].$2,
                                              qty: dummyItemList[idx].$3,
                                              notes: dummyItemList[idx].$4,
                                              context: context,
                                              onRemoved: () {
                                                setState(() {
                                                  itemList.removeAt(idx);
                                                  dummyItemList.removeAt(idx);
                                                  grandTotal =
                                                      dummyItemList.fold(
                                                    0,
                                                    (a, b) => a + (b.$2 * b.$3),
                                                  );
                                                });
                                              },
                                              isWideScreen: true,
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
                                onTap: isLastStep
                                    ? isLoading
                                        ? () {}
                                        : () async {
                                            if (formKey.currentState!
                                                    .validate() &&
                                                paymentMethod != null) {
                                              setState(() {
                                                isLoading = true;
                                              });
                                              try {
                                                final res = await ref
                                                    .read(
                                                      orderControllerProvider
                                                          .notifier,
                                                    )
                                                    .createNew(
                                                      request:
                                                          CreateOrderRequestEntity(
                                                        orderBy:
                                                            customerName.text,
                                                        phoneNumber:
                                                            customerPhone.text,
                                                        menus: itemList,
                                                        paymentMethod:
                                                            paymentMethod!,
                                                      ),
                                                    );
                                                if (res.token.isNotEmpty &&
                                                    res.redirectUrl
                                                        .isNotEmpty) {
                                                  await redirectToMidtransWebView(
                                                    res.redirectUrl,
                                                  );
                                                }
                                              } on ResponseFailure catch (e) {
                                                final err = e.allError
                                                    as Map<String, dynamic>;
                                                setState(() {
                                                  Toast().showErrorToast(
                                                    context: context,
                                                    title:
                                                        'Create Order Failed',
                                                    description:
                                                        '${err['name']} - ${err['message']}',
                                                  );
                                                });
                                              } finally {
                                                setState(() {
                                                  isLoading = false;
                                                  widget.onBack();
                                                });
                                              }
                                            }
                                          }
                                    : itemList.isEmpty
                                        ? () {
                                            setState(() {
                                              Toast().showErrorToast(
                                                context: context,
                                                title: 'Validation Error',
                                                description:
                                                    'Menu Must Be Min. 1 Item!',
                                              );
                                            });
                                          }
                                        : setLastStep,
                                child: Padding(
                                  padding: EdgeInsets.symmetric(
                                    horizontal: 15.w,
                                    vertical: 12.h,
                                  ),
                                  child: isLoading
                                      ? const Center(
                                          child: CustomLoadingIndicator(
                                            color: Colors.white,
                                          ),
                                        )
                                      : Row(
                                          children: [
                                            Text(
                                              isLastStep
                                                  ? 'Tambah\t'
                                                  : 'Lanjut\t ',
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
                  SingleChildScrollView(
                    child: Positioned(
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
                                        onPressed: () async {
                                          await showConfirmationDialog(
                                            context: context,
                                            title: 'Keluar halaman ini?',
                                            onConfirm: () {
                                              context.pop();
                                              widget.onBack();
                                            },
                                            content:
                                                'Halaman ini akan terhapus secara permanen.',
                                            isWideScreen: false,
                                          );
                                        },
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
                                        margin: EdgeInsets.symmetric(
                                          horizontal: 5.w,
                                        ),
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
                                          style: const TextStyle(fontSize: 14),
                                          textAlignVertical:
                                              TextAlignVertical.center,
                                          decoration: InputDecoration(
                                            filled: false,
                                            border: InputBorder.none,
                                            suffixIcon: Padding(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                horizontal: 12,
                                              ),
                                              child: Iconify(
                                                IconAssets.searchIcon,
                                                size: 20.sp,
                                              ),
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
                                        .fetchMenus(
                                      advSearch: {
                                        'withDeleted': false,
                                        'isActive': true,
                                      },
                                    );
                                  } else {
                                    ref
                                        .read(menuControllerProvider.notifier)
                                        .fetchMenus(
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
                                loading: () => const Center(
                                  child: CustomLoadingIndicator(),
                                ),
                                error: (error, stackTrace) {
                                  final err = error as ResponseFailure;
                                  final finalErr =
                                      err.allError as Map<String, dynamic>;
                                  return Center(
                                    child: Column(
                                      children: [
                                        Text(
                                          '${finalErr['name']} - ${finalErr['message']}',
                                          textAlign: TextAlign.center,
                                        ),
                                        TextButton(
                                          onPressed: () {
                                            ref.invalidate(
                                              menuControllerProvider,
                                            );
                                          },
                                          style: TextButton.styleFrom(
                                            backgroundColor:
                                                hexToColor('#1F4940'),
                                            shape: RoundedRectangleBorder(
                                              side: BorderSide(
                                                color: hexToColor('#E1E1E1'),
                                              ),
                                              borderRadius:
                                                  const BorderRadius.all(
                                                Radius.circular(50),
                                              ),
                                            ),
                                          ),
                                          child: const Center(
                                            child: Text(
                                              'Refresh',
                                              style: TextStyle(
                                                color: Colors.white,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  );
                                },
                                data: (data) {
                                  if (isExpanded.isEmpty ||
                                      isExpanded.length !=
                                          data
                                              .where(
                                                (element) => element.isActive!,
                                              )
                                              .length) {
                                    isExpanded = List<bool>.filled(
                                      data
                                          .where(
                                            (element) => element.isActive!,
                                          )
                                          .length,
                                      false,
                                    );
                                  }
                                  return DynamicHeightGridView(
                                    shrinkWrap: true,
                                    physics:
                                        const AlwaysScrollableScrollPhysics(),
                                    itemCount: data
                                        .where((element) => element.isActive!)
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
                                          FocusScope.of(context).unfocus();
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
                                          transitionBuilder:
                                              (child, animation) {
                                            return ScaleTransition(
                                              scale: animation,
                                              child: child,
                                            );
                                          },
                                          child: isExpanded[idx]
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
                                                      dummyItemList.add(
                                                        (
                                                          menu.name,
                                                          menu.price,
                                                          qty,
                                                          notes.text
                                                        ),
                                                      );
                                                      itemList.add({
                                                        'id': menu.id,
                                                        'quantity': qty,
                                                        if (notes
                                                            .text.isNotEmpty)
                                                          'note': notes.text,
                                                      });
                                                      grandTotal =
                                                          dummyItemList.fold(
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
                                                  menuName: menu.name,
                                                  price: menu.price,
                                                  imageUri: menu.imageUri,
                                                  context: context,
                                                  isWideScreen: false,
                                                ),
                                        ),
                                      );
                                    },
                                  );
                                },
                              ),
                            ),
                          ],
                        ),
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
                                            Text(
                                              maxLines: 2,
                                              'auto-generated after create',
                                              style: TextStyle(
                                                fontStyle: FontStyle.italic,
                                                color: hexToColor('#8E8E8E'),
                                                overflow: TextOverflow.ellipsis,
                                                fontSize: 14.sp,
                                              ),
                                            ),
                                          ],
                                        ),
                                        SizedBox(
                                          height: 30.h,
                                        ),
                                        if (isLastStep)
                                          Form(
                                            key: formKey,
                                            autovalidateMode:
                                                AutovalidateMode.onUnfocus,
                                            child: SizedBox(
                                              height: MediaQuery.of(context)
                                                      .size
                                                      .height *
                                                  0.5,
                                              child: ListView(
                                                children: [
                                                  _buildTextFieldForLastStep(
                                                    'Nama Customer',
                                                    'Masukkan nama customer...',
                                                    customerName,
                                                    TextInputType.name,
                                                  ),
                                                  SizedBox(
                                                    height: 10.h,
                                                  ),
                                                  _buildTextFieldForLastStep(
                                                    'Nomor Telepon',
                                                    'Masukkan nomor telepon...',
                                                    customerPhone,
                                                    TextInputType.phone,
                                                  ),
                                                  SizedBox(
                                                    height: 10.h,
                                                  ),
                                                  Text(
                                                    'Metode Pembayaran',
                                                    style: TextStyle(
                                                      color: Colors.black,
                                                      fontWeight:
                                                          FontWeight.w500,
                                                      fontSize: 14.sp,
                                                    ),
                                                  ),
                                                  SizedBox(
                                                    height: 10.h,
                                                  ),
                                                  Row(
                                                    children: [
                                                      Expanded(
                                                        child: _customButton(
                                                          child: Image.asset(
                                                            ImageAssets.qris,
                                                            fit: BoxFit.fill,
                                                            width: 50,
                                                            height: 20,
                                                          ),
                                                          color: Colors.white,
                                                          onTap: () {
                                                            setState(() {
                                                              paymentMethod =
                                                                  'other_qris';
                                                            });
                                                          },
                                                          borderRadius:
                                                              const BorderRadius
                                                                  .all(
                                                            Radius.circular(
                                                              15,
                                                            ),
                                                          ),
                                                          isWideScreen: false,
                                                          padding: EdgeInsets
                                                              .symmetric(
                                                            vertical: MediaQuery
                                                                    .of(
                                                                  context,
                                                                ).size.height *
                                                                0.018,
                                                          ),
                                                          borderColor:
                                                              paymentMethod ==
                                                                      'other_qris'
                                                                  ? Colors.green
                                                                  : Colors
                                                                      .black,
                                                          borderWidth:
                                                              paymentMethod ==
                                                                      'other_qris'
                                                                  ? 3
                                                                  : 1,
                                                        ),
                                                      ),
                                                      const SizedBox(
                                                        width: 5,
                                                      ),
                                                      Expanded(
                                                        child: _customButton(
                                                          child: const Row(
                                                            mainAxisAlignment:
                                                                MainAxisAlignment
                                                                    .center,
                                                            children: [
                                                              Iconify(
                                                                IconAssets
                                                                    .bankCard,
                                                                color: Colors
                                                                    .black,
                                                                size: 20,
                                                              ),
                                                              SizedBox(
                                                                width: 5,
                                                              ),
                                                              Text(
                                                                'Transfer',
                                                                style:
                                                                    TextStyle(
                                                                  color: Colors
                                                                      .black,
                                                                  fontSize: 14,
                                                                ),
                                                              ),
                                                            ],
                                                          ),
                                                          color: Colors.white,
                                                          onTap: () {
                                                            setState(() {
                                                              paymentMethod =
                                                                  'bank_transfer';
                                                            });
                                                          },
                                                          borderRadius:
                                                              const BorderRadius
                                                                  .all(
                                                            Radius.circular(
                                                              15,
                                                            ),
                                                          ),
                                                          isWideScreen: false,
                                                          padding: EdgeInsets
                                                              .symmetric(
                                                            vertical: MediaQuery
                                                                    .of(
                                                                  context,
                                                                ).size.height *
                                                                0.018,
                                                          ),
                                                          borderColor:
                                                              paymentMethod ==
                                                                      'bank_transfer'
                                                                  ? Colors.green
                                                                  : Colors
                                                                      .black,
                                                          borderWidth:
                                                              paymentMethod ==
                                                                      'bank_transfer'
                                                                  ? 3
                                                                  : 1,
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ],
                                              ),
                                            ),
                                          )
                                        else
                                          SizedBox(
                                            height: MediaQuery.of(context)
                                                    .size
                                                    .height *
                                                0.5,
                                            child: dummyItemList.isNotEmpty
                                                ? ListView.builder(
                                                    itemCount: dummyItemList
                                                            .isEmpty
                                                        ? 0
                                                        : dummyItemList.length,
                                                    itemBuilder: (ctx, idx) {
                                                      return itemCard(
                                                        menuName:
                                                            dummyItemList[idx]
                                                                .$1,
                                                        price:
                                                            dummyItemList[idx]
                                                                .$2,
                                                        qty: dummyItemList[idx]
                                                            .$3,
                                                        notes:
                                                            dummyItemList[idx]
                                                                .$4,
                                                        context: context,
                                                        onRemoved: () {
                                                          setState(() {
                                                            dummyItemList
                                                                .removeAt(
                                                              idx,
                                                            );
                                                            itemList
                                                                .removeAt(idx);
                                                            grandTotal =
                                                                dummyItemList
                                                                    .fold(
                                                              0,
                                                              (a, b) =>
                                                                  a +
                                                                  (b.$2 * b.$3),
                                                            );
                                                          });
                                                        },
                                                        isWideScreen: false,
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
                                            onTap: isLastStep
                                                ? isLoading
                                                    ? () {}
                                                    : () async {
                                                        if (formKey
                                                                .currentState!
                                                                .validate() &&
                                                            paymentMethod !=
                                                                null) {
                                                          setState(() {
                                                            isLoading = true;
                                                          });
                                                          try {
                                                            final res =
                                                                await ref
                                                                    .read(
                                                                      orderControllerProvider
                                                                          .notifier,
                                                                    )
                                                                    .createNew(
                                                                      request:
                                                                          CreateOrderRequestEntity(
                                                                        orderBy:
                                                                            customerName.text,
                                                                        phoneNumber:
                                                                            customerPhone.text,
                                                                        menus:
                                                                            itemList,
                                                                        paymentMethod:
                                                                            paymentMethod!,
                                                                      ),
                                                                    );
                                                            if (res.token
                                                                    .isNotEmpty &&
                                                                res.redirectUrl
                                                                    .isNotEmpty) {
                                                              await redirectToMidtransWebView(
                                                                res.redirectUrl,
                                                              );
                                                            }
                                                          } on ResponseFailure catch (e) {
                                                            final err = e
                                                                    .allError
                                                                as Map<String,
                                                                    dynamic>;
                                                            setState(() {
                                                              Toast()
                                                                  .showErrorToast(
                                                                context:
                                                                    context,
                                                                title:
                                                                    'Create Order Failed',
                                                                description:
                                                                    '${err['name']} - ${err['message']}}',
                                                              );
                                                            });
                                                          } finally {
                                                            setState(() {
                                                              isLoading = false;
                                                              widget.onBack();
                                                            });
                                                          }
                                                        }
                                                      }
                                                : itemList.isEmpty
                                                    ? () {
                                                        setState(() {
                                                          Toast()
                                                              .showErrorToast(
                                                            context: context,
                                                            title:
                                                                'Validation Error',
                                                            description:
                                                                'Menu Must Be Min. 1 Item!',
                                                          );
                                                        });
                                                      }
                                                    : setLastStep,
                                            child: Padding(
                                              padding: EdgeInsets.symmetric(
                                                horizontal: 15.w,
                                                vertical: 12.h,
                                              ),
                                              child: isLoading
                                                  ? const Center(
                                                      child:
                                                          CustomLoadingIndicator(
                                                        color: Colors.white,
                                                      ),
                                                    )
                                                  : Row(
                                                      children: [
                                                        Text(
                                                          isLastStep
                                                              ? 'Tambah\t'
                                                              : 'Lanjut\t ',
                                                          style: TextStyle(
                                                            fontWeight:
                                                                FontWeight.w400,
                                                            color: Colors.white,
                                                            fontSize: 14.sp,
                                                            overflow:
                                                                TextOverflow
                                                                    .fade,
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

Widget _buildTextFieldForLastStep(
  String label,
  String hint,
  TextEditingController controller,
  TextInputType keytype,
) {
  return Padding(
    padding: const EdgeInsets.only(bottom: 16),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.w500,
            fontSize: 14.sp,
          ),
        ),
        SizedBox(
          height: 10.h,
        ),
        Container(
          padding: EdgeInsets.symmetric(
            horizontal: 15.w,
          ),
          decoration: BoxDecoration(
            border: Border.all(color: hexToColor('#E1E1E1')),
            borderRadius: const BorderRadius.all(
              Radius.circular(50),
            ),
          ),
          child: TextFormField(
            validator: (val) {
              if (val == null || val.isEmpty) {
                return '   Required Field\n';
              }
              if (label == 'Nama Customer' &&
                  (val.length < 3 || val.length > 150)) {
                return '   Must be min 3 char. and max 150 char.\n';
              }
              if (label == 'Nomor Telepon' &&
                  (val.length < 3 || val.length > 12)) {
                return '   Must be min 3 char. and max 12 char.\n';
              }
              return null;
            },
            keyboardType: keytype,
            controller: controller,
            style: const TextStyle(
              fontWeight: FontWeight.w400,
              color: Colors.black,
              fontSize: 14,
              overflow: TextOverflow.fade,
            ),
            decoration: InputDecoration(
              filled: false,
              border: InputBorder.none,
              hintText: hint,
              hintStyle: TextStyle(
                color: Colors.black.withOpacity(0.3),
                fontWeight: FontWeight.w400,
              ),
            ),
          ),
        ),
      ],
    ),
  );
}

Widget itemCard({
  required String menuName,
  required double price,
  required int qty,
  required VoidCallback onRemoved,
  required BuildContext context,
  required bool isWideScreen,
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
            child: IconButton(
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
            ),
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

FutureVoid showConfirmationDialog({
  required BuildContext context,
  required String title,
  required VoidCallback onConfirm,
  required String content,
  required bool isWideScreen,
}) {
  return showDialog(
    barrierDismissible: false,
    builder: (context) => Center(
      child: Container(
        padding:
            isWideScreen ? null : const EdgeInsets.symmetric(horizontal: 20),
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.all(Radius.circular(35)),
        ),
        margin: EdgeInsets.symmetric(
          horizontal: isWideScreen
              ? MediaQuery.of(context).size.width * 0.3
              : MediaQuery.of(context).size.width * 0.05,
          vertical: MediaQuery.of(context).size.height * 0.3,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Center(
              child: Text(
                title,
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.black,
                  fontSize: isWideScreen ? 35 : 24,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(
                top: 5,
                bottom: 30,
              ),
              child: Center(
                child: Text(
                  content,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    color: Colors.black,
                    fontSize: 16,
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  style: TextButton.styleFrom(
                    elevation: 5,
                    backgroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      side: BorderSide(color: hexToColor('#CACACA')),
                      borderRadius: const BorderRadius.all(Radius.circular(35)),
                    ),
                  ),
                  child: Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: isWideScreen
                          ? 50
                          : MediaQuery.of(context).size.width * 0.055,
                      vertical: 8,
                    ),
                    child: Center(
                      child: Text(
                        'Batal',
                        style: TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.w600,
                          fontSize: isWideScreen ? 18 : 14,
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(
                  width: 20,
                ),
                TextButton(
                  onPressed: onConfirm,
                  style: TextButton.styleFrom(
                    elevation: 5,
                    backgroundColor: hexToColor('#F64C4C'),
                    shape: const RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(35)),
                    ),
                  ),
                  child: Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: isWideScreen
                          ? 50
                          : MediaQuery.of(context).size.width * 0.055,
                      vertical: 8,
                    ),
                    child: Center(
                      child: Text(
                        'Keluar',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: isWideScreen ? 18 : 14,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    ),
    context: context,
  );
}

Widget _customButton({
  required Widget child,
  required Color color,
  required VoidCallback onTap,
  required BorderRadius borderRadius,
  required bool isWideScreen,
  EdgeInsetsGeometry? padding,
  EdgeInsetsGeometry? margin,
  double? width,
  double borderWidth = 0,
  Color borderColor = Colors.transparent,
}) {
  return InkWell(
    onTap: onTap,
    borderRadius: borderRadius,
    child: Container(
      padding: padding,
      margin: margin,
      width: width,
      decoration: BoxDecoration(
        borderRadius: borderRadius,
        color: color,
        border: Border.all(
          width: borderWidth,
          color: borderColor,
        ),
      ),
      child: Center(
        child: child,
      ),
    ),
  );
}
