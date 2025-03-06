// ignore_for_file: public_member_api_docs

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:iconify_flutter/iconify_flutter.dart';
import 'package:iconify_flutter/icons/zondicons.dart';
import 'package:intl/intl.dart';
import 'package:multi_dropdown/multi_dropdown.dart';
import 'package:raskop_fe_backoffice/res/strings.dart';
import 'package:raskop_fe_backoffice/shared/const.dart';
import 'package:raskop_fe_backoffice/shared/toast.dart';
import 'package:raskop_fe_backoffice/src/common/failure/response_failure.dart';
import 'package:raskop_fe_backoffice/src/common/widgets/custom_loading_indicator_widget.dart';
import 'package:raskop_fe_backoffice/src/order/application/order_controller.dart';
import 'package:raskop_fe_backoffice/src/order/domain/entities/order_detail_entity.dart';
import 'package:raskop_fe_backoffice/src/order/domain/entities/order_entity.dart';
import 'package:raskop_fe_backoffice/src/order/domain/entities/update_status_order_request_entity.dart';
import 'package:raskop_fe_backoffice/src/order/presentation/screens/create_order_screen.dart';
import 'package:raskop_fe_backoffice/src/order/presentation/widgets/reservasi_reguler_button_filter_widget.dart';
import 'package:raskop_fe_backoffice/src/supplier/presentation/widgets/positioned_directional_backdrop_blur_widget.dart';

///
class OrderScreen extends ConsumerStatefulWidget {
  ///
  const OrderScreen({super.key});

  ///
  static const String route = 'order';

  @override
  ConsumerState<OrderScreen> createState() => _OrderScreenState();
}

class _OrderScreenState extends ConsumerState<OrderScreen> {
  AsyncValue<List<OrderEntity>> get orders =>
      ref.watch(orderControllerProvider);
  bool isCreating = false;
  bool isDetailPanelVisible = false;

  bool isLoading = false;

  TextEditingController idDetail = TextEditingController();
  TextEditingController name = TextEditingController();
  TextEditingController jenis = TextEditingController();
  TextEditingController kontak = TextEditingController();
  TextEditingController grandTotal = TextEditingController();
  String? status;

  void onReservasi() {
    ref.read(orderControllerProvider.notifier).onSearch(
      advSearch: {
        'withDeleted': true,
        'withReservasi': true,
        'withRelation': true,
      },
    );
  }

  void onReguler() {
    ref.read(orderControllerProvider.notifier).onSearch(
      advSearch: {
        'withDeleted': true,
        'withReservasi': false,
        'withRelation': true,
      },
    );
  }

  List<OrderDetailEntity>? details;

  List<DropdownItem<String>> orderStatus = [
    DropdownItem(label: 'Belum Dibuat', value: 'BELUM_DIBUAT'),
    DropdownItem(label: 'Diproses', value: 'PROSES'),
    DropdownItem(label: 'Selesai Dibuat', value: 'SELESAI_DIBUAT'),
    DropdownItem(label: 'Dibatalkan', value: 'CANCELED'),
    DropdownItem(label: 'Menunggu Pembayaran', value: 'MENUNGGU_PEMBAYARAN'),
    DropdownItem(label: 'Menunggu Pelunasan', value: 'MENUNGGU_PELUNASAN'),
  ];

  List<DropdownItem<String>> updateOrderStatus = [];

  final statusTabletController = MultiSelectController<String>();
  final statusPhoneController = MultiSelectController<String>();

