import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:iconify_flutter/iconify_flutter.dart';
import 'package:iconify_flutter/icons/eva.dart';
import 'package:iconify_flutter/icons/zondicons.dart';
import 'package:intl/intl.dart';
import 'package:multi_dropdown/multi_dropdown.dart';
import 'package:raskop_fe_backoffice/res/assets.dart';
import 'package:raskop_fe_backoffice/res/strings.dart';
import 'package:raskop_fe_backoffice/shared/const.dart';
import 'package:raskop_fe_backoffice/src/menu/presentation/widgets/switch_widget.dart';
import 'package:raskop_fe_backoffice/src/supplier/presentation/widgets/phone_switch_widget.dart';
import 'package:raskop_fe_backoffice/src/supplier/presentation/widgets/positioned_directional_backdrop_blur_widget.dart';

///
class SupplierScreen extends StatefulWidget {
  ///
  const SupplierScreen({super.key});

  ///
  static const String route = 'supplier';

  @override
  State<SupplierScreen> createState() => _SupplierScreenState();
}

class _SupplierScreenState extends State<SupplierScreen> {
  bool isDetailPanelVisible = false;
  bool isCreatePanelVisible = false;
  bool isEditPanelVisible = false;
  TextEditingController nama = TextEditingController();
  TextEditingController kontak = TextEditingController();
  TextEditingController harga = TextEditingController();
  TextEditingController unit = TextEditingController();
  TextEditingController biaya = TextEditingController();
  TextEditingController alamat = TextEditingController();
  TextEditingController produk = TextEditingController();
  List<DropdownItem<String>> advSearchOptions = [
    DropdownItem(label: 'Nama', value: 'reserveBy'),
    DropdownItem(label: 'Kontak', value: 'phoneNumber'),
    DropdownItem(label: 'Nama Produk', value: 'productName'),
    DropdownItem(label: 'Alamat', value: 'address'),
    DropdownItem(label: 'Unit', value: 'unit'),
  ];

  List<DropdownItem<String>> productType = [
    DropdownItem(label: 'Syrup', value: 'Syrup'),
    DropdownItem(label: 'Beans', value: 'Beans'),
  ];

  List<DropdownItem<String>> productUnit = [
    DropdownItem(label: 'KG', value: 'KG'),
    DropdownItem(label: 'Pcs', value: 'pcs'),
    DropdownItem(label: 'Liter', value: 'liter'),
  ];

  final typeTabletCreateController = MultiSelectController<String>();
  final typePhoneCreateController = MultiSelectController<String>();
  final unitTabletCreateController = MultiSelectController<String>();
  final unitPhoneCreateController = MultiSelectController<String>();

  final typeTabletEditController = MultiSelectController<String>();
  final typePhoneEditController = MultiSelectController<String>();
  final unitTabletEditController = MultiSelectController<String>();
  final unitPhoneEditController = MultiSelectController<String>();

