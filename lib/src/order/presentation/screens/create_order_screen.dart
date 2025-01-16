// ignore_for_file: public_member_api_docs

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:iconify_flutter/iconify_flutter.dart';
import 'package:iconify_flutter/icons/eva.dart';
import 'package:iconify_flutter/icons/ic.dart';
import 'package:intl/intl.dart';
import 'package:raskop_fe_backoffice/res/strings.dart';
import 'package:raskop_fe_backoffice/shared/const.dart';
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 10.h),
        child: Row(
          children: [
            AnimatedContainer(
              width: MediaQuery.of(context).size.width * 0.6,
              duration: const Duration(milliseconds: 10),
              child: Column(
                children: [
                  Card(
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
                            borderRadius:
                                const BorderRadius.all(Radius.circular(50)),
                            color: Colors.white,
                            elevation: 5,
                            child: BackButton(
                              color: Colors.black,
                              onPressed: widget.onBack,
                            ),
                          ),
                          Expanded(
                            child: Image.asset(
                              'assets/img/raskop.png',
                              width: 100.w,
                              height: 30.h,
                              scale: 1 / 5,
                            ),
                          ),
                          Expanded(
                            flex: 5,
                            child: Container(
                              padding: EdgeInsets.symmetric(
                                horizontal: 8.w,
                              ),
                              decoration: BoxDecoration(
                                border:
                                    Border.all(color: hexToColor('#E1E1E1')),
                                borderRadius: const BorderRadius.all(
                                  Radius.circular(30),
                                ),
                              ),
                              child: TextFormField(
                                textAlignVertical: TextAlignVertical.center,
                                decoration: InputDecoration(
                                  filled: false,
                                  border: InputBorder.none,
                                  suffixIcon: Icon(
                                    Icons.search,
                                    size: 15.sp,
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
                    height: 25.h,
                    child: Row(
                      children: [
                        GroupButton(
                          isSelected: toggleMenuType,
                          onPressed: (int idx) {
                            setState(() {
                              for (var i = 0; i < toggleMenuType.length; i++) {
                                toggleMenuType[i] = i == idx;
                              }
                            });
                          },
                          borderRadius:
                              const BorderRadius.all(Radius.circular(50)),
                          children: menuTypeOptions
                              .map(
                                ((MenuType, String) menu) => SizedBox(
                                  width: 45.w,
                                  child: Center(
                                    child: Text(
                                      menu.$2,
                                      style: TextStyle(
                                        fontSize: 6.sp,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                                ),
                              )
                              .toList(),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 10.h,
                  ),
                  Expanded(
                    child: SizedBox(
                      height: MediaQuery.of(context).size.height,
                      child: GridView.builder(
                        shrinkWrap: true,
                        itemCount: 20,
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          crossAxisSpacing: 20,
                          mainAxisSpacing: 20,
                          childAspectRatio: 3 / 2,
                        ),
                        itemBuilder: (ctx, idx) {
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
                                      idx,
                                      qty,
                                      () {
                                        setState(() {
                                          if (qty == 1) {
                                            qty = 1;
                                          } else {
                                            qty--;
                                          }
                                        });
                                      },
                                      () {
                                        setState(() {
                                          qty++;
                                        });
                                      },
                                      () {
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
                                      notes,
                                    )
                                  : buildCollapsedMenuItem(idx),
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
              width: MediaQuery.of(context).size.width * 0.26,
              duration: const Duration(milliseconds: 10),
              child: Material(
                color: Colors.white,
                type: MaterialType.card,
                shadowColor: Colors.black38,
                shape: Border(
                  left: BorderSide(color: hexToColor('#E1E1E1'), width: 1.2),
                ),
                child: Padding(
                  padding:
                      EdgeInsets.symmetric(horizontal: 10.w, vertical: 10.h),
                  child: Column(
                    children: [
                      Row(
                        children: [
                          Text(
                            'Nomor ID',
                            style: TextStyle(fontSize: 7.sp),
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
                                fontSize: 7.sp,
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 5.h,
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
                                        onRemoved: () {
                                          setState(() {
                                            dummyItemList.removeAt(idx);
                                            grandTotal = dummyItemList.fold(
                                              0,
                                              (a, b) => a + (b.$2 * b.$3),
                                            );
                                          });
                                        },
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
                            horizontal: 10.w,
                            vertical: 8.h,
                          ),
                          child: Row(
                            children: [
                              Text(
                                'Total\t ',
                                style: TextStyle(
                                  fontWeight: FontWeight.w400,
                                  color: Colors.black,
                                  fontSize: 7.sp,
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
                                  fontSize: 7.sp,
                                  overflow: TextOverflow.fade,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      Card(
                        shape: RoundedRectangleBorder(
                          side: BorderSide(color: hexToColor('#E1E1E1')),
                          borderRadius:
                              const BorderRadius.all(Radius.circular(50)),
                        ),
                        color: hexToColor('#1F4940'),
                        child: InkWell(
                          borderRadius:
                              const BorderRadius.all(Radius.circular(50)),
                          onTap: isLastStep ? () {} : setLastStep,
                          child: Padding(
                            padding: EdgeInsets.symmetric(
                              horizontal: 10.w,
                              vertical: 8.h,
                            ),
                            child: Row(
                              children: [
                                Text(
                                  isLastStep ? 'Tambah\t' : 'Lanjut\t ',
                                  style: TextStyle(
                                    fontWeight: FontWeight.w400,
                                    color: Colors.white,
                                    fontSize: 7.sp,
                                    overflow: TextOverflow.fade,
                                  ),
                                ),
                                const Spacer(),
                                Icon(
                                  Icons.arrow_forward_ios_rounded,
                                  color: Colors.white,
                                  size: 8.sp,
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
            fontSize: 8.sp,
          ),
        ),
        SizedBox(
          height: 5.h,
        ),
        Container(
          padding: EdgeInsets.symmetric(
            horizontal: 8.w,
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
      padding: EdgeInsets.only(left: 10.w),
      child: Row(
        children: [
          Wrap(
            direction: Axis.vertical,
            children: [
              Text(
                menuName,
                style: TextStyle(fontSize: 8.sp),
              ),
              Text.rich(
                maxLines: 2,
                TextSpan(
                  children: [
                    TextSpan(
                      text: currency.format(price),
                      style: TextStyle(fontSize: 5.sp),
                    ),
                    TextSpan(text: ' x ', style: TextStyle(fontSize: 5.sp)),
                    TextSpan(
                      text: qty.toString(),
                      style: TextStyle(fontSize: 5.sp),
                    ),
                    TextSpan(text: ' = ', style: TextStyle(fontSize: 5.sp)),
                    TextSpan(
                      text: currency.format(price * qty),
                      style: TextStyle(fontSize: 5.sp),
                    ),
                  ],
                ),
              ),
              if (notes!.isNotEmpty)
                Expanded(
                  child: Text(
                    notes,
                    style: TextStyle(fontSize: 5.sp),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
            ],
          ),
          const Spacer(),
          IconButton(
            onPressed: onRemoved,
            icon: Center(
              child: Container(
                width: 25.w,
                height: 28.h,
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
        ],
      ),
    ),
  );
}

Widget buildCollapsedMenuItem(int index) {
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
              width: 70.w,
              height: 70.h,
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
              width: 8.w,
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
                      fontSize: 8.sp,
                      fontWeight: FontWeight.w500,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  Text(
                    'Rp80.000,00',
                    style: TextStyle(
                      fontSize: 6.sp,
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

Widget buildExpandedMenuItem(
  int index,
  int qty,
  VoidCallback onDecrement,
  VoidCallback onIncrement,
  VoidCallback onAdd,
  TextEditingController notes,
) {
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
        horizontal: 10.w,
        vertical: 10.h,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(
                width: 40.w,
                height: 40.h,
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
                width: 5.w,
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
                        fontSize: 8.sp,
                        fontWeight: FontWeight.w500,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    Text(
                      'Rp80.000,00',
                      style: TextStyle(
                        fontSize: 6.sp,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          SizedBox(
            height: 4.h,
          ),
          Text(
            'Jumlah',
            style: TextStyle(fontSize: 6.sp),
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
                ),
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 5.w),
                child: Text(qty.toString()),
              ),
              IconButton(
                onPressed: onIncrement,
                style: TextButton.styleFrom(
                  backgroundColor: hexToColor('#E38D5D'),
                ),
                icon: const Icon(
                  Icons.add,
                  color: Colors.white,
                ),
              ),
              const Spacer(),
              TextButton(
                onPressed: onAdd,
                style: TextButton.styleFrom(
                  backgroundColor: hexToColor('#E38D5D'),
                ),
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 5.w),
                  child: Text(
                    AppStrings.tambahBtn,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 5.sp,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
            ],
          ),
          SizedBox(
            height: 4.h,
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
