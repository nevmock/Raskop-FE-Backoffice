import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:iconify_flutter/iconify_flutter.dart';
import 'package:iconify_flutter/icons/bxs.dart';
import 'package:iconify_flutter/icons/icon_park_solid.dart';
import 'package:raskop_fe_backoffice/shared/const.dart';
import 'package:intl/intl.dart';
import 'package:raskop_fe_backoffice/res/strings.dart';
import 'package:raskop_fe_backoffice/shared/const.dart';
import 'package:raskop_fe_backoffice/src/common/widgets/custom_loading_indicator_widget.dart';
import 'package:raskop_fe_backoffice/src/menu/presentation/widgets/switch_widget.dart';
import 'package:raskop_fe_backoffice/src/table/application/table_controller.dart';
import 'package:raskop_fe_backoffice/src/table/domain/entities/table_entity.dart';
import 'package:raskop_fe_backoffice/src/table/presentation/widgets/table_active_switch_widget.dart';
import 'package:raskop_fe_backoffice/src/table/presentation/widgets/table_location_switch_widget.dart';

class TableScreen extends ConsumerStatefulWidget {
  const TableScreen({super.key});

  static const String route = 'table';

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _TableScreenState();
}

class _TableScreenState extends ConsumerState<TableScreen>
    with SingleTickerProviderStateMixin {
  AsyncValue<List<TableEntity>> get table => ref.watch(tableControllerProvider);

  final Map<String, TextEditingController> _controllers = {};
  Timer? debounceTimer;
  String storeLocation = 'Palem';
  bool isScrollableSheetDisplayed = false;

  @override
  void dispose() {
    _controllers.forEach((key, controller) {
      controller.dispose();
    });
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    void debounceOnDescriptionUpdate(
        TableEntity request, String newDescription, WidgetRef ref) {
      if (debounceTimer?.isActive ?? false) debounceTimer!.cancel();
      debounceTimer = Timer(const Duration(milliseconds: 500), () {
        ref.read(tableControllerProvider.notifier).toggleTableDescription(
              request: request,
              id: request.id!,
              newDescription: newDescription,
            );
      });
    }

    void debounceOnCapacityUpdate(
        TableEntity request, int minCapacity, int maxCapacity, WidgetRef ref) {
      if (debounceTimer?.isActive ?? false) debounceTimer!.cancel();
      debounceTimer = Timer(const Duration(milliseconds: 500), () {
        ref.read(tableControllerProvider.notifier).toggleTableCapacity(
              request: request,
              id: request.id!,
              minCapacity: minCapacity,
              maxCapacity: maxCapacity,
            );
      });
    }

    void displayScrollableSheet() {
      setState(() {
        isScrollableSheetDisplayed = true;
      });
    }

    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
        backgroundColor: Colors.white,
        body: LayoutBuilder(
          builder: (context, constraints) {
            if (storeLocation == 'Bumdes') {
              return Padding(
                padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 10.h),
                child: Row(children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: constraints.maxWidth > 500
                          ? CrossAxisAlignment.start
                          : CrossAxisAlignment.center,
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
                      table.when(
                        data: (data) {
                          return AnimatedContainer(
                            width: MediaQuery.of(context).size.width * 0.56,
                            duration: const Duration(milliseconds: 10),
                            child: Container(
                              width: double.infinity,
                              padding: EdgeInsets.symmetric(
                                  horizontal: 0, vertical: 30),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Expanded(
                                    flex: 4,
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      children: [
                                        _buildTableCard(data, '2',
                                            constraints.maxWidth < 800),
                                        SizedBox(height: 5),
                                        _buildTableCard(data, '3',
                                            constraints.maxWidth < 800)
                                      ],
                                    ),
                                  ),
                                  SizedBox(width: 5),
                                  Expanded(
                                    flex: 6,
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
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
                                                    shape:
                                                        RoundedRectangleBorder(
                                                      side: BorderSide(
                                                          color: hexToColor(
                                                              '#E1E1E1')),
                                                      borderRadius:
                                                          const BorderRadius
                                                              .all(
                                                              Radius.circular(
                                                                  20)),
                                                    ),
                                                    color:
                                                        hexToColor('#D9D9D9'),
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
                                                  child: _buildTableCard(
                                                      data,
                                                      '1',
                                                      constraints.maxWidth <
                                                          800)),
                                            ],
                                          ),
                                        ),
                                        SizedBox(height: 5),
                                        _buildTableCard(data, '4',
                                            constraints.maxWidth < 800)
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                        loading: () => Expanded(
                            child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Center(child: CustomLoadingIndicator()),
                          ],
                        )),
                        error: (error, stackTrace) => Center(
                          child: Text(error.toString() + stackTrace.toString()),
                        ),
                      )
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
                        child: table.when(
                          data: (data) {
                            return ListView(
                              padding: EdgeInsets.zero,
                              shrinkWrap: true,
                              children: data.map(
                                (e) {
                                  if (!_controllers.containsKey(e.id)) {
                                    _controllers[e.id!] = TextEditingController(
                                      text: e.description,
                                    );
                                  }
                                  return Card(
                                    shape: RoundedRectangleBorder(
                                      side: BorderSide(
                                          color: hexToColor('#E1E1E1')),
                                      borderRadius: const BorderRadius.all(
                                          Radius.circular(20)),
                                    ),
                                    color: Colors.white,
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
                                                'MEJA ${e.noTable}',
                                                style: TextStyle(
                                                  fontWeight: FontWeight.w700,
                                                  color: Colors.black,
                                                  fontSize: 18,
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                ),
                                              ),
                                              constraints.maxWidth > 900
                                                  ? Row(
                                                      children: [
                                                        SizedBox(
                                                          width: 95,
                                                          height: 50,
                                                          child:
                                                              TableLocationSwitch(
                                                            isOutdoor:
                                                                e.isOutdoor!,
                                                            onSwitch:
                                                                (val) async {
                                                              return ref
                                                                  .read(
                                                                    tableControllerProvider
                                                                        .notifier,
                                                                  )
                                                                  .toggleTableLocation(
                                                                    request: e,
                                                                    id: e.id!,
                                                                    currentLocation:
                                                                        e.isOutdoor!,
                                                                  );
                                                            },
                                                          ),
                                                        ),
                                                        SizedBox(width: 5.w),
                                                        SizedBox(
                                                          width: 95,
                                                          height: 50,
                                                          child:
                                                              TableActiveSwitchWidget(
                                                            isON: e.isActive!,
                                                            onSwitch:
                                                                (val) async {
                                                              return ref
                                                                  .read(
                                                                    tableControllerProvider
                                                                        .notifier,
                                                                  )
                                                                  .toggleTableStatus(
                                                                    request: e,
                                                                    id: e.id!,
                                                                    currentStatus:
                                                                        e.isActive!,
                                                                  );
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
                                                          child:
                                                              TableLocationSwitch(
                                                            isOutdoor:
                                                                e.isOutdoor!,
                                                            onSwitch:
                                                                (val) async {
                                                              return ref
                                                                  .read(
                                                                    tableControllerProvider
                                                                        .notifier,
                                                                  )
                                                                  .toggleTableLocation(
                                                                    request: e,
                                                                    id: e.id!,
                                                                    currentLocation:
                                                                        e.isOutdoor!,
                                                                  );
                                                            },
                                                          ),
                                                        ),
                                                        SizedBox(height: 5.h),
                                                        SizedBox(
                                                          width: 95,
                                                          height: 50,
                                                          child:
                                                              TableActiveSwitchWidget(
                                                            isON: e.isActive!,
                                                            onSwitch:
                                                                (val) async {
                                                              return ref
                                                                  .read(
                                                                    tableControllerProvider
                                                                        .notifier,
                                                                  )
                                                                  .toggleTableStatus(
                                                                    request: e,
                                                                    id: e.id!,
                                                                    currentStatus:
                                                                        e.isActive!,
                                                                  );
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
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                children: [
                                                  Card(
                                                    color: Colors.white,
                                                    shape:
                                                        RoundedRectangleBorder(
                                                      side: BorderSide(
                                                          color: hexToColor(
                                                              '#E1E1E1')),
                                                      borderRadius:
                                                          const BorderRadius
                                                              .all(
                                                              Radius.circular(
                                                                  20)),
                                                    ),
                                                    child: Padding(
                                                      padding:
                                                          EdgeInsets.symmetric(
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
                                                    shape:
                                                        RoundedRectangleBorder(
                                                      side: BorderSide(
                                                          color: hexToColor(
                                                              '#E1E1E1')),
                                                      borderRadius:
                                                          const BorderRadius
                                                              .all(
                                                              Radius.circular(
                                                                  20)),
                                                    ),
                                                    color: Colors.white,
                                                    child: Padding(
                                                      padding:
                                                          EdgeInsets.symmetric(
                                                              horizontal: 5.w,
                                                              vertical: 2.h),
                                                      child: Center(
                                                        child: Text(
                                                          '20',
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
                                                    max: 20,
                                                    initialValues: RangeValues(
                                                      e.minCapacity.toDouble(),
                                                      e.maxCapacity.toDouble(),
                                                    ),
                                                    onChanged: (values) {
                                                      debounceOnCapacityUpdate(
                                                        e,
                                                        values.start.toInt(),
                                                        values.end.toInt(),
                                                        ref,
                                                      );
                                                    },
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
                                                  color: Colors.black,
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
                                                controller: _controllers[e.id!],
                                                decoration: InputDecoration(
                                                  hintText:
                                                      "Masukkan deskripsi meja",
                                                  hintStyle: TextStyle(
                                                    color: Colors.black
                                                        .withOpacity(0.3),
                                                    fontWeight: FontWeight.w600,
                                                  ),
                                                  filled: true,
                                                  fillColor: Colors.white,
                                                  focusedBorder:
                                                      OutlineInputBorder(
                                                    borderRadius:
                                                        BorderRadius.all(
                                                            Radius.circular(
                                                                15)),
                                                  ),
                                                  border: OutlineInputBorder(
                                                    borderRadius:
                                                        BorderRadius.all(
                                                            Radius.circular(
                                                                15)),
                                                  ),
                                                ),
                                                onChanged: (value) {
                                                  debounceOnDescriptionUpdate(
                                                      e, value, ref);
                                                },
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                  );
                                },
                              ).toList(),
                            );
                          },
                          loading: () => const Center(
                            child: CustomLoadingIndicator(),
                          ),
                          error: (error, stackTrace) => Center(
                            child: Text(
                              error.toString() + stackTrace.toString(),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ]),
              );
            } else {
              return Stack(children: [
                Positioned(
                  top: 0,
                  left: 0,
                  right: 0,
                  child: Padding(
                    padding:
                        EdgeInsets.symmetric(horizontal: 10.w, vertical: 10.h),
                    child: Center(
                      child: Column(
                        children: [
                          PhysicalModel(
                            color: Colors.grey.shade100,
                            borderRadius:
                                const BorderRadius.all(Radius.circular(50)),
                            elevation: 5,
                            child: AnimatedContainer(
                              decoration: BoxDecoration(
                                color: Colors.white,
                                border:
                                    Border.all(color: hexToColor('#E1E1E1')),
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
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(50)),
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
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(50)),
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
                          table.when(
                            data: (data) {
                              return AnimatedContainer(
                                duration: const Duration(milliseconds: 10),
                                child: Container(
                                  width: double.infinity,
                                  padding: EdgeInsets.symmetric(
                                      horizontal: 0, vertical: 30),
                                  child: Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Expanded(
                                        flex: 4,
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.end,
                                          children: [
                                            _buildTableCard(data, '2',
                                                constraints.maxWidth < 800),
                                            _buildTableCard(data, '3',
                                                constraints.maxWidth < 800)
                                          ],
                                        ),
                                      ),
                                      SizedBox(width: 5),
                                      Expanded(
                                        flex: 6,
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            SizedBox(
                                              width: constraints.maxWidth < 800
                                                  ? 400
                                                  : 255,
                                              height: 250,
                                              child: Row(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                mainAxisAlignment:
                                                    MainAxisAlignment.start,
                                                children: [
                                                  Align(
                                                    alignment:
                                                        Alignment.bottomLeft,
                                                    child: SizedBox(
                                                      width: 70,
                                                      height:
                                                          constraints.maxWidth <
                                                                  800
                                                              ? 160
                                                              : 170,
                                                      child: Card(
                                                        shape:
                                                            RoundedRectangleBorder(
                                                          side: BorderSide(
                                                              color: hexToColor(
                                                                  '#E1E1E1')),
                                                          borderRadius:
                                                              const BorderRadius
                                                                  .all(Radius
                                                                      .circular(
                                                                          20)),
                                                        ),
                                                        color: hexToColor(
                                                            '#D9D9D9'),
                                                        child: Center(
                                                          child: Text(
                                                            '',
                                                            style: TextStyle(
                                                              fontSize: 20,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold,
                                                              color:
                                                                  Colors.white,
                                                            ),
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                  SizedBox(width: 5),
                                                  Align(
                                                      alignment:
                                                          Alignment.topRight,
                                                      child: _buildTableCard(
                                                          data,
                                                          '1',
                                                          constraints.maxWidth <
                                                              800)),
                                                ],
                                              ),
                                            ),
                                            SizedBox(height: 5),
                                            _buildTableCard(data, '4',
                                                constraints.maxWidth < 800)
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            },
                            loading: () => SizedBox(
                              height: constraints.maxHeight,
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  const Center(child: CustomLoadingIndicator()),
                                ],
                              ),
                            ),
                            error: (error, stackTrace) => Center(
                              child: Text(
                                  error.toString() + stackTrace.toString()),
                            ),
                          ),
                        ],
                      ),
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
                                    horizontal: 15.w,
                                    vertical: 10.h,
                                  ),
                                  child: Column(
                                    children: [
                                      SizedBox(
                                        width: double.infinity,
                                        child: Align(
                                          alignment: Alignment.topCenter,
                                          child: Container(
                                            margin: const EdgeInsets.symmetric(
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
                                      table.when(
                                        data: (data) {
                                          return ListView(
                                            padding: EdgeInsets.zero,
                                            shrinkWrap: true,
                                            children: data.map(
                                              (e) {
                                                if (!_controllers
                                                    .containsKey(e.id)) {
                                                  _controllers[e.id!] =
                                                      TextEditingController(
                                                    text: e.description,
                                                  );
                                                }
                                                return Card(
                                                  shape: RoundedRectangleBorder(
                                                    side: BorderSide(
                                                        color: hexToColor(
                                                            '#E1E1E1')),
                                                    borderRadius:
                                                        const BorderRadius.all(
                                                            Radius.circular(
                                                                20)),
                                                  ),
                                                  color: Colors.white,
                                                  child: Padding(
                                                    padding:
                                                        EdgeInsets.symmetric(
                                                      horizontal: 8.w,
                                                      vertical: 8.h,
                                                    ),
                                                    child: Column(
                                                      children: [
                                                        Row(
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .spaceBetween,
                                                          children: [
                                                            Text(
                                                              'MEJA ${e.noTable}',
                                                              style: TextStyle(
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w700,
                                                                color: Colors
                                                                    .black,
                                                                fontSize: 18,
                                                                overflow:
                                                                    TextOverflow
                                                                        .ellipsis,
                                                              ),
                                                            ),
                                                            Row(
                                                              children: [
                                                                SizedBox(
                                                                  width: 95,
                                                                  height: 50,
                                                                  child:
                                                                      TableLocationSwitch(
                                                                    isOutdoor: e
                                                                        .isOutdoor!,
                                                                    onSwitch:
                                                                        (val) async {
                                                                      return ref
                                                                          .read(
                                                                            tableControllerProvider.notifier,
                                                                          )
                                                                          .toggleTableLocation(
                                                                            request:
                                                                                e,
                                                                            id: e.id!,
                                                                            currentLocation:
                                                                                e.isOutdoor!,
                                                                          );
                                                                    },
                                                                  ),
                                                                ),
                                                                SizedBox(
                                                                    width: 5.w),
                                                                SizedBox(
                                                                  width: 95,
                                                                  height: 50,
                                                                  child:
                                                                      TableActiveSwitchWidget(
                                                                    isON: e
                                                                        .isActive!,
                                                                    onSwitch:
                                                                        (val) async {
                                                                      return ref
                                                                          .read(
                                                                            tableControllerProvider.notifier,
                                                                          )
                                                                          .toggleTableStatus(
                                                                            request:
                                                                                e,
                                                                            id: e.id!,
                                                                            currentStatus:
                                                                                e.isActive!,
                                                                          );
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
                                                                  MainAxisAlignment
                                                                      .spaceBetween,
                                                              children: [
                                                                Card(
                                                                  color: Colors
                                                                      .white,
                                                                  shape:
                                                                      RoundedRectangleBorder(
                                                                    side: BorderSide(
                                                                        color: hexToColor(
                                                                            '#E1E1E1')),
                                                                    borderRadius:
                                                                        const BorderRadius
                                                                            .all(
                                                                            Radius.circular(20)),
                                                                  ),
                                                                  child:
                                                                      Padding(
                                                                    padding: EdgeInsets.symmetric(
                                                                        horizontal:
                                                                            5.w,
                                                                        vertical:
                                                                            2.h),
                                                                    child:
                                                                        Center(
                                                                      child:
                                                                          Text(
                                                                        '0',
                                                                        style:
                                                                            TextStyle(
                                                                          fontSize:
                                                                              14.sp,
                                                                          color:
                                                                              Colors.black,
                                                                        ),
                                                                      ),
                                                                    ),
                                                                  ),
                                                                ),
                                                                Card(
                                                                  shape:
                                                                      RoundedRectangleBorder(
                                                                    side: BorderSide(
                                                                        color: hexToColor(
                                                                            '#E1E1E1')),
                                                                    borderRadius:
                                                                        const BorderRadius
                                                                            .all(
                                                                            Radius.circular(20)),
                                                                  ),
                                                                  color: Colors
                                                                      .white,
                                                                  child:
                                                                      Padding(
                                                                    padding: EdgeInsets.symmetric(
                                                                        horizontal:
                                                                            5.w,
                                                                        vertical:
                                                                            2.h),
                                                                    child:
                                                                        Center(
                                                                      child:
                                                                          Text(
                                                                        '20',
                                                                        style:
                                                                            TextStyle(
                                                                          fontSize:
                                                                              14.sp,
                                                                          color:
                                                                              Colors.black,
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
                                                                  max: 20,
                                                                  initialValues:
                                                                      RangeValues(
                                                                    e.minCapacity
                                                                        .toDouble(),
                                                                    e.maxCapacity
                                                                        .toDouble(),
                                                                  ),
                                                                  onChanged:
                                                                      (values) {
                                                                    debounceOnCapacityUpdate(
                                                                      e,
                                                                      values
                                                                          .start
                                                                          .toInt(),
                                                                      values.end
                                                                          .toInt(),
                                                                      ref,
                                                                    );
                                                                  },
                                                                ),
                                                              ],
                                                            )
                                                          ],
                                                        ),
                                                        Column(
                                                          crossAxisAlignment:
                                                              CrossAxisAlignment
                                                                  .start,
                                                          children: [
                                                            Text(
                                                              'Deskripsi',
                                                              style: TextStyle(
                                                                color: Colors
                                                                    .black,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w600,
                                                                fontSize: 14.sp,
                                                              ),
                                                            ),
                                                            SizedBox(
                                                              height: 5.h,
                                                            ),
                                                            TextFormField(
                                                              style:
                                                                  const TextStyle(
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w400,
                                                                color: Colors
                                                                    .black,
                                                                fontSize: 14,
                                                                overflow:
                                                                    TextOverflow
                                                                        .fade,
                                                              ),
                                                              maxLines: 3,
                                                              controller:
                                                                  _controllers[
                                                                      e.id!],
                                                              decoration:
                                                                  InputDecoration(
                                                                hintText:
                                                                    "Masukkan deskripsi meja",
                                                                hintStyle:
                                                                    TextStyle(
                                                                  color: Colors
                                                                      .black
                                                                      .withOpacity(
                                                                          0.3),
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w600,
                                                                ),
                                                                filled: true,
                                                                fillColor:
                                                                    Colors
                                                                        .white,
                                                                focusedBorder:
                                                                    OutlineInputBorder(
                                                                  borderRadius:
                                                                      BorderRadius.all(
                                                                          Radius.circular(
                                                                              15)),
                                                                ),
                                                                border:
                                                                    OutlineInputBorder(
                                                                  borderRadius:
                                                                      BorderRadius.all(
                                                                          Radius.circular(
                                                                              15)),
                                                                ),
                                                              ),
                                                              onChanged:
                                                                  (value) {
                                                                debounceOnDescriptionUpdate(
                                                                    e,
                                                                    value,
                                                                    ref);
                                                              },
                                                            ),
                                                          ],
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                );
                                              },
                                            ).toList(),
                                          );
                                        },
                                        loading: () => const Center(
                                          child: CustomLoadingIndicator(),
                                        ),
                                        error: (error, stackTrace) => Center(
                                          child: Text(
                                            error.toString() +
                                                stackTrace.toString(),
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
                                'Lihat Setelan Meja',
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
              ]);
            }
          },
        ),
      ),
    );
  }
}

class CustomRangeSlider extends StatefulWidget {
  final double min;
  final double max;
  final RangeValues initialValues;
  final ValueChanged<RangeValues> onChanged;

  const CustomRangeSlider({
    Key? key,
    required this.min,
    required this.max,
    required this.initialValues,
    required this.onChanged,
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
                  widget.onChanged(values);
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

Widget _buildTableCard(List<TableEntity> data, String noTable, bool? isMobile) {
  final tableEntity = data.where((table) => table.noTable == noTable).toList();

  Color cardColor;
  if (tableEntity.isNotEmpty) {
    cardColor = tableEntity.first.isActive
        ? hexToColor('#47B881')
        : hexToColor('#EB6F70');
  } else {
    cardColor = hexToColor('#D9D9D9');
  }

  return SizedBox(
    width: isMobile == false && noTable == '4'
        ? 255
        : isMobile == true && noTable == '4'
            ? 175
            : isMobile == false && noTable == '1'
                ? 180
                : isMobile == true && noTable == '1'
                    ? 100
                    : isMobile == true
                        ? 70
                        : 85,
    height: isMobile == false && noTable == '1'
        ? 200
        : isMobile == true && noTable == '1'
            ? 160
            : isMobile == true
                ? 70
                : 85,
    child: Card(
      shape: RoundedRectangleBorder(
        side: BorderSide(color: hexToColor('#E1E1E1')),
        borderRadius: const BorderRadius.all(Radius.circular(20)),
      ),
      color: cardColor,
      child: Center(
        child: Text(
          noTable,
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
      ),
    ),
  );
}