  @override
  Widget build(BuildContext context) {
    void toggleDetailPanel() {
      setState(() {
        isDetailPanelVisible = !isDetailPanelVisible;
      });
    }

    void toggleCreatePanel() {
      setState(() {
        isCreatePanelVisible = !isCreatePanelVisible;
      });
    }

    void openEditPanel() {
      setState(() {
        isEditPanelVisible = !isEditPanelVisible;
        nama.value = const TextEditingValue(text: 'Christine Brooks');
        kontak.value = const TextEditingValue(text: '+621234567890');
        harga.value = const TextEditingValue(text: '80000');
        unit.value = const TextEditingValue(text: 'Liter');
        biaya.value = const TextEditingValue(text: '15000');
        alamat.value = const TextEditingValue(
          text: 'Bojongsoang kecamatan suka suka, komplek Anugrah Indah',
        );
        produk.value = const TextEditingValue(text: 'Buah Naga');
        typeTabletEditController.selectWhere((item) => item.label == 'Syrup');
        typePhoneEditController.selectWhere((item) => item.label == 'Syrup');
        unitTabletEditController.selectWhere((item) => item.label == 'Liter');
        unitPhoneEditController.selectWhere((item) => item.label == 'Liter');
      });
    }

    void closeEditPanel() {
      setState(() {
        isEditPanelVisible = !isEditPanelVisible;
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
      });
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
                                  flex: 3,
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
                                  startActionPane: ActionPane(
                                    extentRatio: 0.08,
                                    motion: const BehindMotion(),
                                    children: [
                                      Expanded(
                                        child: SizedBox.expand(
                                          child: GestureDetector(
                                            onTap: openEditPanel,
                                            child: Container(
                                              decoration: BoxDecoration(
                                                borderRadius:
                                                    const BorderRadius.only(
                                                  topLeft: Radius.circular(18),
                                                  bottomLeft:
                                                      Radius.circular(18),
                                                ),
                                                color: hexToColor('#E1E1E1'),
                                              ),
                                              child: ClipOval(
                                                child: Center(
                                                  child: Container(
                                                    width:
                                                        MediaQuery.of(context)
                                                                .size
                                                                .width *
                                                            0.05,
                                                    height:
                                                        MediaQuery.of(context)
                                                                .size
                                                                .width *
                                                            0.05,
                                                    padding:
                                                        const EdgeInsets.all(
                                                      12,
                                                    ),
                                                    decoration: BoxDecoration(
                                                      borderRadius:
                                                          const BorderRadius
                                                              .all(
                                                        Radius.circular(30),
                                                      ),
                                                      color:
                                                          hexToColor('#FFAD0D'),
                                                    ),
                                                    child: const Iconify(
                                                      Zondicons.edit_pencil,
                                                      color: Colors.white,
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
                                            onTap: () {},
                                            child: Container(
                                              decoration: BoxDecoration(
                                                borderRadius:
                                                    const BorderRadius.only(
                                                  topRight: Radius.circular(18),
                                                  bottomRight:
                                                      Radius.circular(18),
                                                ),
                                                color: hexToColor('#E1E1E1'),
                                              ),
                                              child: Center(
                                                child: Container(
                                                  width: MediaQuery.of(context)
                                                          .size
                                                          .width *
                                                      0.05,
                                                  height: MediaQuery.of(context)
                                                          .size
                                                          .width *
                                                      0.05,
                                                  padding:
                                                      const EdgeInsets.all(12),
                                                  decoration: BoxDecoration(
                                                    borderRadius:
                                                        const BorderRadius.all(
                                                      Radius.circular(30),
                                                    ),
                                                    color:
                                                        hexToColor('#F64C4C'),
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
                                      border: Border.all(color: Colors.grey),
                                      borderRadius: BorderRadius.circular(18),
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
                                              color: hexToColor('#202224'),
                                              fontSize: 14,
                                            ),
                                          ),
                                        ),
                                        Expanded(
                                          flex: 3,
                                          child: Text(
                                            'Christine Brooks',
                                            style: TextStyle(
                                              fontWeight: FontWeight.w500,
                                              color: hexToColor('#202224'),
                                              fontSize: 14,
                                            ),
                                          ),
                                        ),
                                        Expanded(
                                          flex: 3,
                                          child: Text(
                                            '+621234567890',
                                            style: TextStyle(
                                              fontWeight: FontWeight.w500,
                                              color: hexToColor('#202224'),
                                              fontSize: 14,
                                            ),
                                          ),
                                        ),
                                        Expanded(
                                          flex: 3,
                                          child: Center(
                                            child: Text(
                                              'BUAH',
                                              style: TextStyle(
                                                fontWeight: FontWeight.w500,
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
                                              NumberFormat.simpleCurrency(
                                                locale: 'id-ID',
                                                name: 'Rp',
                                                decimalDigits: 2,
                                              ).format(80000),
                                              style: TextStyle(
                                                fontWeight: FontWeight.w500,
                                                color: hexToColor('#202224'),
                                                fontSize: 14,
                                              ),
                                            ),
                                          ),
                                        ),
                                        Expanded(
                                          flex: 5,
                                          child: Center(
                                            child: Padding(
                                              padding: EdgeInsets.symmetric(
                                                horizontal: 10.h,
                                              ),
                                              child: TextButton(
                                                onPressed: toggleDetailPanel,
                                                style: TextButton.styleFrom(
                                                  backgroundColor:
                                                      hexToColor('#f6e9e0'),
                                                  minimumSize: const Size(
                                                    double.infinity,
                                                    40,
                                                  ),
                                                ),
                                                child: Text(
                                                  'Lihat',
                                                  style: TextStyle(
                                                    fontWeight: FontWeight.w700,
                                                    color:
                                                        hexToColor('#E38D5D'),
                                                    fontSize: 14,
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                        const Expanded(
                                          flex: 2,
                                          child: Center(
                                            child: CustomSwitch(),
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
                        initialValue: 'Liter',
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
                        initialValue: NumberFormat.simpleCurrency(
                          locale: 'id-ID',
                          name: 'Rp',
                          decimalDigits: 2,
                        ).format(15000),
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
                        initialValue:
                            'Bojongsoang kecamatan suka suka, komplek Anugrah Indah',
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
                        initialValue: 'Buah Naga',
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
                                      onPressed: () {},
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
                                        child: const Text(
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
                                      onPressed: () {},
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
                                        child: const Text(
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
                                          items: advSearchOptions,
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
                                  startActionPane: ActionPane(
                                    extentRatio: 0.2,
                                    motion: const BehindMotion(),
                                    children: [
                                      Expanded(
                                        child: SizedBox.expand(
                                          child: GestureDetector(
                                            onTap: openEditPanel,
                                            child: Container(
                                              decoration: BoxDecoration(
                                                borderRadius:
                                                    const BorderRadius.only(
                                                  topLeft: Radius.circular(18),
                                                  bottomLeft:
                                                      Radius.circular(18),
                                                ),
                                                color: hexToColor('#E1E1E1'),
                                              ),
                                              child: ClipOval(
                                                child: Center(
                                                  child: Container(
                                                    padding:
                                                        EdgeInsets.symmetric(
                                                      horizontal: 8.w,
                                                      vertical: 8.h,
                                                    ),
                                                    margin:
                                                        EdgeInsets.symmetric(
                                                      horizontal: 10.w,
                                                      vertical: 8.h,
                                                    ),
                                                    decoration: BoxDecoration(
                                                      borderRadius:
                                                          const BorderRadius
                                                              .all(
                                                        Radius.circular(30),
                                                      ),
                                                      color:
                                                          hexToColor('#FFAD0D'),
                                                    ),
                                                    child: const Iconify(
                                                      Zondicons.edit_pencil,
                                                      color: Colors.white,
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
                                            onTap: () {},
                                            child: Container(
                                              decoration: BoxDecoration(
                                                borderRadius:
                                                    const BorderRadius.only(
                                                  topRight: Radius.circular(18),
                                                  bottomRight:
                                                      Radius.circular(18),
                                                ),
                                                color: hexToColor('#E1E1E1'),
                                              ),
                                              child: ClipOval(
                                                child: Center(
                                                  child: Container(
                                                    padding:
                                                        EdgeInsets.symmetric(
                                                      horizontal: 8.w,
                                                      vertical: 8.h,
                                                    ),
                                                    margin:
                                                        EdgeInsets.symmetric(
                                                      horizontal: 10.w,
                                                      vertical: 8.h,
                                                    ),
                                                    decoration: BoxDecoration(
                                                      borderRadius:
                                                          const BorderRadius
                                                              .all(
                                                        Radius.circular(30),
                                                      ),
                                                      color:
                                                          hexToColor('#F64C4C'),
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
                                      ),
                                    ],
                                  ),
                                  child: Container(
                                    decoration: BoxDecoration(
                                      border: Border.all(color: Colors.grey),
                                      borderRadius: BorderRadius.circular(18),
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
                                          flex: 3,
                                          child: Text(
                                            '00001',
                                            style: TextStyle(
                                              fontWeight: FontWeight.w600,
                                              color: hexToColor('#202224'),
                                              fontSize: 12,
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                          ),
                                        ),
                                        Expanded(
                                          flex: 5,
                                          child: Text(
                                            'Christine Brooks',
                                            style: TextStyle(
                                              fontWeight: FontWeight.w600,
                                              color: hexToColor('#202224'),
                                              fontSize: 12,
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                          ),
                                        ),
                                        Expanded(
                                          flex: 3,
                                          child: Text(
                                            '+621234567890',
                                            style: TextStyle(
                                              fontWeight: FontWeight.w600,
                                              color: hexToColor('#202224'),
                                              fontSize: 12,
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                          ),
                                        ),
                                        Expanded(
                                          flex: 5,
                                          child: Center(
                                            child: Padding(
                                              padding: EdgeInsets.symmetric(
                                                horizontal: 5.h,
                                              ),
                                              child: TextButton(
                                                onPressed: toggleDetailPanel,
                                                style: TextButton.styleFrom(
                                                  backgroundColor:
                                                      hexToColor('#f6e9e0'),
                                                  minimumSize: const Size(
                                                    double.infinity,
                                                    40,
                                                  ),
                                                ),
                                                child: Text(
                                                  'Lihat',
                                                  style: TextStyle(
                                                    fontWeight: FontWeight.w700,
                                                    color:
                                                        hexToColor('#E38D5D'),
                                                    fontSize: 12,
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                        const Expanded(
                                          flex: 5,
                                          child: Center(
                                            child: PhoneSwitchWidget(),
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
                        initialValue: 'Christine Brooks',
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
                        initialValue: '+6281234567890',
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
                        initialValue: 'Buah',
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
                        initialValue: NumberFormat.simpleCurrency(
                          locale: 'id-ID',
                          name: 'Rp',
                          decimalDigits: 2,
                        ).format(80000),
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
                        initialValue: 'Liter',
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
                        initialValue: NumberFormat.simpleCurrency(
                          locale: 'id-ID',
                          name: 'Rp',
                          decimalDigits: 2,
                        ).format(15000),
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
                        initialValue:
                            'Bojongsoang kecamatan suka suka, komplek Anugrah Indah',
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
                        initialValue: 'Buah Naga',
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
                                    onPressed: () {},
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
                                      child: const Text(
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
                                    onPressed: () {},
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
                                      child: const Text(
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
