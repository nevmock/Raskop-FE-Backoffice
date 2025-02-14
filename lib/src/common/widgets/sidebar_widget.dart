// ignore_for_file: inference_failure_on_function_return_type

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:iconify_flutter/iconify_flutter.dart';
import 'package:raskop_fe_backoffice/res/assets.dart';
import 'package:raskop_fe_backoffice/shared/const.dart';

/// Sidebar Widget for Home Screen
class SidebarWidget extends StatefulWidget {
  /// Sidebar Widget Constructor
  const SidebarWidget({
    required this.changeIndex,
    required this.isWideScreen,
    super.key,
  });

  /// Change Index Function for Changing Content Page
  final Function(int) changeIndex;

  /// Property to detect either current device is Tablet or Phone
  final bool isWideScreen;

  @override
  State<SidebarWidget> createState() => _SidebarWidgetState();
}

class _SidebarWidgetState extends State<SidebarWidget> {
  @override
  Widget build(BuildContext context) {
    return designedSidebar();
  }

  List<Color> iconColor = [
    hexToColor('#1f4940'),
    Colors.white,
    Colors.white,
    Colors.white,
    Colors.white,
    Colors.white,
  ];

  List<bool> isSelected = [true, false, false, false, false, false];

  /// HARDCODED SIDEBAR
  Widget designedSidebar() {
    return Padding(
      padding:
          EdgeInsets.only(left: 10.w, bottom: 10.w, top: 10.h, right: 7.5.w),
      child: Drawer(
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(20)),
        ),
        elevation: 1,
        backgroundColor: hexToColor('#1f4940'),
        clipBehavior: Clip.antiAlias,
        width: 36.w,
        child: ListView(
          children: [
            SizedBox(
              height: 20.h,
            ),
            Padding(
              padding: EdgeInsets.symmetric(
                horizontal: widget.isWideScreen ? 10.w : 5.w,
              ),
              child: ListTile(
                selected: isSelected[0],
                selectedTileColor: Colors.white,
                contentPadding: EdgeInsets.all(3.h),
                title: Iconify(
                  IconAssets.dashboardIcon,
                  color: iconColor[0],
                  size: widget.isWideScreen ? 25 : 20,
                ),
                shape: const CircleBorder(),
                onTap: () {
                  setState(() {
                    iconColor[0] = hexToColor('#1f4940');
                    isSelected[0] = true;
                    iconColor[1] = Colors.white;
                    isSelected[1] = false;
                    iconColor[2] = Colors.white;
                    isSelected[2] = false;
                    iconColor[3] = Colors.white;
                    isSelected[3] = false;
                    iconColor[4] = Colors.white;
                    isSelected[4] = false;
                    iconColor[5] = Colors.white;
                    isSelected[5] = false;
                  });
                  widget.changeIndex(0);
                },
              ),
            ),
            SizedBox(
              height: 10.h,
            ),
            Padding(
              padding: EdgeInsets.symmetric(
                horizontal: widget.isWideScreen ? 10.w : 5.w,
              ),
              child: ListTile(
                selected: isSelected[1],
                selectedTileColor: Colors.white,
                contentPadding: EdgeInsets.all(3.h),
                title: Iconify(
                  IconAssets.orderIcon,
                  color: iconColor[1],
                  size: widget.isWideScreen ? 25 : 20,
                ),
                shape: const CircleBorder(),
                iconColor: iconColor[1],
                onTap: () {
                  setState(() {
                    iconColor[0] = Colors.white;
                    isSelected[0] = false;
                    iconColor[1] = hexToColor('#1f4940');
                    isSelected[1] = true;
                    iconColor[2] = Colors.white;
                    isSelected[2] = false;
                    iconColor[3] = Colors.white;
                    isSelected[3] = false;
                    iconColor[4] = Colors.white;
                    isSelected[4] = false;
                    iconColor[5] = Colors.white;
                    isSelected[5] = false;
                  });
                  widget.changeIndex(1);
                },
              ),
            ),
            SizedBox(
              height: 10.h,
            ),
            Padding(
              padding: EdgeInsets.symmetric(
                horizontal: widget.isWideScreen ? 10.w : 5.w,
              ),
              child: ListTile(
                selected: isSelected[2],
                selectedTileColor: Colors.white,
                contentPadding: EdgeInsets.all(3.h),
                title: Iconify(
                  IconAssets.menuIcon,
                  color: iconColor[2],
                  size: widget.isWideScreen ? 25 : 20,
                ),
                shape: const CircleBorder(),
                iconColor: iconColor[2],
                onTap: () {
                  setState(() {
                    iconColor[0] = Colors.white;
                    isSelected[0] = false;
                    iconColor[1] = Colors.white;
                    isSelected[1] = false;
                    iconColor[2] = hexToColor('#1f4940');
                    isSelected[2] = true;
                    iconColor[3] = Colors.white;
                    isSelected[3] = false;
                    iconColor[4] = Colors.white;
                    isSelected[4] = false;
                    iconColor[5] = Colors.white;
                    isSelected[5] = false;
                  });
                  widget.changeIndex(2);
                },
              ),
            ),
            SizedBox(
              height: 10.h,
            ),
            Padding(
              padding: EdgeInsets.symmetric(
                horizontal: widget.isWideScreen ? 10.w : 5.w,
              ),
              child: ListTile(
                selected: isSelected[3],
                selectedTileColor: Colors.white,
                contentPadding: EdgeInsets.all(3.h),
                title: Iconify(
                  IconAssets.reservasiIcon,
                  color: iconColor[3],
                  size: widget.isWideScreen ? 25 : 20,
                ),
                shape: const CircleBorder(),
                iconColor: iconColor[3],
                onTap: () {
                  setState(() {
                    iconColor[0] = Colors.white;
                    isSelected[0] = false;
                    iconColor[1] = Colors.white;
                    isSelected[1] = false;
                    iconColor[2] = Colors.white;
                    isSelected[2] = false;
                    iconColor[3] = hexToColor('#1f4940');
                    isSelected[3] = true;
                    iconColor[4] = Colors.white;
                    isSelected[4] = false;
                    iconColor[5] = Colors.white;
                    isSelected[5] = false;
                  });
                  widget.changeIndex(3);
                },
              ),
            ),
            SizedBox(
              height: 10.h,
            ),
            Padding(
              padding: EdgeInsets.symmetric(
                horizontal: widget.isWideScreen ? 10.w : 5.w,
              ),
              child: ListTile(
                selected: isSelected[4],
                selectedTileColor: Colors.white,
                contentPadding: EdgeInsets.all(3.h),
                title: Iconify(
                  IconAssets.tableIcon,
                  color: iconColor[4],
                  size: widget.isWideScreen ? 25 : 20,
                ),
                shape: const CircleBorder(),
                iconColor: iconColor[4],
                onTap: () {
                  setState(() {
                    iconColor[0] = Colors.white;
                    isSelected[0] = false;
                    iconColor[1] = Colors.white;
                    isSelected[1] = false;
                    iconColor[2] = Colors.white;
                    isSelected[2] = false;
                    iconColor[3] = Colors.white;
                    isSelected[3] = false;
                    iconColor[4] = hexToColor('#1f4940');
                    isSelected[4] = true;
                    iconColor[5] = Colors.white;
                    isSelected[5] = false;
                  });
                  widget.changeIndex(4);
                },
              ),
            ),
            SizedBox(
              height: 10.h,
            ),
            Padding(
              padding: EdgeInsets.symmetric(
                horizontal: widget.isWideScreen ? 10.w : 5.w,
              ),
              child: ListTile(
                selected: isSelected[5],
                selectedTileColor: Colors.white,
                contentPadding: EdgeInsets.all(3.h),
                title: Iconify(
                  IconAssets.supplierIcon,
                  color: iconColor[5],
                  size: widget.isWideScreen ? 25 : 20,
                ),
                shape: const CircleBorder(),
                iconColor: iconColor[5],
                onTap: () {
                  setState(() {
                    iconColor[0] = Colors.white;
                    isSelected[0] = false;
                    iconColor[1] = Colors.white;
                    isSelected[1] = false;
                    iconColor[2] = Colors.white;
                    isSelected[2] = false;
                    iconColor[3] = Colors.white;
                    isSelected[3] = false;
                    iconColor[4] = Colors.white;
                    isSelected[4] = false;
                    iconColor[5] = hexToColor('#1f4940');
                    isSelected[5] = true;
                  });
                  widget.changeIndex(5);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
