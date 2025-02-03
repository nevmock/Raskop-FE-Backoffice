// ignore_for_file: public_member_api_docs

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:iconify_flutter/iconify_flutter.dart';
import 'package:iconify_flutter/icons/eva.dart';
import 'package:iconify_flutter/icons/zondicons.dart';
import 'package:multi_dropdown/multi_dropdown.dart';
import 'package:raskop_fe_backoffice/core/core.dart';
import 'package:raskop_fe_backoffice/res/strings.dart';
import 'package:raskop_fe_backoffice/shared/const.dart';
import 'package:raskop_fe_backoffice/src/order/presentation/screens/create_order_screen.dart';
import 'package:raskop_fe_backoffice/src/order/presentation/widgets/reservasi_reguler_button_filter_widget.dart';
import 'package:raskop_fe_backoffice/src/supplier/presentation/widgets/positioned_directional_backdrop_blur_widget.dart';

///
class OrderScreen extends StatefulWidget {
  ///
  const OrderScreen({super.key});

  ///
  static const String route = 'order';

  @override
  State<OrderScreen> createState() => _OrderScreenState();
}

class _OrderScreenState extends State<OrderScreen> {
  bool isCreating = false;
  bool isDetailPanelVisible = false;

  FutureVoid onReservasi() async {}

  FutureVoid onReguler() async {}

  List<DropdownItem<String>> orderStatus = [
    DropdownItem(label: 'Belum Dibuat', value: 'Belum'),
    DropdownItem(label: 'Diproses', value: 'Diproses'),
    DropdownItem(label: 'Selesai Dibuat', value: 'Selesai'),
    DropdownItem(label: 'Dibatalkan', value: 'Dibatalkan'),
  ];

  final statusTabletController = MultiSelectController<String>();
  final statusPhoneController = MultiSelectController<String>();

