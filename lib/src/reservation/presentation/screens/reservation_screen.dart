import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:go_router/go_router.dart';
import 'package:iconify_flutter/iconify_flutter.dart';
import 'package:iconify_flutter/icons/mdi.dart';
import 'package:iconify_flutter/icons/zondicons.dart';
import 'package:intl/intl.dart';
import 'package:multi_dropdown/multi_dropdown.dart';
import 'package:raskop_fe_backoffice/core/core.dart';
import 'package:raskop_fe_backoffice/res/assets.dart';
import 'package:raskop_fe_backoffice/res/strings.dart';
import 'package:raskop_fe_backoffice/shared/const.dart';
import 'package:raskop_fe_backoffice/shared/toast.dart';
import 'package:raskop_fe_backoffice/src/common/failure/response_failure.dart';
import 'package:raskop_fe_backoffice/src/common/widgets/custom_loading_indicator_widget.dart';
import 'package:raskop_fe_backoffice/src/reservation/application/reservation_controller.dart';
import 'package:raskop_fe_backoffice/src/reservation/domain/entities/create_reservation_request_entity.dart';
import 'package:raskop_fe_backoffice/src/reservation/domain/entities/reservation_entity.dart';
import 'package:raskop_fe_backoffice/src/reservation/domain/entities/table_suggestion_request_entity.dart';
import 'package:raskop_fe_backoffice/src/reservation/presentation/screens/input_menu_screen.dart';
import 'package:raskop_fe_backoffice/src/supplier/presentation/widgets/positioned_directional_backdrop_blur_widget.dart';
import 'package:raskop_fe_backoffice/src/table/application/table_controller.dart';
import 'package:raskop_fe_backoffice/src/table/domain/entities/table_entity.dart';

///
class ReservationScreen extends ConsumerStatefulWidget {
  ///
  const ReservationScreen({super.key});

  ///
  static const String route = 'reservation';

  @override
  ConsumerState<ReservationScreen> createState() => _ReservationScreenState();
}

class _ReservationScreenState extends ConsumerState<ReservationScreen> {
  AsyncValue<List<ReservationEntity>> get reservations =>
      ref.watch(reservationControllerProvider);

  AsyncValue<List<TableEntity>> get tablesDatas =>
      ref.watch(tableControllerProvider);
  bool isDetailPanelVisible = false;
  bool isCreatePanelVisible = false;

  TextEditingController nama = TextEditingController();
  TextEditingController kontak = TextEditingController();
  TextEditingController startText = TextEditingController();
  TextEditingController endText = TextEditingController();
  TextEditingController catatan = TextEditingController();
  TextEditingController komunitas = TextEditingController();
  TextEditingController jumlah = TextEditingController();
  TextEditingController idDetail = TextEditingController();
  TextEditingController tables = TextEditingController();
  TextEditingController search = TextEditingController();
  DateTime start = DateTime.now();
  DateTime? end;
  String? paymentMethod;
  String? orderId;
  bool? isOutdoor;

  List<String> reservedTable = [];

  Map<String, String> paymentInfo = {
    'method': 'other_qris',
    'status': 'DP',
  };

  List<DropdownItem<String>> tableData = [];

  List<DropdownItem<String>> paymentStatus = [
    DropdownItem(label: 'DP', value: 'DP'),
    DropdownItem(label: 'Settlement', value: 'Settlement'),
  ];

  List<DropdownItem<String>> advSearchOptions = [
    DropdownItem(label: 'Nama', value: 'reserveBy'),
    DropdownItem(label: 'Kontak', value: 'phoneNumber'),
    DropdownItem(label: 'Komunitas', value: 'community'),
  ];

  final tableController = MultiSelectController<String>();
  final statusController = MultiSelectController<String>();

  bool isInputtingMenu = false;
  bool isViewingMenu = false;

  List<(String, double, int, String)> itemList =
      <(String, double, int, String)>[];

  final _formKey = GlobalKey<FormState>();

  List<Map<String, dynamic>> orderList = [];

  List<DropdownItem<String>> orderStatus = [
    DropdownItem(label: 'Belum Dibuat', value: 'BELUM_DIBUAT'),
    DropdownItem(label: 'Diproses', value: 'PROSES'),
    DropdownItem(label: 'Selesai Dibuat', value: 'SELESAI_DIBUAT'),
    DropdownItem(label: 'Dibatalkan', value: 'CANCELED'),
    DropdownItem(label: 'Menunggu Pembayaran', value: 'MENUNGGU_PEMBAYARAN'),
    DropdownItem(label: 'Menunggu Pelunasan', value: 'MENUNGGU_PELUNASAN'),
  ];

  final orderStatusTabletController = MultiSelectController<String>();
  final orderStatusPhoneController = MultiSelectController<String>();

  final advSearchTabletController = MultiSelectController<String>();
  final advSearchPhoneController = MultiSelectController<String>();

  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    final controller = ref.watch(reservationControllerProvider.notifier);
    void openDetailPanel({required ReservationEntity detail}) {
      setState(() {
        detail.orders!.isEmpty || detail.orders == null
            ? itemList.addAll([])
            : detail.orders!.first.orderDetail!.isEmpty ||
                    detail.orders!.first.orderDetail == null
                ? itemList.addAll([])
                : itemList.addAll(
                    detail.orders!.first.orderDetail!
                        .map(
                          (e) => (
                            e.menu?.name ?? '',
                            e.menu?.price ?? 0,
                            e.qty,
                            e.note ?? '',
                          ),
                        )
                        .toList(),
                  );
        detail.detailReservasis == null || detail.detailReservasis!.isEmpty
            ? reservedTable.add('No Table Reserved')
            : reservedTable.addAll(
                detail.detailReservasis!.map((e) => e.table!.noTable).toList(),
              );
        tables.value = TextEditingValue(text: reservedTable.join(', '));

        final jumlahByMinCapacity =
            detail.detailReservasis == null || detail.detailReservasis!.isEmpty
                ? 0
                : detail.detailReservasis!.fold(
                    0,
                    (previousValue, element) =>
                        previousValue + element.table!.minCapacity,
                  );
        idDetail.value = TextEditingValue(text: detail.id);
        nama.value = TextEditingValue(text: detail.reserveBy);
        startText.value = TextEditingValue(
          text: DateFormat(
            'dd/MM/yy; hh:mm a',
          ).format(
            detail.start,
          ),
        );
        endText.value = TextEditingValue(
          text: DateFormat(
            'dd/MM/yy; hh:mm a',
          ).format(
            detail.end,
          ),
        );
        catatan.value = TextEditingValue(text: detail.note ?? '');
        komunitas.value = TextEditingValue(text: detail.community ?? '');
        jumlah.value = TextEditingValue(text: '$jumlahByMinCapacity Orang');
        paymentInfo = {
          'method': detail.orders?.first.transaction?.first.paymentMethod ??
              'unknown',
          'status': detail.halfPayment ? 'DP' : 'Settlement',
        };
        orderId = detail.orders!.first.id;
        kontak.value = TextEditingValue(text: detail.phoneNumber);
        isDetailPanelVisible = true;
      });
    }

    void closeDetailPanel() {
      setState(() {
        idDetail.clear();
        nama.clear();
        startText.clear();
        endText.clear();
        catatan.clear();
        komunitas.clear();
        jumlah.clear();
        paymentInfo = {};
        itemList.clear();
        reservedTable.clear();
        kontak.clear();
        orderId = null;
        paymentMethod = null;

        isDetailPanelVisible = false;
      });
    }

    void openCreatePanel() {
      setState(() {
        isCreatePanelVisible = true;
      });
    }

    Future<void> tableSuggest({
      required TableSuggestionRequestEntity request,
    }) async {
      final res = await ref
          .read(reservationControllerProvider.notifier)
          .getTableSuggestion(request: request);
      setState(() {
        tableController.setItems(
          res
              .map(
                (e) => DropdownItem(label: 'Meja ${e.noTable}', value: e.id!),
              )
              .toList(),
        );
      });
    }

    void closeCreatePanel() {
      setState(() {
        isCreatePanelVisible = false;
        nama.clear();
        kontak.clear();
        startText.clear();
        endText.clear();
        catatan.clear();
        komunitas.clear();
        jumlah.clear();
        tableData.clear();
        start = DateTime.now();
        end = null;
        itemList.clear();
        tableController
          ..clearAll()
          ..setItems([]);
        statusController.clearAll();
        paymentMethod = null;
        isOutdoor = null;
        orderList.clear();
      });
    }

    void toggleInputMenuScreen() {
      setState(() {
        isInputtingMenu = !isInputtingMenu;
      });
    }

    void openViewMenuScreen() {
      setState(() {
        isViewingMenu = !isViewingMenu;
      });
    }

    void closeViewMenuScreen() {
      setState(() {
        isViewingMenu = !isViewingMenu;
      });
    }

    Future<void> redirectToMidtransWebView(String redirectUrl) async {
      FocusScope.of(context).unfocus();
      await context.push('/reservation/payment', extra: redirectUrl);
    }

    void onSearchPhone() {
      ref.read(reservationControllerProvider.notifier).onSearch(
        advSearch: {
          'withRelation': true,
          'withDeleted': true,
          for (final item in advSearchPhoneController.selectedItems)
            item.value: search.text,
        },
      );
    }

    void onSearchTablet() {
      ref.read(reservationControllerProvider.notifier).onSearch(
        advSearch: {
          'withRelation': true,
          'withDeleted': true,
          for (final item in advSearchPhoneController.selectedItems)
            item.value: search.text,
        },
      );
    }

    Timer? debounceTimer;

    void debounceOnPhone() {
      if (debounceTimer?.isActive ?? false) debounceTimer!.cancel();
      debounceTimer = Timer(const Duration(milliseconds: 500), onSearchPhone);
    }

