import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:iconify_flutter/iconify_flutter.dart';
import 'package:iconify_flutter/icons/bxs.dart';
import 'package:iconify_flutter/icons/icon_park_solid.dart';
import 'package:raskop_fe_backoffice/shared/const.dart';
import 'package:intl/intl.dart';
import 'package:raskop_fe_backoffice/res/strings.dart';
import 'package:raskop_fe_backoffice/shared/const.dart';
import 'package:raskop_fe_backoffice/src/menu/presentation/widgets/switch_widget.dart';
import 'package:raskop_fe_backoffice/src/table/presentation/widgets/table_active_switch_widget.dart';
import 'package:raskop_fe_backoffice/src/table/presentation/widgets/table_location_switch_widget.dart';

class TableScreen extends StatefulWidget {
  const TableScreen({super.key});

  @override
  State<TableScreen> createState() => _TableScreenState();
}

class _TableScreenState extends State<TableScreen> {
  TextEditingController notes = TextEditingController();
  String storeLocation = 'Palem';

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
          backgroundColor: Colors.white,
          body: LayoutBuilder(builder: (context, constraints) {
            if (storeLocation == 'Bumdes') {
              return Padding(
                padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 10.h),
                child: Row(children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        PhysicalModel(
                          color: Colors.grey.shade100,
                          borderRadius:
                              const BorderRadius.all(Radius.circular(50)),
                          elevation: 5,
                          child: AnimatedContainer(
                            decoration: BoxDecoration(
                              color: Colors.white,
                              border: Border.all(color: hexToColor('#E1E1E1')),
                              borderRadius:
                                  const BorderRadius.all(Radius.circular(50)),
                            ),
                            duration: const Duration(milliseconds: 100),
                            padding: const EdgeInsets.symmetric(
                              horizontal: 5,
                              vertical: 5,
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                TextButton(
                                  style: TextButton.styleFrom(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 20,
                                      vertical: 10,
                                    ),
                                    backgroundColor: storeLocation == 'Palem'
                                        ? hexToColor('#1F4940')
                                        : Colors.transparent,
                                    shape: const RoundedRectangleBorder(
                                      borderRadius:
                                          BorderRadius.all(Radius.circular(50)),
                                    ),
                                  ),
                                  onPressed: () async {
                                    setState(() {
                                      storeLocation = 'Palem';
                                    });
                                  },
                                  child: Center(
                                    child: Text(
                                      'Palem',
                                      style: TextStyle(
                                        color: storeLocation == 'Palem'
                                            ? Colors.white
                                            : hexToColor('#1F4940'),
                                        fontSize: 14,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  ),
                                ),
                                const SizedBox(
                                  width: 12,
                                ),
                                TextButton(
                                  style: TextButton.styleFrom(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 20,
                                      vertical: 10,
                                    ),
                                    backgroundColor: storeLocation == 'Bumdes'
                                        ? hexToColor('#1F4940')
                                        : Colors.transparent,
                                    shape: const RoundedRectangleBorder(
                                      borderRadius:
                                          BorderRadius.all(Radius.circular(50)),
                                    ),
                                  ),
                                  onPressed: () async {
                                    setState(() {
                                      storeLocation = 'Bumdes';
                                    });
                                  },
                                  child: Center(
                                    child: Text(
                                      'Bumdes',
                                      style: TextStyle(
                                        color: storeLocation == 'Bumdes'
                                            ? Colors.white
                                            : hexToColor('#1F4940'),
                                        fontSize: 14,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        Expanded(
                          child: Center(
                            child: Text(
                              "Under Development",
                              style: TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.bold,
                                fontSize: 20.sp,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ]),
              );
            }
            if (constraints.maxWidth > 500) {
              return Padding(
                padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 10.h),
                child: Row(children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      PhysicalModel(
                        color: Colors.grey.shade100,
                        borderRadius:
                            const BorderRadius.all(Radius.circular(50)),
                        elevation: 5,
                        child: AnimatedContainer(
                          decoration: BoxDecoration(
                            color: Colors.white,
                            border: Border.all(color: hexToColor('#E1E1E1')),
                            borderRadius:
                                const BorderRadius.all(Radius.circular(50)),
                          ),
                          duration: const Duration(milliseconds: 100),
                          padding: const EdgeInsets.symmetric(
                            horizontal: 5,
                            vertical: 5,
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              TextButton(
                                style: TextButton.styleFrom(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 20,
                                    vertical: 10,
                                  ),
                                  backgroundColor: storeLocation == 'Palem'
                                      ? hexToColor('#1F4940')
                                      : Colors.transparent,
                                  shape: const RoundedRectangleBorder(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(50)),
                                  ),
                                ),
                                onPressed: () async {
                                  setState(() {
                                    storeLocation = 'Palem';
                                  });
                                },
                                child: Center(
                                  child: Text(
                                    'Palem',
                                    style: TextStyle(
                                      color: storeLocation == 'Palem'
                                          ? Colors.white
                                          : hexToColor('#1F4940'),
                                      fontSize: 14,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(
                                width: 12,
                              ),
                              TextButton(
                                style: TextButton.styleFrom(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 20,
                                    vertical: 10,
                                  ),
                                  backgroundColor: storeLocation == 'Bumdes'
                                      ? hexToColor('#1F4940')
                                      : Colors.transparent,
                                  shape: const RoundedRectangleBorder(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(50)),
                                  ),
                                ),
                                onPressed: () async {
                                  setState(() {
                                    storeLocation = 'Bumdes';
                                  });
                                },
                                child: Center(
                                  child: Text(
                                    'Bumdes',
                                    style: TextStyle(
                                      color: storeLocation == 'Bumdes'
                                          ? Colors.white
                                          : hexToColor('#1F4940'),
                                      fontSize: 14,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      AnimatedContainer(
                        width: MediaQuery.of(context).size.width * 0.56,
                        duration: const Duration(milliseconds: 10),
                        child: Container(
                          width: double.infinity,
                          padding:
                              EdgeInsets.symmetric(horizontal: 0, vertical: 30),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Expanded(
                                flex: 4,
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    SizedBox(
                                      width: 85,
                                      height: 85,
                                      child: Card(
                                        shape: RoundedRectangleBorder(
                                          side: BorderSide(
                                              color: hexToColor('#E1E1E1')),
                                          borderRadius: const BorderRadius.all(
                                              Radius.circular(20)),
                                        ),
                                        color: hexToColor('#47B881'),
                                        child: Center(
                                          child: Text(
                                            '2',
                                            style: TextStyle(
                                              fontSize: 20,
                                              fontWeight: FontWeight.bold,
                                              color: Colors.white,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                    SizedBox(height: 5),
                                    SizedBox(
                                      width: 85,
                                      height: 85,
                                      child: Card(
                                        shape: RoundedRectangleBorder(
                                          side: BorderSide(
                                              color: hexToColor('#E1E1E1')),
                                          borderRadius: const BorderRadius.all(
                                              Radius.circular(20)),
                                        ),
                                        color: hexToColor('#EB6F70'),
                                        child: Center(
                                          child: Text(
                                            '3',
                                            style: TextStyle(
                                              fontSize: 20,
                                              fontWeight: FontWeight.bold,
                                              color: Colors.white,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              SizedBox(width: 5),
                              Expanded(
                                flex: 6,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    SizedBox(
                                      width: 255,
                                      height: 250,
                                      child: Row(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        children: [
                                          Align(
                                            alignment: Alignment.bottomLeft,
                                            child: SizedBox(
                                              width: 70,
                                              height: 170,
                                              child: Card(
                                                shape: RoundedRectangleBorder(
                                                  side: BorderSide(
                                                      color: hexToColor(
                                                          '#E1E1E1')),
                                                  borderRadius:
                                                      const BorderRadius.all(
                                                          Radius.circular(20)),
                                                ),
                                                color: hexToColor('#D9D9D9'),
                                                child: Center(
                                                  child: Text(
                                                    '',
                                                    style: TextStyle(
                                                      fontSize: 20,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      color: Colors.white,
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ),
                                          SizedBox(width: 5),
                                          Align(
                                            alignment: Alignment.topRight,
                                            child: SizedBox(
                                              width: 180,
                                              height: 200,
                                              child: Card(
                                                shape: RoundedRectangleBorder(
                                                  side: BorderSide(
                                                      color: hexToColor(
                                                          '#E1E1E1')),
                                                  borderRadius:
                                                      const BorderRadius.all(
                                                          Radius.circular(20)),
                                                ),
                                                color: hexToColor('#47B881'),
                                                child: Center(
                                                  child: Text(
                                                    '1',
                                                    style: TextStyle(
                                                      fontSize: 20,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      color: Colors.white,
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    SizedBox(height: 5),
                                    SizedBox(
                                      width: 255,
                                      height: 85,
                                      child: Card(
                                        shape: RoundedRectangleBorder(
                                          side: BorderSide(
                                              color: hexToColor('#E1E1E1')),
                                          borderRadius: const BorderRadius.all(
                                              Radius.circular(20)),
                                        ),
                                        color: hexToColor('#47B881'),
                                        child: Center(
                                          child: Text(
                                            '4',
                                            style: TextStyle(
                                              fontSize: 20,
                                              fontWeight: FontWeight.bold,
                                              color: Colors.white,
                                            ),
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
                    ],
                  ),
                  const Spacer(),
                  AnimatedContainer(
                    width: MediaQuery.of(context).size.width * 0.30,
                    duration: const Duration(milliseconds: 10),
                    child: Material(
                      color: Colors.white,
                      type: MaterialType.card,
                      shadowColor: Colors.black38,
                      shape: Border(
                        left: BorderSide(
                            color: hexToColor('#E1E1E1'), width: 1.2),
                      ),
                      child: Padding(
                        padding: EdgeInsets.only(
                            left: 10.w, top: 10.h, right: 0.h, bottom: 10.h),
                        child: ListView.builder(
                          padding: EdgeInsets.zero,
                          shrinkWrap: true,
                          itemCount: 10,
                          itemBuilder: (context, index) {
                            return Card(
                              shape: RoundedRectangleBorder(
                                side: BorderSide(color: hexToColor('#E1E1E1')),
                                borderRadius:
                                    const BorderRadius.all(Radius.circular(20)),
                              ),
                              color: hexToColor("#1f4940"),
                              child: Padding(
                                padding: EdgeInsets.symmetric(
                                  horizontal: 8.w,
                                  vertical: 8.h,
                                ),
                                child: Column(
                                  children: [
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          "MEJA 1",
                                          style: TextStyle(
                                            fontWeight: FontWeight.w700,
                                            color: Colors.white,
                                            fontSize: 18,
                                          ),
                                        ),
                                        constraints.maxWidth > 900
                                            ? Row(
                                                children: [
                                                  SizedBox(
                                                    width: 95,
                                                    height: 50,
                                                    child: TableLocationSwitch(
                                                      isOutdoor: false,
                                                      onSwitch: (val) async {
                                                        return val;
                                                      },
                                                    ),
                                                  ),
                                                  SizedBox(width: 5.w),
                                                  SizedBox(
                                                    width: 95,
                                                    height: 50,
                                                    child:
                                                        TableActiveSwitchWidget(
                                                      isON: false,
                                                      onSwitch: (val) async {
                                                        return val;
                                                      },
                                                    ),
                                                  ),
                                                ],
                                              )
                                            : Column(
                                                children: [
                                                  SizedBox(
                                                    width: 95,
                                                    height: 50,
                                                    child: TableLocationSwitch(
                                                      isOutdoor: false,
                                                      onSwitch: (val) async {
                                                        return val;
                                                      },
                                                    ),
                                                  ),
                                                  SizedBox(height: 5.h),
                                                  SizedBox(
                                                    width: 95,
                                                    height: 50,
                                                    child:
                                                        TableActiveSwitchWidget(
                                                      isON: false,
                                                      onSwitch: (val) async {
                                                        return val;
                                                      },
                                                    ),
                                                  ),
                                                ],
                                              )
                                      ],
                                    ),
                                    SizedBox(height: 5.h),
                                    Column(
                                      children: [
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Card(
                                              color: Colors.white,
                                              child: Padding(
                                                padding: EdgeInsets.symmetric(
                                                    horizontal: 5.w,
                                                    vertical: 2.h),
                                                child: Center(
                                                  child: Text(
                                                    '0',
                                                    style: TextStyle(
                                                      fontSize: 14.sp,
                                                      color: Colors.black,
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ),
                                            Card(
                                              color: Colors.white,
                                              child: Padding(
                                                padding: EdgeInsets.symmetric(
                                                    horizontal: 5.w,
                                                    vertical: 2.h),
                                                child: Center(
                                                  child: Text(
                                                    '12',
                                                    style: TextStyle(
                                                      fontSize: 14.sp,
                                                      color: Colors.black,
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                        Row(
                                          children: [
                                            CustomRangeSlider(
                                              min: 0,
                                              max: 12,
                                              initialValues:
                                                  const RangeValues(0, 6),
                                            ),
                                          ],
                                        )
                                      ],
                                    ),
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
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
                                          style: const TextStyle(
                                            fontWeight: FontWeight.w400,
                                            color: Colors.black,
                                            fontSize: 14,
                                            overflow: TextOverflow.fade,
                                          ),
                                          maxLines: 3,
                                          decoration: InputDecoration(
                                            hintText: "Masukkan deskripsi meja",
                                            hintStyle: TextStyle(
                                              color:
                                                  Colors.black.withOpacity(0.3),
                                              fontWeight: FontWeight.w600,
                                            ),
                                            filled: true,
                                            fillColor: Colors.white,
                                            focusedBorder: OutlineInputBorder(
                                              borderRadius: BorderRadius.all(
                                                  Radius.circular(15)),
                                            ),
                                            border: OutlineInputBorder(
                                              borderRadius: BorderRadius.all(
                                                  Radius.circular(15)),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                    ),
                  ),
                ]),
              );
            } else {
              return Text("Mobile Page");
            }
          })),
    );
  }
}

class CustomRangeSlider extends StatefulWidget {
  final double min;
  final double max;
  final RangeValues initialValues;

  const CustomRangeSlider({
    Key? key,
    required this.min,
    required this.max,
    required this.initialValues,
  }) : super(key: key);

  @override
  _CustomRangeSliderState createState() => _CustomRangeSliderState();
}

class _CustomRangeSliderState extends State<CustomRangeSlider> {
  late RangeValues _rangeSliderValues;

  @override
  void initState() {
    super.initState();
    _rangeSliderValues = widget.initialValues;
  }

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Column(
        children: [
          RangeSlider(
            values: _rangeSliderValues,
            min: widget.min,
            max: widget.max,
            divisions: (widget.max).toInt(),
            labels: RangeLabels(
              _rangeSliderValues.start.round().toString(),
              _rangeSliderValues.end.round().toString(),
            ),
            inactiveColor: hexToColor('#E35D5D'),
            activeColor: hexToColor('#E38C5D'),
            onChanged: (values) {
              setState(() {
                if (values.start >= widget.min && values.end <= widget.max) {
                  _rangeSliderValues = values;
                }
              });
            },
          ),
        ],
      ),
    );
  }
}

class CustomSwitchWithIcon extends StatefulWidget {
  const CustomSwitchWithIcon({super.key});

  @override
  State<CustomSwitchWithIcon> createState() => _CustomSwitchWithIconState();
}

class _CustomSwitchWithIconState extends State<CustomSwitchWithIcon> {
  bool isOn = false;

  void toggleSwitch() {
    setState(() {
      isOn = !isOn;
    });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: toggleSwitch,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
        width: 90,
        height: 50,
        padding: const EdgeInsets.all(5),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(25),
          color: isOn ? hexToColor('#34C759') : hexToColor('#F64C4C'),
        ),
        child: Stack(
          children: [
            AnimatedAlign(
              duration: const Duration(milliseconds: 300),
              curve: Curves.easeInOut,
              alignment: isOn ? Alignment.centerRight : Alignment.centerLeft,
              child: Container(
                width: 40,
                height: 40,
                decoration: const BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.circle,
                ),
              ),
            ),
            AnimatedAlign(
              duration: const Duration(milliseconds: 300),
              curve: Curves.easeInOut,
              alignment: isOn ? Alignment.centerLeft : Alignment.centerRight,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 5),
                child: isOn
                    ? Iconify(
                        IconParkSolid.outdoor,
                        color: Colors.white,
                        size: 30,
                      )
                    : Iconify(
                        Bxs.home_alt_2,
                        color: Colors.white,
                        size: 30,
                      ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
