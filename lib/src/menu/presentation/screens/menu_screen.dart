import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:go_router/go_router.dart';
import 'package:iconify_flutter/iconify_flutter.dart';
import 'package:iconify_flutter/icons/eva.dart';
import 'package:iconify_flutter/icons/zondicons.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:multi_dropdown/multi_dropdown.dart';
import 'package:raskop_fe_backoffice/res/assets.dart';
import 'package:raskop_fe_backoffice/res/paths.dart';
import 'package:raskop_fe_backoffice/res/strings.dart';
import 'package:raskop_fe_backoffice/shared/const.dart';
import 'package:raskop_fe_backoffice/shared/currency_formatter.dart';
import 'package:raskop_fe_backoffice/shared/refresh_loading_animation.dart';
import 'package:raskop_fe_backoffice/shared/toast.dart';
import 'package:raskop_fe_backoffice/src/common/failure/response_failure.dart';
import 'package:raskop_fe_backoffice/src/common/widgets/custom_loading_indicator_widget.dart';
import 'package:raskop_fe_backoffice/src/menu/application/menu_controller.dart';
import 'package:raskop_fe_backoffice/src/menu/domain/entities/menu_entity.dart';
import 'package:raskop_fe_backoffice/src/supplier/presentation/screens/supplier_screen.dart';
import 'package:raskop_fe_backoffice/src/supplier/presentation/widgets/phone_switch_widget.dart';
import 'package:raskop_fe_backoffice/src/supplier/presentation/widgets/positioned_directional_backdrop_blur_widget.dart';
import 'package:raskop_fe_backoffice/src/supplier/presentation/widgets/switch_widget.dart';

///
class MenuScreen extends ConsumerStatefulWidget {
  ///
  const MenuScreen({super.key});

  ///
  static const String route = 'menu';

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _MenuScreenState();
}