    void debounceOnTablet() {
      if (debounceTimer?.isActive ?? false) debounceTimer!.cancel();
      debounceTimer = Timer(const Duration(milliseconds: 500), onSearchTablet);
    }

    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: isInputtingMenu
          ? InputMenuScreen(
              onBack: toggleInputMenuScreen,
              isInput: true,
              orderMenu: itemList,
              orderList: orderList,
              orderId: '',
            )
          : isViewingMenu
              ? InputMenuScreen(
                  onBack: closeViewMenuScreen,
                  isInput: false,
                  orderMenu: itemList,
                  orderList: orderList,
                  orderId: orderId ?? 'Order Not Found',
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
                                  AnimatedContainer(
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      border: Border.all(
                                        color: hexToColor('#E1E1E1'),
                                      ),
                                      borderRadius: const BorderRadius.all(
                                        Radius.circular(15),
                                      ),
                                    ),
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 5,
                                      vertical: 15,
                                    ),
                                    duration: const Duration(milliseconds: 100),
                                    child: Row(
                                      children: [
                                        Flexible(
                                          child: Padding(
                                            padding: const EdgeInsets.only(
                                              left: 20,
                                            ),
                                            child:
                                                Image.asset(ImageAssets.raskop),
                                          ),
                                        ),
                                        const Spacer(),
                                        Expanded(
                                          flex: 5,
                                          child: AnimatedContainer(
                                            duration: const Duration(
                                              milliseconds: 100,
                                            ),
                                            padding: EdgeInsets.symmetric(
                                              horizontal: 15.w,
                                            ),
                                            decoration: BoxDecoration(
                                              border: Border.all(
                                                color: hexToColor('#E1E1E1'),
                                              ),
                                              borderRadius:
                                                  const BorderRadius.all(
                                                Radius.circular(30),
                                              ),
                                            ),
                                            child: Row(
                                              children: [
                                                Flexible(
                                                  flex: 3,
                                                  child: TextFormField(
                                                    controller: search,
                                                    onChanged:
                                                        advSearchTabletController
                                                                .selectedItems
                                                                .isEmpty
                                                            ? (value) {}
                                                            : (value) {
                                                                debounceOnTablet();
                                                              },
                                                    onFieldSubmitted:
                                                        advSearchTabletController
                                                                .selectedItems
                                                                .isEmpty
                                                            ? (value) {}
                                                            : (value) {
                                                                onSearchTablet();
                                                              },
                                                    decoration: InputDecoration(
                                                      filled: false,
                                                      border: InputBorder.none,
                                                      hintText:
                                                          'Temukan nama, kontak, komunitas...',
                                                      hintStyle: TextStyle(
                                                        color: Colors.black
                                                            .withOpacity(0.3),
                                                        fontWeight:
                                                            FontWeight.w400,
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                                Flexible(
                                                  flex: 2,
                                                  child: MultiDropdown<String>(
                                                    items: advSearchOptions,
                                                    controller:
                                                        advSearchTabletController,
                                                    onSelectionChange:
                                                        (selectedItems) {
                                                      setState(() {});
                                                    },
                                                    fieldDecoration:
                                                        const FieldDecoration(
                                                      border:
                                                          OutlineInputBorder(
                                                        borderSide:
                                                            BorderSide.none,
                                                      ),
                                                      hintText: '',
                                                      suffixIcon: Icon(
                                                        Icons.filter_list_alt,
                                                      ),
                                                      animateSuffixIcon: false,
                                                      backgroundColor:
                                                          Colors.transparent,
                                                      borderRadius: 30,
                                                    ),
                                                    dropdownItemDecoration:
                                                        DropdownItemDecoration(
                                                      selectedIcon: Icon(
                                                        Icons.check_box,
                                                        color: hexToColor(
                                                          '#0C9D61',
                                                        ),
                                                      ),
                                                    ),
                                                    dropdownDecoration:
                                                        const DropdownDecoration(
                                                      elevation: 3,
                                                    ),
                                                    chipDecoration:
                                                        ChipDecoration(
                                                      wrap: false,
                                                      backgroundColor:
                                                          hexToColor(
                                                        '#E1E1E1',
                                                      ),
                                                      labelStyle:
                                                          const TextStyle(
                                                        color: Colors.black,
                                                        fontSize: 12,
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  const SizedBox(
                                    height: 10,
                                  ),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: [
                                      ElevatedButton(
                                        style: ElevatedButton.styleFrom(
                                          backgroundColor:
                                              hexToColor('#1f4940'),
                                        ),
                                        onPressed: openCreatePanel,
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
                                    margin:
                                        EdgeInsets.only(top: 12.h, bottom: 7.h),
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
                                            flex: 3,
                                            child: Center(
                                              child: Text(
                                                'START',
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
                                              child: Text(
                                                'END',
                                                style: TextStyle(
                                                  fontWeight: FontWeight.w600,
                                                  color: hexToColor('#202224'),
                                                  fontSize: 14,
                                                ),
                                              ),
                                            ),
                                          ),
                                          Expanded(
                                            flex: 5,
                                            child: Center(
                                              child: Text(
                                                'CATT, KOMUNITAS, PYMT',
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
                                    child: reservations.when(
                                      loading: () => const Center(
                                        child: CustomLoadingIndicator(),
                                      ),
                                      error: (error, stackTrace) => Center(
                                        child: Text(
                                          error.toString() +
                                              stackTrace.toString(),
                                        ),
                                      ),
                                      data: (data) {
                                        return ListView(
                                          controller: controller.controller,
                                          padding: EdgeInsets.zero,
                                          shrinkWrap: true,
                                          children: [
                                            for (final e in data)
                                              Container(
                                                margin: EdgeInsets.only(
                                                  bottom: 7.h,
                                                ),
                                                decoration: BoxDecoration(
                                                  border: Border.all(
                                                    color: Colors.grey,
                                                  ),
                                                  borderRadius:
                                                      BorderRadius.circular(18),
                                                  color: hexToColor('#E1E1E1'),
                                                ),
                                                child: Slidable(
                                                  endActionPane: ActionPane(
                                                    extentRatio: 0.1,
                                                    motion:
                                                        const BehindMotion(),
                                                    children: [
                                                      Expanded(
                                                        child: SizedBox.expand(
                                                          child:
                                                              GestureDetector(
                                                            onTap: () {
                                                              showConfirmationDialog(
                                                                context:
                                                                    context,
                                                                title:
                                                                    'Tolak pengajuan reservasi?',
                                                                content:
                                                                    'Reservasi ini akan ditolak dan terhapus secara permanen.',
                                                                onConfirm:
                                                                    () async {
                                                                  try {
                                                                    await ref
                                                                        .read(
                                                                      reservationControllerProvider
                                                                          .notifier,
                                                                    )
                                                                        .cancelReservation(
                                                                      id: <String,
                                                                          dynamic>{
                                                                        'id': e
                                                                            .id,
                                                                      },
                                                                    );
                                                                    setState(
                                                                        () {
                                                                      Toast()
                                                                          .showSuccessToast(
                                                                        context:
                                                                            context,
                                                                        title:
                                                                            'Tolak Reservasi Success',
                                                                        description:
                                                                            'Successfully Tolak Reservasi',
                                                                      );
                                                                    });
                                                                  } catch (e) {
                                                                    setState(
                                                                        () {
                                                                      Toast()
                                                                          .showErrorToast(
                                                                        context:
                                                                            context,
                                                                        title:
                                                                            'Tolak Reservasi Error',
                                                                        description:
                                                                            'Desc: $e',
                                                                      );
                                                                    });
                                                                    print(
                                                                      'error occured on cancel reservasi : $e',
                                                                    );
                                                                  } finally {
                                                                    setState(
                                                                        () {
                                                                      context
                                                                          .pop();
                                                                      FocusScope
                                                                          .of(
                                                                        context,
                                                                      ).unfocus();
                                                                    });
                                                                  }
                                                                },
                                                                isWideScreen:
                                                                    true,
                                                              );
                                                            },
                                                            child: Container(
                                                              decoration:
                                                                  BoxDecoration(
                                                                borderRadius:
                                                                    const BorderRadius
                                                                        .only(
                                                                  topRight: Radius
                                                                      .circular(
                                                                    18,
                                                                  ),
                                                                  bottomRight:
                                                                      Radius
                                                                          .circular(
                                                                    18,
                                                                  ),
                                                                ),
                                                                color:
                                                                    hexToColor(
                                                                  '#E1E1E1',
                                                                ),
                                                              ),
                                                              child: Center(
                                                                child:
                                                                    Container(
                                                                  width: MediaQuery
                                                                          .of(
                                                                        context,
                                                                      ).size.width *
                                                                      0.064,
                                                                  height: MediaQuery
                                                                          .of(
                                                                        context,
                                                                      ).size.width *
                                                                      0.04,
                                                                  decoration:
                                                                      BoxDecoration(
                                                                    borderRadius:
                                                                        const BorderRadius
                                                                            .all(
                                                                      Radius
                                                                          .circular(
                                                                        15,
                                                                      ),
                                                                    ),
                                                                    color:
                                                                        hexToColor(
                                                                      '#F64C4C',
                                                                    ),
                                                                  ),
                                                                  child:
                                                                      const Center(
                                                                    child: Text(
                                                                      'Tolak',
                                                                      textAlign:
                                                                          TextAlign
                                                                              .center,
                                                                      style:
                                                                          TextStyle(
                                                                        color: Colors
                                                                            .white,
                                                                        fontSize:
                                                                            14,
                                                                      ),
                                                                    ),
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
                                                      border: Border.all(
                                                        color: Colors.grey,
                                                      ),
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                        18,
                                                      ),
                                                      color: Colors.white,
                                                    ),
                                                    padding:
                                                        EdgeInsets.symmetric(
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
                                                                  FontWeight
                                                                      .w500,
                                                              color: hexToColor(
                                                                '#202224',
                                                              ),
                                                              fontSize: 14,
                                                              overflow:
                                                                  TextOverflow
                                                                      .ellipsis,
                                                            ),
                                                          ),
                                                        ),
                                                        Expanded(
                                                          flex: 2,
                                                          child: Text(
                                                            e.reserveBy,
                                                            maxLines: 2,
                                                            style: TextStyle(
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w500,
                                                              color: hexToColor(
                                                                '#202224',
                                                              ),
                                                              fontSize: 14,
                                                              overflow:
                                                                  TextOverflow
                                                                      .ellipsis,
                                                            ),
                                                          ),
                                                        ),
                                                        Expanded(
                                                          flex: 2,
                                                          child: Text(
                                                            e.phoneNumber,
                                                            maxLines: 1,
                                                            style: TextStyle(
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w500,
                                                              color: hexToColor(
                                                                '#202224',
                                                              ),
                                                              fontSize: 14,
                                                              overflow:
                                                                  TextOverflow
                                                                      .ellipsis,
                                                            ),
                                                          ),
                                                        ),
                                                        Expanded(
                                                          flex: 3,
                                                          child: Center(
                                                            child: Text(
                                                              DateFormat(
                                                                'dd/MM/yy; hh:mm a',
                                                              ).format(
                                                                e.start,
                                                              ),
                                                              style: TextStyle(
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w500,
                                                                color:
                                                                    hexToColor(
                                                                  '#202224',
                                                                ),
                                                                fontSize: 14,
                                                              ),
                                                            ),
                                                          ),
                                                        ),
                                                        Expanded(
                                                          flex: 3,
                                                          child: Center(
                                                            child: Text(
                                                              DateFormat(
                                                                'dd/MM/yy; hh:mm a',
                                                              ).format(
                                                                e.end,
                                                              ),
                                                              style: TextStyle(
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w500,
                                                                color:
                                                                    hexToColor(
                                                                  '#202224',
                                                                ),
                                                                fontSize: 14,
                                                              ),
                                                            ),
                                                          ),
                                                        ),
                                                        Expanded(
                                                          flex: 5,
                                                          child: Center(
                                                            child: Padding(
                                                              padding: EdgeInsets
                                                                  .symmetric(
                                                                horizontal:
                                                                    10.h,
                                                              ),
                                                              child: TextButton(
                                                                onPressed: () {
                                                                  openDetailPanel(
                                                                    detail: e,
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
                                                                    double
                                                                        .infinity,
                                                                    40,
                                                                  ),
                                                                ),
                                                                child: Text(
                                                                  'Lihat',
                                                                  style:
                                                                      TextStyle(
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .w700,
                                                                    color:
                                                                        hexToColor(
                                                                      '#E38D5D',
                                                                    ),
                                                                    fontSize:
                                                                        14,
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
                                                padding:
                                                    EdgeInsets.only(top: 16),
                                                child: Center(
                                                  child:
                                                      CustomLoadingIndicator(),
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
                                        borderRadius: BorderRadius.all(
                                          Radius.circular(50),
                                        ),
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
                                  'Catatan',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.w500,
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
                                  controller: catatan,
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
                                  height: 10.h,
                                ),
                                Text(
                                  'Komunitas',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.w500,
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
                                  controller: komunitas,
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
                                  height: 10.h,
                                ),
                                Text(
                                  'Status Pembayaran',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.w500,
                                    fontSize: 14.sp,
                                  ),
                                ),
                                SizedBox(
                                  height: 5.h,
                                ),
                                if (paymentInfo['status'] == 'DP')
                                  Row(
                                    children: [
                                      Flexible(
                                        child: TextFormField(
                                          readOnly: true,
                                          style: const TextStyle(
                                            fontWeight: FontWeight.w400,
                                            color: Colors.black,
                                            fontSize: 14,
                                            overflow: TextOverflow.fade,
                                          ),
                                          initialValue: 'DP',
                                          decoration: const InputDecoration(
                                            filled: true,
                                            fillColor: Colors.white,
                                            focusedBorder: OutlineInputBorder(
                                              borderRadius: BorderRadius.all(
                                                Radius.circular(15),
                                              ),
                                            ),
                                            border: OutlineInputBorder(
                                              borderRadius: BorderRadius.all(
                                                Radius.circular(15),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                      const SizedBox(
                                        width: 5,
                                      ),
                                      Expanded(
                                        flex: 2,
                                        child: _customButton(
                                          child: const Text(
                                            'Pelunasan',
                                            style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 14,
                                            ),
                                          ),
                                          color: hexToColor('#FFAD0D'),
                                          onTap: () async {
                                            await showDialog<AlertDialog>(
                                              context: context,
                                              builder: (context) {
                                                return AlertDialog(
                                                  backgroundColor: Colors.white,
                                                  title: const Text(
                                                    'Metode Pembayaran',
                                                  ),
                                                  content: const Text(
                                                    'Pilih Metode Pembayaran',
                                                  ),
                                                  actions: [
                                                    _customButton(
                                                      child: Image.asset(
                                                        ImageAssets.qris,
                                                        fit: BoxFit.fill,
                                                        width: 50,
                                                        height: 20,
                                                      ),
                                                      color: Colors.white,
                                                      onTap: () async {
                                                        setState(() {
                                                          paymentMethod =
                                                              'other_qris';
                                                        });
                                                        try {
                                                          final res = await ref
                                                              .read(
                                                                reservationControllerProvider
                                                                    .notifier,
                                                              )
                                                              .generatePayment(
                                                                orderId:
                                                                    orderId!,
                                                                paymentMethod:
                                                                    'other_qris',
                                                              );
                                                          if (res.token
                                                                  .isNotEmpty &&
                                                              res.redirectUrl
                                                                  .isNotEmpty) {
                                                            setState(() {
                                                              context.pop();
                                                            });
                                                            await redirectToMidtransWebView(
                                                              res.redirectUrl,
                                                            );
                                                          }
                                                        } on ResponseFailure catch (e) {
                                                          setState(() {
                                                            context.pop();
                                                            Toast()
                                                                .showErrorToast(
                                                              context: context,
                                                              title:
                                                                  'Generate Payment Error',
                                                              description:
                                                                  'Desc: ${e.allError}',
                                                            );
                                                          });
                                                        } finally {
                                                          setState(() {});
                                                          closeDetailPanel();
                                                        }
                                                      },
                                                      borderRadius:
                                                          const BorderRadius
                                                              .all(
                                                        Radius.circular(
                                                          15,
                                                        ),
                                                      ),
                                                      isWideScreen: true,
                                                      padding:
                                                          EdgeInsets.symmetric(
                                                        vertical: MediaQuery.of(
                                                              context,
                                                            ).size.height *
                                                            0.018,
                                                      ),
                                                      borderColor:
                                                          paymentMethod ==
                                                                  'other_qris'
                                                              ? Colors.black
                                                              : Colors.grey,
                                                      borderWidth:
                                                          paymentMethod ==
                                                                  'other_qris'
                                                              ? 2
                                                              : 1,
                                                    ),
                                                    const SizedBox(
                                                      width: 5,
                                                      height: 10,
                                                    ),
                                                    _customButton(
                                                      child: const Row(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .center,
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
                                                              color:
                                                                  Colors.black,
                                                              fontSize: 14,
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                      color: Colors.white,
                                                      onTap: () async {
                                                        setState(() {
                                                          paymentMethod =
                                                              'bank_transfer';
                                                        });
                                                        try {
                                                          final res = await ref
                                                              .read(
                                                                reservationControllerProvider
                                                                    .notifier,
                                                              )
                                                              .generatePayment(
                                                                orderId:
                                                                    orderId!,
                                                                paymentMethod:
                                                                    'bank_transfer',
                                                              );
                                                          if (res.token
                                                                  .isNotEmpty &&
                                                              res.redirectUrl
                                                                  .isNotEmpty) {
                                                            setState(() {
                                                              context.pop();
                                                            });
                                                            await redirectToMidtransWebView(
                                                              res.redirectUrl,
                                                            );
                                                          }
                                                        } on ResponseFailure catch (e) {
                                                          setState(() {
                                                            context.pop();
                                                            Toast()
                                                                .showErrorToast(
                                                              context: context,
                                                              title:
                                                                  'Generate Payment Error',
                                                              description:
                                                                  'Desc: ${e.allError}',
                                                            );
                                                          });
                                                        } finally {
                                                          setState(() {});
                                                          closeDetailPanel();
                                                        }
                                                      },
                                                      borderRadius:
                                                          const BorderRadius
                                                              .all(
                                                        Radius.circular(
                                                          15,
                                                        ),
                                                      ),
                                                      isWideScreen: true,
                                                      padding:
                                                          EdgeInsets.symmetric(
                                                        vertical: MediaQuery.of(
                                                              context,
                                                            ).size.height *
                                                            0.018,
                                                      ),
                                                      borderColor:
                                                          paymentMethod ==
                                                                  'bank_transfer'
                                                              ? Colors.black
                                                              : Colors.grey,
                                                      borderWidth:
                                                          paymentMethod ==
                                                                  'bank_transfer'
                                                              ? 2
                                                              : 1,
                                                    ),
                                                  ],
                                                );
                                              },
                                            );
                                          },
                                          borderRadius: const BorderRadius.all(
                                            Radius.circular(15),
                                          ),
                                          isWideScreen: true,
                                          padding: const EdgeInsets.symmetric(
                                            vertical: 16,
                                          ),
                                        ),
                                      ),
                                    ],
                                  )
                                else
                                  TextFormField(
                                    readOnly: true,
                                    style: const TextStyle(
                                      fontWeight: FontWeight.w400,
                                      color: Colors.black,
                                      fontSize: 14,
                                      overflow: TextOverflow.fade,
                                    ),
                                    initialValue: 'Settlement',
                                    decoration: const InputDecoration(
                                      filled: true,
                                      fillColor: Colors.white,
                                      focusedBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.all(
                                          Radius.circular(15),
                                        ),
                                      ),
                                      border: OutlineInputBorder(
                                        borderRadius: BorderRadius.all(
                                          Radius.circular(15),
                                        ),
                                      ),
                                    ),
                                  ),
                                SizedBox(
                                  height: 10.h,
                                ),
                                Text(
                                  'Meja',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.w500,
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
                                  controller: tables,
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
                                  height: 10.h,
                                ),
                                Text(
                                  'Menu',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.w500,
                                    fontSize: 14.sp,
                                  ),
                                ),
                                SizedBox(
                                  height: 5.h,
                                ),
                                _customButton(
                                  child: const Iconify(
                                    Mdi.eye,
                                    color: Colors.white,
                                  ),
                                  color: hexToColor('#1F4940'),
                                  onTap: openViewMenuScreen,
                                  borderRadius: const BorderRadius.all(
                                    Radius.circular(20),
                                  ),
                                  isWideScreen: true,
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 8),
                                  margin: EdgeInsets.only(
                                    right: MediaQuery.of(context).size.width *
                                        0.18,
                                  ),
                                ),
                                SizedBox(
                                  height: 10.h,
                                ),
                                Text(
                                  'Metode Pembayaran',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.w500,
                                    fontSize: 14.sp,
                                  ),
                                ),
                                SizedBox(
                                  height: 5.h,
                                ),
                                _customButton(
                                  child: paymentInfo['method'] == 'qris'
                                      ? Image.asset(
                                          ImageAssets.qris,
                                          fit: BoxFit.contain,
                                          width: 50,
                                          height: 25,
                                        )
                                      : paymentInfo['method'] == 'bank_transfer'
                                          ? const Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: [
                                                Iconify(
                                                  IconAssets.bankCard,
                                                  color: Colors.black,
                                                  size: 30,
                                                ),
                                                SizedBox(width: 5),
                                                Text(
                                                  'Transfer',
                                                  style: TextStyle(
                                                    color: Colors.black,
                                                    fontSize: 14,
                                                  ),
                                                ),
                                              ],
                                            )
                                          : const Text(
                                              'Unknown Payment',
                                              style: TextStyle(
                                                color: Colors.black,
                                                fontSize: 14,
                                              ),
                                            ),
                                  color: Colors.white,
                                  onTap: () {},
                                  borderRadius: const BorderRadius.all(
                                    Radius.circular(15),
                                  ),
                                  isWideScreen: true,
                                  padding: const EdgeInsets.symmetric(
                                    vertical: 5,
                                    horizontal: 10,
                                  ),
                                  margin: EdgeInsets.only(
                                    right: MediaQuery.of(context).size.width *
                                        0.15,
                                  ),
                                ),
                                SizedBox(
                                  height: 10.h,
                                ),
                                Text(
                                  'Jumlah Orang',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.w500,
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
                                  controller: jumlah,
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
                              ],
                              width: MediaQuery.of(context).size.width * 0.3,
                            ),
                            PositionedDirectionalBackdropBlurWidget(
                              isPanelVisible: isCreatePanelVisible,
                              end: -MediaQuery.of(context).size.width,
                              content: [
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Container(
                                      decoration: const BoxDecoration(
                                        color: Colors.white,
                                        borderRadius: BorderRadius.all(
                                          Radius.circular(50),
                                        ),
                                      ),
                                      child: IconButton(
                                        padding: const EdgeInsets.all(10),
                                        color: hexToColor('#1F4940'),
                                        icon: const Icon(Icons.arrow_back),
                                        onPressed: closeCreatePanel,
                                      ),
                                    ),
                                  ],
                                ),
                                SizedBox(
                                  height: 20.h,
                                ),
                                LayoutBuilder(
                                  builder: (context, constraints) {
                                    final isWideScreen =
                                        constraints.maxWidth > 600;
                                    final crossAxisCount = isWideScreen ? 3 : 2;
                                    final itemWidth = (constraints.maxWidth -
                                            (50 * (crossAxisCount - 2))) /
                                        crossAxisCount;
                                    return Form(
                                      key: _formKey,
                                      autovalidateMode:
                                          AutovalidateMode.onUnfocus,
                                      child: SingleChildScrollView(
                                        child: Wrap(
                                          spacing: 10,
                                          children: [
                                            SizedBox(
                                              width: itemWidth.w,
                                              child: _buildTextField(
                                                'Nama',
                                                'Masukkan nama',
                                                nama,
                                                TextInputType.name,
                                                (val) {},
                                                [],
                                                12.sp,
                                              ),
                                            ),
                                            SizedBox(
                                              width: itemWidth.w,
                                              child: _buildTextField(
                                                'Kontak',
                                                'Masukkan nomor telepon',
                                                kontak,
                                                TextInputType.phone,
                                                (val) {},
                                                [],
                                                12.sp,
                                              ),
                                            ),
                                            SizedBox(
                                              width: itemWidth.w,
                                              child: _buildDateTimePickerField(
                                                label: 'Start',
                                                hint: 'Masukkan waktu mulai',
                                                controller: startText,
                                                onTap: () async {
                                                  await pickStartDateTime(
                                                    isWideScreen: true,
                                                  );
                                                },
                                                labelSize: 12.sp,
                                              ),
                                            ),
                                            SizedBox(
                                              width: itemWidth.w,
                                              child: _buildDateTimePickerField(
                                                label: 'End',
                                                hint: 'Masukkan waktu berakhir',
                                                controller: endText,
                                                onTap: () async {
                                                  await pickEndDateTime(
                                                    isWideScreen: true,
                                                  );
                                                },
                                                labelSize: 12.sp,
                                              ),
                                            ),
                                            SizedBox(
                                              width: (itemWidth * 2 + 5).w,
                                              child: _buildTextField(
                                                'Catatan',
                                                'Masukkan catatan',
                                                catatan,
                                                TextInputType.text,
                                                (val) {},
                                                [],
                                                12.sp,
                                              ),
                                            ),
                                            SizedBox(
                                              width: itemWidth.w,
                                              child: _buildTextField(
                                                'Komunitas',
                                                'Masukkan komunitas',
                                                komunitas,
                                                TextInputType.text,
                                                (val) {},
                                                [],
                                                12.sp,
                                              ),
                                            ),
                                            SizedBox(
                                              width: itemWidth.w,
                                              child: Padding(
                                                padding: const EdgeInsets.only(
                                                  bottom: 16,
                                                ),
                                                child: Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    Text(
                                                      'Status Pembayaran',
                                                      style: TextStyle(
                                                        color: Colors.white,
                                                        fontWeight:
                                                            FontWeight.w600,
                                                        fontSize: 12.sp,
                                                      ),
                                                    ),
                                                    SizedBox(
                                                      height: 5.h,
                                                    ),
                                                    MultiDropdown(
                                                      validator:
                                                          (selectedOptions) {
                                                        if (selectedOptions ==
                                                            null) {
                                                          return 'Required Field';
                                                        }
                                                        return null;
                                                      },
                                                      controller:
                                                          statusController,
                                                      singleSelect: true,
                                                      items: paymentStatus,
                                                      chipDecoration:
                                                          ChipDecoration(
                                                        backgroundColor:
                                                            hexToColor(
                                                          '#E1E1E1',
                                                        ),
                                                        runSpacing: 2,
                                                        spacing: 10,
                                                      ),
                                                      fieldDecoration:
                                                          FieldDecoration(
                                                        backgroundColor:
                                                            Colors.white,
                                                        padding:
                                                            const EdgeInsets
                                                                .symmetric(
                                                          vertical: 16,
                                                          horizontal: 12,
                                                        ),
                                                        hintText:
                                                            'Pilih DP atau Settlement',
                                                        hintStyle: TextStyle(
                                                          fontSize: 14.sp,
                                                          overflow: TextOverflow
                                                              .ellipsis,
                                                          color: Colors.black
                                                              .withOpacity(0.3),
                                                          fontWeight:
                                                              FontWeight.w600,
                                                        ),
                                                        suffixIcon:
                                                            const Padding(
                                                          padding:
                                                              EdgeInsets.all(
                                                            12,
                                                          ),
                                                          child: Iconify(
                                                            Zondicons
                                                                .cheveron_down,
                                                          ),
                                                        ),
                                                        showClearIcon: false,
                                                        border:
                                                            OutlineInputBorder(
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(15),
                                                          borderSide:
                                                              const BorderSide(
                                                            color:
                                                                Colors.black87,
                                                          ),
                                                        ),
                                                      ),
                                                      itemSeparator:
                                                          const Padding(
                                                        padding: EdgeInsets
                                                            .symmetric(
                                                          horizontal: 12,
                                                        ),
                                                        child: Divider(),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ),
                                            SizedBox(
                                              width: itemWidth.w,
                                              child: Padding(
                                                padding: const EdgeInsets.only(
                                                  bottom: 16,
                                                ),
                                                child: Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    Text(
                                                      'Meja',
                                                      style: TextStyle(
                                                        color: Colors.white,
                                                        fontWeight:
                                                            FontWeight.w600,
                                                        fontSize: 12.sp,
                                                      ),
                                                    ),
                                                    SizedBox(
                                                      height: 5.h,
                                                    ),
                                                    MultiDropdown(
                                                      autovalidateMode:
                                                          AutovalidateMode
                                                              .onUnfocus,
                                                      validator: (option) {
                                                        if (jumlah.text == '') {
                                                          return 'Required Jumlah Orang field';
                                                        }

                                                        if (startText.text ==
                                                            '') {
                                                          return 'Required Start Time field';
                                                        }

                                                        if (endText.text ==
                                                            '') {
                                                          return 'Required End Time field';
                                                        }

                                                        if (isOutdoor == null) {
                                                          return 'Required To Choose Ruangan field';
                                                        }

                                                        if (option == null) {
                                                          return 'Required field';
                                                        }
                                                        return null;
                                                      },
                                                      enabled: tableController
                                                          .items.isNotEmpty,
                                                      items: tableData,
                                                      controller:
                                                          tableController,
                                                      chipDecoration:
                                                          ChipDecoration(
                                                        wrap: false,
                                                        backgroundColor:
                                                            hexToColor(
                                                          '#E1E1E1',
                                                        ),
                                                        runSpacing: 2,
                                                        spacing: 10,
                                                      ),
                                                      fieldDecoration:
                                                          FieldDecoration(
                                                        backgroundColor:
                                                            Colors.white,
                                                        padding:
                                                            const EdgeInsets
                                                                .symmetric(
                                                          vertical: 16,
                                                          horizontal: 12,
                                                        ),
                                                        hintText: tableController
                                                                .items
                                                                .isNotEmpty
                                                            ? 'Pilih satu atau lebih meja yang tersedia'
                                                            : 'Lengkapi start, end, jml org, dan ruangan',
                                                        hintStyle: TextStyle(
                                                          fontSize: 14.sp,
                                                          overflow: TextOverflow
                                                              .ellipsis,
                                                          color: Colors.black
                                                              .withOpacity(0.3),
                                                          fontWeight:
                                                              FontWeight.w600,
                                                        ),
                                                        suffixIcon:
                                                            const Padding(
                                                          padding:
                                                              EdgeInsets.all(
                                                            12,
                                                          ),
                                                          child: Iconify(
                                                            Zondicons
                                                                .cheveron_down,
                                                          ),
                                                        ),
                                                        showClearIcon: false,
                                                        border:
                                                            OutlineInputBorder(
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(15),
                                                          borderSide:
                                                              const BorderSide(
                                                            color:
                                                                Colors.black87,
                                                          ),
                                                        ),
                                                      ),
                                                      itemSeparator:
                                                          const Padding(
                                                        padding: EdgeInsets
                                                            .symmetric(
                                                          horizontal: 12,
                                                        ),
                                                        child: Divider(),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ),
                                            SizedBox(
                                              width: itemWidth.w,
                                              child: Padding(
                                                padding: const EdgeInsets.only(
                                                  bottom: 16,
                                                ),
                                                child: Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    Text(
                                                      'Menu',
                                                      style: TextStyle(
                                                        color: Colors.white,
                                                        fontSize: 14.sp,
                                                      ),
                                                    ),
                                                    const SizedBox(
                                                      height: 5,
                                                    ),
                                                    _customButton(
                                                      child: itemList.isEmpty
                                                          ? Text(
                                                              'Klik Disini untuk Pilih Menu',
                                                              style: TextStyle(
                                                                color: Colors
                                                                    .white,
                                                                fontSize: 14.sp,
                                                              ),
                                                            )
                                                          : Row(
                                                              mainAxisAlignment:
                                                                  MainAxisAlignment
                                                                      .center,
                                                              children: [
                                                                Text(
                                                                  'Lihat Menu',
                                                                  style:
                                                                      TextStyle(
                                                                    color: Colors
                                                                        .white,
                                                                    fontSize:
                                                                        14.sp,
                                                                  ),
                                                                ),
                                                                const SizedBox(
                                                                  width: 5,
                                                                ),
                                                                const Iconify(
                                                                  Mdi.eye,
                                                                  color: Colors
                                                                      .white,
                                                                ),
                                                              ],
                                                            ),
                                                      color:
                                                          hexToColor('#1F4940'),
                                                      onTap:
                                                          toggleInputMenuScreen,
                                                      borderRadius:
                                                          const BorderRadius
                                                              .all(
                                                        Radius.circular(15),
                                                      ),
                                                      isWideScreen:
                                                          isWideScreen,
                                                      padding:
                                                          EdgeInsets.symmetric(
                                                        vertical: MediaQuery.of(
                                                              context,
                                                            ).size.height *
                                                            0.018,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ),
                                            SizedBox(
                                              width: itemWidth.w,
                                              child: Padding(
                                                padding: const EdgeInsets.only(
                                                  bottom: 16,
                                                ),
                                                child: Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    Text(
                                                      'Metode Pembayaran',
                                                      style: TextStyle(
                                                        color: Colors.white,
                                                        fontSize: 14.sp,
                                                      ),
                                                    ),
                                                    const SizedBox(
                                                      height: 5,
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
                                                            isWideScreen:
                                                                isWideScreen,
                                                            padding: EdgeInsets
                                                                .symmetric(
                                                              vertical: MediaQuery
                                                                          .of(
                                                                    context,
                                                                  )
                                                                      .size
                                                                      .height *
                                                                  0.018,
                                                            ),
                                                            borderColor:
                                                                paymentMethod ==
                                                                        'other_qris'
                                                                    ? Colors
                                                                        .black
                                                                    : Colors
                                                                        .transparent,
                                                            borderWidth:
                                                                paymentMethod ==
                                                                        'other_qris'
                                                                    ? 2
                                                                    : 0,
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
                                                                    fontSize:
                                                                        14,
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
                                                            isWideScreen:
                                                                isWideScreen,
                                                            padding: EdgeInsets
                                                                .symmetric(
                                                              vertical: MediaQuery
                                                                          .of(
                                                                    context,
                                                                  )
                                                                      .size
                                                                      .height *
                                                                  0.018,
                                                            ),
                                                            borderColor:
                                                                paymentMethod ==
                                                                        'bank_transfer'
                                                                    ? Colors
                                                                        .black
                                                                    : Colors
                                                                        .transparent,
                                                            borderWidth:
                                                                paymentMethod ==
                                                                        'bank_transfer'
                                                                    ? 2
                                                                    : 0,
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ),
                                            SizedBox(
                                              width: itemWidth.w,
                                              child: _buildTextField(
                                                'Jumlah Orang',
                                                'Masukkan jumlah orang',
                                                jumlah,
                                                TextInputType.number,
                                                (val) {},
                                                [],
                                                12.sp,
                                              ),
                                            ),
                                            SizedBox(
                                              width: itemWidth.w,
                                              child: Padding(
                                                padding: const EdgeInsets.only(
                                                  bottom: 16,
                                                ),
                                                child: Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    Text(
                                                      'Ruangan',
                                                      style: TextStyle(
                                                        color: Colors.white,
                                                        fontSize: 14.sp,
                                                      ),
                                                    ),
                                                    const SizedBox(
                                                      height: 5,
                                                    ),
                                                    Row(
                                                      children: [
                                                        Expanded(
                                                          child: _customButton(
                                                            child: const Row(
                                                              mainAxisAlignment:
                                                                  MainAxisAlignment
                                                                      .center,
                                                              children: [
                                                                Iconify(
                                                                  IconAssets
                                                                      .outdoorIcon,
                                                                  color: Colors
                                                                      .black,
                                                                  size: 20,
                                                                ),
                                                                SizedBox(
                                                                  width: 5,
                                                                ),
                                                                Text(
                                                                  'Outdoor',
                                                                  style:
                                                                      TextStyle(
                                                                    color: Colors
                                                                        .black,
                                                                    fontSize:
                                                                        14,
                                                                  ),
                                                                ),
                                                              ],
                                                            ),
                                                            color: Colors.white,
                                                            onTap: () {
                                                              setState(() {
                                                                isOutdoor =
                                                                    true;
                                                                if (jumlah
                                                                        .text ==
                                                                    '') {
                                                                  return;
                                                                }
                                                                if (startText
                                                                        .text ==
                                                                    '') {
                                                                  return;
                                                                }
                                                                if (endText
                                                                        .text ==
                                                                    '') {
                                                                  return;
                                                                }
                                                                print(
                                                                  TableSuggestionRequestEntity(
                                                                    capacity: int
                                                                        .parse(
                                                                      jumlah
                                                                          .text,
                                                                    ),
                                                                    isOutdoor:
                                                                        true,
                                                                    date:
                                                                        DateFormat(
                                                                      'yyyy-MM-dd',
                                                                    ).format(
                                                                      start,
                                                                    ),
                                                                    startTime: DateFormat
                                                                            .Hms()
                                                                        .format(
                                                                      start,
                                                                    ),
                                                                    endTime: DateFormat
                                                                            .Hms()
                                                                        .format(
                                                                      end!,
                                                                    ),
                                                                  ),
                                                                );
                                                                tableSuggest(
                                                                  request:
                                                                      TableSuggestionRequestEntity(
                                                                    capacity: int
                                                                        .parse(
                                                                      jumlah
                                                                          .text,
                                                                    ),
                                                                    isOutdoor:
                                                                        isOutdoor!,
                                                                    date:
                                                                        DateFormat(
                                                                      'yyyy-MM-dd',
                                                                    ).format(
                                                                      start,
                                                                    ),
                                                                    startTime: DateFormat
                                                                            .Hms()
                                                                        .format(
                                                                      start,
                                                                    ),
                                                                    endTime: DateFormat
                                                                            .Hms()
                                                                        .format(
                                                                      end!,
                                                                    ),
                                                                  ),
                                                                );
                                                                setState(() {});
                                                              });
                                                            },
                                                            borderRadius:
                                                                const BorderRadius
                                                                    .all(
                                                              Radius.circular(
                                                                15,
                                                              ),
                                                            ),
                                                            isWideScreen:
                                                                isWideScreen,
                                                            padding: EdgeInsets
                                                                .symmetric(
                                                              vertical: MediaQuery
                                                                          .of(
                                                                    context,
                                                                  )
                                                                      .size
                                                                      .height *
                                                                  0.018,
                                                            ),
                                                            borderColor: isOutdoor ==
                                                                        null ||
                                                                    !isOutdoor!
                                                                ? Colors
                                                                    .transparent
                                                                : Colors.black,
                                                            borderWidth: isOutdoor ==
                                                                        null ||
                                                                    !isOutdoor!
                                                                ? 0
                                                                : 2,
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
                                                                      .indoorIcon,
                                                                  color: Colors
                                                                      .black,
                                                                  size: 20,
                                                                ),
                                                                SizedBox(
                                                                  width: 5,
                                                                ),
                                                                Text(
                                                                  'Indoor',
                                                                  style:
                                                                      TextStyle(
                                                                    color: Colors
                                                                        .black,
                                                                    fontSize:
                                                                        14,
                                                                  ),
                                                                ),
                                                              ],
                                                            ),
                                                            color: Colors.white,
                                                            onTap: () {
                                                              setState(() {
                                                                isOutdoor =
                                                                    false;
                                                                if (jumlah
                                                                        .text ==
                                                                    '') {
                                                                  return;
                                                                }
                                                                if (startText
                                                                        .text ==
                                                                    '') {
                                                                  return;
                                                                }
                                                                if (endText
                                                                        .text ==
                                                                    '') {
                                                                  return;
                                                                }
                                                                print(
                                                                  TableSuggestionRequestEntity(
                                                                    capacity: int
                                                                        .parse(
                                                                      jumlah
                                                                          .text,
                                                                    ),
                                                                    isOutdoor:
                                                                        true,
                                                                    date:
                                                                        DateFormat(
                                                                      'yyyy-MM-dd',
                                                                    ).format(
                                                                      start,
                                                                    ),
                                                                    startTime: DateFormat
                                                                            .Hms()
                                                                        .format(
                                                                      start,
                                                                    ),
                                                                    endTime: DateFormat
                                                                            .Hms()
                                                                        .format(
                                                                      end!,
                                                                    ),
                                                                  ),
                                                                );
                                                                tableSuggest(
                                                                  request:
                                                                      TableSuggestionRequestEntity(
                                                                    capacity: int
                                                                        .parse(
                                                                      jumlah
                                                                          .text,
                                                                    ),
                                                                    isOutdoor:
                                                                        isOutdoor!,
                                                                    date:
                                                                        DateFormat(
                                                                      'yyyy-MM-dd',
                                                                    ).format(
                                                                      start,
                                                                    ),
                                                                    startTime: DateFormat
                                                                            .Hms()
                                                                        .format(
                                                                      start,
                                                                    ),
                                                                    endTime: DateFormat
                                                                            .Hms()
                                                                        .format(
                                                                      end!,
                                                                    ),
                                                                  ),
                                                                );
                                                                setState(() {});
                                                              });
                                                            },
                                                            borderRadius:
                                                                const BorderRadius
                                                                    .all(
                                                              Radius.circular(
                                                                15,
                                                              ),
                                                            ),
                                                            isWideScreen:
                                                                isWideScreen,
                                                            padding: EdgeInsets
                                                                .symmetric(
                                                              vertical: MediaQuery
                                                                          .of(
                                                                    context,
                                                                  )
                                                                      .size
                                                                      .height *
                                                                  0.018,
                                                            ),
                                                            borderColor: isOutdoor ==
                                                                        null ||
                                                                    isOutdoor!
                                                                ? Colors
                                                                    .transparent
                                                                : Colors.black,
                                                            borderWidth: isOutdoor ==
                                                                        null ||
                                                                    isOutdoor!
                                                                ? 0
                                                                : 2,
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ),
                                            SizedBox(
                                              width: (itemWidth * 2.5 + 30).w,
                                            ),
                                            ElevatedButton(
                                              onPressed: isLoading
                                                  ? () {}
                                                  : () async {
                                                      if (_formKey.currentState!
                                                              .validate() &&
                                                          paymentMethod !=
                                                              null) {
                                                        setState(() {
                                                          isLoading = true;
                                                        });
                                                        try {
                                                          final res = await ref
                                                              .read(
                                                                reservationControllerProvider
                                                                    .notifier,
                                                              )
                                                              .createNew(
                                                                request:
                                                                    CreateReservationRequestEntity(
                                                                  reserveBy:
                                                                      nama.text,
                                                                  community:
                                                                      komunitas
                                                                          .text,
                                                                  phoneNumber:
                                                                      kontak
                                                                          .text,
                                                                  note: catatan
                                                                      .text,
                                                                  start:
                                                                      '${DateFormat(
                                                                    'yyyy-MM-dd',
                                                                  ).format(
                                                                    start,
                                                                  )} ${DateFormat.Hm().format(start)}',
                                                                  end:
                                                                      '${DateFormat(
                                                                    'yyyy-MM-dd',
                                                                  ).format(
                                                                    end!,
                                                                  )} ${DateFormat.Hm().format(end!)}',
                                                                  menus:
                                                                      orderList,
                                                                  tables: tableController
                                                                      .selectedItems
                                                                      .map(
                                                                        (e) => e
                                                                            .value,
                                                                      )
                                                                      .toList(),
                                                                  paymentMethod:
                                                                      paymentMethod!,
                                                                  halfPayment: statusController
                                                                          .selectedItems
                                                                          .first
                                                                          .value ==
                                                                      'DP',
                                                                ),
                                                              );
                                                          if (res.token
                                                                  .isNotEmpty &&
                                                              res.redirectUrl
                                                                  .isNotEmpty) {
                                                            print(
                                                              '${res.token} and ${res.redirectUrl}',
                                                            );
                                                            await redirectToMidtransWebView(
                                                              res.redirectUrl,
                                                            );
                                                          }
                                                        } catch (e) {
                                                          setState(() {
                                                            Toast()
                                                                .showErrorToast(
                                                              context: context,
                                                              title:
                                                                  'Tambah Reservasi Error',
                                                              description:
                                                                  'Desc: $e',
                                                            );
                                                          });
                                                          print(
                                                            'create reservation error: $e',
                                                          );
                                                        } finally {
                                                          setState(() {
                                                            isLoading = false;
                                                          });
                                                          closeCreatePanel();
                                                        }
                                                      }
                                                    },
                                              style: ElevatedButton.styleFrom(
                                                backgroundColor:
                                                    hexToColor('#1F4940'),
                                                shape:
                                                    const RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.all(
                                                    Radius.circular(30),
                                                  ),
                                                ),
                                              ),
                                              child: Padding(
                                                padding: EdgeInsets.symmetric(
                                                  vertical: 18.h,
                                                  horizontal: 15.w,
                                                ),
                                                child: isLoading
                                                    ? const Center(
                                                        child:
                                                            CustomLoadingIndicator(
                                                          color: Colors.white,
                                                        ),
                                                      )
                                                    : const Text(
                                                        AppStrings.tambahBtn,
                                                        style: TextStyle(
                                                          color: Colors.white,
                                                          fontWeight:
                                                              FontWeight.w600,
                                                          fontSize: 14,
                                                        ),
                                                      ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    );
                                  },
                                ),
                              ],
                              width: MediaQuery.of(context).size.width * 0.9,
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
                                  AnimatedContainer(
                                    height: MediaQuery.of(context).size.height *
                                        0.1,
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      border: Border.all(
                                        color: hexToColor('#E1E1E1'),
                                      ),
                                      borderRadius: const BorderRadius.all(
                                        Radius.circular(15),
                                      ),
                                    ),
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 5,
                                    ),
                                    duration: const Duration(milliseconds: 100),
                                    child: Row(
                                      children: [
                                        Flexible(
                                          child: Padding(
                                            padding: const EdgeInsets.only(
                                              left: 5,
                                            ),
                                            child: Image.asset(
                                              ImageAssets.raskop,
                                              width: 100,
                                              height: 100,
                                            ),
                                          ),
                                        ),
                                        const SizedBox(
                                          width: 5,
                                        ),
                                        Expanded(
                                          flex: 4,
                                          child: AnimatedContainer(
                                            duration: const Duration(
                                              milliseconds: 100,
                                            ),
                                            padding: const EdgeInsets.symmetric(
                                              horizontal: 8,
                                            ),
                                            decoration: BoxDecoration(
                                              border: Border.all(
                                                color: hexToColor('#E1E1E1'),
                                              ),
                                              borderRadius:
                                                  const BorderRadius.all(
                                                Radius.circular(30),
                                              ),
                                            ),
                                            child: Row(
                                              children: [
                                                Flexible(
                                                  flex: 2,
                                                  child: Padding(
                                                    padding:
                                                        const EdgeInsets.only(
                                                      left: 8,
                                                    ),
                                                    child: TextFormField(
                                                      controller: search,
                                                      onChanged:
                                                          advSearchPhoneController
                                                                  .selectedItems
                                                                  .isEmpty
                                                              ? (value) {}
                                                              : (value) {
                                                                  debounceOnPhone();
                                                                },
                                                      onFieldSubmitted:
                                                          advSearchPhoneController
                                                                  .selectedItems
                                                                  .isEmpty
                                                              ? (value) {}
                                                              : (value) {
                                                                  onSearchPhone();
                                                                },
                                                      style: const TextStyle(
                                                        fontSize: 12,
                                                      ),
                                                      decoration:
                                                          InputDecoration(
                                                        filled: false,
                                                        border:
                                                            InputBorder.none,
                                                        hintText: 'Temukan...',
                                                        hintStyle: TextStyle(
                                                          color: Colors.black
                                                              .withOpacity(0.3),
                                                          fontWeight:
                                                              FontWeight.w400,
                                                          fontSize: 12,
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                                Flexible(
                                                  flex: 3,
                                                  child: MultiDropdown<String>(
                                                    items: advSearchOptions,
                                                    controller:
                                                        advSearchPhoneController,
                                                    onSelectionChange:
                                                        (selectedItems) {
                                                      setState(() {});
                                                    },
                                                    fieldDecoration:
                                                        const FieldDecoration(
                                                      border:
                                                          OutlineInputBorder(
                                                        borderSide:
                                                            BorderSide.none,
                                                      ),
                                                      hintText: '',
                                                      suffixIcon: Icon(
                                                        Icons.filter_list_alt,
                                                      ),
                                                      animateSuffixIcon: false,
                                                      backgroundColor:
                                                          Colors.transparent,
                                                      borderRadius: 30,
                                                    ),
                                                    dropdownItemDecoration:
                                                        DropdownItemDecoration(
                                                      selectedIcon: Icon(
                                                        Icons.check_box,
                                                        color: hexToColor(
                                                          '#0C9D61',
                                                        ),
                                                      ),
                                                    ),
                                                    dropdownDecoration:
                                                        const DropdownDecoration(
                                                      elevation: 3,
                                                    ),
                                                    chipDecoration:
                                                        ChipDecoration(
                                                      wrap: false,
                                                      backgroundColor:
                                                          hexToColor(
                                                        '#E1E1E1',
                                                      ),
                                                      labelStyle:
                                                          const TextStyle(
                                                        color: Colors.black,
                                                        fontSize: 10,
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  const SizedBox(
                                    height: 10,
                                  ),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: [
                                      ElevatedButton(
                                        style: ElevatedButton.styleFrom(
                                          backgroundColor:
                                              hexToColor('#1f4940'),
                                        ),
                                        onPressed: openCreatePanel,
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
                                    margin:
                                        EdgeInsets.only(top: 12.h, bottom: 7.h),
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
                                            flex: 3,
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
                                            flex: 5,
                                            child: Text(
                                              'Nama',
                                              style: TextStyle(
                                                fontWeight: FontWeight.w600,
                                                color: hexToColor('#202224'),
                                                fontSize: 12,
                                              ),
                                            ),
                                          ),
                                          Expanded(
                                            flex: 3,
                                            child: Text(
                                              'Kontak',
                                              style: TextStyle(
                                                fontWeight: FontWeight.w600,
                                                color: hexToColor('#202224'),
                                                fontSize: 12,
                                              ),
                                            ),
                                          ),
                                          Expanded(
                                            flex: 5,
                                            child: Center(
                                              child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                children: [
                                                  Container(
                                                    width: 5,
                                                    height: 5,
                                                    decoration: BoxDecoration(
                                                      color:
                                                          hexToColor('#000000'),
                                                      shape: BoxShape.circle,
                                                    ),
                                                  ),
                                                  const SizedBox(width: 5),
                                                  Container(
                                                    width: 5,
                                                    height: 5,
                                                    decoration: BoxDecoration(
                                                      color:
                                                          hexToColor('#000000'),
                                                      shape: BoxShape.circle,
                                                    ),
                                                  ),
                                                  const SizedBox(width: 5),
                                                  Container(
                                                    width: 5,
                                                    height: 5,
                                                    decoration: BoxDecoration(
                                                      color:
                                                          hexToColor('#000000'),
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
                                    child: reservations.when(
                                      data: (data) {
                                        return ListView(
                                          controller: controller.controller,
                                          padding: EdgeInsets.zero,
                                          shrinkWrap: true,
                                          children: [
                                            for (final e in data)
                                              Container(
                                                margin: EdgeInsets.only(
                                                  bottom: 7.h,
                                                ),
                                                decoration: BoxDecoration(
                                                  border: Border.all(
                                                    color: Colors.grey,
                                                  ),
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                    18,
                                                  ),
                                                  color: hexToColor('#E1E1E1'),
                                                ),
                                                child: Slidable(
                                                  endActionPane: ActionPane(
                                                    extentRatio: 0.2,
                                                    motion:
                                                        const BehindMotion(),
                                                    children: [
                                                      Expanded(
                                                        child: SizedBox.expand(
                                                          child:
                                                              GestureDetector(
                                                            onTap: () {
                                                              showConfirmationDialog(
                                                                context:
                                                                    context,
                                                                title:
                                                                    'Tolak pengajuan reservasi?',
                                                                content:
                                                                    'Reservasi ini akan ditolak dan terhapus secara permanen.',
                                                                onConfirm:
                                                                    () async {
                                                                  try {
                                                                    await ref
                                                                        .read(
                                                                      reservationControllerProvider
                                                                          .notifier,
                                                                    )
                                                                        .cancelReservation(
                                                                      id: <String,
                                                                          dynamic>{
                                                                        'id': e
                                                                            .id,
                                                                      },
                                                                    );
                                                                    setState(
                                                                        () {
                                                                      Toast()
                                                                          .showSuccessToast(
                                                                        context:
                                                                            context,
                                                                        title:
                                                                            'Tolak Reservasi Success',
                                                                        description:
                                                                            'Successfully Tolak Reservasi',
                                                                      );
                                                                    });
                                                                  } catch (e) {
                                                                    setState(
                                                                        () {
                                                                      Toast()
                                                                          .showErrorToast(
                                                                        context:
                                                                            context,
                                                                        title:
                                                                            'Tolak Reservasi Error',
                                                                        description:
                                                                            'Desc: $e',
                                                                      );
                                                                    });
                                                                    print(
                                                                      'error occured on cancel reservasi : $e',
                                                                    );
                                                                  } finally {
                                                                    setState(
                                                                        () {
                                                                      context
                                                                          .pop();
                                                                      FocusScope
                                                                          .of(
                                                                        context,
                                                                      ).unfocus();
                                                                    });
                                                                  }
                                                                },
                                                                isWideScreen:
                                                                    false,
                                                              );
                                                            },
                                                            child: Container(
                                                              decoration:
                                                                  BoxDecoration(
                                                                borderRadius:
                                                                    const BorderRadius
                                                                        .only(
                                                                  topRight: Radius
                                                                      .circular(
                                                                    18,
                                                                  ),
                                                                  bottomRight:
                                                                      Radius
                                                                          .circular(
                                                                    18,
                                                                  ),
                                                                ),
                                                                color:
                                                                    hexToColor(
                                                                  '#E1E1E1',
                                                                ),
                                                              ),
                                                              child: Center(
                                                                child:
                                                                    Container(
                                                                  width: MediaQuery
                                                                          .of(
                                                                        context,
                                                                      ).size.width *
                                                                      0.15,
                                                                  height: MediaQuery
                                                                          .of(
                                                                        context,
                                                                      ).size.width *
                                                                      0.1,
                                                                  decoration:
                                                                      BoxDecoration(
                                                                    borderRadius:
                                                                        const BorderRadius
                                                                            .all(
                                                                      Radius
                                                                          .circular(
                                                                        15,
                                                                      ),
                                                                    ),
                                                                    color:
                                                                        hexToColor(
                                                                      '#F64C4C',
                                                                    ),
                                                                  ),
                                                                  child:
                                                                      const Center(
                                                                    child: Text(
                                                                      'Tolak',
                                                                      textAlign:
                                                                          TextAlign
                                                                              .center,
                                                                      style:
                                                                          TextStyle(
                                                                        color: Colors
                                                                            .white,
                                                                        fontSize:
                                                                            14,
                                                                      ),
                                                                    ),
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
                                                      border: Border.all(
                                                        color: Colors.grey,
                                                      ),
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                        18,
                                                      ),
                                                      color: Colors.white,
                                                    ),
                                                    padding:
                                                        EdgeInsets.symmetric(
                                                      horizontal: 10.w,
                                                      vertical: 8.h,
                                                    ),
                                                    child: Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .spaceBetween,
                                                      children: [
                                                        Expanded(
                                                          flex: 3,
                                                          child: Text(
                                                            e.id,
                                                            style: TextStyle(
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w600,
                                                              color: hexToColor(
                                                                '#202224',
                                                              ),
                                                              fontSize: 12,
                                                              overflow:
                                                                  TextOverflow
                                                                      .ellipsis,
                                                            ),
                                                          ),
                                                        ),
                                                        const SizedBox(
                                                          width: 5,
                                                        ),
                                                        Expanded(
                                                          flex: 5,
                                                          child: Text(
                                                            e.reserveBy,
                                                            style: TextStyle(
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w600,
                                                              color: hexToColor(
                                                                '#202224',
                                                              ),
                                                              fontSize: 12,
                                                              overflow:
                                                                  TextOverflow
                                                                      .ellipsis,
                                                            ),
                                                          ),
                                                        ),
                                                        const SizedBox(
                                                          width: 3,
                                                        ),
                                                        Expanded(
                                                          flex: 3,
                                                          child: Text(
                                                            e.phoneNumber,
                                                            style: TextStyle(
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w600,
                                                              color: hexToColor(
                                                                '#202224',
                                                              ),
                                                              fontSize: 12,
                                                              overflow:
                                                                  TextOverflow
                                                                      .ellipsis,
                                                            ),
                                                          ),
                                                        ),
                                                        Expanded(
                                                          flex: 5,
                                                          child: Center(
                                                            child: Padding(
                                                              padding: EdgeInsets
                                                                  .symmetric(
                                                                horizontal: 5.h,
                                                              ),
                                                              child: TextButton(
                                                                onPressed: () =>
                                                                    openDetailPanel(
                                                                  detail: e,
                                                                ),
                                                                style: TextButton
                                                                    .styleFrom(
                                                                  backgroundColor:
                                                                      hexToColor(
                                                                    '#f6e9e0',
                                                                  ),
                                                                  minimumSize:
                                                                      const Size(
                                                                    double
                                                                        .infinity,
                                                                    40,
                                                                  ),
                                                                ),
                                                                child: Text(
                                                                  'Lihat',
                                                                  style:
                                                                      TextStyle(
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .w700,
                                                                    color:
                                                                        hexToColor(
                                                                      '#E38D5D',
                                                                    ),
                                                                    fontSize:
                                                                        12,
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
                                                padding:
                                                    EdgeInsets.only(top: 16),
                                                child: Center(
                                                  child:
                                                      CustomLoadingIndicator(),
                                                ),
                                              ),
                                          ],
                                        );
                                      },
                                      error: (error, stk) => Center(
                                        child: Text(
                                          error.toString() + stk.toString(),
                                        ),
                                      ),
                                      loading: () => const Center(
                                        child: CustomLoadingIndicator(),
                                      ),
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
                                        borderRadius: BorderRadius.all(
                                          Radius.circular(50),
                                        ),
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
                                  'Nama',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.w500,
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
                                  controller: nama,
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
                                  height: 10.h,
                                ),
                                Text(
                                  'Kontak',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.w500,
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
                                SizedBox(
                                  height: 10.h,
                                ),
                                Text(
                                  'Start',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.w500,
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
                                  controller: startText,
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
                                  height: 10.h,
                                ),
                                Text(
                                  'End',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.w500,
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
                                  controller: endText,
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
                                  height: 10.h,
                                ),
                                Text(
                                  'Catatan',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.w500,
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
                                  controller: catatan,
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
                                  height: 10.h,
                                ),
                                Text(
                                  'Komunitas',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.w500,
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
                                  controller: komunitas,
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
                                  height: 10.h,
                                ),
                                Text(
                                  'Status Pembayaran',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.w500,
                                    fontSize: 14.sp,
                                  ),
                                ),
                                SizedBox(
                                  height: 5.h,
                                ),
                                if (paymentInfo['status'] == 'DP')
                                  Row(
                                    children: [
                                      Flexible(
                                        child: TextFormField(
                                          readOnly: true,
                                          style: const TextStyle(
                                            fontWeight: FontWeight.w400,
                                            color: Colors.black,
                                            fontSize: 14,
                                            overflow: TextOverflow.fade,
                                          ),
                                          initialValue: 'DP',
                                          decoration: const InputDecoration(
                                            filled: true,
                                            fillColor: Colors.white,
                                            focusedBorder: OutlineInputBorder(
                                              borderRadius: BorderRadius.all(
                                                Radius.circular(15),
                                              ),
                                            ),
                                            border: OutlineInputBorder(
                                              borderRadius: BorderRadius.all(
                                                Radius.circular(15),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                      const SizedBox(
                                        width: 5,
                                      ),
                                      Expanded(
                                        flex: 2,
                                        child: _customButton(
                                          child: const Text(
                                            'Pelunasan',
                                            style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 14,
                                            ),
                                          ),
                                          color: hexToColor('#FFAD0D'),
                                          onTap: () async {
                                            await showDialog<AlertDialog>(
                                              context: context,
                                              builder: (context) {
                                                return AlertDialog(
                                                  backgroundColor: Colors.white,
                                                  title: const Text(
                                                    'Metode Pembayaran',
                                                  ),
                                                  content: const Text(
                                                    'Pilih Metode Pembayaran',
                                                  ),
                                                  actions: [
                                                    _customButton(
                                                      child: Image.asset(
                                                        ImageAssets.qris,
                                                        fit: BoxFit.fill,
                                                        width: 50,
                                                        height: 20,
                                                      ),
                                                      color: Colors.white,
                                                      onTap: () async {
                                                        setState(() {
                                                          paymentMethod =
                                                              'other_qris';
                                                        });
                                                        try {
                                                          final res = await ref
                                                              .read(
                                                                reservationControllerProvider
                                                                    .notifier,
                                                              )
                                                              .generatePayment(
                                                                orderId:
                                                                    orderId!,
                                                                paymentMethod:
                                                                    'other_qris',
                                                              );
                                                          if (res.token
                                                                  .isNotEmpty &&
                                                              res.redirectUrl
                                                                  .isNotEmpty) {
                                                            setState(() {
                                                              context.pop();
                                                            });
                                                            await redirectToMidtransWebView(
                                                              res.redirectUrl,
                                                            );
                                                          }
                                                        } on ResponseFailure catch (e) {
                                                          setState(() {
                                                            context.pop();
                                                            Toast()
                                                                .showErrorToast(
                                                              context: context,
                                                              title:
                                                                  'Generate Payment Error',
                                                              description:
                                                                  'Desc: ${e.allError}',
                                                            );
                                                          });
                                                        } finally {
                                                          setState(() {});
                                                          closeDetailPanel();
                                                        }
                                                      },
                                                      borderRadius:
                                                          const BorderRadius
                                                              .all(
                                                        Radius.circular(
                                                          15,
                                                        ),
                                                      ),
                                                      isWideScreen: true,
                                                      padding:
                                                          EdgeInsets.symmetric(
                                                        vertical: MediaQuery.of(
                                                              context,
                                                            ).size.height *
                                                            0.018,
                                                      ),
                                                      borderColor:
                                                          paymentMethod ==
                                                                  'other_qris'
                                                              ? Colors.black
                                                              : Colors.grey,
                                                      borderWidth:
                                                          paymentMethod ==
                                                                  'other_qris'
                                                              ? 2
                                                              : 1,
                                                    ),
                                                    const SizedBox(
                                                      width: 5,
                                                      height: 10,
                                                    ),
                                                    _customButton(
                                                      child: const Row(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .center,
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
                                                              color:
                                                                  Colors.black,
                                                              fontSize: 14,
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                      color: Colors.white,
                                                      onTap: () async {
                                                        setState(() {
                                                          paymentMethod =
                                                              'bank_transfer';
                                                        });
                                                        try {
                                                          final res = await ref
                                                              .read(
                                                                reservationControllerProvider
                                                                    .notifier,
                                                              )
                                                              .generatePayment(
                                                                orderId:
                                                                    orderId!,
                                                                paymentMethod:
                                                                    'bank_transfer',
                                                              );
                                                          if (res.token
                                                                  .isNotEmpty &&
                                                              res.redirectUrl
                                                                  .isNotEmpty) {
                                                            setState(() {
                                                              context.pop();
                                                            });
                                                            await redirectToMidtransWebView(
                                                              res.redirectUrl,
                                                            );
                                                          }
                                                        } on ResponseFailure catch (e) {
                                                          setState(() {
                                                            context.pop();
                                                            Toast()
                                                                .showErrorToast(
                                                              context: context,
                                                              title:
                                                                  'Generate Payment Error',
                                                              description:
                                                                  'Desc: ${e.allError}',
                                                            );
                                                          });
                                                        } finally {
                                                          setState(() {});
                                                          closeDetailPanel();
                                                        }
                                                      },
                                                      borderRadius:
                                                          const BorderRadius
                                                              .all(
                                                        Radius.circular(
                                                          15,
                                                        ),
                                                      ),
                                                      isWideScreen: true,
                                                      padding:
                                                          EdgeInsets.symmetric(
                                                        vertical: MediaQuery.of(
                                                              context,
                                                            ).size.height *
                                                            0.018,
                                                      ),
                                                      borderColor:
                                                          paymentMethod ==
                                                                  'bank_transfer'
                                                              ? Colors.black
                                                              : Colors.grey,
                                                      borderWidth:
                                                          paymentMethod ==
                                                                  'bank_transfer'
                                                              ? 2
                                                              : 1,
                                                    ),
                                                  ],
                                                );
                                              },
                                            );
                                          },
                                          borderRadius: const BorderRadius.all(
                                            Radius.circular(15),
                                          ),
                                          isWideScreen: false,
                                          padding: const EdgeInsets.symmetric(
                                            vertical: 16,
                                          ),
                                        ),
                                      ),
                                    ],
                                  )
                                else
                                  TextFormField(
                                    readOnly: true,
                                    style: const TextStyle(
                                      fontWeight: FontWeight.w400,
                                      color: Colors.black,
                                      fontSize: 14,
                                      overflow: TextOverflow.fade,
                                    ),
                                    initialValue: 'Settlement',
                                    decoration: const InputDecoration(
                                      filled: true,
                                      fillColor: Colors.white,
                                      focusedBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.all(
                                          Radius.circular(15),
                                        ),
                                      ),
                                      border: OutlineInputBorder(
                                        borderRadius: BorderRadius.all(
                                          Radius.circular(15),
                                        ),
                                      ),
                                    ),
                                  ),
                                SizedBox(
                                  height: 10.h,
                                ),
                                Text(
                                  'Meja',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.w500,
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
                                  controller: tables,
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
                                  height: 10.h,
                                ),
                                Text(
                                  'Menu',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.w500,
                                    fontSize: 14.sp,
                                  ),
                                ),
                                SizedBox(
                                  height: 5.h,
                                ),
                                _customButton(
                                  child: const Iconify(
                                    Mdi.eye,
                                    color: Colors.white,
                                  ),
                                  color: hexToColor('#1F4940'),
                                  onTap: openViewMenuScreen,
                                  borderRadius: const BorderRadius.all(
                                    Radius.circular(20),
                                  ),
                                  isWideScreen: true,
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 8),
                                  margin: EdgeInsets.only(
                                    right:
                                        MediaQuery.of(context).size.width * 0.4,
                                  ),
                                ),
                                SizedBox(
                                  height: 10.h,
                                ),
                                Text(
                                  'Metode Pembayaran',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.w500,
                                    fontSize: 14.sp,
                                  ),
                                ),
                                SizedBox(
                                  height: 5.h,
                                ),
                                _customButton(
                                  child: paymentInfo['method'] == 'qris'
                                      ? Image.asset(
                                          ImageAssets.qris,
                                          fit: BoxFit.contain,
                                          width: 50,
                                          height: 25,
                                        )
                                      : paymentInfo['method'] == 'bank_transfer'
                                          ? const Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: [
                                                Iconify(
                                                  IconAssets.bankCard,
                                                  color: Colors.black,
                                                  size: 30,
                                                ),
                                                SizedBox(width: 5),
                                                Text(
                                                  'Transfer',
                                                  style: TextStyle(
                                                    color: Colors.black,
                                                    fontSize: 14,
                                                  ),
                                                ),
                                              ],
                                            )
                                          : const Text(
                                              'Unknown Payment',
                                              style: TextStyle(
                                                color: Colors.black,
                                                fontSize: 14,
                                              ),
                                            ),
                                  color: Colors.white,
                                  onTap: () {},
                                  borderRadius: const BorderRadius.all(
                                    Radius.circular(15),
                                  ),
                                  isWideScreen: false,
                                  padding: const EdgeInsets.symmetric(
                                    vertical: 5,
                                    horizontal: 10,
                                  ),
                                  margin: EdgeInsets.only(
                                    right:
                                        MediaQuery.of(context).size.width * 0.4,
                                  ),
                                ),
                                SizedBox(
                                  height: 10.h,
                                ),
                                Text(
                                  'Jumlah Orang',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.w500,
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
                                  controller: jumlah,
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
                              ],
                              width: MediaQuery.of(context).size.width - 40.w,
                            ),
                            PositionedDirectionalBackdropBlurWidget(
                              isPanelVisible: isCreatePanelVisible,
                              end: -MediaQuery.of(context).size.width,
                              content: [
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Container(
                                      decoration: const BoxDecoration(
                                        color: Colors.white,
                                        borderRadius: BorderRadius.all(
                                          Radius.circular(50),
                                        ),
                                      ),
                                      child: IconButton(
                                        padding: const EdgeInsets.all(10),
                                        color: hexToColor('#1F4940'),
                                        icon: const Icon(Icons.arrow_back),
                                        onPressed: closeCreatePanel,
                                      ),
                                    ),
                                  ],
                                ),
                                SizedBox(
                                  height: 20.h,
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(16),
                                  child: Form(
                                    key: _formKey,
                                    autovalidateMode:
                                        AutovalidateMode.onUnfocus,
                                    child: Column(
                                      children: [
                                        _buildTextField(
                                          'Nama',
                                          'Masukkan nama',
                                          nama,
                                          TextInputType.name,
                                          (val) {},
                                          [],
                                          14.sp,
                                        ),
                                        _buildTextField(
                                          'Kontak',
                                          'Masukkan nomor telepon',
                                          kontak,
                                          TextInputType.phone,
                                          (val) {},
                                          [],
                                          14.sp,
                                        ),
                                        _buildDateTimePickerField(
                                          label: 'Start',
                                          hint: 'Masukkan waktu mulai',
                                          controller: startText,
                                          onTap: () async {
                                            await pickStartDateTime(
                                              isWideScreen: false,
                                            );
                                          },
                                          labelSize: 14.sp,
                                        ),
                                        _buildDateTimePickerField(
                                          label: 'End',
                                          hint: 'Masukkan waktu berakhir',
                                          controller: endText,
                                          onTap: () async {
                                            await pickEndDateTime(
                                              isWideScreen: false,
                                            );
                                          },
                                          labelSize: 14.sp,
                                        ),
                                        _buildTextField(
                                          'Catatan',
                                          'Masukkan catatan',
                                          catatan,
                                          TextInputType.text,
                                          (val) {},
                                          [],
                                          14.sp,
                                        ),
                                        _buildTextField(
                                          'Komunitas',
                                          'Masukkan komunitas',
                                          komunitas,
                                          TextInputType.text,
                                          (val) {},
                                          [],
                                          14.sp,
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.only(
                                            bottom: 16,
                                          ),
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                'Status Pembayaran',
                                                style: TextStyle(
                                                  color: Colors.white,
                                                  fontWeight: FontWeight.w600,
                                                  fontSize: 14.sp,
                                                ),
                                              ),
                                              SizedBox(
                                                height: 5.h,
                                              ),
                                              MultiDropdown(
                                                validator: (selectedOptions) {
                                                  if (selectedOptions == null) {
                                                    return 'Required Field';
                                                  }
                                                  return null;
                                                },
                                                autovalidateMode:
                                                    AutovalidateMode.onUnfocus,
                                                controller: statusController,
                                                singleSelect: true,
                                                items: paymentStatus,
                                                chipDecoration: ChipDecoration(
                                                  backgroundColor: hexToColor(
                                                    '#E1E1E1',
                                                  ),
                                                  runSpacing: 2,
                                                  spacing: 10,
                                                ),
                                                fieldDecoration:
                                                    FieldDecoration(
                                                  backgroundColor: Colors.white,
                                                  padding: const EdgeInsets
                                                      .symmetric(
                                                    vertical: 16,
                                                    horizontal: 12,
                                                  ),
                                                  hintText:
                                                      'Pilih DP atau Settlement',
                                                  hintStyle: TextStyle(
                                                    fontSize: 14.sp,
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                    color: Colors.black
                                                        .withOpacity(0.3),
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
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                      15,
                                                    ),
                                                    borderSide:
                                                        const BorderSide(
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
                                            ],
                                          ),
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.only(
                                            bottom: 16,
                                          ),
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                'Meja',
                                                style: TextStyle(
                                                  color: Colors.white,
                                                  fontWeight: FontWeight.w600,
                                                  fontSize: 14.sp,
                                                ),
                                              ),
                                              SizedBox(
                                                height: 5.h,
                                              ),
                                              MultiDropdown(
                                                autovalidateMode:
                                                    AutovalidateMode.onUnfocus,
                                                validator: (option) {
                                                  if (jumlah.text == '') {
                                                    return 'Required Jumlah Orang field';
                                                  }

                                                  if (startText.text == '') {
                                                    return 'Required Start Time field';
                                                  }

                                                  if (endText.text == '') {
                                                    return 'Required End Time field';
                                                  }

                                                  if (isOutdoor == null) {
                                                    return 'Required To Choose Ruangan field';
                                                  }

                                                  if (option == null) {
                                                    return 'Required field';
                                                  }
                                                  return null;
                                                },
                                                enabled: tableController
                                                    .items.isNotEmpty,
                                                items: tableData,
                                                controller: tableController,
                                                chipDecoration: ChipDecoration(
                                                  wrap: false,
                                                  backgroundColor: hexToColor(
                                                    '#E1E1E1',
                                                  ),
                                                  runSpacing: 2,
                                                  spacing: 10,
                                                ),
                                                fieldDecoration:
                                                    FieldDecoration(
                                                  backgroundColor: Colors.white,
                                                  padding: const EdgeInsets
                                                      .symmetric(
                                                    vertical: 16,
                                                    horizontal: 12,
                                                  ),
                                                  hintText: tableController
                                                          .items.isNotEmpty
                                                      ? 'Pilih satu atau lebih meja yang tersedia'
                                                      : 'Lengkapi start, end, jml org, dan ruangan',
                                                  hintStyle: TextStyle(
                                                    fontSize: 14.sp,
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                    color: Colors.black
                                                        .withOpacity(0.3),
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
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                      15,
                                                    ),
                                                    borderSide:
                                                        const BorderSide(
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
                                            ],
                                          ),
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.only(
                                            bottom: 16,
                                          ),
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                'Menu',
                                                style: TextStyle(
                                                  color: Colors.white,
                                                  fontWeight: FontWeight.w600,
                                                  fontSize: 14.sp,
                                                ),
                                              ),
                                              const SizedBox(
                                                height: 5,
                                              ),
                                              _customButton(
                                                child: itemList.isEmpty
                                                    ? Text(
                                                        'Klik Disini untuk Pilih Menu',
                                                        style: TextStyle(
                                                          color: Colors.white,
                                                          fontWeight:
                                                              FontWeight.w600,
                                                          fontSize: 14.sp,
                                                        ),
                                                      )
                                                    : Row(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .center,
                                                        children: [
                                                          Text(
                                                            'Lihat Menu',
                                                            style: TextStyle(
                                                              color:
                                                                  Colors.white,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w600,
                                                              fontSize: 14.sp,
                                                            ),
                                                          ),
                                                          const SizedBox(
                                                            width: 5,
                                                          ),
                                                          const Iconify(
                                                            Mdi.eye,
                                                            color: Colors.white,
                                                          ),
                                                        ],
                                                      ),
                                                color: hexToColor('#1F4940'),
                                                onTap: toggleInputMenuScreen,
                                                borderRadius:
                                                    const BorderRadius.all(
                                                  Radius.circular(15),
                                                ),
                                                isWideScreen: false,
                                                padding: EdgeInsets.symmetric(
                                                  vertical: MediaQuery.of(
                                                        context,
                                                      ).size.height *
                                                      0.018,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.only(
                                            bottom: 16,
                                          ),
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                'Metode Pembayaran',
                                                style: TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 14.sp,
                                                  fontWeight: FontWeight.w600,
                                                ),
                                              ),
                                              const SizedBox(
                                                height: 5,
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
                                                      padding:
                                                          EdgeInsets.symmetric(
                                                        vertical: MediaQuery.of(
                                                              context,
                                                            ).size.height *
                                                            0.018,
                                                      ),
                                                      borderColor:
                                                          paymentMethod ==
                                                                  'other_qris'
                                                              ? Colors.black
                                                              : Colors
                                                                  .transparent,
                                                      borderWidth:
                                                          paymentMethod ==
                                                                  'other_qris'
                                                              ? 2
                                                              : 0,
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
                                                              color:
                                                                  Colors.black,
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
                                                      padding:
                                                          EdgeInsets.symmetric(
                                                        vertical: MediaQuery.of(
                                                              context,
                                                            ).size.height *
                                                            0.018,
                                                      ),
                                                      borderColor:
                                                          paymentMethod ==
                                                                  'bank_transfer'
                                                              ? Colors.black
                                                              : Colors
                                                                  .transparent,
                                                      borderWidth:
                                                          paymentMethod ==
                                                                  'bank_transfer'
                                                              ? 2
                                                              : 0,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ],
                                          ),
                                        ),
                                        _buildTextField(
                                          'Jumlah Orang',
                                          'Masukkan jumlah orang',
                                          jumlah,
                                          TextInputType.number,
                                          (val) {},
                                          [],
                                          14.sp,
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.only(
                                            bottom: 16,
                                          ),
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                'Ruangan',
                                                style: TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 14.sp,
                                                  fontWeight: FontWeight.w600,
                                                ),
                                              ),
                                              const SizedBox(
                                                height: 5,
                                              ),
                                              Row(
                                                children: [
                                                  Expanded(
                                                    child: _customButton(
                                                      child: const Row(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .center,
                                                        children: [
                                                          Iconify(
                                                            IconAssets
                                                                .outdoorIcon,
                                                            color: Colors.black,
                                                            size: 20,
                                                          ),
                                                          SizedBox(
                                                            width: 5,
                                                          ),
                                                          Text(
                                                            'Outdoor',
                                                            style: TextStyle(
                                                              color:
                                                                  Colors.black,
                                                              fontSize: 14,
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                      color: Colors.white,
                                                      onTap: () {
                                                        setState(() {
                                                          isOutdoor = true;
                                                        });
                                                        if (jumlah.text == '') {
                                                          return;
                                                        }
                                                        if (startText.text ==
                                                            '') {
                                                          return;
                                                        }
                                                        if (endText.text ==
                                                            '') {
                                                          return;
                                                        }
                                                        print(
                                                          TableSuggestionRequestEntity(
                                                            capacity: int.parse(
                                                              jumlah.text,
                                                            ),
                                                            isOutdoor: true,
                                                            date: DateFormat(
                                                              'yyyy-MM-dd',
                                                            ).format(
                                                              start,
                                                            ),
                                                            startTime:
                                                                DateFormat.Hms()
                                                                    .format(
                                                              start,
                                                            ),
                                                            endTime:
                                                                DateFormat.Hms()
                                                                    .format(
                                                              end!,
                                                            ),
                                                          ),
                                                        );
                                                        tableSuggest(
                                                          request:
                                                              TableSuggestionRequestEntity(
                                                            capacity: int.parse(
                                                              jumlah.text,
                                                            ),
                                                            isOutdoor:
                                                                isOutdoor!,
                                                            date: DateFormat(
                                                              'yyyy-MM-dd',
                                                            ).format(
                                                              start,
                                                            ),
                                                            startTime:
                                                                DateFormat.Hms()
                                                                    .format(
                                                              start,
                                                            ),
                                                            endTime:
                                                                DateFormat.Hms()
                                                                    .format(
                                                              end!,
                                                            ),
                                                          ),
                                                        );
                                                        setState(() {});
                                                      },
                                                      borderRadius:
                                                          const BorderRadius
                                                              .all(
                                                        Radius.circular(
                                                          15,
                                                        ),
                                                      ),
                                                      isWideScreen: false,
                                                      padding:
                                                          EdgeInsets.symmetric(
                                                        vertical: MediaQuery.of(
                                                              context,
                                                            ).size.height *
                                                            0.018,
                                                      ),
                                                      borderColor: isOutdoor ==
                                                                  null ||
                                                              !isOutdoor!
                                                          ? Colors.transparent
                                                          : Colors.black,
                                                      borderWidth:
                                                          isOutdoor == null ||
                                                                  !isOutdoor!
                                                              ? 0
                                                              : 2,
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
                                                                .indoorIcon,
                                                            color: Colors.black,
                                                            size: 20,
                                                          ),
                                                          SizedBox(
                                                            width: 5,
                                                          ),
                                                          Text(
                                                            'Indoor',
                                                            style: TextStyle(
                                                              color:
                                                                  Colors.black,
                                                              fontSize: 14,
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                      color: Colors.white,
                                                      onTap: () {
                                                        setState(() {
                                                          isOutdoor = false;
                                                          if (jumlah.text ==
                                                              '') {
                                                            return;
                                                          }
                                                          if (startText.text ==
                                                              '') {
                                                            return;
                                                          }
                                                          if (endText.text ==
                                                              '') {
                                                            return;
                                                          }
                                                          print(
                                                            TableSuggestionRequestEntity(
                                                              capacity:
                                                                  int.parse(
                                                                jumlah.text,
                                                              ),
                                                              isOutdoor: true,
                                                              date: DateFormat(
                                                                'yyyy-MM-dd',
                                                              ).format(
                                                                start,
                                                              ),
                                                              startTime:
                                                                  DateFormat
                                                                          .Hms()
                                                                      .format(
                                                                start,
                                                              ),
                                                              endTime:
                                                                  DateFormat
                                                                          .Hms()
                                                                      .format(
                                                                end!,
                                                              ),
                                                            ),
                                                          );
                                                          tableSuggest(
                                                            request:
                                                                TableSuggestionRequestEntity(
                                                              capacity:
                                                                  int.parse(
                                                                jumlah.text,
                                                              ),
                                                              isOutdoor: true,
                                                              date: DateFormat(
                                                                'yyyy-MM-dd',
                                                              ).format(
                                                                start,
                                                              ),
                                                              startTime:
                                                                  DateFormat
                                                                          .Hms()
                                                                      .format(
                                                                start,
                                                              ),
                                                              endTime:
                                                                  DateFormat
                                                                          .Hms()
                                                                      .format(
                                                                end!,
                                                              ),
                                                            ),
                                                          );
                                                          setState(() {});
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
                                                      padding:
                                                          EdgeInsets.symmetric(
                                                        vertical: MediaQuery.of(
                                                              context,
                                                            ).size.height *
                                                            0.018,
                                                      ),
                                                      borderColor: isOutdoor ==
                                                                  null ||
                                                              isOutdoor!
                                                          ? Colors.transparent
                                                          : Colors.black,
                                                      borderWidth:
                                                          isOutdoor == null ||
                                                                  isOutdoor!
                                                              ? 0
                                                              : 2,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ],
                                          ),
                                        ),
                                        Row(
                                          children: [
                                            const Spacer(),
                                            ElevatedButton(
                                              onPressed: isLoading
                                                  ? () {}
                                                  : () async {
                                                      if (_formKey.currentState!
                                                              .validate() &&
                                                          paymentMethod !=
                                                              null) {
                                                        setState(() {
                                                          isLoading = true;
                                                        });
                                                        try {
                                                          final res = await ref
                                                              .read(
                                                                reservationControllerProvider
                                                                    .notifier,
                                                              )
                                                              .createNew(
                                                                request:
                                                                    CreateReservationRequestEntity(
                                                                  reserveBy:
                                                                      nama.text,
                                                                  community:
                                                                      komunitas
                                                                          .text,
                                                                  phoneNumber:
                                                                      kontak
                                                                          .text,
                                                                  note: catatan
                                                                      .text,
                                                                  start:
                                                                      '${DateFormat(
                                                                    'yyyy-MM-dd',
                                                                  ).format(
                                                                    start,
                                                                  )} ${DateFormat.Hm().format(start)}',
                                                                  end:
                                                                      '${DateFormat(
                                                                    'yyyy-MM-dd',
                                                                  ).format(
                                                                    end!,
                                                                  )} ${DateFormat.Hm().format(end!)}',
                                                                  menus:
                                                                      orderList,
                                                                  tables: tableController
                                                                      .selectedItems
                                                                      .map(
                                                                        (e) => e
                                                                            .value,
                                                                      )
                                                                      .toList(),
                                                                  paymentMethod:
                                                                      paymentMethod!,
                                                                  halfPayment: statusController
                                                                          .selectedItems
                                                                          .first
                                                                          .value ==
                                                                      'DP',
                                                                ),
                                                              );
                                                          if (res.token
                                                                  .isNotEmpty &&
                                                              res.redirectUrl
                                                                  .isNotEmpty) {
                                                            print(
                                                              '${res.token} and ${res.redirectUrl}',
                                                            );
                                                            await redirectToMidtransWebView(
                                                              res.redirectUrl,
                                                            );
                                                          }
                                                        } catch (e) {
                                                          setState(() {
                                                            Toast()
                                                                .showErrorToast(
                                                              context: context,
                                                              title:
                                                                  'Tambah Reservasi Error',
                                                              description:
                                                                  'Desc: $e',
                                                            );
                                                          });
                                                          print(
                                                            'create reservation error: $e',
                                                          );
                                                        } finally {
                                                          setState(() {
                                                            isLoading = false;
                                                          });
                                                          closeCreatePanel();
                                                        }
                                                      }
                                                    },
                                              style: ElevatedButton.styleFrom(
                                                backgroundColor:
                                                    hexToColor('#1F4940'),
                                                shape:
                                                    const RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.all(
                                                    Radius.circular(30),
                                                  ),
                                                ),
                                              ),
                                              child: Padding(
                                                padding: EdgeInsets.symmetric(
                                                  vertical: 6.4.h,
                                                  horizontal: 8.w,
                                                ),
                                                child: isLoading
                                                    ? const Center(
                                                        child:
                                                            CustomLoadingIndicator(
                                                          color: Colors.white,
                                                        ),
                                                      )
                                                    : const Text(
                                                        AppStrings.tambahBtn,
                                                        style: TextStyle(
                                                          color: Colors.white,
                                                          fontWeight:
                                                              FontWeight.w600,
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

  FutureVoid pickStartDateTime({required bool isWideScreen}) async {
    final now = DateTime.now();
    final date = await showDatePicker(
      context: context,
      initialDate: now,
      firstDate: now,
      lastDate: DateTime(now.year + 100),
    );
    if (date == null) return;

    final time = await pickTime(isWideScreen: isWideScreen);
    if (time == null) return;

    final newDateTime =
        DateTime(date.year, date.month, date.day, time.hour, time.minute);

    setState(() {
      start = newDateTime;
      startText.value = TextEditingValue(
        text: DateFormat('dd/MM/yy; hh:mm a').format(newDateTime),
      );
    });
  }

  FutureVoid pickEndDateTime({required bool isWideScreen}) async {
    final date = await showDatePicker(
      context: context,
      firstDate: start,
      initialDate: start,
      lastDate: start.copyWith(day: start.day + 2),
    );
    if (date == null) return;

    final time = await pickTime(isWideScreen: isWideScreen);
    if (time == null) return;

    final newDateTime =
        DateTime(date.year, date.month, date.day, time.hour, time.minute);

    setState(() {
      end = newDateTime;
      endText.value = TextEditingValue(
        text: DateFormat('dd/MM/yy; hh:mm a').format(newDateTime),
      );
    });
  }

  Future<TimeOfDay?> pickTime({required bool isWideScreen}) => showTimePicker(
        context: context,
        initialTime: TimeOfDay.now(),
        orientation:
            isWideScreen ? Orientation.landscape : Orientation.portrait,
      );
}

Widget _buildDateTimePickerField({
  required String label,
  required String hint,
  required TextEditingController controller,
  void Function()? onTap,
  double? labelSize,
}) {
  return Padding(
    padding: const EdgeInsets.only(bottom: 16),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w600,
            fontSize: labelSize ?? 8.sp,
          ),
        ),
        SizedBox(
          height: 5.h,
        ),
        TextFormField(
          validator: (value) {
            if (value == null || value == '') {
              return 'Required Field';
            }
            return null;
          },
          onTap: onTap,
          controller: controller,
          readOnly: true,
          style: const TextStyle(
            fontWeight: FontWeight.w400,
            color: Colors.black,
            fontSize: 14,
            overflow: TextOverflow.fade,
          ),
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: TextStyle(
              color: Colors.black.withOpacity(0.3),
              fontWeight: FontWeight.w600,
            ),
            filled: true,
            fillColor: Colors.white,
            focusedBorder: const OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(15)),
            ),
            border: const OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(15)),
            ),
          ),
        ),
      ],
    ),
  );
}

Widget _buildTextField(
  String label,
  String hint,
  TextEditingController controller,
  TextInputType keytype,
  void Function(String)? onChanged,
  List<TextInputFormatter>? inputFormatter,
  double labelSize,
) {
  return Padding(
    padding: const EdgeInsets.only(bottom: 16),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w600,
            fontSize: labelSize,
          ),
        ),
        SizedBox(
          height: 5.h,
        ),
        TextFormField(
          validator: (value) {
            if ((value == null || value.isEmpty) && label != 'Catatan') {
              return 'Required Field!';
            }
            if (label == 'Kontak' && (value!.length < 3 || value.length > 12)) {
              return 'Must be min 3 char. and max 12 char.';
            }
            if ((label == 'Nama' || label == 'Komunitas') &&
                (value!.length < 3 || value.length > 150)) {
              return 'Must be min 3 char. and max 150 char.';
            }
            if (label == 'Catatan' && value!.length > 1500) {
              return 'Must be max 1500 char.';
            }
            return null;
          },
          inputFormatters: inputFormatter,
          keyboardType: keytype,
          controller: controller,
          style: const TextStyle(
            fontWeight: FontWeight.w400,
            color: Colors.black,
            fontSize: 14,
            overflow: TextOverflow.fade,
          ),
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: TextStyle(
              color: Colors.black.withOpacity(0.3),
              fontWeight: FontWeight.w600,
            ),
            filled: true,
            fillColor: Colors.white,
            focusedBorder: const OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(15)),
            ),
            border: const OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(15)),
            ),
          ),
          onChanged: onChanged,
        ),
      ],
    ),
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

///
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
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 100),
        padding:
            isWideScreen ? null : const EdgeInsets.symmetric(horizontal: 20),
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.all(Radius.circular(35)),
        ),
        margin: EdgeInsets.symmetric(
          horizontal: isWideScreen
              ? MediaQuery.of(context).size.width * 0.2
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
                  fontSize: isWideScreen ? 35 : 20,
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
                          : MediaQuery.of(context).size.width * 0.04,
                      vertical: 8,
                    ),
                    child: Center(
                      child: Text(
                        'Batalkan',
                        style: TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.w600,
                          fontSize: isWideScreen ? 18 : 12,
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
                          : MediaQuery.of(context).size.width * 0.04,
                      vertical: 8,
                    ),
                    child: Center(
                      child: Text(
                        'Konfirmasi',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: isWideScreen ? 18 : 12,
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
