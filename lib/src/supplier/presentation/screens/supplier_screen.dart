import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:iconify_flutter/iconify_flutter.dart';
import 'package:iconify_flutter/icons/eva.dart';
import 'package:iconify_flutter/icons/zondicons.dart';
import 'package:intl/intl.dart';
import 'package:multi_dropdown/multi_dropdown.dart';
import 'package:raskop_fe_backoffice/core/core.dart';
import 'package:raskop_fe_backoffice/res/assets.dart';
import 'package:raskop_fe_backoffice/res/strings.dart';
import 'package:raskop_fe_backoffice/shared/const.dart';
import 'package:raskop_fe_backoffice/src/supplier/application/supplier_controller.dart';
import 'package:raskop_fe_backoffice/src/supplier/domain/entities/supplier_entity.dart';
import 'package:raskop_fe_backoffice/src/supplier/presentation/widgets/phone_switch_widget.dart';
import 'package:raskop_fe_backoffice/src/supplier/presentation/widgets/positioned_directional_backdrop_blur_widget.dart';
import 'package:raskop_fe_backoffice/src/supplier/presentation/widgets/switch_widget.dart';

///
class SupplierScreen extends ConsumerStatefulWidget {
  ///
  const SupplierScreen({super.key});

  ///
  static const String route = 'supplier';

  @override
  ConsumerState<SupplierScreen> createState() => _SupplierScreenState();
}

class _SupplierScreenState extends ConsumerState<SupplierScreen> {
  AsyncValue<List<SupplierEntity>> get supplier =>
      ref.watch(supplierControllerProvider);

  SupplierEntity detailSupplier = const SupplierEntity(
    id: '',
    name: '',
    contact: '',
    type: '',
    price: 0,
    unit: '',
    shippingFee: 0,
    address: '',
    productName: '',
    isActive: false,
  );

  final createKey = GlobalKey<FormState>();
  final editKey = GlobalKey<FormState>();

  bool isDetailPanelVisible = false;
  bool isCreatePanelVisible = false;
  bool isEditPanelVisible = false;
  TextEditingController nama = TextEditingController();
  TextEditingController kontak = TextEditingController();
  TextEditingController harga = TextEditingController();
  TextEditingController tipe = TextEditingController();
  TextEditingController unit = TextEditingController();
  TextEditingController biaya = TextEditingController();
  TextEditingController alamat = TextEditingController();
  TextEditingController produk = TextEditingController();
  TextEditingController search = TextEditingController();
  double price = 0;
  double fee = 0;
  String? id;
  bool? switchStatusForEdit;
  List<DropdownItem<String>> advSearchOptions = [
    DropdownItem(label: 'Nama', value: 'name'),
    DropdownItem(label: 'Kontak', value: 'contact'),
    DropdownItem(label: 'Nama Produk', value: 'productName'),
    DropdownItem(label: 'Alamat', value: 'address'),
    DropdownItem(label: 'Unit', value: 'unit'),
  ];

  List<DropdownItem<String>> productType = [
    DropdownItem(label: 'Sirup', value: 'SYRUPE'),
    DropdownItem(label: 'Kacang/Biji Kopi', value: 'BEANS'),
    DropdownItem(label: 'Bubuk/Powder', value: 'POWDER'),
    DropdownItem(label: 'Cup', value: 'CUP'),
    DropdownItem(label: 'Kudapan/Snack', value: 'SNACK'),
    DropdownItem(label: 'Lainnya', value: 'OTHER_INGREDIENT'),
  ];

  List<DropdownItem<String>> productUnit = [
    DropdownItem(label: 'Kilogram', value: 'KG'),
    DropdownItem(label: 'Piece', value: 'PIECE'),
    DropdownItem(label: 'Liter', value: 'LITER'),
    DropdownItem(label: 'Gram', value: 'GRAM'),
    DropdownItem(label: 'Pack/Box', value: 'BOX'),
    DropdownItem(label: 'Ball', value: 'BALL'),
  ];

  final typeTabletCreateController = MultiSelectController<String>();
  final typePhoneCreateController = MultiSelectController<String>();
  final unitTabletCreateController = MultiSelectController<String>();
  final unitPhoneCreateController = MultiSelectController<String>();

  final typeTabletEditController = MultiSelectController<String>();
  final typePhoneEditController = MultiSelectController<String>();
  final unitTabletEditController = MultiSelectController<String>();
  final unitPhoneEditController = MultiSelectController<String>();

  final advSearchTabletController = MultiSelectController<String>();
  final advSearchPhoneController = MultiSelectController<String>();

  bool isLoading = false;

  bool isNameAscending = true;

  bool isContactAscending = true;