  @override
  Widget build(BuildContext context) {
    void toggleDetailPanel() {
      setState(() {
        isDetailPanelVisible = !isDetailPanelVisible;
        statusTabletController.selectWhere(
          (item) => item.label == 'Belum Dibuat',
        );
        statusPhoneController.selectWhere(
          (item) => item.label == 'Belum Dibuat',
        );
      });
    }

    void toggleCreateScreen() {
      setState(() {
        isCreating = !isCreating;
      });
    }

    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: isCreating
          ? CreateOrderScreen(
              onBack: toggleCreateScreen,
            )
          : Scaffold(
              backgroundColor: Colors.white,
              body: LayoutBuilder(
                builder: (context, constraints) {
                  if (constraints.maxWidth > 500) {
                    return Stack(
                      children: [
                        AnimatedContainer(
                          padding: EdgeInsets.symmetric(
                            horizontal: 10.w,
                            vertical: 10.h,
                          ),
                          duration: const Duration(milliseconds: 300),
                          child: Column(
                            children: [
                              Row(
                                children: [
                                  ReservasiRegulerButtonFilterWidget(
                                    onReservasi: onReservasi(),
                                    onReguler: onReguler(),
                                    isWideScreen: true,
                                  ),
                                  const Spacer(),
                                  ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: hexToColor('#1f4940'),
                                    ),
                                    onPressed: toggleCreateScreen,
                                    child: Padding(
                                      padding: EdgeInsets.symmetric(
                                        horizontal: 10.w,
                                        vertical: 10.h,
                                      ),
                                      child: const Text(
                                        AppStrings.tambahBtn,
                                        style: TextStyle(
                                          fontWeight: FontWeight.w500,
                                          color: Colors.white,
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              Container(
                                margin: EdgeInsets.only(top: 12.h, bottom: 7.h),
                                decoration: BoxDecoration(
                                  border: Border.all(color: Colors.grey),
                                  borderRadius: BorderRadius.circular(18),
                                  color: Colors.white,
                                ),
                                child: Padding(
                                  padding: EdgeInsets.symmetric(
                                    horizontal: 10.w,
                                    vertical: 15.h,
                                  ),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Expanded(
                                        flex: 2,
                                        child: Text(
                                          'ID',
                                          style: TextStyle(
                                            fontWeight: FontWeight.w600,
                                            color: hexToColor('#202224'),
                                            fontSize: 14,
                                          ),
                                        ),
                                      ),
                                      Expanded(
                                        flex: 2,
                                        child: Text(
                                          'JENIS',
                                          style: TextStyle(
                                            fontWeight: FontWeight.w600,
                                            color: hexToColor('#202224'),
                                            fontSize: 14,
                                          ),
                                        ),
                                      ),
                                      Expanded(
                                        flex: 2,
                                        child: Text(
                                          'NAMA',
                                          style: TextStyle(
                                            fontWeight: FontWeight.w600,
                                            color: hexToColor('#202224'),
                                            fontSize: 14,
                                          ),
                                        ),
                                      ),
                                      Expanded(
                                        flex: 2,
                                        child: Text(
                                          'KONTAK',
                                          style: TextStyle(
                                            fontWeight: FontWeight.w600,
                                            color: hexToColor('#202224'),
                                            fontSize: 14,
                                          ),
                                        ),
                                      ),
                                      Expanded(
                                        flex: 2,
                                        child: Center(
                                          child: Text(
                                            'STATUS',
                                            style: TextStyle(
                                              fontWeight: FontWeight.w600,
                                              color: hexToColor('#202224'),
                                              fontSize: 14,
                                            ),
                                          ),
                                        ),
                                      ),
                                      Expanded(
                                        flex: 2,
                                        child: Center(
                                          child: Text(
                                            'DETAIL ORDER',
                                            textAlign: TextAlign.center,
                                            style: TextStyle(
                                              fontWeight: FontWeight.w600,
                                              color: hexToColor('#202224'),
                                              fontSize: 14,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              Expanded(
                                child: ListView.builder(
                                  padding: EdgeInsets.zero,
                                  shrinkWrap: true,
                                  itemCount: 20,
                                  itemBuilder: (context, index) {
                                    return Container(
                                      margin: EdgeInsets.only(bottom: 7.h),
                                      decoration: BoxDecoration(
                                        border: Border.all(color: Colors.grey),
                                        borderRadius: BorderRadius.circular(18),
                                        color: hexToColor('#E1E1E1'),
                                      ),
                                      child: Slidable(
                                        endActionPane: ActionPane(
                                          extentRatio: 0.08,
                                          motion: const BehindMotion(),
                                          children: [
                                            Expanded(
                                              child: SizedBox.expand(
                                                child: GestureDetector(
                                                  onTap: () {},
                                                  child: Container(
                                                    decoration: BoxDecoration(
                                                      borderRadius:
                                                          const BorderRadius
                                                              .only(
                                                        topRight:
                                                            Radius.circular(18),
                                                        bottomRight:
                                                            Radius.circular(18),
                                                      ),
                                                      color:
                                                          hexToColor('#E1E1E1'),
                                                    ),
                                                    child: Center(
                                                      child: Container(
                                                        width: MediaQuery.of(
                                                              context,
                                                            ).size.width *
                                                            0.045,
                                                        height: MediaQuery.of(
                                                              context,
                                                            ).size.width *
                                                            0.045,
                                                        padding:
                                                            const EdgeInsets
                                                                .all(12),
                                                        decoration:
                                                            BoxDecoration(
                                                          borderRadius:
                                                              const BorderRadius
                                                                  .all(
                                                            Radius.circular(30),
                                                          ),
                                                          color: hexToColor(
                                                            '#F64C4C',
                                                          ),
                                                        ),
                                                        child: const Iconify(
                                                          Eva.trash_fill,
                                                          color: Colors.white,
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                        child: Container(
                                          decoration: BoxDecoration(
                                            border:
                                                Border.all(color: Colors.grey),
                                            borderRadius:
                                                BorderRadius.circular(18),
                                            color: Colors.white,
                                          ),
                                          padding: EdgeInsets.symmetric(
                                            horizontal: 10.w,
                                            vertical: 8.h,
                                          ),
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Expanded(
                                                flex: 2,
                                                child: Text(
                                                  '00001',
                                                  style: TextStyle(
                                                    fontWeight: FontWeight.w500,
                                                    color:
                                                        hexToColor('#202224'),
                                                    fontSize: 14,
                                                  ),
                                                ),
                                              ),
                                              Expanded(
                                                flex: 2,
                                                child: Text(
                                                  index.isEven
                                                      ? 'Reguler'
                                                      : 'Reservasi',
                                                  style: TextStyle(
                                                    fontWeight: FontWeight.w500,
                                                    color:
                                                        hexToColor('#202224'),
                                                    fontSize: 14,
                                                  ),
                                                ),
                                              ),
                                              Expanded(
                                                flex: 2,
                                                child: Text(
                                                  'Christine Brooks',
                                                  style: TextStyle(
                                                    fontWeight: FontWeight.w500,
                                                    color:
                                                        hexToColor('#202224'),
                                                    fontSize: 14,
                                                  ),
                                                ),
                                              ),
                                              Expanded(
                                                flex: 2,
                                                child: Text(
                                                  '+621234567890',
                                                  style: TextStyle(
                                                    fontWeight: FontWeight.w500,
                                                    color:
                                                        hexToColor('#202224'),
                                                    fontSize: 14,
                                                  ),
                                                ),
                                              ),
                                              Expanded(
                                                flex: 2,
                                                child: Center(
                                                  child: Chip(
                                                    backgroundColor:
                                                        Colors.white,
                                                    shape:
                                                        const RoundedRectangleBorder(
                                                      borderRadius:
                                                          BorderRadius.all(
                                                        Radius.circular(
                                                          30,
                                                        ),
                                                      ),
                                                    ),
                                                    side: BorderSide(
                                                      width: 3,
                                                      color: index == 0
                                                          ? hexToColor(
                                                              '#FFDD82',
                                                            )
                                                          : index == 1
                                                              ? hexToColor(
                                                                  '#1F4940',
                                                                )
                                                              : index == 2
                                                                  ? hexToColor(
                                                                      '#47B881',
                                                                    )
                                                                  : index == 3
                                                                      ? hexToColor(
                                                                          '#F64C4C',
                                                                        )
                                                                      : hexToColor(
                                                                          '#1F4940',
                                                                        ),
                                                    ),
                                                    label: Center(
                                                      child: Text(
                                                        index == 0
                                                            ? 'Belum Dibuat'
                                                            : index == 1
                                                                ? 'Diproses'
                                                                : index == 2
                                                                    ? 'Selesai Dibuat'
                                                                    : index == 3
                                                                        ? 'Dibatalkan'
                                                                        : 'Diproses',
                                                        style: TextStyle(
                                                          fontWeight:
                                                              FontWeight.w700,
                                                          color: index == 0
                                                              ? hexToColor(
                                                                  '#FFDD82',
                                                                )
                                                              : index == 1
                                                                  ? hexToColor(
                                                                      '#1F4940',
                                                                    )
                                                                  : index == 2
                                                                      ? hexToColor(
                                                                          '#47B881',
                                                                        )
                                                                      : index ==
                                                                              3
                                                                          ? hexToColor(
                                                                              '#F64C4C',
                                                                            )
                                                                          : hexToColor(
                                                                              '#1F4940',
                                                                            ),
                                                          fontSize: 14,
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              ),
                                              Expanded(
                                                flex: 2,
                                                child: Center(
                                                  child: Padding(
                                                    padding:
                                                        EdgeInsets.symmetric(
                                                      horizontal: 10.h,
                                                    ),
                                                    child: TextButton(
                                                      onPressed:
                                                          toggleDetailPanel,
                                                      style:
                                                          TextButton.styleFrom(
                                                        backgroundColor:
                                                            hexToColor(
                                                          '#f6e9e0',
                                                        ),
                                                        minimumSize: const Size(
                                                          double.infinity,
                                                          40,
                                                        ),
                                                      ),
                                                      child: Text(
                                                        'Lihat',
                                                        style: TextStyle(
                                                          fontWeight:
                                                              FontWeight.w700,
                                                          color: hexToColor(
                                                            '#E38D5D',
                                                          ),
                                                          fontSize: 14,
                                                        ),
                                                      ),
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
                                ),
                              ),
                            ],
                          ),
                        ),
                        PositionedDirectionalBackdropBlurWidget(
                          isPanelVisible: isDetailPanelVisible,
                          end: -MediaQuery.of(context).size.width * 0.3,
                          content: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Container(
                                  decoration: const BoxDecoration(
                                    color: Colors.white,
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(50)),
                                  ),
                                  child: IconButton(
                                    padding: const EdgeInsets.all(10),
                                    color: hexToColor('#1F4940'),
                                    icon: const Icon(Icons.arrow_back),
                                    onPressed: toggleDetailPanel,
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(
                              height: 20.h,
                            ),
                            Text(
                              'Status',
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.w500,
                                fontSize: 14.sp,
                              ),
                            ),
                            SizedBox(
                              height: 5.h,
                            ),
                            MultiDropdown<String>(
                              singleSelect: true,
                              items: orderStatus,
                              controller: statusTabletController,
                              fieldDecoration: FieldDecoration(
                                backgroundColor: Colors.white,
                                padding: const EdgeInsets.symmetric(
                                  vertical: 16,
                                  horizontal: 12,
                                ),
                                hintText: 'Pilih Status Order terkini',
                                hintStyle: TextStyle(
                                  fontSize: 14.sp,
                                  overflow: TextOverflow.ellipsis,
                                  color: Colors.black.withOpacity(0.3),
                                  fontWeight: FontWeight.w600,
                                ),
                                suffixIcon: const Padding(
                                  padding: EdgeInsets.all(
                                    12,
                                  ),
                                  child: Iconify(
                                    Zondicons.cheveron_down,
                                  ),
                                ),
                                showClearIcon: false,
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(
                                    15,
                                  ),
                                  borderSide: const BorderSide(
                                    color: Colors.black87,
                                  ),
                                ),
                              ),
                              itemSeparator: const Padding(
                                padding: EdgeInsets.symmetric(
                                  horizontal: 12,
                                ),
                                child: Divider(),
                              ),
                            ),
                            SizedBox(
                              height: 20.h,
                            ),
                            SizedBox(
                              height: MediaQuery.of(context).size.height * 0.6,
                              child: ListView.builder(
                                itemCount: 3,
                                itemBuilder: (ctx, idx) {
                                  return Card.filled(
                                    margin: EdgeInsets.only(bottom: 15.h),
                                    shape: const RoundedRectangleBorder(
                                      borderRadius:
                                          BorderRadius.all(Radius.circular(15)),
                                    ),
                                    color: Colors.white,
                                    child: Padding(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 20,
                                        vertical: 20,
                                      ),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            'ID : 00001',
                                            style: TextStyle(
                                              fontWeight: FontWeight.w500,
                                              color: Colors.black,
                                              fontSize: 14.sp,
                                              overflow: TextOverflow.fade,
                                            ),
                                          ),
                                          const Divider(),
                                          RichText(
                                            text: TextSpan(
                                              children: [
                                                TextSpan(
                                                  text: 'Nama Menu : \t ',
                                                  style: TextStyle(
                                                    fontWeight: FontWeight.w400,
                                                    color: Colors.black45,
                                                    fontSize: 15.sp,
                                                    overflow: TextOverflow.fade,
                                                  ),
                                                ),
                                                TextSpan(
                                                  text: 'Mocktail',
                                                  style: TextStyle(
                                                    fontWeight: FontWeight.w500,
                                                    color: Colors.black,
                                                    fontSize: 15.sp,
                                                    overflow: TextOverflow.fade,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                          const Divider(),
                                          RichText(
                                            text: TextSpan(
                                              children: [
                                                TextSpan(
                                                  text: 'Catt : \t\t\t',
                                                  style: TextStyle(
                                                    fontWeight: FontWeight.w400,
                                                    color: Colors.black45,
                                                    fontSize: 14.sp,
                                                    overflow: TextOverflow.fade,
                                                  ),
                                                ),
                                                WidgetSpan(
                                                  child: SizedBox(
                                                    width:
                                                        MediaQuery.of(context)
                                                                .size
                                                                .width *
                                                            0.046,
                                                  ),
                                                ),
                                                TextSpan(
                                                  text: 'Jangan pakai es',
                                                  style: TextStyle(
                                                    fontWeight: FontWeight.w500,
                                                    color: Colors.black,
                                                    fontSize: 14.sp,
                                                    overflow: TextOverflow.fade,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                          const Divider(),
                                          RichText(
                                            text: TextSpan(
                                              children: [
                                                TextSpan(
                                                  text: 'Jumlah : \t',
                                                  style: TextStyle(
                                                    fontWeight: FontWeight.w400,
                                                    color: Colors.black45,
                                                    fontSize: 14.sp,
                                                    overflow: TextOverflow.fade,
                                                  ),
                                                ),
                                                WidgetSpan(
                                                  child: SizedBox(
                                                    width:
                                                        MediaQuery.of(context)
                                                                .size
                                                                .width *
                                                            0.035,
                                                  ),
                                                ),
                                                TextSpan(
                                                  text: '2',
                                                  style: TextStyle(
                                                    fontWeight: FontWeight.w500,
                                                    color: Colors.black,
                                                    fontSize: 14.sp,
                                                    overflow: TextOverflow.fade,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                          const Divider(),
                                          RichText(
                                            text: TextSpan(
                                              children: [
                                                TextSpan(
                                                  text: 'Subtotal : \t',
                                                  style: TextStyle(
                                                    fontWeight: FontWeight.w400,
                                                    color: Colors.black45,
                                                    fontSize: 14.sp,
                                                    overflow: TextOverflow.fade,
                                                  ),
                                                ),
                                                WidgetSpan(
                                                  child: SizedBox(
                                                    width:
                                                        MediaQuery.of(context)
                                                                .size
                                                                .width *
                                                            0.033,
                                                  ),
                                                ),
                                                TextSpan(
                                                  text: 'Rp50.000,00',
                                                  style: TextStyle(
                                                    fontWeight: FontWeight.w500,
                                                    color: Colors.black,
                                                    fontSize: 14.sp,
                                                    overflow: TextOverflow.fade,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  );
                                },
                              ),
                            ),
                            SizedBox(
                              height: 10.h,
                            ),
                            SizedBox(
                              child: Card.filled(
                                shape: const RoundedRectangleBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(15)),
                                ),
                                color: Colors.white,
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 25,
                                    vertical: 20,
                                  ),
                                  child: Row(
                                    children: [
                                      Text(
                                        'Grand Total : \t ',
                                        style: TextStyle(
                                          fontWeight: FontWeight.w400,
                                          color: Colors.black45,
                                          fontSize: 14.sp,
                                          overflow: TextOverflow.fade,
                                        ),
                                      ),
                                      const Spacer(),
                                      Text(
                                        'Rp150.000,00',
                                        style: TextStyle(
                                          fontWeight: FontWeight.w500,
                                          color: Colors.black,
                                          fontSize: 14.sp,
                                          overflow: TextOverflow.fade,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ],
                          width: MediaQuery.of(context).size.width * 0.3,
                        ),
                      ],
                    );
                  } else {
                    return Stack(
                      children: [
                        AnimatedContainer(
                          padding: EdgeInsets.symmetric(
                            horizontal: 10.w,
                            vertical: 10.h,
                          ),
                          duration: const Duration(milliseconds: 300),
                          child: Column(
                            children: [
                              Row(
                                children: [
                                  ReservasiRegulerButtonFilterWidget(
                                    onReservasi: onReservasi(),
                                    onReguler: onReguler(),
                                    isWideScreen: false,
                                  ),
                                  const Spacer(),
                                  ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: hexToColor('#1f4940'),
                                    ),
                                    onPressed: toggleCreateScreen,
                                    child: Padding(
                                      padding: EdgeInsets.symmetric(
                                        horizontal: 10.w,
                                        vertical: 10.h,
                                      ),
                                      child: const Text(
                                        AppStrings.tambahBtn,
                                        style: TextStyle(
                                          fontWeight: FontWeight.w600,
                                          color: Colors.white,
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              Container(
                                margin: EdgeInsets.only(top: 12.h, bottom: 7.h),
                                decoration: BoxDecoration(
                                  border: Border.all(color: Colors.grey),
                                  borderRadius: BorderRadius.circular(18),
                                  color: Colors.white,
                                ),
                                child: Padding(
                                  padding: EdgeInsets.symmetric(
                                    horizontal: 10.w,
                                    vertical: 15.h,
                                  ),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Expanded(
                                        flex: 2,
                                        child: Text(
                                          'ID',
                                          style: TextStyle(
                                            fontWeight: FontWeight.w600,
                                            color: hexToColor('#202224'),
                                            fontSize: 12,
                                          ),
                                        ),
                                      ),
                                      Expanded(
                                        flex: 2,
                                        child: Text(
                                          'NAMA',
                                          style: TextStyle(
                                            fontWeight: FontWeight.w600,
                                            color: hexToColor('#202224'),
                                            fontSize: 12,
                                          ),
                                        ),
                                      ),
                                      Expanded(
                                        flex: 2,
                                        child: Center(
                                          child: Text(
                                            'STATUS',
                                            style: TextStyle(
                                              fontWeight: FontWeight.w600,
                                              color: hexToColor('#202224'),
                                              fontSize: 14,
                                            ),
                                          ),
                                        ),
                                      ),
                                      Expanded(
                                        flex: 3,
                                        child: Center(
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              Container(
                                                width: 5,
                                                height: 5,
                                                decoration: BoxDecoration(
                                                  color: hexToColor('#000000'),
                                                  shape: BoxShape.circle,
                                                ),
                                              ),
                                              const SizedBox(width: 5),
                                              Container(
                                                width: 5,
                                                height: 5,
                                                decoration: BoxDecoration(
                                                  color: hexToColor('#000000'),
                                                  shape: BoxShape.circle,
                                                ),
                                              ),
                                              const SizedBox(width: 5),
                                              Container(
                                                width: 5,
                                                height: 5,
                                                decoration: BoxDecoration(
                                                  color: hexToColor('#000000'),
                                                  shape: BoxShape.circle,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              Expanded(
                                child: ListView.builder(
                                  padding: EdgeInsets.zero,
                                  shrinkWrap: true,
                                  itemCount: 20,
                                  itemBuilder: (context, index) {
                                    return Container(
                                      margin: EdgeInsets.only(bottom: 7.h),
                                      decoration: BoxDecoration(
                                        border: Border.all(color: Colors.grey),
                                        borderRadius: BorderRadius.circular(18),
                                        color: hexToColor('#E1E1E1'),
                                      ),
                                      child: Slidable(
                                        endActionPane: ActionPane(
                                          extentRatio: 0.2,
                                          motion: const BehindMotion(),
                                          children: [
                                            Expanded(
                                              child: SizedBox.expand(
                                                child: GestureDetector(
                                                  onTap: () {},
                                                  child: Container(
                                                    decoration: BoxDecoration(
                                                      borderRadius:
                                                          const BorderRadius
                                                              .only(
                                                        topRight:
                                                            Radius.circular(18),
                                                        bottomRight:
                                                            Radius.circular(18),
                                                      ),
                                                      color:
                                                          hexToColor('#E1E1E1'),
                                                    ),
                                                    child: Center(
                                                      child: Container(
                                                        padding: EdgeInsets
                                                            .symmetric(
                                                          horizontal: 8.w,
                                                          vertical: 8.h,
                                                        ),
                                                        margin: EdgeInsets
                                                            .symmetric(
                                                          horizontal: 10.w,
                                                          vertical: 8.h,
                                                        ),
                                                        decoration:
                                                            BoxDecoration(
                                                          borderRadius:
                                                              const BorderRadius
                                                                  .all(
                                                            Radius.circular(30),
                                                          ),
                                                          color: hexToColor(
                                                            '#F64C4C',
                                                          ),
                                                        ),
                                                        child: const Iconify(
                                                          Eva.trash_fill,
                                                          color: Colors.white,
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                        child: Container(
                                          decoration: BoxDecoration(
                                            border:
                                                Border.all(color: Colors.grey),
                                            borderRadius:
                                                BorderRadius.circular(18),
                                            color: Colors.white,
                                          ),
                                          padding: EdgeInsets.symmetric(
                                            horizontal: 10.w,
                                            vertical: 8.h,
                                          ),
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Expanded(
                                                flex: 2,
                                                child: Text(
                                                  '00001',
                                                  style: TextStyle(
                                                    fontWeight: FontWeight.w600,
                                                    color:
                                                        hexToColor('#202224'),
                                                    fontSize: 12,
                                                  ),
                                                ),
                                              ),
                                              Expanded(
                                                flex: 2,
                                                child: Text(
                                                  'Christine Brooks',
                                                  style: TextStyle(
                                                    fontWeight: FontWeight.w600,
                                                    color:
                                                        hexToColor('#202224'),
                                                    fontSize: 12,
                                                  ),
                                                ),
                                              ),
                                              Expanded(
                                                flex: 2,
                                                child: Center(
                                                  child: Chip(
                                                    backgroundColor:
                                                        Colors.white,
                                                    shape:
                                                        const RoundedRectangleBorder(
                                                      borderRadius:
                                                          BorderRadius.all(
                                                        Radius.circular(
                                                          30,
                                                        ),
                                                      ),
                                                    ),
                                                    side: BorderSide(
                                                      width: 3,
                                                      color: index == 0
                                                          ? hexToColor(
                                                              '#FFDD82',
                                                            )
                                                          : index == 1
                                                              ? hexToColor(
                                                                  '#1F4940',
                                                                )
                                                              : index == 2
                                                                  ? hexToColor(
                                                                      '#47B881',
                                                                    )
                                                                  : index == 3
                                                                      ? hexToColor(
                                                                          '#F64C4C',
                                                                        )
                                                                      : hexToColor(
                                                                          '#1F4940',
                                                                        ),
                                                    ),
                                                    label: Center(
                                                      child: Text(
                                                        index == 0
                                                            ? 'Belum Dibuat'
                                                            : index == 1
                                                                ? 'Diproses'
                                                                : index == 2
                                                                    ? 'Selesai Dibuat'
                                                                    : index == 3
                                                                        ? 'Dibatalkan'
                                                                        : 'Diproses',
                                                        maxLines: 2,
                                                        style: TextStyle(
                                                          overflow:
                                                              TextOverflow.fade,
                                                          fontWeight:
                                                              FontWeight.w700,
                                                          color: index == 0
                                                              ? hexToColor(
                                                                  '#FFDD82',
                                                                )
                                                              : index == 1
                                                                  ? hexToColor(
                                                                      '#1F4940',
                                                                    )
                                                                  : index == 2
                                                                      ? hexToColor(
                                                                          '#47B881',
                                                                        )
                                                                      : index ==
                                                                              3
                                                                          ? hexToColor(
                                                                              '#F64C4C',
                                                                            )
                                                                          : hexToColor(
                                                                              '#1F4940',
                                                                            ),
                                                          fontSize: 12,
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              ),
                                              Expanded(
                                                flex: 3,
                                                child: Center(
                                                  child: Padding(
                                                    padding:
                                                        EdgeInsets.symmetric(
                                                      horizontal: 10.h,
                                                    ),
                                                    child: TextButton(
                                                      onPressed:
                                                          toggleDetailPanel,
                                                      style:
                                                          TextButton.styleFrom(
                                                        backgroundColor:
                                                            hexToColor(
                                                          '#f6e9e0',
                                                        ),
                                                        minimumSize: const Size(
                                                          double.infinity,
                                                          40,
                                                        ),
                                                      ),
                                                      child: Text(
                                                        'Lihat',
                                                        style: TextStyle(
                                                          fontWeight:
                                                              FontWeight.w700,
                                                          color: hexToColor(
                                                            '#E38D5D',
                                                          ),
                                                          fontSize: 12,
                                                        ),
                                                      ),
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
                                ),
                              ),
                            ],
                          ),
                        ),
                        PositionedDirectionalBackdropBlurWidget(
                          isPanelVisible: isDetailPanelVisible,
                          end: -MediaQuery.of(context).size.width,
                          content: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Container(
                                  decoration: const BoxDecoration(
                                    color: Colors.white,
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(50)),
                                  ),
                                  child: IconButton(
                                    padding: const EdgeInsets.all(10),
                                    color: hexToColor('#1F4940'),
                                    icon: const Icon(Icons.arrow_back),
                                    onPressed: toggleDetailPanel,
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(
                              height: 20.h,
                            ),
                            Text(
                              'Jenis',
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.w600,
                                fontSize: 14.sp,
                              ),
                            ),
                            SizedBox(
                              height: 5.h,
                            ),
                            TextFormField(
                              readOnly: true,
                              style: const TextStyle(
                                fontWeight: FontWeight.w400,
                                color: Colors.black,
                                fontSize: 14,
                                overflow: TextOverflow.fade,
                              ),
                              initialValue: 'Reguler',
                              decoration: const InputDecoration(
                                filled: true,
                                fillColor: Colors.white,
                                focusedBorder: OutlineInputBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(15)),
                                ),
                                border: OutlineInputBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(15)),
                                ),
                              ),
                            ),
                            SizedBox(
                              height: 20.h,
                            ),
                            Text(
                              'Kontak',
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.w600,
                                fontSize: 14.sp,
                              ),
                            ),
                            SizedBox(
                              height: 5.h,
                            ),
                            TextFormField(
                              readOnly: true,
                              style: const TextStyle(
                                fontWeight: FontWeight.w400,
                                color: Colors.black,
                                fontSize: 14,
                                overflow: TextOverflow.fade,
                              ),
                              initialValue: '+6281234567890',
                              decoration: const InputDecoration(
                                filled: true,
                                fillColor: Colors.white,
                                focusedBorder: OutlineInputBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(15)),
                                ),
                                border: OutlineInputBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(15)),
                                ),
                              ),
                            ),
                            const SizedBox(
                              height: 20,
                            ),
                            Text(
                              'Status',
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.w500,
                                fontSize: 14.sp,
                              ),
                            ),
                            SizedBox(
                              height: 5.h,
                            ),
                            MultiDropdown<String>(
                              singleSelect: true,
                              items: orderStatus,
                              controller: statusPhoneController,
                              fieldDecoration: FieldDecoration(
                                backgroundColor: Colors.white,
                                padding: const EdgeInsets.symmetric(
                                  vertical: 16,
                                  horizontal: 12,
                                ),
                                hintText: 'Pilih Status Order terkini',
                                hintStyle: TextStyle(
                                  fontSize: 14.sp,
                                  overflow: TextOverflow.ellipsis,
                                  color: Colors.black.withOpacity(0.3),
                                  fontWeight: FontWeight.w600,
                                ),
                                suffixIcon: const Padding(
                                  padding: EdgeInsets.all(
                                    12,
                                  ),
                                  child: Iconify(
                                    Zondicons.cheveron_down,
                                  ),
                                ),
                                showClearIcon: false,
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(
                                    15,
                                  ),
                                  borderSide: const BorderSide(
                                    color: Colors.black87,
                                  ),
                                ),
                              ),
                              itemSeparator: const Padding(
                                padding: EdgeInsets.symmetric(
                                  horizontal: 12,
                                ),
                                child: Divider(),
                              ),
                            ),
                            SizedBox(
                              height: 20.h,
                            ),
                            SizedBox(
                              height: MediaQuery.of(context).size.height * 0.6,
                              child: ListView.builder(
                                itemCount: 3,
                                itemBuilder: (ctx, idx) {
                                  return Card.filled(
                                    margin: EdgeInsets.only(bottom: 15.h),
                                    shape: const RoundedRectangleBorder(
                                      borderRadius:
                                          BorderRadius.all(Radius.circular(15)),
                                    ),
                                    color: Colors.white,
                                    child: Padding(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 20,
                                        vertical: 20,
                                      ),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            'ID : 00001',
                                            style: TextStyle(
                                              fontWeight: FontWeight.w500,
                                              color: Colors.black,
                                              fontSize: 14.sp,
                                              overflow: TextOverflow.fade,
                                            ),
                                          ),
                                          const Divider(),
                                          RichText(
                                            text: TextSpan(
                                              children: [
                                                TextSpan(
                                                  text: 'Nama Menu : \t ',
                                                  style: TextStyle(
                                                    fontWeight: FontWeight.w400,
                                                    color: Colors.black45,
                                                    fontSize: 15.sp,
                                                    overflow: TextOverflow.fade,
                                                  ),
                                                ),
                                                TextSpan(
                                                  text: 'Mocktail',
                                                  style: TextStyle(
                                                    fontWeight: FontWeight.w500,
                                                    color: Colors.black,
                                                    fontSize: 15.sp,
                                                    overflow: TextOverflow.fade,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                          const Divider(),
                                          RichText(
                                            text: TextSpan(
                                              children: [
                                                TextSpan(
                                                  text: 'Catt : \t\t\t',
                                                  style: TextStyle(
                                                    fontWeight: FontWeight.w400,
                                                    color: Colors.black45,
                                                    fontSize: 14.sp,
                                                    overflow: TextOverflow.fade,
                                                  ),
                                                ),
                                                WidgetSpan(
                                                  child: SizedBox(
                                                    width:
                                                        MediaQuery.of(context)
                                                                .size
                                                                .width *
                                                            0.046,
                                                  ),
                                                ),
                                                TextSpan(
                                                  text: 'Jangan pakai es',
                                                  style: TextStyle(
                                                    fontWeight: FontWeight.w500,
                                                    color: Colors.black,
                                                    fontSize: 14.sp,
                                                    overflow: TextOverflow.fade,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                          const Divider(),
                                          RichText(
                                            text: TextSpan(
                                              children: [
                                                TextSpan(
                                                  text: 'Jumlah : \t',
                                                  style: TextStyle(
                                                    fontWeight: FontWeight.w400,
                                                    color: Colors.black45,
                                                    fontSize: 14.sp,
                                                    overflow: TextOverflow.fade,
                                                  ),
                                                ),
                                                WidgetSpan(
                                                  child: SizedBox(
                                                    width:
                                                        MediaQuery.of(context)
                                                                .size
                                                                .width *
                                                            0.035,
                                                  ),
                                                ),
                                                TextSpan(
                                                  text: '2',
                                                  style: TextStyle(
                                                    fontWeight: FontWeight.w500,
                                                    color: Colors.black,
                                                    fontSize: 14.sp,
                                                    overflow: TextOverflow.fade,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                          const Divider(),
                                          RichText(
                                            text: TextSpan(
                                              children: [
                                                TextSpan(
                                                  text: 'Subtotal : \t',
                                                  style: TextStyle(
                                                    fontWeight: FontWeight.w400,
                                                    color: Colors.black45,
                                                    fontSize: 14.sp,
                                                    overflow: TextOverflow.fade,
                                                  ),
                                                ),
                                                WidgetSpan(
                                                  child: SizedBox(
                                                    width:
                                                        MediaQuery.of(context)
                                                                .size
                                                                .width *
                                                            0.033,
                                                  ),
                                                ),
                                                TextSpan(
                                                  text: 'Rp50.000,00',
                                                  style: TextStyle(
                                                    fontWeight: FontWeight.w500,
                                                    color: Colors.black,
                                                    fontSize: 14.sp,
                                                    overflow: TextOverflow.fade,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  );
                                },
                              ),
                            ),
                            SizedBox(
                              height: 10.h,
                            ),
                            SizedBox(
                              child: Card.filled(
                                shape: const RoundedRectangleBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(15)),
                                ),
                                color: Colors.white,
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 25,
                                    vertical: 20,
                                  ),
                                  child: Row(
                                    children: [
                                      Text(
                                        'Grand Total : \t ',
                                        style: TextStyle(
                                          fontWeight: FontWeight.w400,
                                          color: Colors.black45,
                                          fontSize: 14.sp,
                                          overflow: TextOverflow.fade,
                                        ),
                                      ),
                                      const Spacer(),
                                      Text(
                                        'Rp150.000,00',
                                        style: TextStyle(
                                          fontWeight: FontWeight.w500,
                                          color: Colors.black,
                                          fontSize: 14.sp,
                                          overflow: TextOverflow.fade,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ],
                          width: MediaQuery.of(context).size.width - 40.w,
                        ),
                      ],
                    );
                  }
                },
              ),
            ),
    );
  }
}
