import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:raskop_fe_backoffice/shared/const.dart';
import 'package:raskop_fe_backoffice/src/common/widgets/sidebar_widget.dart';

/// Home Page
class HomeScreen extends StatefulWidget {
  /// Home Page constructor
  const HomeScreen({
    required this.navigationShell,
    super.key,
  });

  /// HomeScreen route name
  static const String route = 'home';

  /// Navigation Shell
  final StatefulNavigationShell navigationShell;

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  bool isExpanded = false;

  @override
  Widget build(BuildContext context) {
    void toggleExpanded() {
      setState(() {
        isExpanded = !isExpanded;
      });
    }

    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        if (constraints.maxWidth > 500) {
          return SafeArea(
            child: Scaffold(
              backgroundColor: Colors.white,
              body: Row(
                children: [
                  SizedBox(
                    width: MediaQuery.of(context).size.width * 0.089,
                    child: SidebarWidget(
                      changeIndex: (idx) {
                        setState(() {
                          widget.navigationShell.goBranch(idx);
                        });
                      },
                      isWideScreen: constraints.maxWidth > 500,
                    ),
                  ),
                  Expanded(
                    child: widget.navigationShell,
                  ),
                ],
              ),
            ),
          );
        } else {
          return SafeArea(
            child: Scaffold(
              backgroundColor: Colors.white,
              body: Padding(
                padding: EdgeInsets.symmetric(horizontal: 10.w),
                child: Stack(
                  children: [
                    Positioned.fill(
                      child: Center(child: widget.navigationShell),
                    ),
                    AnimatedPositionedDirectional(
                      duration: const Duration(milliseconds: 500),
                      curve: Curves.fastEaseInToSlowEaseOut,
                      top: 10.h,
                      bottom: 100.h,
                      start: isExpanded
                          ? -MediaQuery.of(context).size.width * 0.3
                          : 0.w,
                      width: MediaQuery.of(context).size.width * 0.18,
                      child: SidebarWidget(
                        changeIndex: (idx) {
                          setState(() {
                            widget.navigationShell.goBranch(idx);
                          });
                        },
                        isWideScreen: constraints.maxWidth > 500,
                      ),
                    ),
                    Positioned(
                      left: 10.w,
                      bottom: 50.h,
                      width: MediaQuery.of(context).size.width * 0.13,
                      child: Container(
                        decoration: BoxDecoration(
                          color: hexToColor('#1F4940'),
                          borderRadius:
                              const BorderRadius.all(Radius.circular(50)),
                        ),
                        child: IconButton(
                          padding: const EdgeInsets.all(10),
                          color: Colors.white,
                          icon: isExpanded
                              ? const Icon(Icons.arrow_forward_ios_rounded)
                              : const Icon(Icons.arrow_back_ios_new_rounded),
                          onPressed: toggleExpanded,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        }
      },
    );
  }
}