  @override
  Widget build(BuildContext context) {
    void openDetailPanel({required SupplierEntity detailSupplier}) {
      setState(() {
        nama.value = TextEditingValue(text: detailSupplier.name);
        kontak.value = TextEditingValue(text: detailSupplier.contact);
        harga.value = TextEditingValue(
          text: NumberFormat.simpleCurrency(
            locale: 'id-ID',
            name: 'Rp',
            decimalDigits: 2,
          ).format(detailSupplier.price),
        );
        unit.value = TextEditingValue(text: detailSupplier.unit);
        biaya.value = TextEditingValue(
          text: NumberFormat.simpleCurrency(
            locale: 'id-ID',
            name: 'Rp',
            decimalDigits: 2,
          ).format(detailSupplier.shippingFee),
        );
        alamat.value = TextEditingValue(text: detailSupplier.address);
        produk.value = TextEditingValue(text: detailSupplier.productName);
        tipe.value = TextEditingValue(text: detailSupplier.type);
        isDetailPanelVisible = true;
      });
    }

    void closeDetailPanel() {
      setState(() {
        nama.clear();
        kontak.clear();
        harga.clear();
        unit.clear();
        biaya.clear();
        alamat.clear();
        produk.clear();
        tipe.clear();
        isDetailPanelVisible = false;
      });
    }

    void toggleCreatePanel() {
      setState(() {
        isCreatePanelVisible = !isCreatePanelVisible;
      });
    }

    void closeCreatePanel() {
      setState(() {
        nama.clear();
        kontak.clear();
        harga.clear();
        unit.clear();
        biaya.clear();
        alamat.clear();
        produk.clear();
        typeTabletEditController.clearAll();
        unitTabletEditController.clearAll();
        typePhoneEditController.clearAll();
        unitPhoneEditController.clearAll();
        isCreatePanelVisible = false;
        FocusScope.of(context).unfocus();
      });
    }

    void openEditPanel({required SupplierEntity request}) {
      setState(() {
        isEditPanelVisible = !isEditPanelVisible;
        nama.value = TextEditingValue(text: request.name);
        kontak.value = TextEditingValue(text: request.contact);
        harga.value = TextEditingValue(text: request.price.toString());
        biaya.value = TextEditingValue(text: request.shippingFee.toString());
        alamat.value = TextEditingValue(text: request.address);
        produk.value = TextEditingValue(text: request.productName);
        typeTabletEditController
            .selectWhere((item) => item.value == request.type);
        typePhoneEditController
            .selectWhere((item) => item.value == request.type);
        unitTabletEditController
            .selectWhere((item) => item.value == request.unit);
        unitPhoneEditController
            .selectWhere((item) => item.value == request.unit);
        id = request.id;
        switchStatusForEdit = request.isActive;
      });
    }

    void closeEditPanel() {
      setState(() {
        isEditPanelVisible = !isEditPanelVisible;
        nama.clear();
        kontak.clear();
        harga.clear();
        biaya.clear();
        alamat.clear();
        produk.clear();
        typeTabletEditController.clearAll();
        unitTabletEditController.clearAll();
        typePhoneEditController.clearAll();
        unitPhoneEditController.clearAll();
        id = null;
        switchStatusForEdit = null;
        FocusScope.of(context).unfocus();
      });
    }

    void onSearchPhone() {
      ref.read(supplierControllerProvider.notifier).fetchSuppliers(
        search: search.text,
        advSearch: {
          for (final item in advSearchPhoneController.selectedItems)
            item.value: search.text,
        },
      );
    }

    void onSearchTablet() {
      ref.read(supplierControllerProvider.notifier).fetchSuppliers(
        search: search.text,
        advSearch: {
          for (final item in advSearchTabletController.selectedItems)
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

    void onSort({required String column, required String direction}) {
      ref.read(supplierControllerProvider.notifier).fetchSuppliers(
        order: [
          <String, dynamic>{
            'column': column,
            'direction': direction,
          },
        ],
      );
    }

    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
        resizeToAvoidBottomInset: true,
        backgroundColor: Colors.white,
        body: LayoutBuilder(
          builder: (context, constraints) {
            if (constraints.maxWidth > 500) {
              return Stack(
                children: [
                  AnimatedContainer(
                    padding:
                        EdgeInsets.symmetric(horizontal: 10.w, vertical: 10.h),
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
                                  child: Image.asset(ImageAssets.raskop),
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
                                    borderRadius: const BorderRadius.all(
                                      Radius.circular(30),
                                    ),
                                  ),
                                  child: Row(
                                    children: [
                                      Flexible(
                                        flex: 3,
                                        child: TextFormField(
                                          controller: search,
                                          onChanged: (value) {
                                            debounceOnTablet();
                                          },
                                          onFieldSubmitted: (value) {
                                            onSearchTablet();
                                          },
                                          decoration: InputDecoration(
                                            filled: false,
                                            border: InputBorder.none,
                                            hintText:
                                                'Temukan nama, kontak, unit...',
                                            hintStyle: TextStyle(
                                              color:
                                                  Colors.black.withOpacity(0.3),
                                              fontWeight: FontWeight.w400,
                                            ),
                                          ),
                                        ),
                                      ),
                                      Flexible(
                                        flex: 2,
                                        child: MultiDropdown<String>(
                                          items: advSearchOptions,
                                          controller: advSearchTabletController,
                                          onSelectionChange: (selectedItems) {
                                            onSearchTablet();
                                          },
                                          fieldDecoration:
                                              const FieldDecoration(
                                            border: OutlineInputBorder(
                                              borderSide: BorderSide.none,
                                            ),
                                            hintText: '',
                                            suffixIcon: Icon(
                                              Icons.filter_list_alt,
                                            ),
                                            animateSuffixIcon: false,
                                            backgroundColor: Colors.transparent,
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
                                          chipDecoration: ChipDecoration(
                                            wrap: false,
                                            backgroundColor: hexToColor(
                                              '#E1E1E1',
                                            ),
                                            labelStyle: const TextStyle(
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
                              const SizedBox(
                                width: 20,
                              ),
                              Flexible(
                                flex: 2,
                                child: Padding(
                                  padding: const EdgeInsets.only(
                                    right: 20,
                                  ),
                                  child: TextButton(
                                    onPressed: () {},
                                    style: TextButton.styleFrom(
                                      backgroundColor: hexToColor('#1F4940'),
                                      shape: const RoundedRectangleBorder(
                                        borderRadius: BorderRadius.all(
                                          Radius.circular(
                                            30,
                                          ),
                                        ),
                                      ),
                                    ),
                                    child: const Center(
                                      child: Text(
                                        'Pencarian Lanjutan',
                                        style: TextStyle(
                                          color: Colors.white,
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
                        const SizedBox(
                          height: 10,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: hexToColor('#1f4940'),
                              ),
                              onPressed: toggleCreatePanel,
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
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                                  flex: 3,
                                  child: Row(
                                    children: [
                                      Text(
                                        'NAMA',
                                        style: TextStyle(
                                          fontWeight: FontWeight.w600,
                                          color: hexToColor('#202224'),
                                          fontSize: 14,
                                        ),
                                      ),
                                      GestureDetector(
                                        onTap: () {
                                          onSort(
                                            column: 'name',
                                            direction: isNameAscending
                                                ? 'DESC'
                                                : 'ASC',
                                          );
                                          setState(() {
                                            isNameAscending = !isNameAscending;
                                          });
                                        },
                                        child: Iconify(
                                          isNameAscending
                                              ? IconAssets.ascendingIcon
                                              : IconAssets.descendingIcon,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Expanded(
                                  flex: 3,
                                  child: Row(
                                    children: [
                                      Text(
                                        'KONTAK',
                                        style: TextStyle(
                                          fontWeight: FontWeight.w600,
                                          color: hexToColor('#202224'),
                                          fontSize: 14,
                                        ),
                                      ),
                                      GestureDetector(
                                        onTap: () {
                                          onSort(
                                            column: 'contact',
                                            direction: isContactAscending
                                                ? 'DESC'
                                                : 'ASC',
                                          );
                                          setState(() {
                                            isContactAscending =
                                                !isContactAscending;
                                          });
                                        },
                                        child: Iconify(
                                          isContactAscending
                                              ? IconAssets.ascendingIcon
                                              : IconAssets.descendingIcon,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Expanded(
                                  flex: 3,
                                  child: Center(
                                    child: Text(
                                      'TIPE',
                                      textAlign: TextAlign.center,
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
                                      'HARGA',
                                      textAlign: TextAlign.center,
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
                                      'UNIT, BIAYA, ALAMAT, PRODUK',
                                      textAlign: TextAlign.center,
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
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Container(
                                          width: 20,
                                          height: 20,
                                          decoration: BoxDecoration(
                                            color: hexToColor('#47B881'),
                                            shape: BoxShape.circle,
                                          ),
                                        ),
                                        const SizedBox(width: 5),
                                        Container(
                                          width: 20,
                                          height: 20,
                                          decoration: BoxDecoration(
                                            color: hexToColor('#F64C4C'),
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
                          child: supplier.when(
                            data: (data) {
                              return ListView(
                                padding: EdgeInsets.zero,
                                shrinkWrap: true,
                                children: data
                                    .map(
                                      (e) => Container(
                                        margin: EdgeInsets.only(bottom: 7.h),
                                        decoration: BoxDecoration(
                                          border:
                                              Border.all(color: Colors.grey),
                                          borderRadius:
                                              BorderRadius.circular(18),
                                          color: hexToColor('#E1E1E1'),
                                        ),
                                        child: Slidable(
                                          startActionPane: ActionPane(
                                            extentRatio: 0.08,
                                            motion: const BehindMotion(),
                                            children: [
                                              Expanded(
                                                child: SizedBox.expand(
                                                  child: GestureDetector(
                                                    onTap: () {
                                                      openEditPanel(request: e);
                                                    },
                                                    child: Container(
                                                      decoration: BoxDecoration(
                                                        borderRadius:
                                                            const BorderRadius
                                                                .only(
                                                          topLeft:
                                                              Radius.circular(
                                                            18,
                                                          ),
                                                          bottomLeft:
                                                              Radius.circular(
                                                            18,
                                                          ),
                                                        ),
                                                        color: hexToColor(
                                                          '#E1E1E1',
                                                        ),
                                                      ),
                                                      child: ClipOval(
                                                        child: Center(
                                                          child: Container(
                                                            width:
                                                                MediaQuery.of(
                                                                      context,
                                                                    )
                                                                        .size
                                                                        .width *
                                                                    0.05,
                                                            height:
                                                                MediaQuery.of(
                                                                      context,
                                                                    )
                                                                        .size
                                                                        .width *
                                                                    0.05,
                                                            padding:
                                                                const EdgeInsets
                                                                    .all(
                                                              12,
                                                            ),
                                                            decoration:
                                                                BoxDecoration(
                                                              borderRadius:
                                                                  const BorderRadius
                                                                      .all(
                                                                Radius.circular(
                                                                  30,
                                                                ),
                                                              ),
                                                              color: hexToColor(
                                                                '#FFAD0D',
                                                              ),
                                                            ),
                                                            child:
                                                                const Iconify(
                                                              Zondicons
                                                                  .edit_pencil,
                                                              color:
                                                                  Colors.white,
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
                                          endActionPane: ActionPane(
                                            extentRatio: 0.08,
                                            motion: const BehindMotion(),
                                            children: [
                                              Expanded(
                                                child: SizedBox.expand(
                                                  child: GestureDetector(
                                                    onTap: () {
                                                      showConfirmationDialog(
                                                        context: context,
                                                        title:
                                                            'Hapus Supplier?',
                                                        onDelete: isLoading
                                                            ? () {}
                                                            : () async {
                                                                setState(() {
                                                                  isLoading =
                                                                      true;
                                                                });
                                                                try {
                                                                  await ref
                                                                      .read(
                                                                        supplierControllerProvider
                                                                            .notifier,
                                                                      )
                                                                      .deleteData(
                                                                        id: e
                                                                            .id!,
                                                                        deletePermanent:
                                                                            false,
                                                                      );
                                                                } catch (e) {
                                                                  // show snackbar or anything else
                                                                  print(
                                                                    'delete failed : $e',
                                                                  );
                                                                } finally {
                                                                  setState(() {
                                                                    isLoading =
                                                                        false;
                                                                    Navigator
                                                                        .pop(
                                                                      context,
                                                                    );
                                                                  });
                                                                }
                                                              },
                                                        onDeletePermanent:
                                                            isLoading
                                                                ? () {}
                                                                : () async {
                                                                    setState(
                                                                        () {
                                                                      isLoading =
                                                                          true;
                                                                    });
                                                                    try {
                                                                      await ref
                                                                          .read(
                                                                            supplierControllerProvider.notifier,
                                                                          )
                                                                          .deleteData(
                                                                            id: e.id!,
                                                                            deletePermanent:
                                                                                true,
                                                                          );
                                                                    } catch (e) {
                                                                      // show snackbar or anything else
                                                                      print(
                                                                        'delete permanent failed: $e',
                                                                      );
                                                                    } finally {
                                                                      setState(
                                                                          () {
                                                                        isLoading =
                                                                            false;
                                                                        Navigator
                                                                            .pop(
                                                                          context,
                                                                        );
                                                                      });
                                                                    }
                                                                  },
                                                        content:
                                                            'Supplier ini akan terhapus dari halaman ini.',
                                                        isWideScreen: true,
                                                      );
                                                    },
                                                    child: Container(
                                                      decoration: BoxDecoration(
                                                        borderRadius:
                                                            const BorderRadius
                                                                .only(
                                                          topRight:
                                                              Radius.circular(
                                                            18,
                                                          ),
                                                          bottomRight:
                                                              Radius.circular(
                                                            18,
                                                          ),
                                                        ),
                                                        color: hexToColor(
                                                          '#E1E1E1',
                                                        ),
                                                      ),
                                                      child: Center(
                                                        child: Container(
                                                          width: MediaQuery.of(
                                                                context,
                                                              ).size.width *
                                                              0.05,
                                                          height: MediaQuery.of(
                                                                context,
                                                              ).size.width *
                                                              0.05,
                                                          padding:
                                                              const EdgeInsets
                                                                  .all(12),
                                                          decoration:
                                                              BoxDecoration(
                                                            borderRadius:
                                                                const BorderRadius
                                                                    .all(
                                                              Radius.circular(
                                                                30,
                                                              ),
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
                                              border: Border.all(
                                                color: Colors.grey,
                                              ),
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
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                Expanded(
                                                  flex: 2,
                                                  child: Text(
                                                    e.id!,
                                                    maxLines: 1,
                                                    style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.w500,
                                                      color:
                                                          hexToColor('#202224'),
                                                      fontSize: 14,
                                                      overflow:
                                                          TextOverflow.ellipsis,
                                                    ),
                                                  ),
                                                ),
                                                Expanded(
                                                  flex: 3,
                                                  child: Text(
                                                    e.name,
                                                    maxLines: 2,
                                                    style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.w500,
                                                      color:
                                                          hexToColor('#202224'),
                                                      fontSize: 14,
                                                      overflow:
                                                          TextOverflow.ellipsis,
                                                    ),
                                                  ),
                                                ),
                                                Expanded(
                                                  flex: 3,
                                                  child: Text(
                                                    e.contact,
                                                    maxLines: 2,
                                                    style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.w500,
                                                      color:
                                                          hexToColor('#202224'),
                                                      fontSize: 14,
                                                      overflow:
                                                          TextOverflow.ellipsis,
                                                    ),
                                                  ),
                                                ),
                                                Expanded(
                                                  flex: 3,
                                                  child: Center(
                                                    child: Text(
                                                      e.type,
                                                      maxLines: 2,
                                                      textAlign:
                                                          TextAlign.center,
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
                                                ),
                                                Expanded(
                                                  flex: 3,
                                                  child: Center(
                                                    child: Text(
                                                      NumberFormat
                                                          .simpleCurrency(
                                                        locale: 'id-ID',
                                                        name: 'Rp',
                                                        decimalDigits: 2,
                                                      ).format(e.price),
                                                      maxLines: 2,
                                                      textAlign:
                                                          TextAlign.center,
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
                                                ),
                                                Expanded(
                                                  flex: 5,
                                                  child: Center(
                                                    child: Padding(
                                                      padding:
                                                          EdgeInsets.symmetric(
                                                        horizontal: 10.h,
                                                      ),
                                                      child: TextButton(
                                                        onPressed: () {
                                                          openDetailPanel(
                                                            detailSupplier:
                                                                SupplierEntity(
                                                              id: e.id,
                                                              name: e.name,
                                                              contact:
                                                                  e.contact,
                                                              type: e.type,
                                                              price: e.price,
                                                              unit: e.unit,
                                                              shippingFee:
                                                                  e.shippingFee,
                                                              address:
                                                                  e.address,
                                                              productName:
                                                                  e.productName,
                                                              isActive:
                                                                  e.isActive,
                                                            ),
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
                                                Expanded(
                                                  flex: 2,
                                                  child: Center(
                                                    child: CustomSwitch(
                                                      isON: e.isActive!,
                                                      onSwitch: (val) {
                                                        return ref
                                                            .read(
                                                              supplierControllerProvider
                                                                  .notifier,
                                                            )
                                                            .toggleSupplierStatus(
                                                              request: e,
                                                              id: e.id!,
                                                              currentStatus:
                                                                  e.isActive!,
                                                            );
                                                      },
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ),
                                    )
                                    .toList(),
                              );
                            },
                            loading: () => const Center(
                              child: CircularProgressIndicator.adaptive(
                                valueColor:
                                    AlwaysStoppedAnimation<Color>(Colors.black),
                              ),
                            ),
                            error: (error, stackTrace) => Center(
                              child: Text(
                                error.toString() + stackTrace.toString(),
                              ),
                            ),
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
                        'Unit',
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
                        controller: unit,
                        decoration: const InputDecoration(
                          filled: true,
                          fillColor: Colors.white,
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(15)),
                          ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(15)),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 10.h,
                      ),
                      Text(
                        'Biaya Pengiriman',
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
                        controller: biaya,
                        decoration: const InputDecoration(
                          filled: true,
                          fillColor: Colors.white,
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(15)),
                          ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(15)),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 10.h,
                      ),
                      Text(
                        'Alamat',
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
                        maxLines: 3,
                        controller: alamat,
                        decoration: const InputDecoration(
                          filled: true,
                          fillColor: Colors.white,
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(15)),
                          ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(15)),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 10.h,
                      ),
                      Text(
                        'Produk',
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
                        controller: produk,
                        decoration: const InputDecoration(
                          filled: true,
                          fillColor: Colors.white,
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(15)),
                          ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(15)),
                          ),
                        ),
                      ),
                    ],
                    width: MediaQuery.of(context).size.width * 0.3,
                  ),
                  PositionedDirectionalBackdropBlurWidget(
                    isPanelVisible: isCreatePanelVisible,
                    end: -MediaQuery.of(context).size.width * 1,
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
                              onPressed: toggleCreatePanel,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 20.h,
                      ),
                      Padding(
                        padding: const EdgeInsets.all(16),
                        child: LayoutBuilder(
                          builder: (context, constraints) {
                            final isWideScreen = constraints.maxWidth > 600;
                            final crossAxisCount = isWideScreen ? 3 : 2;
                            final itemWidth = (constraints.maxWidth -
                                    (100 * (crossAxisCount - 2))) /
                                crossAxisCount;
                            return Form(
                              key: createKey,
                              autovalidateMode: AutovalidateMode.onUnfocus,
                              child: SingleChildScrollView(
                                child: Wrap(
                                  alignment: WrapAlignment.center,
                                  spacing: 10,
                                  children: [
                                    SizedBox(
                                      width: itemWidth.w,
                                      child: _buildTextField(
                                        'Nama',
                                        'Masukkan nama pemilik',
                                        nama,
                                        TextInputType.name,
                                        14.sp,
                                      ),
                                    ),
                                    SizedBox(
                                      width: itemWidth.w,
                                      child: _buildTextField(
                                        'Kontak',
                                        'Masukkan nomor telepon',
                                        kontak,
                                        TextInputType.phone,
                                        14.sp,
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
                                              'Tipe',
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
                                              validator: (value) {
                                                if (value == null ||
                                                    value.isEmpty) {
                                                  return 'Required Field';
                                                }
                                                return null;
                                              },
                                              controller:
                                                  typeTabletCreateController,
                                              singleSelect: true,
                                              items: productType,
                                              chipDecoration: ChipDecoration(
                                                backgroundColor: hexToColor(
                                                  '#E1E1E1',
                                                ),
                                                runSpacing: 2,
                                                spacing: 10,
                                              ),
                                              fieldDecoration: FieldDecoration(
                                                errorBorder: OutlineInputBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                    15,
                                                  ),
                                                  borderSide: const BorderSide(
                                                    color: Colors.red,
                                                  ),
                                                ),
                                                backgroundColor: Colors.white,
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                  vertical: 16,
                                                  horizontal: 12,
                                                ),
                                                hintText:
                                                    'Pilih tipe yang diinginkan',
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
                                          ],
                                        ),
                                      ),
                                    ),
                                    SizedBox(
                                      width: itemWidth.w,
                                      child: _buildTextField(
                                        'Harga',
                                        'Masukkan harga',
                                        harga,
                                        TextInputType.number,
                                        14.sp,
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
                                              'Unit',
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
                                              validator: (value) {
                                                if (value == null ||
                                                    value.isEmpty) {
                                                  return 'Required Field';
                                                }
                                                return null;
                                              },
                                              controller:
                                                  unitTabletCreateController,
                                              singleSelect: true,
                                              items: productUnit,
                                              chipDecoration: ChipDecoration(
                                                backgroundColor: hexToColor(
                                                  '#E1E1E1',
                                                ),
                                                runSpacing: 2,
                                                spacing: 10,
                                              ),
                                              fieldDecoration: FieldDecoration(
                                                errorBorder: OutlineInputBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                    15,
                                                  ),
                                                  borderSide: const BorderSide(
                                                    color: Colors.red,
                                                  ),
                                                ),
                                                backgroundColor: Colors.white,
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                  vertical: 16,
                                                  horizontal: 12,
                                                ),
                                                hintText:
                                                    'Pilih unit satuan barang',
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
                                          ],
                                        ),
                                      ),
                                    ),
                                    SizedBox(
                                      width: itemWidth.w,
                                      child: _buildTextField(
                                        'Biaya Pengiriman',
                                        'Masukkan total biaya pengiriman',
                                        biaya,
                                        TextInputType.number,
                                        14.sp,
                                      ),
                                    ),
                                    SizedBox(
                                      width: (itemWidth * 2 + 5).w,
                                      child: _buildTextField(
                                        'Alamat',
                                        'Masukkan alamat lengkap',
                                        alamat,
                                        TextInputType.streetAddress,
                                        14.sp,
                                      ),
                                    ),
                                    SizedBox(
                                      width: itemWidth.w,
                                      child: _buildTextField(
                                        'Produk',
                                        'Masukkan nama produk',
                                        produk,
                                        TextInputType.text,
                                        14.sp,
                                      ),
                                    ),
                                    SizedBox(
                                      width: (itemWidth * 3 - 60).w,
                                    ),
                                    ElevatedButton(
                                      onPressed: isLoading
                                          ? () {}
                                          : () async {
                                              setState(() {
                                                isLoading = true;
                                              });

                                              try {
                                                if (createKey.currentState!
                                                    .validate()) {
                                                  await ref
                                                      .read(
                                                        supplierControllerProvider
                                                            .notifier,
                                                      )
                                                      .createNew(
                                                        request: SupplierEntity(
                                                          name: nama.text,
                                                          contact: kontak.text,
                                                          type:
                                                              typeTabletCreateController
                                                                  .selectedItems
                                                                  .first
                                                                  .value,
                                                          price: double.parse(
                                                            harga.text,
                                                          ),
                                                          unit:
                                                              unitTabletCreateController
                                                                  .selectedItems
                                                                  .first
                                                                  .value,
                                                          shippingFee:
                                                              double.parse(
                                                            biaya.text,
                                                          ),
                                                          address: alamat.text,
                                                          productName:
                                                              produk.text,
                                                          isActive: false,
                                                        ),
                                                      );
                                                  closeCreatePanel();
                                                }
                                              } catch (e) {
                                                //show snackbar or anything else
                                              } finally {
                                                setState(() {
                                                  isLoading = false;
                                                });
                                              }
                                            },
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: hexToColor('#1F4940'),
                                        shape: const RoundedRectangleBorder(
                                          borderRadius: BorderRadius.all(
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
                                            ? const LinearProgressIndicator(
                                                valueColor:
                                                    AlwaysStoppedAnimation<
                                                        Color>(Colors.white),
                                              )
                                            : const Text(
                                                AppStrings.tambahBtn,
                                                style: TextStyle(
                                                  color: Colors.white,
                                                  fontWeight: FontWeight.w600,
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
                      ),
                    ],
                    width: MediaQuery.of(context).size.width * 0.9,
                  ),
                  PositionedDirectionalBackdropBlurWidget(
                    isPanelVisible: isEditPanelVisible,
                    end: -MediaQuery.of(context).size.width * 1,
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
                              onPressed: closeEditPanel,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 20.h,
                      ),
                      Padding(
                        padding: const EdgeInsets.all(16),
                        child: LayoutBuilder(
                          builder: (context, constraints) {
                            final isWideScreen = constraints.maxWidth > 600;
                            final crossAxisCount = isWideScreen ? 3 : 2;
                            final itemWidth = (constraints.maxWidth -
                                    (100.w * (crossAxisCount - 2))) /
                                crossAxisCount;
                            return Form(
                              key: editKey,
                              child: SingleChildScrollView(
                                child: Wrap(
                                  spacing: 10,
                                  alignment: WrapAlignment.center,
                                  children: [
                                    SizedBox(
                                      width: itemWidth.w,
                                      child: _buildTextField(
                                        'Nama',
                                        'Masukkan nama pemilik',
                                        nama,
                                        TextInputType.name,
                                        14.sp,
                                      ),
                                    ),
                                    SizedBox(
                                      width: itemWidth.w,
                                      child: _buildTextField(
                                        'Kontak',
                                        'Masukkan nomor telepon',
                                        kontak,
                                        TextInputType.phone,
                                        14.sp,
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
                                              'Tipe',
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
                                              validator: (value) {
                                                if (value == null ||
                                                    value.isEmpty) {
                                                  return 'Required Field';
                                                }
                                                return null;
                                              },
                                              controller:
                                                  typeTabletEditController,
                                              singleSelect: true,
                                              items: productType,
                                              chipDecoration: ChipDecoration(
                                                backgroundColor: hexToColor(
                                                  '#E1E1E1',
                                                ),
                                                runSpacing: 2,
                                                spacing: 10,
                                              ),
                                              fieldDecoration: FieldDecoration(
                                                backgroundColor: Colors.white,
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                  vertical: 16,
                                                  horizontal: 12,
                                                ),
                                                hintText:
                                                    'Pilih tipe yang diinginkan',
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
                                          ],
                                        ),
                                      ),
                                    ),
                                    SizedBox(
                                      width: itemWidth.w,
                                      child: _buildTextField(
                                        'Harga',
                                        'Masukkan harga',
                                        harga,
                                        TextInputType.number,
                                        14.sp,
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
                                              'Unit',
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
                                              validator: (value) {
                                                if (value == null ||
                                                    value.isEmpty) {
                                                  return 'Required Field';
                                                }
                                                return null;
                                              },
                                              controller:
                                                  unitTabletEditController,
                                              singleSelect: true,
                                              items: productUnit,
                                              chipDecoration: ChipDecoration(
                                                backgroundColor: hexToColor(
                                                  '#E1E1E1',
                                                ),
                                                runSpacing: 2,
                                                spacing: 10,
                                              ),
                                              fieldDecoration: FieldDecoration(
                                                backgroundColor: Colors.white,
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                  vertical: 16,
                                                  horizontal: 12,
                                                ),
                                                hintText:
                                                    'Pilih unit satuan barang',
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
                                          ],
                                        ),
                                      ),
                                    ),
                                    SizedBox(
                                      width: itemWidth.w,
                                      child: _buildTextField(
                                        'Biaya Pengiriman',
                                        'Masukkan total biaya pengiriman',
                                        biaya,
                                        TextInputType.number,
                                        14.sp,
                                      ),
                                    ),
                                    SizedBox(
                                      width: (itemWidth * 2 + 5).w,
                                      child: _buildTextField(
                                        'Alamat',
                                        'Masukkan alamat lengkap',
                                        alamat,
                                        TextInputType.streetAddress,
                                        14.sp,
                                      ),
                                    ),
                                    SizedBox(
                                      width: itemWidth.w,
                                      child: _buildTextField(
                                        'Produk',
                                        'Masukkan nama produk',
                                        produk,
                                        TextInputType.text,
                                        14.sp,
                                      ),
                                    ),
                                    SizedBox(
                                      width: (itemWidth * 3 - 60).w,
                                    ),
                                    ElevatedButton(
                                      onPressed: isLoading
                                          ? () {}
                                          : () async {
                                              setState(() {
                                                isLoading = true;
                                              });
                                              try {
                                                if (editKey.currentState!
                                                    .validate()) {
                                                  await ref
                                                      .read(
                                                        supplierControllerProvider
                                                            .notifier,
                                                      )
                                                      .updateData(
                                                        request: SupplierEntity(
                                                          name: nama.text,
                                                          contact: kontak.text,
                                                          type:
                                                              typeTabletEditController
                                                                  .selectedItems
                                                                  .first
                                                                  .value,
                                                          price: double.parse(
                                                            harga.text,
                                                          ),
                                                          unit:
                                                              unitTabletEditController
                                                                  .selectedItems
                                                                  .first
                                                                  .value,
                                                          shippingFee:
                                                              double.parse(
                                                            biaya.text,
                                                          ),
                                                          address: alamat.text,
                                                          productName:
                                                              produk.text,
                                                          isActive:
                                                              switchStatusForEdit,
                                                        ),
                                                        id: id!,
                                                      );
                                                  closeEditPanel();
                                                }
                                              } catch (e) {
                                                // show snackbar or anything else
                                              } finally {
                                                setState(() {
                                                  isLoading = false;
                                                });
                                              }
                                            },
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: hexToColor('#1F4940'),
                                        shape: const RoundedRectangleBorder(
                                          borderRadius: BorderRadius.all(
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
                                            ? const LinearProgressIndicator(
                                                valueColor:
                                                    AlwaysStoppedAnimation<
                                                        Color>(Colors.white),
                                              )
                                            : const Text(
                                                'Edit',
                                                style: TextStyle(
                                                  color: Colors.white,
                                                  fontWeight: FontWeight.w600,
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
                    padding:
                        EdgeInsets.symmetric(horizontal: 10.w, vertical: 10.h),
                    duration: const Duration(milliseconds: 300),
                    child: Column(
                      children: [
                        AnimatedContainer(
                          height: MediaQuery.of(context).size.height * 0.1,
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
                                    borderRadius: const BorderRadius.all(
                                      Radius.circular(30),
                                    ),
                                  ),
                                  child: Row(
                                    children: [
                                      Flexible(
                                        flex: 2,
                                        child: Padding(
                                          padding: const EdgeInsets.only(
                                            left: 8,
                                          ),
                                          child: TextFormField(
                                            controller: search,
                                            onChanged: (value) {
                                              debounceOnPhone(); // Debounce biar nggak spam API
                                            },
                                            onFieldSubmitted: (value) {
                                              onSearchPhone();
                                            },
                                            style: const TextStyle(
                                              fontSize: 12,
                                            ),
                                            decoration: InputDecoration(
                                              filled: false,
                                              border: InputBorder.none,
                                              hintText: 'Temukan...',
                                              hintStyle: TextStyle(
                                                color: Colors.black
                                                    .withOpacity(0.3),
                                                fontWeight: FontWeight.w400,
                                                fontSize: 12,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                      Flexible(
                                        flex: 3,
                                        child: MultiDropdown<String>(
                                          controller: advSearchPhoneController,
                                          items: advSearchOptions,
                                          onSelectionChange: (selectedItems) {
                                            onSearchPhone();
                                          },
                                          fieldDecoration:
                                              const FieldDecoration(
                                            border: OutlineInputBorder(
                                              borderSide: BorderSide.none,
                                            ),
                                            hintText: '',
                                            suffixIcon: Icon(
                                              Icons.filter_list_alt,
                                            ),
                                            animateSuffixIcon: false,
                                            backgroundColor: Colors.transparent,
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
                                          chipDecoration: ChipDecoration(
                                            wrap: false,
                                            backgroundColor: hexToColor(
                                              '#E1E1E1',
                                            ),
                                            labelStyle: const TextStyle(
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
                                backgroundColor: hexToColor('#1f4940'),
                              ),
                              onPressed: toggleCreatePanel,
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
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                                Expanded(
                                  flex: 5,
                                  child: Center(
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Container(
                                          width: 15,
                                          height: 15,
                                          decoration: BoxDecoration(
                                            color: hexToColor('#47B881'),
                                            shape: BoxShape.circle,
                                          ),
                                        ),
                                        const SizedBox(width: 5),
                                        Container(
                                          width: 15,
                                          height: 15,
                                          decoration: BoxDecoration(
                                            color: hexToColor('#F64C4C'),
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
                          child: supplier.when(
                            data: (data) {
                              return ListView(
                                padding: EdgeInsets.zero,
                                shrinkWrap: true,
                                children: data
                                    .map(
                                      (e) => Container(
                                        margin: EdgeInsets.only(bottom: 7.h),
                                        decoration: BoxDecoration(
                                          border:
                                              Border.all(color: Colors.grey),
                                          borderRadius:
                                              BorderRadius.circular(18),
                                          color: hexToColor('#E1E1E1'),
                                        ),
                                        child: Slidable(
                                          startActionPane: ActionPane(
                                            extentRatio: 0.2,
                                            motion: const BehindMotion(),
                                            children: [
                                              Expanded(
                                                child: SizedBox.expand(
                                                  child: GestureDetector(
                                                    onTap: () {
                                                      openEditPanel(request: e);
                                                    },
                                                    child: Container(
                                                      decoration: BoxDecoration(
                                                        borderRadius:
                                                            const BorderRadius
                                                                .only(
                                                          topLeft:
                                                              Radius.circular(
                                                            18,
                                                          ),
                                                          bottomLeft:
                                                              Radius.circular(
                                                            18,
                                                          ),
                                                        ),
                                                        color: hexToColor(
                                                          '#E1E1E1',
                                                        ),
                                                      ),
                                                      child: ClipOval(
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
                                                                Radius.circular(
                                                                  30,
                                                                ),
                                                              ),
                                                              color: hexToColor(
                                                                '#FFAD0D',
                                                              ),
                                                            ),
                                                            child:
                                                                const Iconify(
                                                              Zondicons
                                                                  .edit_pencil,
                                                              color:
                                                                  Colors.white,
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
                                          endActionPane: ActionPane(
                                            extentRatio: 0.2,
                                            motion: const BehindMotion(),
                                            children: [
                                              Expanded(
                                                child: SizedBox.expand(
                                                  child: GestureDetector(
                                                    onTap: () {
                                                      showConfirmationDialog(
                                                        context: context,
                                                        title:
                                                            'Hapus Supplier?',
                                                        onDelete: isLoading
                                                            ? () {}
                                                            : () async {
                                                                setState(() {
                                                                  isLoading =
                                                                      true;
                                                                });
                                                                try {
                                                                  await ref
                                                                      .read(
                                                                        supplierControllerProvider
                                                                            .notifier,
                                                                      )
                                                                      .deleteData(
                                                                        id: e
                                                                            .id!,
                                                                        deletePermanent:
                                                                            false,
                                                                      );
                                                                } catch (e) {
                                                                  // show snackbar or anything else
                                                                  print(
                                                                    'delete failed : $e',
                                                                  );
                                                                } finally {
                                                                  setState(() {
                                                                    isLoading =
                                                                        false;
                                                                    Navigator
                                                                        .pop(
                                                                      context,
                                                                    );
                                                                    FocusScope
                                                                        .of(
                                                                      context,
                                                                    ).unfocus();
                                                                  });
                                                                }
                                                              },
                                                        onDeletePermanent:
                                                            isLoading
                                                                ? () {}
                                                                : () async {
                                                                    setState(
                                                                        () {
                                                                      isLoading =
                                                                          true;
                                                                    });
                                                                    try {
                                                                      await ref
                                                                          .read(
                                                                            supplierControllerProvider.notifier,
                                                                          )
                                                                          .deleteData(
                                                                            id: e.id!,
                                                                            deletePermanent:
                                                                                true,
                                                                          );
                                                                    } catch (e) {
                                                                      // show snackbar or anything else
                                                                      print(
                                                                        'delete permanent failed: $e',
                                                                      );
                                                                    } finally {
                                                                      setState(
                                                                          () {
                                                                        isLoading =
                                                                            false;
                                                                        Navigator
                                                                            .pop(
                                                                          context,
                                                                        );
                                                                        FocusScope.of(context)
                                                                            .unfocus();
                                                                      });
                                                                    }
                                                                  },
                                                        content:
                                                            'Supplier ini akan terhapus dari halaman ini.',
                                                        isWideScreen: false,
                                                      );
                                                    },
                                                    child: Container(
                                                      decoration: BoxDecoration(
                                                        borderRadius:
                                                            const BorderRadius
                                                                .only(
                                                          topRight:
                                                              Radius.circular(
                                                            18,
                                                          ),
                                                          bottomRight:
                                                              Radius.circular(
                                                            18,
                                                          ),
                                                        ),
                                                        color: hexToColor(
                                                          '#E1E1E1',
                                                        ),
                                                      ),
                                                      child: ClipOval(
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
                                                                Radius.circular(
                                                                  30,
                                                                ),
                                                              ),
                                                              color: hexToColor(
                                                                '#F64C4C',
                                                              ),
                                                            ),
                                                            child:
                                                                const Iconify(
                                                              Eva.trash_fill,
                                                              color:
                                                                  Colors.white,
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
                                                  BorderRadius.circular(18),
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
                                                  flex: 3,
                                                  child: Text(
                                                    e.id!,
                                                    style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.w600,
                                                      color:
                                                          hexToColor('#202224'),
                                                      fontSize: 12,
                                                      overflow:
                                                          TextOverflow.ellipsis,
                                                    ),
                                                  ),
                                                ),
                                                const SizedBox(
                                                  width: 5,
                                                ),
                                                Expanded(
                                                  flex: 5,
                                                  child: Text(
                                                    e.name,
                                                    style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.w600,
                                                      color:
                                                          hexToColor('#202224'),
                                                      fontSize: 12,
                                                      overflow:
                                                          TextOverflow.ellipsis,
                                                    ),
                                                  ),
                                                ),
                                                const SizedBox(
                                                  width: 3,
                                                ),
                                                Expanded(
                                                  flex: 3,
                                                  child: Text(
                                                    e.contact,
                                                    style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.w600,
                                                      color:
                                                          hexToColor('#202224'),
                                                      fontSize: 12,
                                                      overflow:
                                                          TextOverflow.ellipsis,
                                                    ),
                                                  ),
                                                ),
                                                const SizedBox(
                                                  width: 2,
                                                ),
                                                Expanded(
                                                  flex: 5,
                                                  child: Center(
                                                    child: Padding(
                                                      padding:
                                                          EdgeInsets.symmetric(
                                                        horizontal: 5.h,
                                                      ),
                                                      child: TextButton(
                                                        onPressed: () {
                                                          openDetailPanel(
                                                            detailSupplier: e,
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
                                                Expanded(
                                                  flex: 5,
                                                  child: Center(
                                                    child: PhoneSwitchWidget(
                                                      isON: e.isActive!,
                                                      onSwitch: (val) async {
                                                        return ref
                                                            .read(
                                                              supplierControllerProvider
                                                                  .notifier,
                                                            )
                                                            .toggleSupplierStatus(
                                                              request: e,
                                                              id: e.id!,
                                                              currentStatus:
                                                                  e.isActive!,
                                                            );
                                                      },
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ),
                                    )
                                    .toList(),
                              );
                            },
                            error: (error, stackTrace) => Center(
                              child: Text(
                                error.toString() + stackTrace.toString(),
                                textAlign: TextAlign.center,
                              ),
                            ),
                            loading: () => const Center(
                              child: CircularProgressIndicator.adaptive(
                                valueColor:
                                    AlwaysStoppedAnimation<Color>(Colors.black),
                              ),
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
                        'Nama',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w600,
                          fontSize: 12.sp,
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
                            borderRadius: BorderRadius.all(Radius.circular(15)),
                          ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(15)),
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
                          fontWeight: FontWeight.w600,
                          fontSize: 12.sp,
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
                            borderRadius: BorderRadius.all(Radius.circular(15)),
                          ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(15)),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 10.h,
                      ),
                      Text(
                        'Tipe',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w600,
                          fontSize: 12.sp,
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
                        controller: tipe,
                        decoration: const InputDecoration(
                          filled: true,
                          fillColor: Colors.white,
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(15)),
                          ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(15)),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 10.h,
                      ),
                      Text(
                        'Harga',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w600,
                          fontSize: 12.sp,
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
                        controller: harga,
                        decoration: const InputDecoration(
                          filled: true,
                          fillColor: Colors.white,
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(15)),
                          ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(15)),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 10.h,
                      ),
                      Text(
                        'Unit',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w600,
                          fontSize: 12.sp,
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
                        controller: unit,
                        decoration: const InputDecoration(
                          filled: true,
                          fillColor: Colors.white,
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(15)),
                          ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(15)),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 10.h,
                      ),
                      Text(
                        'Biaya Pengiriman',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w600,
                          fontSize: 12.sp,
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
                        controller: biaya,
                        decoration: const InputDecoration(
                          filled: true,
                          fillColor: Colors.white,
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(15)),
                          ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(15)),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 10.h,
                      ),
                      Text(
                        'Alamat',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w600,
                          fontSize: 12.sp,
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
                        maxLines: 3,
                        controller: alamat,
                        decoration: const InputDecoration(
                          filled: true,
                          fillColor: Colors.white,
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(15)),
                          ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(15)),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 10.h,
                      ),
                      Text(
                        'Produk',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w600,
                          fontSize: 12.sp,
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
                        controller: produk,
                        decoration: const InputDecoration(
                          filled: true,
                          fillColor: Colors.white,
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(15)),
                          ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(15)),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 10.h,
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
                              borderRadius:
                                  BorderRadius.all(Radius.circular(50)),
                            ),
                            child: IconButton(
                              padding: const EdgeInsets.all(10),
                              color: hexToColor('#1F4940'),
                              icon: const Icon(Icons.arrow_back),
                              onPressed: toggleCreatePanel,
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
                          autovalidateMode: AutovalidateMode.onUnfocus,
                          key: createKey,
                          child: Column(
                            children: [
                              _buildTextField(
                                'Nama',
                                'Masukkan nama pemilik',
                                nama,
                                TextInputType.name,
                                12.sp,
                              ),
                              _buildTextField(
                                'Kontak',
                                'Masukkan nomor telepon',
                                kontak,
                                TextInputType.phone,
                                12.sp,
                              ),
                              Padding(
                                padding: const EdgeInsets.only(
                                  bottom: 16,
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Tipe',
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.w600,
                                        fontSize: 12.sp,
                                      ),
                                    ),
                                    SizedBox(
                                      height: 5.h,
                                    ),
                                    MultiDropdown(
                                      controller: typePhoneCreateController,
                                      validator: (value) {
                                        if (value == null || value.isEmpty) {
                                          return 'Required Field';
                                        }
                                        return null;
                                      },
                                      singleSelect: true,
                                      items: productType,
                                      chipDecoration: ChipDecoration(
                                        backgroundColor: hexToColor(
                                          '#E1E1E1',
                                        ),
                                        runSpacing: 2,
                                        spacing: 10,
                                      ),
                                      fieldDecoration: FieldDecoration(
                                        backgroundColor: Colors.white,
                                        padding: const EdgeInsets.symmetric(
                                          vertical: 16,
                                          horizontal: 12,
                                        ),
                                        hintText: 'Pilih tipe yang diinginkan',
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
                                  ],
                                ),
                              ),
                              _buildTextField(
                                'Harga',
                                'Masukkan harga',
                                harga,
                                TextInputType.number,
                                12.sp,
                              ),
                              Padding(
                                padding: const EdgeInsets.only(
                                  bottom: 16,
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Unit',
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.w600,
                                        fontSize: 12.sp,
                                      ),
                                    ),
                                    SizedBox(
                                      height: 5.h,
                                    ),
                                    MultiDropdown(
                                      controller: unitPhoneCreateController,
                                      validator: (value) {
                                        if (value == null || value.isEmpty) {
                                          return 'Required Field';
                                        }
                                        return null;
                                      },
                                      singleSelect: true,
                                      items: productUnit,
                                      chipDecoration: ChipDecoration(
                                        backgroundColor: hexToColor(
                                          '#E1E1E1',
                                        ),
                                        runSpacing: 2,
                                        spacing: 10,
                                      ),
                                      fieldDecoration: FieldDecoration(
                                        backgroundColor: Colors.white,
                                        padding: const EdgeInsets.symmetric(
                                          vertical: 16,
                                          horizontal: 12,
                                        ),
                                        hintText: 'Pilih unit satuan barang',
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
                                  ],
                                ),
                              ),
                              _buildTextField(
                                'Biaya Pengiriman',
                                'Masukkan total biaya pengiriman',
                                biaya,
                                TextInputType.number,
                                12.sp,
                              ),
                              _buildTextField(
                                'Alamat',
                                'Masukkan alamat lengkap',
                                alamat,
                                TextInputType.streetAddress,
                                12.sp,
                              ),
                              _buildTextField(
                                'Produk',
                                'Masukkan nama produk',
                                produk,
                                TextInputType.text,
                                12.sp,
                              ),
                              Row(
                                children: [
                                  const Spacer(),
                                  ElevatedButton(
                                    onPressed: isLoading
                                        ? () {}
                                        : () async {
                                            setState(() {
                                              isLoading = true;
                                            });

                                            try {
                                              if (createKey.currentState!
                                                  .validate()) {
                                                await ref
                                                    .read(
                                                      supplierControllerProvider
                                                          .notifier,
                                                    )
                                                    .createNew(
                                                      request: SupplierEntity(
                                                        name: nama.text,
                                                        contact: kontak.text,
                                                        type:
                                                            typePhoneCreateController
                                                                .selectedItems
                                                                .first
                                                                .value,
                                                        price: double.parse(
                                                          harga.text,
                                                        ),
                                                        unit:
                                                            unitPhoneCreateController
                                                                .selectedItems
                                                                .first
                                                                .value,
                                                        shippingFee:
                                                            double.parse(
                                                          biaya.text,
                                                        ),
                                                        address: alamat.text,
                                                        productName:
                                                            produk.text,
                                                        isActive: false,
                                                      ),
                                                    );
                                                closeCreatePanel();
                                              }
                                            } catch (e) {
                                              //show snackbar or anything else
                                            } finally {
                                              setState(() {
                                                isLoading = false;
                                              });
                                            }
                                          },
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: hexToColor('#1F4940'),
                                      shape: const RoundedRectangleBorder(
                                        borderRadius: BorderRadius.all(
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
                                          ? const LinearProgressIndicator(
                                              valueColor:
                                                  AlwaysStoppedAnimation<Color>(
                                                Colors.white,
                                              ),
                                            )
                                          : const Text(
                                              AppStrings.tambahBtn,
                                              style: TextStyle(
                                                color: Colors.white,
                                                fontWeight: FontWeight.w600,
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
                  PositionedDirectionalBackdropBlurWidget(
                    isPanelVisible: isEditPanelVisible,
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
                              onPressed: closeEditPanel,
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
                          key: editKey,
                          autovalidateMode: AutovalidateMode.onUnfocus,
                          child: Column(
                            children: [
                              _buildTextField(
                                'Nama',
                                'Masukkan nama pemilik',
                                nama,
                                TextInputType.name,
                                12.sp,
                              ),
                              _buildTextField(
                                'Kontak',
                                'Masukkan nomor telepon',
                                kontak,
                                TextInputType.phone,
                                12.sp,
                              ),
                              Padding(
                                padding: const EdgeInsets.only(
                                  bottom: 16,
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Tipe',
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.w600,
                                        fontSize: 12.sp,
                                      ),
                                    ),
                                    SizedBox(
                                      height: 5.h,
                                    ),
                                    MultiDropdown(
                                      controller: typePhoneEditController,
                                      validator: (value) {
                                        if (value == null || value.isEmpty) {
                                          return 'Required Field';
                                        }
                                        return null;
                                      },
                                      singleSelect: true,
                                      items: productType,
                                      chipDecoration: ChipDecoration(
                                        backgroundColor: hexToColor(
                                          '#E1E1E1',
                                        ),
                                        runSpacing: 2,
                                        spacing: 10,
                                      ),
                                      fieldDecoration: FieldDecoration(
                                        backgroundColor: Colors.white,
                                        padding: const EdgeInsets.symmetric(
                                          vertical: 16,
                                          horizontal: 12,
                                        ),
                                        hintText: 'Pilih tipe yang diinginkan',
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
                                  ],
                                ),
                              ),
                              _buildTextField(
                                'Harga',
                                'Masukkan harga',
                                harga,
                                TextInputType.number,
                                12.sp,
                              ),
                              Padding(
                                padding: const EdgeInsets.only(
                                  bottom: 16,
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Unit',
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.w600,
                                        fontSize: 12.sp,
                                      ),
                                    ),
                                    SizedBox(
                                      height: 5.h,
                                    ),
                                    MultiDropdown(
                                      controller: unitPhoneEditController,
                                      validator: (value) {
                                        if (value == null || value.isEmpty) {
                                          return 'Required Field';
                                        }
                                        return null;
                                      },
                                      singleSelect: true,
                                      items: productUnit,
                                      chipDecoration: ChipDecoration(
                                        backgroundColor: hexToColor(
                                          '#E1E1E1',
                                        ),
                                        runSpacing: 2,
                                        spacing: 10,
                                      ),
                                      fieldDecoration: FieldDecoration(
                                        backgroundColor: Colors.white,
                                        padding: const EdgeInsets.symmetric(
                                          vertical: 16,
                                          horizontal: 12,
                                        ),
                                        hintText: 'Pilih unit satuan barang',
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
                                  ],
                                ),
                              ),
                              _buildTextField(
                                'Biaya Pengiriman',
                                'Masukkan total biaya pengiriman',
                                biaya,
                                TextInputType.number,
                                12.sp,
                              ),
                              _buildTextField(
                                'Alamat',
                                'Masukkan alamat lengkap',
                                alamat,
                                TextInputType.streetAddress,
                                12.sp,
                              ),
                              _buildTextField(
                                'Produk',
                                'Masukkan nama produk',
                                produk,
                                TextInputType.text,
                                12.sp,
                              ),
                              Row(
                                children: [
                                  const Spacer(),
                                  ElevatedButton(
                                    onPressed: isLoading
                                        ? () {}
                                        : () async {
                                            setState(() {
                                              isLoading = true;
                                            });
                                            try {
                                              if (editKey.currentState!
                                                  .validate()) {
                                                await ref
                                                    .read(
                                                      supplierControllerProvider
                                                          .notifier,
                                                    )
                                                    .updateData(
                                                      request: SupplierEntity(
                                                        name: nama.text,
                                                        contact: kontak.text,
                                                        type:
                                                            typePhoneEditController
                                                                .selectedItems
                                                                .first
                                                                .value,
                                                        price: double.parse(
                                                          harga.text,
                                                        ),
                                                        unit:
                                                            unitPhoneEditController
                                                                .selectedItems
                                                                .first
                                                                .value,
                                                        shippingFee:
                                                            double.parse(
                                                          biaya.text,
                                                        ),
                                                        address: alamat.text,
                                                        productName:
                                                            produk.text,
                                                        isActive:
                                                            switchStatusForEdit,
                                                      ),
                                                      id: id!,
                                                    );
                                                closeEditPanel();
                                              }
                                            } catch (e) {
                                              // show snackbar or anything else
                                            } finally {
                                              setState(() {
                                                isLoading = false;
                                              });
                                            }
                                          },
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: hexToColor('#1F4940'),
                                      shape: const RoundedRectangleBorder(
                                        borderRadius: BorderRadius.all(
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
                                          ? const LinearProgressIndicator(
                                              valueColor:
                                                  AlwaysStoppedAnimation<Color>(
                                                Colors.white,
                                              ),
                                            )
                                          : const Text(
                                              'Edit',
                                              style: TextStyle(
                                                color: Colors.white,
                                                fontWeight: FontWeight.w600,
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
}

Widget _buildTextField(
  String label,
  String hint,
  TextEditingController controller,
  TextInputType keytype,
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
            if (value == null || value.isEmpty) {
              return 'Required Field!';
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
            hintText: hint,
            hintStyle: TextStyle(
              color: Colors.black.withValues(alpha: 0.3),
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

///
FutureVoid showConfirmationDialog({
  required BuildContext context,
  required String title,
  required VoidCallback onDelete,
  required VoidCallback onDeletePermanent,
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
          vertical: isWideScreen
              ? MediaQuery.of(context).size.height * 0.25
              : MediaQuery.of(context).size.height * 0.2,
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
                    FocusScope.of(context).unfocus();
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
                  onPressed: onDelete,
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
                        'Hapus',
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
            const SizedBox(
              height: 10,
            ),
            Material(
              child: ExpansionTile(
                showTrailingIcon: false,
                collapsedBackgroundColor: Colors.white,
                shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(35)),
                ),
                collapsedShape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(35)),
                ),
                backgroundColor: Colors.white,
                childrenPadding: EdgeInsets.symmetric(
                  horizontal: MediaQuery.of(context).size.width * 0.1,
                  vertical: 15,
                ),
                expandedAlignment: Alignment.center,
                title: Center(
                  child: Text(
                    'Hapus Permanen?',
                    style: TextStyle(
                      color: Colors.red,
                      fontWeight: FontWeight.w500,
                      fontSize: isWideScreen ? 14 : 12,
                    ),
                  ),
                ),
                children: [
                  TextButton(
                    onPressed: onDeletePermanent,
                    style: TextButton.styleFrom(
                      elevation: 5,
                      backgroundColor: hexToColor('#A33333'),
                      shape: const RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(Radius.circular(35)),
                      ),
                    ),
                    child: Center(
                      child: Text(
                        'Hapus Permanen',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: isWideScreen ? 18 : 14,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    ),
    context: context,
  );
}
