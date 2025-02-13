// ignore_for_file: public_member_api_docs

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:multi_dropdown/multi_dropdown.dart';
import 'package:raskop_fe_backoffice/shared/const.dart';

///
class DashboardScreen extends StatefulWidget {
  ///
  const DashboardScreen({super.key});

  ///
  static const String route = 'dashboar';

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  final statusTabletController = MultiSelectController<String>();
  final statusPhoneController = MultiSelectController<String>();

  String filter = 'Hari ini';

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
        backgroundColor: Colors.white,
        body: LayoutBuilder(
          builder: (context, constraints) {
            if (constraints.maxWidth > 470) {
              return Column(
                children: [
                  _buildDashboardFilter(constraints.maxWidth),
                  Row(),
                ],
              );
            } else {
              return Column(
                children: [
                  _buildDashboardFilter(constraints.maxWidth),
                  const Row(
                    children: [],
                  ),
                ],
              );
            }
          },
        ),
      ),
    );
  }

  Widget _buildDashboardFilter(double maxWidth) {
    return Container(
      margin: const EdgeInsets.symmetric(
        vertical: 24,
        horizontal: 12,
      ),
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        borderRadius: const BorderRadius.all(Radius.circular(16)),
        border: Border.all(
          color: Colors.white38,
        ),
        color: Colors.white,
        boxShadow: const [
          BoxShadow(
            color: Colors.black12,
            spreadRadius: 4,
            blurRadius: 10,
            offset: Offset(3, 3),
          ),
        ],
      ),
      child: Wrap(
        alignment:
            maxWidth > 470 ? WrapAlignment.spaceBetween : WrapAlignment.center,
        children: [
          const Row(), // Stretching Widget to max width
          Image.asset(
            'assets/img/raskop.png',
            width: 100.w,
            height: 50.h,
            scale: 1 / 5,
          ),
          PhysicalModel(
            color: Colors.grey.shade100,
            borderRadius: const BorderRadius.all(Radius.circular(50)),
            elevation: 5,
            child: AnimatedContainer(
              decoration: BoxDecoration(
                color: Colors.white,
                border: Border.all(color: hexToColor('#E1E1E1')),
                borderRadius: const BorderRadius.all(Radius.circular(50)),
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
                      backgroundColor: filter == 'Hari ini'
                          ? hexToColor('#1F4940')
                          : Colors.transparent,
                      shape: const RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(Radius.circular(50)),
                      ),
                    ),
                    onPressed: () async {
                      setState(() {
                        filter = 'Hari ini';
                      });
                    },
                    child: Center(
                      child: Text(
                        'Hari ini',
                        style: TextStyle(
                          color: filter == 'Hari ini'
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
                      backgroundColor: filter == 'Bulan ini'
                          ? hexToColor('#1F4940')
                          : Colors.transparent,
                      shape: const RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(Radius.circular(50)),
                      ),
                    ),
                    onPressed: () async {
                      setState(() {
                        filter = 'Bulan ini';
                      });
                    },
                    child: Center(
                      child: Text(
                        'Bulan ini',
                        style: TextStyle(
                          color: filter == 'Bulan ini'
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
                      backgroundColor: filter == 'Tanggal'
                          ? hexToColor('#1F4940')
                          : Colors.transparent,
                      shape: const RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(Radius.circular(50)),
                      ),
                    ),
                    onPressed: () async {
                      setState(() {
                        filter = 'Tanggal';
                      });
                    },
                    child: Center(
                      child: Row(
                        children: [
                          Icon(
                            Icons.date_range,
                            color: filter == 'Tanggal'
                                ? Colors.white
                                : hexToColor('#1F4940'),
                          ),
                          const SizedBox(width: 8),
                          Text(
                            'Tanggal',
                            style: TextStyle(
                              color: filter == 'Tanggal'
                                  ? Colors.white
                                  : hexToColor('#1F4940'),
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
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
        ],
      ),
    );
  }
}
