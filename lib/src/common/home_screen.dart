import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:raskop_fe_backoffice/src/common/widgets/sidebar_widget.dart';
import 'package:raskop_fe_backoffice/src/menu/presentation/screens/menu_screen.dart';
import 'package:raskop_fe_backoffice/src/order/presentation/screens/order_screen.dart';
import 'package:raskop_fe_backoffice/src/reservation/presentation/screens/reservation_screen.dart';
import 'package:raskop_fe_backoffice/src/supplier/presentation/screens/supplier_screen.dart';

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
    //const TableScreen(),
    const SupplierScreen(),
  ];
  int index = -1;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.white,
        body: Row(
          children: [
            SizedBox(
              width: 55.w,
              child: SidebarWidget(
                changeIndex: (idx) {
                  setState(() {
                    index = idx;
                  });
                },
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
  }
}
