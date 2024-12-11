import 'package:flutter/material.dart';
import 'package:raskop_fe_backoffice/src/common/widgets/sidebar_widget.dart';

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
    //const OrderScreen(),
    //const MenuScreen(),
    //const ReservationScreen(),
    //const TableScreen(),
    //const SupplierScreen(),
  ];
  int index = -1;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Row(
        children: [
          Flexible(
            child: SidebarWidget(
              changeIndex: (idx) {
                setState(() {
                  index = idx;
                });
              },
            ),
          ),
          const Spacer(),
          if (screens.isNotEmpty && index != -1)
            Flexible(child: screens[index])
          else
            Flexible(
              child: Text(widget.title),
            ),
        ],
      ),
    );
  }
}