class _MenuScreenState extends ConsumerState<MenuScreen>
    with SingleTickerProviderStateMixin {
  AsyncValue<List<MenuEntity>> get menu => ref.watch(menuControllerProvider);

  MenuEntity detailMenu = const MenuEntity(
    id: '',
    name: '',
    category: '',
    description: '',
    imageUri: '',
    price: 0,
    qty: 0,
    isActive: false,
  );

  final createKey = GlobalKey<FormState>();
  final editKey = GlobalKey<FormState>();

  bool isDetailPanelVisible = false;
  bool isCreatePanelVisible = false;
  bool isEditPanelVisible = false;
  TextEditingController nama = TextEditingController();
  TextEditingController kategori = TextEditingController();
  TextEditingController harga = TextEditingController();
  TextEditingController jumlah = TextEditingController();
  TextEditingController deskripsi = TextEditingController();
  TextEditingController search = TextEditingController();

  String? imageUri;
  String? imageFile;
  double price = 0;
  String? id;
  bool? switchStatusForEdit;

  List<DropdownItem<String>> advSearchOptions = [
    DropdownItem(label: 'Nama', value: 'name'),
    DropdownItem(label: 'Kategori', value: 'category'),
    DropdownItem(label: 'Harga', value: 'price'),
  ];

  final advSearchTabletController = MultiSelectController<String>();
  final advSearchPhoneController = MultiSelectController<String>();

  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    void openDetailPanel({required MenuEntity detailMenu}) {
      setState(() {
        nama.value = TextEditingValue(text: detailMenu.name);
        kategori.value = TextEditingValue(text: detailMenu.category);
        deskripsi.value = TextEditingValue(text: detailMenu.description);
        harga.value = TextEditingValue(
          text: NumberFormat.simpleCurrency(
            locale: 'id-ID',
            name: 'Rp',
            decimalDigits: 2,
          ).format(detailMenu.price),
        );
        jumlah.value = TextEditingValue(text: detailMenu.qty.toString());
        isDetailPanelVisible = true;
        imageUri = detailMenu.imageUri;
      });
    }

    void closeDetailPanel() {
      setState(() {
        nama.clear();
        harga.clear();
        kategori.clear();
        jumlah.clear();
        deskripsi.clear();
        isDetailPanelVisible = false;
        imageUri = null;
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
        harga.clear();
        kategori.clear();
        jumlah.clear();
        deskripsi.clear();
        isCreatePanelVisible = false;
        FocusScope.of(context).unfocus();
      });

      if (imageFile != null) {
        final file = File(imageFile!);
        if (file.existsSync()) {
          try {
            file.deleteSync();
          } catch (e) {
            print('Error deleting file: $e');
          }
        }
        imageFile = null;
      }
    }

    void openEditPanel({required MenuEntity request}) {
      setState(() {
        isEditPanelVisible = !isEditPanelVisible;
        nama.value = TextEditingValue(text: request.name);
        harga.value = TextEditingValue(text: request.price.toString());
        kategori.value = TextEditingValue(text: request.category);
        jumlah.value = TextEditingValue(text: request.qty.toString());
        deskripsi.value = TextEditingValue(text: request.description);
        id = request.id;
        switchStatusForEdit = request.isActive;
        imageUri = request.imageUri;
      });
    }

    void closeEditPanel() {
      setState(() {
        isEditPanelVisible = !isEditPanelVisible;
        nama.clear();
        harga.clear();
        kategori.clear();
        jumlah.clear();
        deskripsi.clear();
        id = null;
        switchStatusForEdit = null;
        FocusScope.of(context).unfocus();

        if (imageFile != null) {
          final file = File(imageFile!);
          if (file.existsSync()) {
            try {
              file.deleteSync();
            } catch (e) {
              print('Error deleting file: $e');
            }
          }
          imageFile = null;
        }
      });
    }

    void onSearchPhone() {
      ref.read(menuControllerProvider.notifier).onSearch(
        advSearch: {
          for (final item in advSearchPhoneController.selectedItems)
            if (item.value == 'price' && search.text.isNotEmpty) ...{
              item.value: double.parse(search.text),
            } else
              item.value: search.text,
          'withDeleted': false,
        },
      );
    }

    void onSearchTablet() {
      ref.read(menuControllerProvider.notifier).onSearch(
        advSearch: {
          for (final item in advSearchTabletController.selectedItems)
            if (item.value == 'price' && search.text.isNotEmpty) ...{
              item.value: double.parse(search.text),
            } else
              item.value: search.text,
          'withDeleted': false,
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

    String getFileName(String? uri) {
      if (uri == null) return 'Unknown.jpg';
      return uri.split('/').last;
    }

    Future<void> pickImage() async {
      final ImagePicker _picker = ImagePicker();
      final XFile? image = await _picker.pickImage(
        source: ImageSource.gallery,
        imageQuality: 50,
      );
      if (image != null) {
        setState(() {
          imageFile = image.path;
        });
      }
    }

    final controller = ref.watch(menuControllerProvider.notifier);

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
                        RefreshLoadingAnimation(
                          provider: ref.watch(menuControllerProvider),
                          onRefresh: () async => controller.refresh(),
                          children: [
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
                                        onChanged: advSearchTabletController
                                                .selectedItems.isEmpty
                                            ? (value) {}
                                            : (value) {
                                                debounceOnTablet();
                                              },
                                        onFieldSubmitted:
                                            advSearchTabletController
                                                    .selectedItems.isEmpty
                                                ? (value) {}
                                                : (value) {
                                                    onSearchTablet();
                                                  },
                                        decoration: InputDecoration(
                                          filled: false,
                                          border: InputBorder.none,
                                          hintText: 'Temukan nama, menu...',
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
                                          setState(() {});
                                        },
                                        fieldDecoration: const FieldDecoration(
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
                          ],
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            const Text(
                              'Petunjuk: Ketuk logo dua kali untuk menyegarkan halaman*\nPetunjuk: Geser ke kiri/kanan item untuk melihat tombol hapus/edit*',
                              style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            const Spacer(),
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
                                  flex: 4,
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
                                    'KATEGORI',
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
                                    'HARGA',
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
                                      'STOK',
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
                                      'DETAIL MENU',
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
                          child: menu.when(
                            data: (data) {
                              return ListView(
                                physics: const AlwaysScrollableScrollPhysics(),
                                controller: controller.controller,
                                padding: EdgeInsets.zero,
                                shrinkWrap: true,
                                children: [
                                  for (final e in data)
                                    Container(
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
                                                          child: const Iconify(
                                                            Zondicons
                                                                .edit_pencil,
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
                                                  onTap: () {
                                                    showConfirmationDialog(
                                                      context: context,
                                                      title: 'Hapus Menu?',
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
                                                                      menuControllerProvider
                                                                          .notifier,
                                                                    )
                                                                    .deleteData(
                                                                      id: e.id!,
                                                                      deletePermanent:
                                                                          false,
                                                                    );
                                                                setState(() {
                                                                  Toast()
                                                                      .showSuccessToast(
                                                                    context:
                                                                        context,
                                                                    title:
                                                                        'Delete Menu Success',
                                                                    description:
                                                                        'Successfully Delete Menu!',
                                                                  );
                                                                });
                                                              } on ResponseFailure catch (e) {
                                                                final err = e
                                                                        .allError
                                                                    as Map<
                                                                        String,
                                                                        dynamic>;
                                                                setState(() {
                                                                  Toast()
                                                                      .showErrorToast(
                                                                    context:
                                                                        context,
                                                                    title:
                                                                        'Delete Menu Failed',
                                                                    description:
                                                                        '${err['name']} - ${err['message']}',
                                                                  );
                                                                });
                                                              } finally {
                                                                setState(() {
                                                                  isLoading =
                                                                      false;
                                                                  context.pop();
                                                                  FocusScope.of(
                                                                    context,
                                                                  ).unfocus();
                                                                });
                                                              }
                                                            },
                                                      content:
                                                          'Menu ini akan terhapus dari halaman ini.',
                                                      isWideScreen: true,
                                                      isLoading: isLoading,
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
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Expanded(
                                                flex: 2,
                                                child: Text(
                                                  e.id!,
                                                  maxLines: 1,
                                                  style: TextStyle(
                                                    fontWeight: FontWeight.w500,
                                                    color:
                                                        hexToColor('#202224'),
                                                    fontSize: 14,
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                  ),
                                                ),
                                              ),
                                              Expanded(
                                                flex: 4,
                                                child: Text(
                                                  e.name,
                                                  maxLines: 2,
                                                  style: TextStyle(
                                                    fontWeight: FontWeight.w500,
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
                                                  e.category,
                                                  maxLines: 2,
                                                  style: TextStyle(
                                                    fontWeight: FontWeight.w500,
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
                                                  NumberFormat.simpleCurrency(
                                                    locale: 'id-ID',
                                                    name: 'Rp',
                                                    decimalDigits: 2,
                                                  ).format(e.price),
                                                  maxLines: 2,
                                                  style: TextStyle(
                                                    fontWeight: FontWeight.w500,
                                                    color:
                                                        hexToColor('#202224'),
                                                    fontSize: 14,
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                  ),
                                                ),
                                              ),
                                              Expanded(
                                                flex: 2,
                                                child: Center(
                                                  child: Text(
                                                    e.qty.toString(),
                                                    maxLines: 2,
                                                    style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.w500,
                                                      color: hexToColor(
                                                        '#202224',
                                                      ),
                                                      fontSize: 14,
                                                      overflow:
                                                          TextOverflow.ellipsis,
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
                                                          detailMenu:
                                                              MenuEntity(
                                                            id: e.id,
                                                            name: e.name,
                                                            price: e.price,
                                                            category:
                                                                e.category,
                                                            qty: e.qty,
                                                            description:
                                                                e.description,
                                                            imageUri:
                                                                e.imageUri,
                                                            isActive:
                                                                e.isActive,
                                                          ),
                                                        );
                                                      },
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
                                              Expanded(
                                                flex: 3,
                                                child: Center(
                                                  child: CustomSwitch(
                                                    isON: e.isActive!,
                                                    onSwitch: (val) {
                                                      return ref
                                                          .read(
                                                            menuControllerProvider
                                                                .notifier,
                                                          )
                                                          .toggleMenuStatus(
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
                                      onPressed: controller.refresh,
                                      style: TextButton.styleFrom(
                                        backgroundColor: hexToColor('#1F4940'),
                                        shape: RoundedRectangleBorder(
                                          side: BorderSide(
                                            color: hexToColor('#E1E1E1'),
                                          ),
                                          borderRadius: const BorderRadius.all(
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
                          ),
                        ),
                      ],
                    ),
                  ),
                  PositionedDirectionalBackdropBlurWidget(
                    isPanelVisible: isDetailPanelVisible,
                    end: -MediaQuery.of(context).size.width * 0.4,
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
                      SizedBox(
                        height: 320,
                        child: Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(16),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.grey.withOpacity(0.2),
                                spreadRadius: 2,
                                blurRadius: 5,
                                offset: const Offset(0, 3),
                              ),
                            ],
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Expanded(
                                child: Container(
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(16),
                                    border: Border.all(
                                      color: Colors.grey.withOpacity(0.5),
                                      width: 1,
                                    ),
                                  ),
                                  clipBehavior: Clip.hardEdge,
                                  child: imageUri == null
                                      ? const Center(
                                          child: Text('Gambar Belum Diunggah'),
                                        )
                                      : Image.network(
                                          'https://${BasePaths.baseAPIURL}/${imageUri}',
                                          fit: BoxFit
                                              .cover, // Menggunakan BoxFit.cover
                                          loadingBuilder: (
                                            BuildContext context,
                                            Widget child,
                                            ImageChunkEvent? loadingProgress,
                                          ) {
                                            if (loadingProgress == null)
                                              return child;
                                            return Center(
                                              child: CircularProgressIndicator(
                                                value: loadingProgress
                                                            .expectedTotalBytes !=
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
                                            return const Center(
                                              child: Text(
                                                'Failed to load image',
                                              ),
                                            );
                                          },
                                        ),
                                ),
                              ),
                              SizedBox(height: 8.h),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Expanded(
                                    child: Text(
                                      getFileName(imageUri),
                                      maxLines: 1,
                                      style: const TextStyle(
                                        fontFamily: 'Inter',
                                        fontWeight: FontWeight.w500,
                                        fontSize: 14,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 10.h,
                      ),
                      Text(
                        'Deskripsi',
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
                        controller: deskripsi,
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
                    width: MediaQuery.of(context).size.width * 0.4,
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
                            return IntrinsicHeight(
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.stretch,
                                children: [
                                  // Form Section
                                  Expanded(
                                    flex: 3,
                                    child: Form(
                                      key: createKey,
                                      child: SingleChildScrollView(
                                        child: Wrap(
                                          spacing: 10,
                                          children: [
                                            SizedBox(
                                              width: itemWidth.w - 8,
                                              child: _buildTextField(
                                                'Nama',
                                                'Masukkan nama menu',
                                                nama,
                                                TextInputType.name,
                                                16,
                                              ),
                                            ),
                                            SizedBox(
                                              width: itemWidth.w - 8,
                                              child: _buildTextField(
                                                'Kategori',
                                                'Masukkan kategori',
                                                kategori,
                                                TextInputType.text,
                                                16,
                                              ),
                                            ),
                                            SizedBox(
                                              width: itemWidth.w - 8,
                                              child: _buildTextField(
                                                'Harga',
                                                'Masukkan harga',
                                                harga,
                                                TextInputType.number,
                                                16,
                                              ),
                                            ),
                                            SizedBox(
                                              width: itemWidth.w - 8,
                                              child: _buildTextField(
                                                'Stok',
                                                'Masukkan jumlah stok saat ini',
                                                jumlah,
                                                TextInputType.number,
                                                16,
                                              ),
                                            ),
                                            SizedBox(
                                              width: (itemWidth * 2 + 5).w - 16,
                                              child: _buildTextField(
                                                'Deskripsi',
                                                'Masukkan deskripsi ',
                                                deskripsi,
                                                TextInputType.text,
                                                16,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                  // Image Section
                                  Expanded(
                                    flex: 2,
                                    child: Container(
                                      padding: const EdgeInsets.all(12),
                                      decoration: BoxDecoration(
                                        color: Colors.white,
                                        borderRadius: BorderRadius.circular(16),
                                        boxShadow: [
                                          BoxShadow(
                                            color: Colors.grey.withOpacity(0.2),
                                            spreadRadius: 2,
                                            blurRadius: 5,
                                            offset: const Offset(0, 3),
                                          ),
                                        ],
                                      ),
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Expanded(
                                            child: Container(
                                              decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(16),
                                                border: Border.all(
                                                  color: Colors.grey
                                                      .withOpacity(0.5),
                                                  width: 1,
                                                ),
                                              ),
                                              clipBehavior: Clip.hardEdge,
                                              child: imageFile == null
                                                  ? const Center(
                                                      child: Text(
                                                        'Gambar Belum Diunggah',
                                                      ),
                                                    )
                                                  : FutureBuilder<File>(
                                                      future: Future.value(
                                                        File(imageFile!),
                                                      ),
                                                      builder:
                                                          (context, snapshot) {
                                                        if (snapshot
                                                                .connectionState ==
                                                            ConnectionState
                                                                .waiting) {
                                                          return const Center(
                                                            child:
                                                                CircularProgressIndicator(),
                                                          ); // Tampilkan indikator pemuatan
                                                        } else if (snapshot
                                                            .hasError) {
                                                          return const Center(
                                                            child: Text(
                                                              'Failed to load image',
                                                            ),
                                                          ); // Tampilkan pesan kesalahan
                                                        } else {
                                                          return Image.file(
                                                            snapshot.data!,
                                                            fit: BoxFit.cover,
                                                          );
                                                        }
                                                      },
                                                    ),
                                            ),
                                          ),
                                          SizedBox(height: 4.h),
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Expanded(
                                                child: Text(
                                                  imageFile != null
                                                      ? getFileName(imageFile)
                                                      : 'Unknown.jpg',
                                                  style: const TextStyle(
                                                    fontFamily: 'Inter',
                                                    fontWeight: FontWeight.w500,
                                                    fontSize: 14,
                                                  ),
                                                ),
                                              ),
                                              SizedBox(
                                                width: 32,
                                                height: 32,
                                                child: IconButton(
                                                  onPressed: pickImage,
                                                  icon: Icon(
                                                    Icons.file_upload_outlined,
                                                    color:
                                                        hexToColor('#1F4940'),
                                                    size: 32,
                                                  ),
                                                  padding: EdgeInsets.zero,
                                                  constraints:
                                                      const BoxConstraints(),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            );
                          },
                        ),
                      ),
                      Align(
                        alignment: Alignment.centerRight,
                        child: Padding(
                          padding: const EdgeInsets.only(top: 0, right: 16.0),
                          child: ElevatedButton(
                            onPressed: isLoading
                                ? () {}
                                : () async {
                                    setState(() {
                                      isLoading = true;
                                    });

                                    try {
                                      if (createKey.currentState!.validate()) {
                                        await ref
                                            .read(
                                              menuControllerProvider.notifier,
                                            )
                                            .createNew(
                                              request: MenuEntity(
                                                name: nama.text,
                                                price: double.parse(
                                                  harga.text,
                                                ),
                                                qty: int.parse(
                                                  jumlah.text,
                                                ),
                                                category: kategori.text,
                                                description: deskripsi.text,
                                                isActive: false,
                                              ),
                                              imageFile: imageFile,
                                            );
                                        setState(() {
                                          Toast().showSuccessToast(
                                            context: context,
                                            title: 'Create Menu Success',
                                            description:
                                                'Successfully Created New Menu!',
                                          );
                                        });
                                        closeCreatePanel();
                                      }
                                    } on ResponseFailure catch (e) {
                                      final err =
                                          e.allError as Map<String, dynamic>;
                                      setState(() {
                                        Toast().showErrorToast(
                                          context: context,
                                          title: 'Create Menu Failed',
                                          description:
                                              '${err['name']} - ${err['message']}',
                                        );
                                      });
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
                                  ? const CustomLoadingIndicator(
                                      color: Colors.white,
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
                            return IntrinsicHeight(
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.stretch,
                                children: [
                                  // Form Section
                                  Expanded(
                                    flex: 3,
                                    child: Form(
                                      key: editKey,
                                      child: SingleChildScrollView(
                                        child: Wrap(
                                          spacing: 10,
                                          children: [
                                            SizedBox(
                                              width: itemWidth.w - 8,
                                              child: _buildTextField(
                                                'Nama',
                                                'Masukkan nama menu',
                                                nama,
                                                TextInputType.name,
                                                16,
                                              ),
                                            ),
                                            SizedBox(
                                              width: itemWidth.w - 8,
                                              child: _buildTextField(
                                                'Kategori',
                                                'Masukkan kategori',
                                                kategori,
                                                TextInputType.text,
                                                16,
                                              ),
                                            ),
                                            SizedBox(
                                              width: itemWidth.w - 8,
                                              child: _buildTextField(
                                                'Harga',
                                                'Masukkan harga',
                                                harga,
                                                TextInputType.number,
                                                16,
                                              ),
                                            ),
                                            SizedBox(
                                              width: itemWidth.w - 8,
                                              child: _buildTextField(
                                                'Stok',
                                                'Masukkan jumlah stok saat ini',
                                                jumlah,
                                                TextInputType.number,
                                                16,
                                              ),
                                            ),
                                            SizedBox(
                                              width: (itemWidth * 2 + 5).w - 16,
                                              child: _buildTextField(
                                                'Deskripsi',
                                                'Masukkan deskripsi menu',
                                                deskripsi,
                                                TextInputType.text,
                                                16,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                  // Image Section
                                  Expanded(
                                    flex: 2,
                                    child: Container(
                                      padding: const EdgeInsets.all(12),
                                      decoration: BoxDecoration(
                                        color: Colors.white,
                                        borderRadius: BorderRadius.circular(16),
                                        boxShadow: [
                                          BoxShadow(
                                            color: Colors.grey.withOpacity(0.2),
                                            spreadRadius: 2,
                                            blurRadius: 5,
                                            offset: const Offset(0, 3),
                                          ),
                                        ],
                                      ),
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Expanded(
                                            child: Container(
                                              decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(16),
                                                border: Border.all(
                                                  color: Colors.grey
                                                      .withOpacity(0.5),
                                                  width: 1,
                                                ),
                                              ),
                                              clipBehavior: Clip.hardEdge,
                                              child: imageFile != null
                                                  ? FutureBuilder<File>(
                                                      future: Future.value(
                                                        File(imageFile!),
                                                      ),
                                                      builder:
                                                          (context, snapshot) {
                                                        if (snapshot
                                                                .connectionState ==
                                                            ConnectionState
                                                                .waiting) {
                                                          return const Center(
                                                            child:
                                                                CircularProgressIndicator(),
                                                          ); // Tampilkan indikator pemuatan
                                                        } else if (snapshot
                                                            .hasError) {
                                                          return const Center(
                                                            child: Text(
                                                              'Failed to load image',
                                                            ),
                                                          ); // Tampilkan pesan kesalahan
                                                        } else {
                                                          return Image.file(
                                                            snapshot.data!,
                                                            fit: BoxFit.cover,
                                                          );
                                                        }
                                                      },
                                                    )
                                                  : imageUri != null
                                                      ? Image.network(
                                                          'https://${BasePaths.baseAPIURL}/$imageUri',
                                                          fit: BoxFit
                                                              .cover, // Menggunakan BoxFit.cover
                                                          loadingBuilder: (
                                                            BuildContext
                                                                context,
                                                            Widget child,
                                                            ImageChunkEvent?
                                                                loadingProgress,
                                                          ) {
                                                            if (loadingProgress ==
                                                                null)
                                                              return child;
                                                            return Center(
                                                              child:
                                                                  CircularProgressIndicator(
                                                                value: loadingProgress
                                                                            .expectedTotalBytes !=
                                                                        null
                                                                    ? loadingProgress
                                                                            .cumulativeBytesLoaded /
                                                                        (loadingProgress.expectedTotalBytes ??
                                                                            1)
                                                                    : null,
                                                              ),
                                                            );
                                                          },
                                                          errorBuilder: (
                                                            BuildContext
                                                                context,
                                                            Object error,
                                                            StackTrace?
                                                                stackTrace,
                                                          ) {
                                                            return const Center(
                                                              child: Text(
                                                                'Failed to load image',
                                                              ),
                                                            );
                                                          },
                                                        )
                                                      : const Center(
                                                          child: Text(
                                                            'Gambar Belum Diunggah',
                                                          ),
                                                        ),
                                            ),
                                          ),
                                          SizedBox(height: 4.h),
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Expanded(
                                                child: Text(
                                                  imageFile != null
                                                      ? getFileName(imageFile)
                                                      : imageUri != null
                                                          ? getFileName(
                                                              imageUri,
                                                            )
                                                          : "Unknown.jpg",
                                                  maxLines: 1,
                                                  style: const TextStyle(
                                                    fontFamily: 'Inter',
                                                    fontWeight: FontWeight.w500,
                                                    fontSize: 14,
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                  ),
                                                ),
                                              ),
                                              SizedBox(
                                                width: 32,
                                                height: 32,
                                                child: IconButton(
                                                  onPressed: pickImage,
                                                  icon: Icon(
                                                    Icons.file_upload_outlined,
                                                    color:
                                                        hexToColor('#1F4940'),
                                                    size: 32,
                                                  ),
                                                  padding: EdgeInsets.zero,
                                                  constraints:
                                                      const BoxConstraints(),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            );
                          },
                        ),
                      ),
                      Align(
                        alignment: Alignment.centerRight,
                        child: Padding(
                          padding: const EdgeInsets.only(top: 0, right: 16.0),
                          child: ElevatedButton(
                            onPressed: isLoading
                                ? () {}
                                : () async {
                                    setState(() {
                                      isLoading = true;
                                    });
                                    try {
                                      if (editKey.currentState!.validate()) {
                                        await ref
                                            .read(
                                              menuControllerProvider.notifier,
                                            )
                                            .updateData(
                                              request: MenuEntity(
                                                name: nama.text,
                                                price: double.parse(
                                                  harga.text,
                                                ),
                                                qty: int.parse(
                                                  jumlah.text,
                                                ),
                                                category: kategori.text,
                                                description: deskripsi.text,
                                                isActive: switchStatusForEdit,
                                              ),
                                              id: id!,
                                              imageFile: imageFile,
                                            );
                                        setState(() {
                                          Toast().showSuccessToast(
                                            context: context,
                                            title: 'Edit Menu Success',
                                            description:
                                                'Successfully Edit Menu!',
                                          );
                                        });
                                        closeEditPanel();
                                      }
                                    } on ResponseFailure catch (e) {
                                      final err =
                                          e.allError as Map<String, dynamic>;
                                      setState(() {
                                        Toast().showErrorToast(
                                          context: context,
                                          title: 'Edit Menu Failed',
                                          description:
                                              '${err['name']} - ${err['message']}',
                                        );
                                      });
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
                                  ? const CustomLoadingIndicator(
                                      color: Colors.white,
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
                                            onChanged: advSearchPhoneController
                                                    .selectedItems.isEmpty
                                                ? (value) {}
                                                : (value) {
                                                    debounceOnPhone();
                                                  },
                                            onFieldSubmitted:
                                                advSearchPhoneController
                                                        .selectedItems.isEmpty
                                                    ? (value) {}
                                                    : (value) {
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
                                            setState(() {});
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
                                  flex: 4,
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
                                  flex: 4,
                                  child: Text(
                                    'Kategori',
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
                          child: menu.when(
                            data: (data) {
                              return ListView(
                                physics: const AlwaysScrollableScrollPhysics(),
                                controller: controller.controller,
                                padding: EdgeInsets.zero,
                                shrinkWrap: true,
                                children: [
                                  for (final e in data)
                                    Container(
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
                                                          child: const Iconify(
                                                            Zondicons
                                                                .edit_pencil,
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
                                                  onTap: () {
                                                    showConfirmationDialog(
                                                      context: context,
                                                      title: 'Hapus Menu?',
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
                                                                      menuControllerProvider
                                                                          .notifier,
                                                                    )
                                                                    .deleteData(
                                                                      id: e.id!,
                                                                      deletePermanent:
                                                                          false,
                                                                    );
                                                                setState(() {
                                                                  Toast()
                                                                      .showSuccessToast(
                                                                    context:
                                                                        context,
                                                                    title:
                                                                        'Delete Menu Success',
                                                                    description:
                                                                        'Successfully Delete Menu!',
                                                                  );
                                                                });
                                                              } on ResponseFailure catch (e) {
                                                                final err = e
                                                                        .allError
                                                                    as Map<
                                                                        String,
                                                                        dynamic>;
                                                                setState(() {
                                                                  Toast()
                                                                      .showErrorToast(
                                                                    context:
                                                                        context,
                                                                    title:
                                                                        'Delete Menu Failed',
                                                                    description:
                                                                        '${err['name']} - ${err['message']}',
                                                                  );
                                                                });
                                                              } finally {
                                                                setState(() {
                                                                  isLoading =
                                                                      false;
                                                                  context.pop();
                                                                  FocusScope.of(
                                                                    context,
                                                                  ).unfocus();
                                                                });
                                                              }
                                                            },
                                                      content:
                                                          'Menu ini akan terhapus dari halaman ini.',
                                                      isWideScreen: false,
                                                      isLoading: isLoading,
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
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Expanded(
                                                flex: 3,
                                                child: Text(
                                                  e.id!,
                                                  style: TextStyle(
                                                    fontWeight: FontWeight.w600,
                                                    color:
                                                        hexToColor('#202224'),
                                                    fontSize: 12,
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                  ),
                                                ),
                                              ),
                                              Expanded(
                                                flex: 4,
                                                child: Text(
                                                  e.name,
                                                  style: TextStyle(
                                                    fontWeight: FontWeight.w600,
                                                    color:
                                                        hexToColor('#202224'),
                                                    fontSize: 12,
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                  ),
                                                ),
                                              ),
                                              Expanded(
                                                flex: 4,
                                                child: Text(
                                                  e.category,
                                                  style: TextStyle(
                                                    fontWeight: FontWeight.w500,
                                                    color:
                                                        hexToColor('#202224'),
                                                    fontSize: 12,
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                  ),
                                                ),
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
                                                          detailMenu:
                                                              MenuEntity(
                                                            id: e.id,
                                                            name: e.name,
                                                            price: e.price,
                                                            category:
                                                                e.category,
                                                            qty: e.qty,
                                                            description:
                                                                e.description,
                                                            isActive:
                                                                e.isActive,
                                                            imageUri:
                                                                e.imageUri,
                                                          ),
                                                        );
                                                      },
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
                                              Expanded(
                                                flex: 5,
                                                child: Center(
                                                  child: PhoneSwitchWidget(
                                                    isON: e.isActive!,
                                                    onSwitch: (val) async {
                                                      return ref
                                                          .read(
                                                            menuControllerProvider
                                                                .notifier,
                                                          )
                                                          .toggleMenuStatus(
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
                                      onPressed: controller.refresh,
                                      style: TextButton.styleFrom(
                                        backgroundColor: hexToColor('#1F4940'),
                                        shape: RoundedRectangleBorder(
                                          side: BorderSide(
                                            color: hexToColor('#E1E1E1'),
                                          ),
                                          borderRadius: const BorderRadius.all(
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
                      SizedBox(
                        height: 320,
                        child: Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(16),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.grey.withOpacity(0.2),
                                spreadRadius: 2,
                                blurRadius: 5,
                                offset: const Offset(0, 3),
                              ),
                            ],
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Expanded(
                                child: Container(
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(16),
                                    border: Border.all(
                                      color: Colors.grey.withOpacity(0.5),
                                      width: 1,
                                    ),
                                  ),
                                  clipBehavior: Clip.hardEdge,
                                  child: imageUri == null
                                      ? const Center(
                                          child: Text('Gambar Belum Diunggah'),
                                        )
                                      : Image.network(
                                          'https://${BasePaths.baseAPIURL}/${imageUri}',
                                          fit: BoxFit
                                              .cover, // Menggunakan BoxFit.cover
                                          loadingBuilder: (
                                            BuildContext context,
                                            Widget child,
                                            ImageChunkEvent? loadingProgress,
                                          ) {
                                            if (loadingProgress == null)
                                              return child;
                                            return Center(
                                              child: CircularProgressIndicator(
                                                value: loadingProgress
                                                            .expectedTotalBytes !=
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
                                            return const Center(
                                              child: Text(
                                                'Failed to load image',
                                              ),
                                            );
                                          },
                                        ),
                                ),
                              ),
                              SizedBox(height: 8.h),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Expanded(
                                    child: Text(
                                      getFileName(imageUri),
                                      maxLines: 1,
                                      style: const TextStyle(
                                        fontFamily: 'Inter',
                                        fontWeight: FontWeight.w500,
                                        fontSize: 14,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 10.h,
                      ),
                      Text(
                        'Deskripsi',
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
                        controller: deskripsi,
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
                        padding: EdgeInsets.zero,
                        child: Form(
                          key: createKey,
                          child: Column(
                            children: [
                              _buildTextField(
                                'Nama',
                                'Masukkan nama menu',
                                nama,
                                TextInputType.name,
                                12.sp,
                              ),
                              _buildTextField(
                                'Kategori',
                                'Masukkan kategori',
                                kategori,
                                TextInputType.text,
                                12.sp,
                              ),
                              _buildTextField(
                                'Harga',
                                'Masukkan harga',
                                harga,
                                TextInputType.number,
                                12.sp,
                              ),
                              _buildTextField(
                                'Stok',
                                'Masukkan jumlah stok saat ini',
                                jumlah,
                                TextInputType.number,
                                12.sp,
                              ),
                              _buildTextField(
                                'Deskripsi',
                                'Masukkan deskripsi menu',
                                deskripsi,
                                TextInputType.text,
                                12.sp,
                              ),
                              Card(
                                color: Colors.white,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(16),
                                ),
                                elevation: 5,
                                child: Padding(
                                  padding: const EdgeInsets.all(8),
                                  child: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      SizedBox(
                                        height: 200,
                                        child: ClipRRect(
                                          borderRadius:
                                              BorderRadius.circular(16),
                                          child: imageFile == null
                                              ? const Center(
                                                  child: Text(
                                                    'Gambar Belum Diunggah',
                                                  ),
                                                )
                                              : FutureBuilder<File>(
                                                  future: Future.value(
                                                    File(imageFile!),
                                                  ),
                                                  builder: (context, snapshot) {
                                                    if (snapshot
                                                            .connectionState ==
                                                        ConnectionState
                                                            .waiting) {
                                                      return const Center(
                                                        child:
                                                            CircularProgressIndicator(),
                                                      ); // Tampilkan indikator pemuatan
                                                    } else if (snapshot
                                                        .hasError) {
                                                      return const Center(
                                                        child: Text(
                                                          'Failed to load image',
                                                        ),
                                                      ); // Tampilkan pesan kesalahan
                                                    } else {
                                                      return Image.file(
                                                        snapshot.data!,
                                                        fit: BoxFit.cover,
                                                      );
                                                    }
                                                  },
                                                ),
                                        ),
                                      ),
                                      const SizedBox(
                                        height: 4,
                                      ), // Menggunakan SizedBox untuk jarak
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Expanded(
                                            child: Text(
                                              imageFile != null
                                                  ? getFileName(imageFile)
                                                  : 'Unknown.jpg',
                                              style: const TextStyle(
                                                fontFamily: 'Inter',
                                                fontWeight: FontWeight.w500,
                                                fontSize: 14,
                                                overflow: TextOverflow.ellipsis,
                                              ),
                                            ),
                                          ),
                                          SizedBox(
                                            width: 32,
                                            height: 32,
                                            child: IconButton(
                                              onPressed: pickImage,
                                              icon: Icon(
                                                Icons.file_upload_outlined,
                                                color: hexToColor('#1F4940'),
                                                size: 32,
                                              ),
                                              padding: EdgeInsets.zero,
                                              constraints:
                                                  const BoxConstraints(),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              SizedBox(
                                height: 10.h,
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
                                                      menuControllerProvider
                                                          .notifier,
                                                    )
                                                    .createNew(
                                                      request: MenuEntity(
                                                        name: nama.text,
                                                        price: double.parse(
                                                          harga.text,
                                                        ),
                                                        qty: int.parse(
                                                          jumlah.text,
                                                        ),
                                                        category: kategori.text,
                                                        description:
                                                            deskripsi.text,
                                                        isActive: false,
                                                      ),
                                                      imageFile: imageFile,
                                                    );
                                                setState(() {
                                                  Toast().showSuccessToast(
                                                    context: context,
                                                    title:
                                                        'Create Menu Success',
                                                    description:
                                                        'Successfully Created New Menu!',
                                                  );
                                                });
                                                closeCreatePanel();
                                              }
                                            } on ResponseFailure catch (e) {
                                              final err = e.allError
                                                  as Map<String, dynamic>;
                                              setState(() {
                                                Toast().showErrorToast(
                                                  context: context,
                                                  title: 'Create Menu Failed',
                                                  description:
                                                      '${err['name']} - ${err['message']}',
                                                );
                                              });
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
                                          ? const Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: [
                                                SizedBox(
                                                  width: 100,
                                                  height: 20,
                                                  child: CustomLoadingIndicator(
                                                    color: Colors.white,
                                                  ),
                                                ),
                                              ],
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
                        padding: EdgeInsets.zero,
                        child: Form(
                          key: editKey,
                          child: Column(
                            children: [
                              _buildTextField(
                                'Nama',
                                'Masukkan nama menu',
                                nama,
                                TextInputType.name,
                                12.sp,
                              ),
                              _buildTextField(
                                'Kategori',
                                'Masukkan kategori',
                                kategori,
                                TextInputType.text,
                                12.sp,
                              ),
                              _buildTextField(
                                'Harga',
                                'Masukkan harga',
                                harga,
                                TextInputType.number,
                                12.sp,
                              ),
                              _buildTextField(
                                'Stok',
                                'Masukkan jumlah stok saat ini',
                                jumlah,
                                TextInputType.number,
                                12.sp,
                              ),
                              _buildTextField(
                                'Deskripsi',
                                'Masukkan deskripsi menu',
                                deskripsi,
                                TextInputType.text,
                                12.sp,
                              ),
                              Card(
                                color: Colors.white,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(16),
                                ),
                                elevation: 5,
                                child: Padding(
                                  padding: const EdgeInsets.all(8),
                                  child: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      SizedBox(
                                        height: 200,
                                        child: ClipRRect(
                                          borderRadius:
                                              BorderRadius.circular(16),
                                          child: imageFile != null
                                              ? FutureBuilder<File>(
                                                  future: Future.value(
                                                    File(imageFile!),
                                                  ),
                                                  builder: (context, snapshot) {
                                                    if (snapshot
                                                            .connectionState ==
                                                        ConnectionState
                                                            .waiting) {
                                                      return const Center(
                                                        child:
                                                            CircularProgressIndicator(),
                                                      ); // Tampilkan indikator pemuatan
                                                    } else if (snapshot
                                                        .hasError) {
                                                      return const Center(
                                                        child: Text(
                                                          'Failed to load image',
                                                        ),
                                                      ); // Tampilkan pesan kesalahan
                                                    } else {
                                                      return Image.file(
                                                        snapshot.data!,
                                                        fit: BoxFit.cover,
                                                      );
                                                    }
                                                  },
                                                )
                                              : imageUri != null
                                                  ? Image.network(
                                                      'https://${BasePaths.baseAPIURL}/$imageUri',
                                                      fit: BoxFit
                                                          .cover, // Menggunakan BoxFit.cover
                                                      loadingBuilder: (
                                                        BuildContext context,
                                                        Widget child,
                                                        ImageChunkEvent?
                                                            loadingProgress,
                                                      ) {
                                                        if (loadingProgress ==
                                                            null) return child;
                                                        return Center(
                                                          child:
                                                              CircularProgressIndicator(
                                                            value: loadingProgress
                                                                        .expectedTotalBytes !=
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
                                                        return const Center(
                                                          child: Text(
                                                            'Failed to load image',
                                                          ),
                                                        );
                                                      },
                                                    )
                                                  : const Center(
                                                      child: Text(
                                                        'Gambar Belum Diunggah',
                                                      ),
                                                    ),
                                        ),
                                      ),
                                      const SizedBox(
                                        height: 4,
                                      ), // Menggunakan SizedBox untuk jarak
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Expanded(
                                            child: Text(
                                              imageFile != null
                                                  ? getFileName(imageFile)
                                                  : imageUri != null
                                                      ? getFileName(imageUri)
                                                      : "Unknown.jpg",
                                              maxLines: 1,
                                              style: const TextStyle(
                                                fontFamily: 'Inter',
                                                fontWeight: FontWeight.w500,
                                                fontSize: 14,
                                                overflow: TextOverflow.ellipsis,
                                              ),
                                            ),
                                          ),
                                          SizedBox(
                                            width: 32,
                                            height: 32,
                                            child: IconButton(
                                              onPressed: pickImage,
                                              icon: Icon(
                                                Icons.file_upload_outlined,
                                                color: hexToColor('#1F4940'),
                                                size: 32,
                                              ),
                                              padding: EdgeInsets.zero,
                                              constraints:
                                                  const BoxConstraints(),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              SizedBox(
                                height: 10.h,
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
                                                      menuControllerProvider
                                                          .notifier,
                                                    )
                                                    .updateData(
                                                      request: MenuEntity(
                                                        name: nama.text,
                                                        price: double.parse(
                                                          harga.text,
                                                        ),
                                                        qty: int.parse(
                                                          jumlah.text,
                                                        ),
                                                        category: kategori.text,
                                                        description:
                                                            deskripsi.text,
                                                        isActive:
                                                            switchStatusForEdit,
                                                      ),
                                                      id: id!,
                                                      imageFile: imageFile,
                                                    );
                                                closeEditPanel();
                                              }
                                            } on ResponseFailure catch (e) {
                                              final err = e.allError
                                                  as Map<String, dynamic>;
                                              setState(() {
                                                Toast().showErrorToast(
                                                  context: context,
                                                  title: 'Edit Menu Failed',
                                                  description:
                                                      '${err['name']} - ${err['message']}',
                                                );
                                              });
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
                                          ? const Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: [
                                                SizedBox(
                                                  width: 100,
                                                  height: 20,
                                                  child: CustomLoadingIndicator(
                                                    color: Colors.white,
                                                  ),
                                                ),
                                              ],
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
              return 'Required Field';
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
          inputFormatters: label == 'Harga'
              ? [
                  CurrencyInputFormatter(),
                ]
              : [],
        ),
      ],
    ),
  );
}
