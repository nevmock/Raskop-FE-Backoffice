import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:iconify_flutter/iconify_flutter.dart';
import 'package:iconify_flutter/icons/eva.dart';
import 'package:iconify_flutter/icons/zondicons.dart';
import 'package:intl/intl.dart';
import 'package:raskop_fe_backoffice/core/core.dart';
import 'package:raskop_fe_backoffice/res/strings.dart';
import 'package:raskop_fe_backoffice/shared/const.dart';
import 'package:raskop_fe_backoffice/src/menu/presentation/widgets/switch_widget.dart';
import 'package:raskop_fe_backoffice/src/supplier/presentation/widgets/positioned_directional_backdrop_blur_widget.dart';

///
class ReservationScreen extends StatefulWidget {
  ///
  const ReservationScreen({super.key});

  ///
  static const String route = 'reservation';

  @override
  State<ReservationScreen> createState() => _ReservationScreenState();
}

class _ReservationScreenState extends State<ReservationScreen> {
  bool isDetailPanelVisible = false;
  bool isCreatePanelVisible = false;
  bool isEditPanelVisible = false;
  TextEditingController nama = TextEditingController();
  TextEditingController kontak = TextEditingController();
  TextEditingController startText = TextEditingController();
  TextEditingController endText = TextEditingController();
  TextEditingController catatan = TextEditingController();
  TextEditingController komunitas = TextEditingController();
  DateTime start = DateTime.now();
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
        startText.value = const TextEditingValue(text: '23/11/24; 11:30 PM');
        endText.value = const TextEditingValue(text: '24/11/24; 03:00 AM');
        catatan.value = const TextEditingValue(
          text: 'Minta kursi bayi satu yaa',
        );
        komunitas.value = const TextEditingValue(text: 'Dosen Telyu');
      });
    }

    void closeEditPanel() {
      setState(() {
        isEditPanelVisible = !isEditPanelVisible;
        nama.clear();
        kontak.clear();
        startText.clear();
        endText.clear();
        catatan.clear();
        komunitas.clear();
      });
    }

    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
        body: Stack(
          children: [
            AnimatedContainer(
              padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 10.h),
              duration: const Duration(milliseconds: 300),
              child: Column(
                children: [
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
                                'CATT, KOMUNITAS',
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
                                mainAxisAlignment: MainAxisAlignment.center,
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
                                          borderRadius: const BorderRadius.only(
                                            topLeft: Radius.circular(15),
                                            bottomLeft: Radius.circular(15),
                                          ),
                                          color: hexToColor('#E1E1E1'),
                                        ),
                                        child: ClipOval(
                                          child: Center(
                                            child: Container(
                                              width: 25.w,
                                              height: 27.h,
                                              padding: const EdgeInsets.all(12),
                                              decoration: BoxDecoration(
                                                borderRadius:
                                                    const BorderRadius.all(
                                                  Radius.circular(30),
                                                ),
                                                color: hexToColor('#FFAD0D'),
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
                                          borderRadius: const BorderRadius.only(
                                            topRight: Radius.circular(15),
                                            bottomRight: Radius.circular(15),
                                          ),
                                          color: hexToColor('#E1E1E1'),
                                        ),
                                        child: Center(
                                          child: Container(
                                            width: 25.w,
                                            height: 28.h,
                                            padding: const EdgeInsets.all(12),
                                            decoration: BoxDecoration(
                                              borderRadius:
                                                  const BorderRadius.all(
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
                                    flex: 2,
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
                                    flex: 2,
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
                                        DateFormat('dd/MM/yy; hh:mm a').format(
                                          DateTime.utc(2024, 11, 23, 23, 30),
                                        ),
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
                                        DateFormat('dd/MM/yy; hh:mm a').format(
                                          DateTime.utc(2024, 11, 24, 3),
                                        ),
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
                                              color: hexToColor('#E38D5D'),
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
                Container(
                  margin: EdgeInsets.only(
                    right: MediaQuery.of(context).size.width * 0.238,
                  ),
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.all(Radius.circular(50)),
                  ),
                  child: IconButton(
                    padding: const EdgeInsets.all(10),
                    color: hexToColor('#1F4940'),
                    icon: const Icon(Icons.arrow_back),
                    onPressed: toggleDetailPanel,
                  ),
                ),
                SizedBox(
                  height: 20.h,
                ),
                Text(
                  'Catatan',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                    fontSize: 8.sp,
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
                  initialValue: 'Minta kursi bayi satu yaa',
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
                  'Komunitas',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                    fontSize: 8.sp,
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
                  initialValue: 'Dosen Telyu',
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
                Container(
                  margin: EdgeInsets.only(
                    right: MediaQuery.of(context).size.width * 0.82,
                  ),
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.all(Radius.circular(50)),
                  ),
                  child: IconButton(
                    padding: const EdgeInsets.all(10),
                    color: hexToColor('#1F4940'),
                    icon: const Icon(Icons.arrow_back),
                    onPressed: toggleCreatePanel,
                  ),
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
                              (270.w * (crossAxisCount - 2))) /
                          crossAxisCount;
                      return Form(
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
                                ),
                              ),
                              SizedBox(
                                width: itemWidth.w,
                                child: _buildTextField(
                                  'Kontak',
                                  'Masukkan nomor telepon',
                                  kontak,
                                  TextInputType.phone,
                                ),
                              ),
                              SizedBox(
                                width: itemWidth.w,
                                child: _buildDateTimePickerField(
                                  label: 'Start',
                                  hint: 'Masukkan waktu mulai',
                                  controller: startText,
                                  onTap: () async {
                                    await pickStartDateTime();
                                  },
                                ),
                              ),
                              SizedBox(
                                width: itemWidth.w,
                                child: _buildDateTimePickerField(
                                  label: 'End',
                                  hint: 'Masukkan waktu berakhir',
                                  controller: endText,
                                  onTap: () async {
                                    await pickEndDateTime();
                                  },
                                ),
                              ),
                              SizedBox(
                                width: (itemWidth * 2 + 5).w,
                                child: _buildTextField(
                                  'Catatan',
                                  'Masukkan catatan',
                                  catatan,
                                  TextInputType.text,
                                ),
                              ),
                              SizedBox(
                                width: itemWidth.w,
                                child: _buildTextField(
                                  'Komunitas',
                                  'Masukkan komunitas',
                                  komunitas,
                                  TextInputType.text,
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
              width: MediaQuery.of(context).size.width - 70.w,
            ),
            PositionedDirectionalBackdropBlurWidget(
              isPanelVisible: isEditPanelVisible,
              end: -MediaQuery.of(context).size.width * 1,
              content: [
                Container(
                  margin: EdgeInsets.only(
                    right: MediaQuery.of(context).size.width * 0.82,
                  ),
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.all(Radius.circular(50)),
                  ),
                  child: IconButton(
                    padding: const EdgeInsets.all(10),
                    color: hexToColor('#1F4940'),
                    icon: const Icon(Icons.arrow_back),
                    onPressed: closeEditPanel,
                  ),
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
                              (270.w * (crossAxisCount - 2))) /
                          crossAxisCount;
                      return Form(
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
                              ),
                            ),
                            SizedBox(
                              width: itemWidth.w,
                              child: _buildTextField(
                                'Kontak',
                                'Masukkan nomor telepon',
                                kontak,
                                TextInputType.phone,
                              ),
                            ),
                            SizedBox(
                              width: itemWidth.w,
                              child: _buildDateTimePickerField(
                                label: 'Start',
                                hint: 'Masukkan waktu mulai',
                                controller: startText,
                                onTap: () async {
                                  await pickStartDateTime();
                                },
                              ),
                            ),
                            SizedBox(
                              width: itemWidth.w,
                              child: _buildDateTimePickerField(
                                label: 'End',
                                hint: 'Masukkan waktu berakhir',
                                controller: endText,
                                onTap: () async {
                                  await pickEndDateTime();
                                },
                              ),
                            ),
                            SizedBox(
                              width: (itemWidth * 2 + 5).w,
                              child: _buildTextField(
                                'Catatan',
                                'Masukkan catatan',
                                catatan,
                                TextInputType.text,
                              ),
                            ),
                            SizedBox(
                              width: itemWidth.w,
                              child: _buildTextField(
                                'Komunitas',
                                'Masukkan komunitas',
                                komunitas,
                                TextInputType.text,
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
                      );
                    },
                  ),
                ),
              ],
              width: MediaQuery.of(context).size.width - 70.w,
            ),
          ],
        ),
      ),
    );
  }

  FutureVoid pickStartDateTime() async {
    final now = DateTime.now();
    final date = await showDatePicker(
      context: context,
      initialDate: now,
      firstDate: now,
      lastDate: DateTime(now.year + 100),
    );
    if (date == null) return;

    final time = await pickTime();
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

  FutureVoid pickEndDateTime() async {
    final now = DateTime.now();
    final date = await showDatePicker(
      context: context,
      initialDate: now,
      firstDate: start,
      lastDate: start.copyWith(year: start.year + 100),
    );
    if (date == null) return;

    final time = await pickTime();
    if (time == null) return;

    final newDateTime =
        DateTime(date.year, date.month, date.day, time.hour, time.minute);

    setState(() {
      endText.value = TextEditingValue(
        text: DateFormat('dd/MM/yy; hh:mm a').format(newDateTime),
      );
    });
  }

  Future<TimeOfDay?> pickTime() =>
      showTimePicker(context: context, initialTime: TimeOfDay.now());
}

Widget _buildDateTimePickerField({
  required String label,
  required String hint,
  required TextEditingController controller,
  void Function()? onTap,
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
            fontSize: 8.sp,
          ),
        ),
        SizedBox(
          height: 5.h,
        ),
        TextField(
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
            fontSize: 8.sp,
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