  @override
  Widget build(BuildContext context) {
    final controller = ref.watch(orderControllerProvider.notifier);
    void openDetailPanel({required OrderEntity detailOrder}) {
      setState(() {
        isDetailPanelVisible = true;
        details = detailOrder.orderDetail;
        status =
            orderStatus.firstWhere((e) => e.value == detailOrder.status).label;
        idDetail.value = TextEditingValue(text: detailOrder.id);
        name.value = TextEditingValue(text: detailOrder.orderBy);
        jenis.value = TextEditingValue(
          text: detailOrder.reservasiId == null || detailOrder.reservasiId == ''
              ? 'Reguler'
              : 'Reservasi',
        );
        kontak.value = TextEditingValue(text: detailOrder.phoneNumber);
        grandTotal.value = TextEditingValue(
          text: detailOrder.transaction!.isEmpty
              ? 'Trx Not Found'
              : NumberFormat.simpleCurrency(
                  locale: 'id-ID',
                  name: 'Rp',
                  decimalDigits: 2,
                ).format(detailOrder.transaction!.first.grossAmount),
        );
        detailOrder.status == 'BELUM_DIBUAT'
            ? statusTabletController
                .addItem(DropdownItem(label: 'Diproses', value: 'PROSES'))
            : detailOrder.status == 'PROSES'
                ? statusTabletController.addItems([
                    DropdownItem(
                      label: 'Selesai Dibuat',
                      value: 'SELESAI_DIBUAT',
                    ),
                  ])
                : statusTabletController.clearAll();
        detailOrder.status == 'BELUM_DIBUAT'
            ? statusPhoneController
                .addItem(DropdownItem(label: 'Diproses', value: 'PROSES'))
            : detailOrder.status == 'PROSES'
                ? statusPhoneController.addItems([
                    DropdownItem(
                      label: 'Selesai Dibuat',
                      value: 'SELESAI_DIBUAT',
                    ),
                  ])
                : statusPhoneController.clearAll();
      });
    }

    void closeDetailPanel() {
      setState(() {
        isDetailPanelVisible = false;
        statusTabletController
          ..clearAll()
          ..setItems([]);
        statusPhoneController
          ..clearAll()
          ..setItems([]);
        idDetail.clear();
        name.clear();
        jenis.clear();
        kontak.clear();
        grandTotal.clear();
        status = null;
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
                                    onReservasi: onReservasi,
                                    onReguler: onReguler,
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
                                child: orders.when(
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
                                                orderControllerProvider,
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
                                    return ListView(
                                      controller: controller.controller,
                                      padding: EdgeInsets.zero,
                                      shrinkWrap: true,
                                      children: [
                                        for (final e in data)
                                          Container(
                                            margin:
                                                EdgeInsets.only(bottom: 7.h),
                                            decoration: BoxDecoration(
                                              border: Border.all(
                                                color: Colors.grey,
                                              ),
                                              borderRadius:
                                                  BorderRadius.circular(18),
                                              color: hexToColor('#E1E1E1'),
                                            ),
                                            child: Slidable(
                                              child: Container(
                                                decoration: BoxDecoration(
                                                  border: Border.all(
                                                    color: Colors.grey,
                                                  ),
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                    18,
                                                  ),
                                                  color: Colors.white,
                                                ),
                                                padding: EdgeInsets.symmetric(
                                                  horizontal: 10.w,
                                                  vertical: 8.h,
                                                ),
                                                child: Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceBetween,
                                                  children: [
                                                    Expanded(
                                                      flex: 2,
                                                      child: Text(
                                                        e.id,
                                                        maxLines: 1,
                                                        style: TextStyle(
                                                          fontWeight:
                                                              FontWeight.w500,
                                                          color: hexToColor(
                                                            '#202224',
                                                          ),
                                                          fontSize: 14,
                                                          overflow: TextOverflow
                                                              .ellipsis,
                                                        ),
                                                      ),
                                                    ),
                                                    Expanded(
                                                      flex: 2,
                                                      child: Text(
                                                        e.reservasiId != null
                                                            ? 'Reservasi'
                                                            : 'Reguler',
                                                        style: TextStyle(
                                                          fontWeight:
                                                              FontWeight.w500,
                                                          color: hexToColor(
                                                            '#202224',
                                                          ),
                                                          fontSize: 14,
                                                        ),
                                                      ),
                                                    ),
                                                    Expanded(
                                                      flex: 2,
                                                      child: Text(
                                                        e.orderBy,
                                                        maxLines: 2,
                                                        style: TextStyle(
                                                          fontWeight:
                                                              FontWeight.w500,
                                                          color: hexToColor(
                                                            '#202224',
                                                          ),
                                                          fontSize: 14,
                                                          overflow: TextOverflow
                                                              .ellipsis,
                                                        ),
                                                      ),
                                                    ),
                                                    Expanded(
                                                      flex: 2,
                                                      child: Text(
                                                        e.phoneNumber,
                                                        style: TextStyle(
                                                          fontWeight:
                                                              FontWeight.w500,
                                                          color: hexToColor(
                                                            '#202224',
                                                          ),
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
                                                                BorderRadius
                                                                    .all(
                                                              Radius.circular(
                                                                30,
                                                              ),
                                                            ),
                                                          ),
                                                          side: BorderSide(
                                                            width: 3,
                                                            color: e.status ==
                                                                    orderStatus
                                                                        .elementAt(
                                                                          0,
                                                                        )
                                                                        .value
                                                                ? hexToColor(
                                                                    '#FFDD82',
                                                                  )
                                                                : e.status ==
                                                                        orderStatus
                                                                            .elementAt(
                                                                              1,
                                                                            )
                                                                            .value
                                                                    ? hexToColor(
                                                                        '#1F4940',
                                                                      )
                                                                    : e.status ==
                                                                            orderStatus.elementAt(2).value
                                                                        ? hexToColor(
                                                                            '#47B881',
                                                                          )
                                                                        : e.status == orderStatus.elementAt(3).value
                                                                            ? hexToColor(
                                                                                '#F64C4C',
                                                                              )
                                                                            : hexToColor(
                                                                                '#4287F5',
                                                                              ),
                                                          ),
                                                          label: Center(
                                                            child: Text(
                                                              orderStatus
                                                                  .firstWhere(
                                                                    (element) =>
                                                                        element
                                                                            .value ==
                                                                        e.status,
                                                                  )
                                                                  .label,
                                                              style: TextStyle(
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w700,
                                                                color: e
                                                                            .status ==
                                                                        orderStatus
                                                                            .elementAt(
                                                                              0,
                                                                            )
                                                                            .value
                                                                    ? hexToColor(
                                                                        '#FFDD82',
                                                                      )
                                                                    : e.status ==
                                                                            orderStatus.elementAt(1).value
                                                                        ? hexToColor(
                                                                            '#1F4940',
                                                                          )
                                                                        : e.status == orderStatus.elementAt(2).value
                                                                            ? hexToColor(
                                                                                '#47B881',
                                                                              )
                                                                            : e.status == orderStatus.elementAt(3).value
                                                                                ? hexToColor(
                                                                                    '#F64C4C',
                                                                                  )
                                                                                : hexToColor(
                                                                                    '#4287F5',
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
                                                          padding: EdgeInsets
                                                              .symmetric(
                                                            horizontal: 10.h,
                                                          ),
                                                          child: TextButton(
                                                            onPressed: () {
                                                              openDetailPanel(
                                                                detailOrder: e,
                                                              );
                                                            },
                                                            style: TextButton
                                                                .styleFrom(
                                                              backgroundColor:
                                                                  hexToColor(
                                                                '#f6e9e0',
                                                              ),
                                                              minimumSize:
                                                                  const Size(
                                                                double.infinity,
                                                                40,
                                                              ),
                                                            ),
                                                            child: Text(
                                                              'Lihat',
                                                              style: TextStyle(
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w700,
                                                                color:
                                                                    hexToColor(
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
                                          ),
                                        if (controller.hasMore)
                                          const Padding(
                                            padding: EdgeInsets.only(top: 16),
                                            child: Center(
                                              child: CustomLoadingIndicator(),
                                            ),
                                          ),
                                      ],
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
                                    onPressed: closeDetailPanel,
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(
                              height: 20.h,
                            ),
                            Text(
                              'ID Order',
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
                              controller: idDetail,
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
                              status == null ? 'Status' : 'Status: ${status!}',
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.w500,
                                fontSize: 14.sp,
                              ),
                            ),
                            SizedBox(
                              height: 5.h,
                            ),
                            Row(
                              children: [
                                Expanded(
                                  flex: 2,
                                  child: MultiDropdown<String>(
                                    singleSelect: true,
                                    items: updateOrderStatus,
                                    controller: statusTabletController,
                                    onSelectionChange: (selectedItems) {
                                      setState(() {});
                                    },
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
                                ),
                                const SizedBox(
                                  width: 5,
                                ),
                                Flexible(
                                  child: ElevatedButton(
                                    onPressed: isLoading
                                        ? () {}
                                        : () async {
                                            if (statusTabletController
                                                    .selectedItems.isNotEmpty &&
                                                statusTabletController
                                                        .selectedItems
                                                        .first
                                                        .value !=
                                                    status) {
                                              setState(() {
                                                isLoading = true;
                                              });
                                              try {
                                                await ref
                                                    .read(
                                                      orderControllerProvider
                                                          .notifier,
                                                    )
                                                    .updateStatus(
                                                      request:
                                                          UpdateStatusOrderRequestEntity(
                                                        id: idDetail.text,
                                                        status:
                                                            statusTabletController
                                                                .selectedItems
                                                                .first
                                                                .value,
                                                      ),
                                                    );
                                                setState(() {
                                                  Toast().showSuccessToast(
                                                    context: context,
                                                    title:
                                                        'Update Status Success',
                                                    description:
                                                        'Order with ID: ${idDetail.text} has been successfully updated',
                                                  );
                                                });
                                              } on ResponseFailure catch (e) {
                                                final err = e.allError
                                                    as Map<String, dynamic>;
                                                setState(() {
                                                  Toast().showErrorToast(
                                                    context: context,
                                                    title:
                                                        'Update Status Failed',
                                                    description:
                                                        '${err['name']} - ${err['message']}}',
                                                  );
                                                });
                                              } finally {
                                                setState(() {
                                                  isLoading = false;
                                                });
                                                closeDetailPanel();
                                              }
                                            }
                                          },
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: hexToColor('#1F4940'),
                                      shape: const RoundedRectangleBorder(
                                        borderRadius: BorderRadius.all(
                                          Radius.circular(15),
                                        ),
                                      ),
                                    ),
                                    child: Padding(
                                      padding: const EdgeInsets.symmetric(
                                        vertical: 6,
                                      ),
                                      child: isLoading
                                          ? const Center(
                                              child: CustomLoadingIndicator(
                                                boxWidth: 5,
                                                color: Colors.white,
                                              ),
                                            )
                                          : const Center(
                                              child: Text(
                                                'Update Status',
                                                textAlign: TextAlign.center,
                                                style: TextStyle(
                                                  color: Colors.white,
                                                  fontWeight: FontWeight.w600,
                                                  fontSize: 12,
                                                ),
                                              ),
                                            ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(
                              height: 20.h,
                            ),
                            if (details != null)
                              SizedBox(
                                height:
                                    MediaQuery.of(context).size.height * 0.6,
                                child: ListView(
                                  children: details!.map(
                                    (e) {
                                      return Card.filled(
                                        margin: EdgeInsets.only(bottom: 15.h),
                                        shape: const RoundedRectangleBorder(
                                          borderRadius: BorderRadius.all(
                                            Radius.circular(15),
                                          ),
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
                                                'ID : ${e.id}',
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
                                                        fontWeight:
                                                            FontWeight.w400,
                                                        color: Colors.black45,
                                                        fontSize: 15.sp,
                                                        overflow:
                                                            TextOverflow.fade,
                                                      ),
                                                    ),
                                                    TextSpan(
                                                      text: e.menu!.name,
                                                      style: TextStyle(
                                                        fontWeight:
                                                            FontWeight.w500,
                                                        color: Colors.black,
                                                        fontSize: 15.sp,
                                                        overflow:
                                                            TextOverflow.fade,
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
                                                        fontWeight:
                                                            FontWeight.w400,
                                                        color: Colors.black45,
                                                        fontSize: 14.sp,
                                                        overflow:
                                                            TextOverflow.fade,
                                                      ),
                                                    ),
                                                    WidgetSpan(
                                                      child: SizedBox(
                                                        width: MediaQuery.of(
                                                              context,
                                                            ).size.width *
                                                            0.046,
                                                      ),
                                                    ),
                                                    TextSpan(
                                                      text: e.note,
                                                      style: TextStyle(
                                                        fontWeight:
                                                            FontWeight.w500,
                                                        color: Colors.black,
                                                        fontSize: 14.sp,
                                                        overflow:
                                                            TextOverflow.fade,
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
                                                        fontWeight:
                                                            FontWeight.w400,
                                                        color: Colors.black45,
                                                        fontSize: 14.sp,
                                                        overflow:
                                                            TextOverflow.fade,
                                                      ),
                                                    ),
                                                    WidgetSpan(
                                                      child: SizedBox(
                                                        width: MediaQuery.of(
                                                              context,
                                                            ).size.width *
                                                            0.035,
                                                      ),
                                                    ),
                                                    TextSpan(
                                                      text: e.qty.toString(),
                                                      style: TextStyle(
                                                        fontWeight:
                                                            FontWeight.w500,
                                                        color: Colors.black,
                                                        fontSize: 14.sp,
                                                        overflow:
                                                            TextOverflow.fade,
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
                                                        fontWeight:
                                                            FontWeight.w400,
                                                        color: Colors.black45,
                                                        fontSize: 14.sp,
                                                        overflow:
                                                            TextOverflow.fade,
                                                      ),
                                                    ),
                                                    WidgetSpan(
                                                      child: SizedBox(
                                                        width: MediaQuery.of(
                                                              context,
                                                            ).size.width *
                                                            0.033,
                                                      ),
                                                    ),
                                                    TextSpan(
                                                      text: NumberFormat
                                                          .simpleCurrency(
                                                        locale: 'id-ID',
                                                        name: 'Rp',
                                                        decimalDigits: 2,
                                                      ).format(
                                                        e.price,
                                                      ),
                                                      style: TextStyle(
                                                        fontWeight:
                                                            FontWeight.w500,
                                                        color: Colors.black,
                                                        fontSize: 14.sp,
                                                        overflow:
                                                            TextOverflow.fade,
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
                                  ).toList(),
                                ),
                              )
                            else
                              const SizedBox(),
                            SizedBox(
                              height: 10.h,
                            ),
                            if (details != null)
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
                                          grandTotal.text,
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
                              )
                            else
                              const SizedBox(),
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
                                    onReservasi: onReservasi,
                                    onReguler: onReguler,
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
                                child: orders.when(
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
                                                orderControllerProvider,
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
                                    return ListView(
                                      controller: controller.controller,
                                      padding: EdgeInsets.zero,
                                      shrinkWrap: true,
                                      children: [
                                        for (final e in data)
                                          Container(
                                            margin:
                                                EdgeInsets.only(bottom: 7.h),
                                            decoration: BoxDecoration(
                                              border: Border.all(
                                                color: Colors.grey,
                                              ),
                                              borderRadius:
                                                  BorderRadius.circular(18),
                                              color: hexToColor('#E1E1E1'),
                                            ),
                                            child: Slidable(
                                              child: Container(
                                                decoration: BoxDecoration(
                                                  border: Border.all(
                                                    color: Colors.grey,
                                                  ),
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                    18,
                                                  ),
                                                  color: Colors.white,
                                                ),
                                                padding: EdgeInsets.symmetric(
                                                  horizontal: 10.w,
                                                  vertical: 8.h,
                                                ),
                                                child: Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceBetween,
                                                  children: [
                                                    Expanded(
                                                      flex: 2,
                                                      child: Text(
                                                        e.id,
                                                        maxLines: 1,
                                                        style: TextStyle(
                                                          fontWeight:
                                                              FontWeight.w600,
                                                          color: hexToColor(
                                                            '#202224',
                                                          ),
                                                          fontSize: 12,
                                                          overflow: TextOverflow
                                                              .ellipsis,
                                                        ),
                                                      ),
                                                    ),
                                                    Expanded(
                                                      flex: 2,
                                                      child: Text(
                                                        e.orderBy,
                                                        maxLines: 1,
                                                        style: TextStyle(
                                                          fontWeight:
                                                              FontWeight.w600,
                                                          color: hexToColor(
                                                            '#202224',
                                                          ),
                                                          fontSize: 12,
                                                          overflow: TextOverflow
                                                              .ellipsis,
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
                                                                BorderRadius
                                                                    .all(
                                                              Radius.circular(
                                                                30,
                                                              ),
                                                            ),
                                                          ),
                                                          side: BorderSide(
                                                            width: 3,
                                                            color: e.status ==
                                                                    orderStatus
                                                                        .elementAt(
                                                                          0,
                                                                        )
                                                                        .value
                                                                ? hexToColor(
                                                                    '#FFDD82',
                                                                  )
                                                                : e.status ==
                                                                        orderStatus
                                                                            .elementAt(
                                                                              1,
                                                                            )
                                                                            .value
                                                                    ? hexToColor(
                                                                        '#1F4940',
                                                                      )
                                                                    : e.status ==
                                                                            orderStatus.elementAt(2).value
                                                                        ? hexToColor(
                                                                            '#47B881',
                                                                          )
                                                                        : e.status == orderStatus.elementAt(3).value
                                                                            ? hexToColor(
                                                                                '#F64C4C',
                                                                              )
                                                                            : hexToColor(
                                                                                '#4287F5',
                                                                              ),
                                                          ),
                                                          label: Center(
                                                            child: Text(
                                                              orderStatus
                                                                  .firstWhere(
                                                                    (el) =>
                                                                        el.value ==
                                                                        e.status,
                                                                  )
                                                                  .label,
                                                              maxLines: 2,
                                                              style: TextStyle(
                                                                overflow:
                                                                    TextOverflow
                                                                        .fade,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w700,
                                                                color: e
                                                                            .status ==
                                                                        orderStatus
                                                                            .elementAt(
                                                                              0,
                                                                            )
                                                                            .value
                                                                    ? hexToColor(
                                                                        '#FFDD82',
                                                                      )
                                                                    : e.status ==
                                                                            orderStatus.elementAt(1).value
                                                                        ? hexToColor(
                                                                            '#1F4940',
                                                                          )
                                                                        : e.status == orderStatus.elementAt(3).value
                                                                            ? hexToColor(
                                                                                '#47B881',
                                                                              )
                                                                            : e.status == orderStatus.elementAt(3).value
                                                                                ? hexToColor(
                                                                                    '#F64C4C',
                                                                                  )
                                                                                : hexToColor(
                                                                                    '#4287F5',
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
                                                          padding: EdgeInsets
                                                              .symmetric(
                                                            horizontal: 10.h,
                                                          ),
                                                          child: TextButton(
                                                            onPressed: () {
                                                              openDetailPanel(
                                                                detailOrder: e,
                                                              );
                                                            },
                                                            style: TextButton
                                                                .styleFrom(
                                                              backgroundColor:
                                                                  hexToColor(
                                                                '#f6e9e0',
                                                              ),
                                                              minimumSize:
                                                                  const Size(
                                                                double.infinity,
                                                                40,
                                                              ),
                                                            ),
                                                            child: Text(
                                                              'Lihat',
                                                              style: TextStyle(
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w700,
                                                                color:
                                                                    hexToColor(
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
                                          ),
                                        if (controller.hasMore)
                                          const Padding(
                                            padding: EdgeInsets.only(top: 16),
                                            child: Center(
                                              child: CustomLoadingIndicator(),
                                            ),
                                          ),
                                      ],
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
                                    onPressed: closeDetailPanel,
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(
                              height: 20.h,
                            ),
                            Text(
                              'ID Order',
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
                              controller: idDetail,
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
                              controller: jenis,
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
                              controller: kontak,
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
                              status == null ? 'Status' : 'Status: ${status!}',
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.w500,
                                fontSize: 14.sp,
                              ),
                            ),
                            SizedBox(
                              height: 5.h,
                            ),
                            Row(
                              children: [
                                Expanded(
                                  flex: 2,
                                  child: MultiDropdown<String>(
                                    singleSelect: true,
                                    items: updateOrderStatus,
                                    controller: statusPhoneController,
                                    onSelectionChange: (selectedItems) {
                                      setState(() {});
                                    },
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
                                ),
                                const SizedBox(width: 5),
                                Flexible(
                                  child: ElevatedButton(
                                    onPressed: isLoading
                                        ? () {}
                                        : () async {
                                            if (statusPhoneController
                                                    .selectedItems.isNotEmpty &&
                                                statusPhoneController
                                                        .selectedItems
                                                        .first
                                                        .value !=
                                                    status) {
                                              setState(() {
                                                isLoading = true;
                                              });
                                              try {
                                                print(
                                                  UpdateStatusOrderRequestEntity(
                                                    id: idDetail.text,
                                                    status:
                                                        statusPhoneController
                                                            .selectedItems
                                                            .first
                                                            .value,
                                                  ),
                                                );
                                                await ref
                                                    .read(
                                                      orderControllerProvider
                                                          .notifier,
                                                    )
                                                    .updateStatus(
                                                      request:
                                                          UpdateStatusOrderRequestEntity(
                                                        id: idDetail.text,
                                                        status:
                                                            statusPhoneController
                                                                .selectedItems
                                                                .first
                                                                .value,
                                                      ),
                                                    );
                                                setState(() {
                                                  Toast().showSuccessToast(
                                                    context: context,
                                                    title:
                                                        'Update Status Success',
                                                    description:
                                                        'Order with ID: ${idDetail.text} has been successfully updated',
                                                  );
                                                });
                                              } on ResponseFailure catch (e) {
                                                final err = e.allError
                                                    as Map<String, dynamic>;
                                                setState(() {
                                                  Toast().showErrorToast(
                                                    context: context,
                                                    title:
                                                        'Update Status Failed',
                                                    description:
                                                        '${err['name']} - ${err['message']}',
                                                  );
                                                });
                                              } finally {
                                                setState(() {
                                                  isLoading = false;
                                                });
                                                closeDetailPanel();
                                              }
                                            }
                                          },
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: hexToColor('#1F4940'),
                                      shape: const RoundedRectangleBorder(
                                        borderRadius: BorderRadius.all(
                                          Radius.circular(15),
                                        ),
                                      ),
                                    ),
                                    child: Padding(
                                      padding: const EdgeInsets.symmetric(
                                        vertical: 6,
                                      ),
                                      child: isLoading
                                          ? const CustomLoadingIndicator(
                                              boxWidth: 5,
                                              color: Colors.white,
                                            )
                                          : const Center(
                                              child: Text(
                                                'Update Status',
                                                textAlign: TextAlign.center,
                                                style: TextStyle(
                                                  color: Colors.white,
                                                  fontWeight: FontWeight.w600,
                                                  fontSize: 12,
                                                ),
                                              ),
                                            ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(
                              height: 20.h,
                            ),
                            if (details != null)
                              SizedBox(
                                height:
                                    MediaQuery.of(context).size.height * 0.6,
                                child: ListView(
                                  children: details!.map(
                                    (e) {
                                      return Card.filled(
                                        margin: EdgeInsets.only(bottom: 15.h),
                                        shape: const RoundedRectangleBorder(
                                          borderRadius: BorderRadius.all(
                                            Radius.circular(15),
                                          ),
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
                                                'ID : ${e.id}',
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
                                                        fontWeight:
                                                            FontWeight.w400,
                                                        color: Colors.black45,
                                                        fontSize: 15.sp,
                                                        overflow:
                                                            TextOverflow.fade,
                                                      ),
                                                    ),
                                                    TextSpan(
                                                      text: e.menu!.name,
                                                      style: TextStyle(
                                                        fontWeight:
                                                            FontWeight.w500,
                                                        color: Colors.black,
                                                        fontSize: 15.sp,
                                                        overflow:
                                                            TextOverflow.fade,
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
                                                        fontWeight:
                                                            FontWeight.w400,
                                                        color: Colors.black45,
                                                        fontSize: 14.sp,
                                                        overflow:
                                                            TextOverflow.fade,
                                                      ),
                                                    ),
                                                    WidgetSpan(
                                                      child: SizedBox(
                                                        width: MediaQuery.of(
                                                              context,
                                                            ).size.width *
                                                            0.046,
                                                      ),
                                                    ),
                                                    TextSpan(
                                                      text: e.note,
                                                      style: TextStyle(
                                                        fontWeight:
                                                            FontWeight.w500,
                                                        color: Colors.black,
                                                        fontSize: 14.sp,
                                                        overflow:
                                                            TextOverflow.fade,
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
                                                        fontWeight:
                                                            FontWeight.w400,
                                                        color: Colors.black45,
                                                        fontSize: 14.sp,
                                                        overflow:
                                                            TextOverflow.fade,
                                                      ),
                                                    ),
                                                    WidgetSpan(
                                                      child: SizedBox(
                                                        width: MediaQuery.of(
                                                              context,
                                                            ).size.width *
                                                            0.035,
                                                      ),
                                                    ),
                                                    TextSpan(
                                                      text: e.qty.toString(),
                                                      style: TextStyle(
                                                        fontWeight:
                                                            FontWeight.w500,
                                                        color: Colors.black,
                                                        fontSize: 14.sp,
                                                        overflow:
                                                            TextOverflow.fade,
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
                                                        fontWeight:
                                                            FontWeight.w400,
                                                        color: Colors.black45,
                                                        fontSize: 14.sp,
                                                        overflow:
                                                            TextOverflow.fade,
                                                      ),
                                                    ),
                                                    WidgetSpan(
                                                      child: SizedBox(
                                                        width: MediaQuery.of(
                                                              context,
                                                            ).size.width *
                                                            0.033,
                                                      ),
                                                    ),
                                                    TextSpan(
                                                      text: NumberFormat
                                                          .simpleCurrency(
                                                        locale: 'id-ID',
                                                        name: 'Rp',
                                                        decimalDigits: 2,
                                                      ).format(e.price),
                                                      style: TextStyle(
                                                        fontWeight:
                                                            FontWeight.w500,
                                                        color: Colors.black,
                                                        fontSize: 14.sp,
                                                        overflow:
                                                            TextOverflow.fade,
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
                                  ).toList(),
                                ),
                              )
                            else
                              const SizedBox(),
                            SizedBox(
                              height: 10.h,
                            ),
                            if (details != null)
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
                                          grandTotal.text,
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
                              )
                            else
                              const SizedBox(),
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
