// ignore_for_file: public_member_api_docs

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:iconify_flutter/iconify_flutter.dart';
import 'package:iconify_flutter/icons/eva.dart';
import 'package:iconify_flutter/icons/ic.dart';
import 'package:intl/intl.dart';
import 'package:raskop_fe_backoffice/res/strings.dart';
import 'package:raskop_fe_backoffice/shared/const.dart';
import 'package:raskop_fe_backoffice/src/order/presentation/widgets/dynamic_height_grid_view_widget.dart';
import 'package:raskop_fe_backoffice/src/order/presentation/widgets/group_button_widget.dart';

/// Menu Type Filter
enum MenuType { food, coffee, nonCoffee, manualBrew, mocktail }

const List<(MenuType, String)> menuTypeOptions = <(MenuType, String)>[
  (MenuType.food, 'Food'),
  (MenuType.coffee, 'Coffee'),
  (MenuType.nonCoffee, 'Non-Coffee'),
  (MenuType.manualBrew, 'Manual Brew'),
  (MenuType.mocktail, 'Mocktail'),
];

///
class CreateOrderScreen extends StatefulWidget {
  ///
  const CreateOrderScreen({required this.onBack, super.key});

  final VoidCallback onBack;

  @override
  State<CreateOrderScreen> createState() => _CreateOrderScreenState();
}

class _CreateOrderScreenState extends State<CreateOrderScreen> {
  TextEditingController notes = TextEditingController();
  TextEditingController customerName = TextEditingController();
  TextEditingController customerPhone = TextEditingController();
  int qty = 1;
  double grandTotal = 0;
  bool isLastStep = false;
  final List<bool> toggleMenuType =
      MenuType.values.map((MenuType e) => e == MenuType.food).toList();

  /// Dummy List For Summary Ordered Item Widget Testing
  List<(String, double, int, String)> dummyItemList =
      <(String, double, int, String)>[];

  final isExpanded = List<bool>.generate(20, (_) => false);

  void setLastStep() {
    setState(() {
      isLastStep = true;
    });
  }

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

  bool isScrollableSheetDisplayed = false;
  void displayScrollableSheet() {
    setState(() {
      isScrollableSheetDisplayed = true;
    });
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
                                    'assets/img/raskop.png',
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
                            child: DynamicHeightGridView(
                              itemCount: 20,
                              crossAxisCount: 2,
                              crossAxisSpacing: 20,
                              mainAxisSpacing: 20,
                              builder: (context, idx) {
                                return GestureDetector(
                                  onTap: () => toggleExpansion(idx),
                                  child: AnimatedSwitcher(
                                    duration: const Duration(milliseconds: 300),
                                    transitionBuilder: (child, animation) {
                                      return ScaleTransition(
                                        scale: animation,
                                        child: child,
                                      );
                                    },
                                    child: isExpanded[idx]
                                        ? buildExpandedMenuItem(
                                            index: idx,
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
                                                    'Steak with Paprika',
                                                    80000.00,
                                                    qty,
                                                    notes.text
                                                  ),
                                                );
                                                grandTotal = dummyItemList.fold(
                                                  0,
                                                  (a, b) => a + (b.$2 * b.$3),
                                                );
                                              });
                                            },
                                            notes: notes,
                                            context: context,
                                            isWideScreen: true,
                                          )
                                        : buildCollapsedMenuItem(
                                            index: idx,
                                            context: context,
                                            isWideScreen: true,
                                          ),
                                  ),
                                );
                              },
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
                                    '#12345678-1234-1234-1234-123456789abc',
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
                            if (isLastStep)
                              Expanded(
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
                                  ],
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
                                onTap: isLastStep ? () {} : setLastStep,
                                child: Padding(
                                  padding: EdgeInsets.symmetric(
                                    horizontal: 15.w,
                                    vertical: 12.h,
                                  ),
                                  child: Row(
                                    children: [
                                      Text(
                                        isLastStep ? 'Tambah\t' : 'Lanjut\t ',
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
                                      'assets/img/raskop.png',
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
                            child: DynamicHeightGridView(
                              itemCount: 20,
                              crossAxisCount: 1,
                              crossAxisSpacing: 20,
                              mainAxisSpacing: 20,
                              builder: (context, idx) {
                                return GestureDetector(
                                  onTap: () => toggleExpansion(idx),
                                  child: AnimatedSwitcher(
                                    duration: const Duration(milliseconds: 300),
                                    transitionBuilder: (child, animation) {
                                      return ScaleTransition(
                                        scale: animation,
                                        child: child,
                                      );
                                    },
                                    child: isExpanded[idx]
                                        ? buildExpandedMenuItem(
                                            index: idx,
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
                                                    'Steak with Paprika',
                                                    80000.00,
                                                    qty,
                                                    notes.text
                                                  ),
                                                );
                                                grandTotal = dummyItemList.fold(
                                                  0,
                                                  (a, b) => a + (b.$2 * b.$3),
                                                );
                                              });
                                            },
                                            notes: notes,
                                            context: context,
                                            isWideScreen: false,
                                          )
                                        : buildCollapsedMenuItem(
                                            index: idx,
                                            context: context,
                                            isWideScreen: false,
                                          ),
                                  ),
                                );
                              },
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
                                                '#12345678-1234-1234-1234-123456789abc',
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
                                        if (isLastStep)
                                          SizedBox(
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
                                              ],
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
                                                ? () {}
                                                : setLastStep,
                                            child: Padding(
                                              padding: EdgeInsets.symmetric(
                                                horizontal: 15.w,
                                                vertical: 12.h,
                                              ),
                                              child: Row(
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
              child: const Placeholder(
                child: Center(
                  child: Text(
                    'INI FOTO MAKANAN',
                    textAlign: TextAlign.center,
                  ),
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
                    'Steak With Paprica',
                    maxLines: 2,
                    style: TextStyle(
                      fontSize: 16.sp,
                      fontWeight: FontWeight.w500,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  Text(
                    'Rp80.000,00',
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
                child: const Placeholder(
                  child: Center(
                    child: Text(
                      'INI FOTO MAKANAN',
                      textAlign: TextAlign.center,
                    ),
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
                      'Steak With Paprica',
                      maxLines: 2,
                      style: TextStyle(
                        fontSize: 16.sp,
                        fontWeight: FontWeight.w500,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    Text(
                      'Rp80.000,00',
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
