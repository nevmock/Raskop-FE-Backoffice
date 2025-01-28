import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:raskop_fe_backoffice/shared/const.dart';
import 'package:raskop_fe_backoffice/src/common/widgets/sidebar_widget.dart';
import 'package:raskop_fe_backoffice/src/menu/presentation/screens/menu_screen.dart';
import 'package:raskop_fe_backoffice/src/order/presentation/screens/order_screen.dart';
import 'package:raskop_fe_backoffice/src/reservation/presentation/screens/reservation_screen.dart';
import 'package:raskop_fe_backoffice/src/supplier/presentation/screens/supplier_screen.dart';
import 'package:raskop_fe_backoffice/src/table/presentation/screens/table_screen.dart';

/// Home Page
class HomeScreen extends StatefulWidget {
  /// Home Page constructor
  const HomeScreen({required this.title, super.key});

  /// HomeScreen route name
  static const String route = 'home';

  /// HomeScreen title
  final String title;

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  // URUTAN INDEX: 0. DASHBOARD, 1. ORDER, 2. MENU, 3. RESERVATION, 4. TABLE, 5. SUPPLIER
  List<Widget> screens = [
    //const DashboardScreen(),
    const OrderScreen(),
    const MenuScreen(),
    const ReservationScreen(),
    const TableScreen(),
    const SupplierScreen(),
  ];
  int index = -1;

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
                          index = idx;
                        });
                      },
                      isWideScreen: constraints.maxWidth > 500,
                    ),
                  ),
                  Expanded(
                    child: (screens.isNotEmpty && index != -1)
                        ? screens[index]
                        : Center(child: Text(widget.title)),
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
                    if (screens.isNotEmpty && index != -1)
                      Positioned.fill(child: Center(child: screens[index]))
                    else
                      Positioned.fill(child: Center(child: Text(widget.title))),
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
                            index = idx;
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
