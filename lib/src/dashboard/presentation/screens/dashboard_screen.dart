// ignore_for_file: public_member_api_docs

import 'package:fl_chart/fl_chart.dart';
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

  List<Color> gradientColors = [
    Colors.red,
    Colors.blue,
  ];

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
        backgroundColor: Colors.white,
        body: SingleChildScrollView(
          child: LayoutBuilder(
            builder: (context, constraints) {
              if (constraints.maxWidth > 700) {
                return Column(
                  children: [
                    _buildDashboardFilter(constraints.maxWidth),
                    Row(
                      spacing: 24,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Flexible(
                          flex: 3,
                          child: Column(
                            spacing: 24,
                            children: [
                              _buildDashboardChart(),
                              _buildDashboardChart(),
                              _buildDashboardChart(),
                            ],
                          ),
                        ),
                        Flexible(
                          flex: 2,
                          child: _buildDashboardMenu(constraints, context),
                        ),
                      ],
                    ),
                  ],
                );
              } else {
                return Column(
                  spacing: 24,
                  children: [
                    _buildDashboardFilter(constraints.maxWidth),
                    _buildDashboardMenu(constraints, context),
                    _buildDashboardChart(),
                    _buildDashboardChart(),
                    _buildDashboardChart(),
                    const SizedBox(height: 24)
                  ],
                );
              }
            },
          ),
        ),
      ),
    );
  }

  Container _buildDashboardChart() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        borderRadius: const BorderRadius.all(
          Radius.circular(16),
        ),
        gradient: LinearGradient(
          colors: [
            hexToColor('#1F4940').withOpacity(.7),
            hexToColor('#1F4940').withOpacity(.4),
          ],
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Penjualan',
            style: TextStyle(
              color: Colors.white,
              fontSize: 20,
              fontWeight: FontWeight.w600,
            ),
          ),
          AspectRatio(
            aspectRatio: 1.70,
            child: LineChart(
              LineChartData(
                gridData: FlGridData(
                  horizontalInterval: 1,
                  verticalInterval: 1,
                  getDrawingHorizontalLine: (value) {
                    return const FlLine(
                      color: Colors.black,
                      strokeWidth: .5,
                      dashArray: [8],
                    );
                  },
                  getDrawingVerticalLine: (value) {
                    return const FlLine(
                      color: Colors.transparent,
                      strokeWidth: 1,
                    );
                  },
                ),
                titlesData: FlTitlesData(
                  rightTitles: const AxisTitles(),
                  topTitles: const AxisTitles(),
                  bottomTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      reservedSize: 30,
                      interval: 1,
                      getTitlesWidget: bottomTitleWidgets,
                    ),
                  ),
                  leftTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      interval: 1,
                      getTitlesWidget: leftTitleWidgets,
                      reservedSize: 42,
                    ),
                  ),
                ),
                borderData: FlBorderData(show: false),
                minX: 0,
                maxX: 11,
                minY: 0,
                maxY: 6,
                lineBarsData: [
                  LineChartBarData(
                    spots: const [
                      FlSpot(0, 3),
                      FlSpot(2.6, 2),
                      FlSpot(4.9, 5),
                      FlSpot(6.8, 3.1),
                      FlSpot(8, 4),
                      FlSpot(9.5, 3),
                      FlSpot(11, 4),
                    ],
                    isCurved: true,
                    color: Colors.white,
                    barWidth: 5,
                    isStrokeCapRound: true,
                    dotData: const FlDotData(
                      show: false,
                    ),
                    belowBarData: BarAreaData(
                      show: true,
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          hexToColor('#FAFAFA'),
                          hexToColor('#CACACA'),
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

  Widget bottomTitleWidgets(double value, TitleMeta meta) {
    const style = TextStyle(
      fontWeight: FontWeight.bold,
      fontSize: 14,
      color: Colors.white,
    );
    Widget text;
    switch (value.toInt()) {
      case 2:
        text = const Text('MAR', style: style);
      case 5:
        text = const Text('JUN', style: style);
      case 8:
        text = const Text('SEP', style: style);
      default:
        text = const Text('', style: style);
    }

    return SideTitleWidget(
      meta: meta,
      child: text,
    );
  }

  Widget leftTitleWidgets(double value, TitleMeta meta) {
    const style = TextStyle(
      fontWeight: FontWeight.bold,
      fontSize: 14,
      color: Colors.white,
    );
    String text;
    switch (value.toInt()) {
      case 1:
        text = '10K';
      case 3:
        text = '30k';
      case 5:
        text = '50k';
      default:
        return Container();
    }

    return Text(text, style: style, textAlign: TextAlign.left);
  }

  Container _buildDashboardMenu(
    BoxConstraints constraints,
    BuildContext context,
  ) {
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        borderRadius: const BorderRadius.all(Radius.circular(16)),
        gradient: LinearGradient(
          colors: [
            hexToColor('#1F4940').withOpacity(.7),
            hexToColor('#1F4940').withOpacity(.4),
          ],
        ),
      ),
      child: Column(
        children: [
          const Row(
            children: [
              Expanded(
                child: Text(
                  'Menu Favorit',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                    fontWeight: FontWeight.w600,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              Icon(
                Icons.star_rounded,
                color: Colors.amberAccent,
              ),
            ],
          ),
          const SizedBox(height: 12),
          for (final int i in [1, 2, 3]) ...[
            Container(
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.all(
                  Radius.circular(16),
                ),
              ),
              child: Stack(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(12),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      spacing: 16,
                      children: [
                        const SizedBox(
                          width: 125,
                          height: 125,
                          child: Placeholder(
                            child: Center(
                              child: Text(
                                'INI FOTO MAKANAN',
                                textAlign: TextAlign.center,
                              ),
                            ),
                          ),
                        ),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                'Steak With Paprica',
                                style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              Text(
                                'Food',
                                style: TextStyle(
                                  color: hexToColor('#CACACA'),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  Positioned(
                    right: 10,
                    bottom: 10,
                    child: Text(
                      'Terjual ${i}5 pcs',
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                  Positioned(
                    right: -5,
                    bottom: -10,
                    child: Text(
                      i.toString(),
                      style: TextStyle(
                        fontSize: 120,
                        height: 1,
                        color: hexToColor('#1F4940').withOpacity(.25),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
          ],
        ],
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
            maxWidth > 500 ? WrapAlignment.spaceBetween : WrapAlignment.center,
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
                      final date = await showDateRangePicker(
                        context: context,
                        firstDate: DateTime(2025),
                        lastDate: DateTime.now().add(
                          const Duration(days: 30),
                        ),
                      );
                      if (date?.start != null || date?.end != null) {
                        setState(() {
                          filter = 'Tanggal';
                        });
                      }
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
