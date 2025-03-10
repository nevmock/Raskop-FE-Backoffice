// ignore_for_file: public_member_api_docs, avoid_dynamic_calls

import 'dart:developer';

import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:multi_dropdown/multi_dropdown.dart';
import 'package:raskop_fe_backoffice/shared/const.dart';
import 'package:raskop_fe_backoffice/src/common/widgets/custom_loading_indicator_widget.dart';
import 'package:raskop_fe_backoffice/src/dashboard/application/dashboard_controller.dart';

///
class DashboardScreen extends ConsumerStatefulWidget {
  ///
  const DashboardScreen({super.key});

  ///
  static const String route = 'dashboard';

  @override
  ConsumerState<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends ConsumerState<DashboardScreen> {
  AsyncValue<List<dynamic>> get datas =>
      ref.watch(dashboardControllerProvider.call());

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
                              _buildDashboardChart('total_sales'),
                              _buildDashboardChart('total_orders'),
                              _buildDashboardChart('total_items_sold'),
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
                    _buildDashboardChart('total_sales'),
                    _buildDashboardChart('total_orders'),
                    _buildDashboardChart('total_items_sold'),
                    const SizedBox(height: 24),
                  ],
                );
              }
            },
          ),
        ),
      ),
    );
  }

  Container _buildDashboardChart(String tipe) {
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
          Text(
            tipe == 'total_sales'
                ? 'Total Sales'
                : tipe == 'total_orders'
                    ? 'Total Orders'
                    : 'Total Items Sold',
            style: const TextStyle(
              color: Colors.white,
              fontSize: 20,
              fontWeight: FontWeight.w600,
            ),
          ),
          AspectRatio(
            aspectRatio: 1.70,
            child: datas.when(
              data: (data) {
                // Check if all entries are from the same month
                if (datas.value?.isEmpty ?? true) {
                  return const Center(
                    child: Text(
                      'Data Kosong',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 24,
                      ),
                    ),
                  );
                }
                final chartData = (datas.value ?? [])[1] as List;
                if (chartData.isEmpty) {
                  return const Center(
                    child: Text(
                      'Data Kosong',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 24,
                      ),
                    ),
                  );
                }
                var isSameMonth = true;
                var firstMonth = -1;

                for (final item in dynamicToMaps(chartData)) {
                  log(item.toString());
                  final month =
                      int.parse(item['sales_date'].toString().split('-')[1]);
                  if (firstMonth == -1) {
                    firstMonth = month;
                  } else if (month != firstMonth) {
                    isSameMonth = false;
                    break;
                  }
                }

                if (isSameMonth && firstMonth != -1) {
                  // If all data is from the same month, aggregate by day
                  return _buildDailyChart(
                    dynamicToMaps(chartData),
                    tipe,
                    data,
                  );
                } else {
                  // If data spans multiple months, aggregate by month
                  return _buildMonthlyChart(
                    dynamicToMaps(chartData),
                    tipe,
                    data,
                  );
                }
              },
              error: (error, stackTrace) {
                return Text(
                  'Error: $error',
                  style: const TextStyle(color: Colors.white),
                );
              },
              loading: () {
                return const Center(child: CustomLoadingIndicator());
              },
            ),
          ),
        ],
      ),
    );
  }

  List<Map<String, dynamic>> dynamicToMaps(List<dynamic> list) {
    return list.map((item) {
      if (item is Map) {
        // Cast each map to the correct type
        return Map<String, dynamic>.from(item);
      }
      // Handle non-map items (return empty map, skip, or throw error)
      return <String, dynamic>{};
    }).toList();
  }

  Widget _buildMonthlyChart(
    List<Map<String, dynamic>> datas,
    String tipe,
    dynamic data,
  ) {
    // Agregasi data per bulan
    final monthlyData = <int, Map<String, dynamic>>{};

    // Create default entries for all 12 months
    for (var month = 1; month <= 12; month++) {
      monthlyData[month] = {
        'month': month,
        'total_sales': 0,
        'total_orders': 0,
        'total_items_sold': 0,
      };
    }

    for (final item in datas) {
      // Ekstrak bulan dari tanggal
      final month = int.parse(item['sales_date'].toString().split('-')[1]);

      // Akumulasi data
      monthlyData[month]!['total_sales'] += item['total_sales'];
      monthlyData[month]!['total_orders'] += item['total_orders'];
      monthlyData[month]!['total_items_sold'] += item['total_items_sold'];
    }

    // Konversi ke List dan urutkan berdasarkan bulan
    final aggregatedData = monthlyData.values.toList()
      ..sort(
        (a, b) => (a['month'] as int).compareTo(b['month'] as int),
      );

    if (data.isNotEmpty == true) {
      // Hitung nilai maksimum untuk skala sumbu Y
      var maxY = aggregatedData
          .map(
            (e) => tipe == 'total_sales'
                ? (e[tipe] as int) /
                    1000 // Konversi ke ribuan untuk tampilan lebih baik
                : (e[tipe] as int).toDouble(),
          )
          .reduce((curr, next) => curr > next ? curr : next);

      // Tambahkan padding 10% pada nilai maksimum Y
      maxY = maxY * 1.1;

      return LineChart(
        LineChartData(
          gridData: FlGridData(
            horizontalInterval: maxY / 5, // Bagi sumbu Y menjadi 5 bagian
            verticalInterval: 1,
            getDrawingHorizontalLine: (value) {
              return const FlLine(
                color: Colors.white24,
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
                getTitlesWidget: (value, meta) => _bottomTitleWidgetsMonthly(
                  value,
                  meta,
                  aggregatedData,
                ),
              ),
            ),
            leftTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                interval: maxY / 5, // Bagi sumbu Y menjadi 5 bagian
                getTitlesWidget: _leftTitleWidgets,
                reservedSize: 50,
              ),
            ),
          ),
          borderData: FlBorderData(show: false),
          minX: 0,
          maxX: aggregatedData.isNotEmpty
              ? 0 // This is wrong - should be aggregatedData.length - 1.0
              : aggregatedData.length - 1.0,
          minY: 0,
          maxY: maxY,
          lineBarsData: [
            LineChartBarData(
              spots: List.generate(aggregatedData.length, (index) {
                // Konversi data ke FlSpot
                final yValue = tipe == 'total_sales'
                    ? (aggregatedData[index][tipe] as int) /
                        1000 // Konversi ke ribuan untuk total_sales
                    : (aggregatedData[index][tipe] as int).toDouble();

                return FlSpot(index.toDouble(), yValue);
              }),
              isCurved: true,
              color: Colors.white,
              barWidth: 3,
              isStrokeCapRound: true,
              dotData: FlDotData(
                getDotPainter: (spot, percent, barData, index) {
                  // Don't show dots for zero values
                  if (aggregatedData[index][tipe] == 0) {
                    return FlDotCirclePainter(
                      radius: 0,
                      color: Colors.transparent,
                    );
                  }
                  return FlDotCirclePainter(
                    radius: 4,
                    color: Colors.white,
                    strokeWidth: 2,
                    strokeColor: hexToColor('#1F4940'),
                  );
                },
              ),
              belowBarData: BarAreaData(
                show: true,
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    hexToColor('#FAFAFA').withOpacity(0.5),
                    hexToColor('#CACACA').withOpacity(0.1),
                  ],
                ),
              ),
            ),
          ],
        ),
      );
    } else {
      return const Center(
        child: Text(
          'Data Kosong',
          style: TextStyle(color: Colors.white),
          textAlign: TextAlign.left,
        ),
      );
    }
  }

  Widget _buildDailyChart(
    List<Map<String, dynamic>> datas,
    String tipe,
    dynamic data,
  ) {
    // Aggregate data by day
    final dailyData = <String, Map<String, dynamic>>{};

    // Parse and prepare data
    for (final item in datas) {
      final dateStr = item['sales_date'].toString();
      final dateParts = dateStr.split('-');
      final day = int.parse(dateParts[2]);
      final month = int.parse(dateParts[1]);

      final dayKey = '$month-$day'; // Format: MM-DD

      if (!dailyData.containsKey(dayKey)) {
        dailyData[dayKey] = {
          'day': day,
          'month': month,
          'date_key': dayKey,
          'total_sales': 0,
          'total_orders': 0,
          'total_items_sold': 0,
        };
      }

      // Accumulate data
      dailyData[dayKey]!['total_sales'] += item['total_sales'];
      dailyData[dayKey]!['total_orders'] += item['total_orders'];
      dailyData[dayKey]!['total_items_sold'] += item['total_items_sold'];
    }

    // Convert to list and sort by day
    final aggregatedData = dailyData.values.toList()
      ..sort((a, b) => (a['day'] as int).compareTo(b['day'] as int));

    if (data.isNotEmpty == true) {
      // Calculate maximum Y value for scale
      var maxY = aggregatedData
          .map(
            (e) => tipe == 'total_sales'
                ? (e[tipe] as int) / 1000
                : (e[tipe] as int).toDouble(),
          )
          .reduce((curr, next) => curr > next ? curr : next);

      // Add 10% padding to maximum Y
      maxY = maxY * 1.1;

      // Get the month name for the title
      final months = [
        'Januari',
        'Februari',
        'Maret',
        'April',
        'Mei',
        'Juni',
        'Juli',
        'Agustus',
        'September',
        'Oktober',
        'November',
        'Desember',
      ];
      final monthIndex =
          aggregatedData.isNotEmpty ? aggregatedData[0]['month'] as int : 1;
      final monthName = months[monthIndex - 1];

      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(bottom: 8),
            child: Text(
              'Data Harian: $monthName',
              style: const TextStyle(
                color: Colors.white,
                fontSize: 14,
                fontWeight: FontWeight.w400,
              ),
            ),
          ),
          Expanded(
            child: LineChart(
              LineChartData(
                gridData: FlGridData(
                  horizontalInterval: maxY / 5,
                  verticalInterval: 1,
                  getDrawingHorizontalLine: (value) {
                    return const FlLine(
                      color: Colors.white24,
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
                      getTitlesWidget: (value, meta) =>
                          _bottomTitleWidgetsDaily(
                        value,
                        meta,
                        aggregatedData,
                      ),
                    ),
                  ),
                  leftTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      interval: maxY / 5,
                      getTitlesWidget: _leftTitleWidgets,
                      reservedSize: 50,
                    ),
                  ),
                ),
                borderData: FlBorderData(show: false),
                minX: 0,
                maxX: aggregatedData.length - 1.0,
                minY: 0,
                maxY: maxY,
                lineBarsData: [
                  LineChartBarData(
                    spots: List.generate(aggregatedData.length, (index) {
                      final yValue = tipe == 'total_sales'
                          ? (aggregatedData[index][tipe] as int) / 1000
                          : (aggregatedData[index][tipe] as int).toDouble();

                      return FlSpot(index.toDouble(), yValue);
                    }),
                    isCurved: true,
                    color: Colors.white,
                    barWidth: 3,
                    isStrokeCapRound: true,
                    dotData: FlDotData(
                      getDotPainter: (spot, percent, barData, index) {
                        return FlDotCirclePainter(
                          radius: 4,
                          color: Colors.white,
                          strokeWidth: 2,
                          strokeColor: hexToColor('#1F4940'),
                        );
                      },
                    ),
                    belowBarData: BarAreaData(
                      show: true,
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          hexToColor('#FAFAFA').withOpacity(0.5),
                          hexToColor('#CACACA').withOpacity(0.1),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      );
    } else {
      return const Center(
        child: Text(
          'Data Kosong',
          style: TextStyle(color: Colors.white),
          textAlign: TextAlign.left,
        ),
      );
    }
  }

  Widget _bottomTitleWidgetsMonthly(
    double value,
    TitleMeta meta,
    List<Map<String, dynamic>> aggregatedData,
  ) {
    const style = TextStyle(
      fontWeight: FontWeight.bold,
      fontSize: 12,
      color: Colors.white,
    );

    // Nama bulan
    final months = [
      'JAN',
      'FEB',
      'MAR',
      'APR',
      'MEI',
      'JUN',
      'JUL',
      'AGS',
      'SEP',
      'OKT',
      'NOV',
      'DES',
    ];

    // Hanya tampilkan teks untuk nilai bulat
    if (value.toInt() != value) {
      return const SizedBox.shrink();
    }

    // Pengecekan indeks di dalam rentang
    if (value.toInt() < 0 || value.toInt() >= aggregatedData.length) {
      return const SizedBox.shrink();
    }

    // Ambil bulan dari data yang sudah diagregasi
    final monthIndex = aggregatedData[value.toInt()]['month'] as int;
    final text = Text(months[monthIndex - 1], style: style);

    return SideTitleWidget(
      meta: meta,
      child: text,
    );
  }

  Widget _bottomTitleWidgetsDaily(
    double value,
    TitleMeta meta,
    List<Map<String, dynamic>> aggregatedData,
  ) {
    const style = TextStyle(
      fontWeight: FontWeight.bold,
      fontSize: 12,
      color: Colors.white,
    );

    // Only show text for integer values
    if (value.toInt() != value) {
      return const SizedBox.shrink();
    }

    // Check if index is within range
    if (value.toInt() < 0 || value.toInt() >= aggregatedData.length) {
      return const SizedBox.shrink();
    }

    // Get day from aggregated data
    final day = aggregatedData[value.toInt()]['day'] as int;
    final text = Text(day.toString(), style: style);

    return SideTitleWidget(
      meta: meta,
      child: text,
    );
  }

  Widget _leftTitleWidgets(double value, TitleMeta meta) {
    const style = TextStyle(
      fontWeight: FontWeight.bold,
      fontSize: 12,
      color: Colors.white,
    );

    // Format angka besar untuk keterbacaan yang lebih baik
    String formattedValue;
    if (value >= 1000) {
      formattedValue = '${(value / 1000).toStringAsFixed(1)}K';
    } else {
      formattedValue = value.toInt().toString();
    }

    return Text(formattedValue, style: style, textAlign: TextAlign.left);
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
          const SizedBox(height: 4),
          datas.when(
            data: (data) {
              if (datas.value?.isNotEmpty ?? true) {
                return const Center(
                  child: Text(
                    'Data Kosong',
                    style: TextStyle(color: Colors.white),
                    textAlign: TextAlign.left,
                  ),
                );
              } else {
                if (datas.value?.isEmpty ?? true) {
                  return const Center(
                    child: Text(
                      'Data Kosong',
                      style: TextStyle(color: Colors.white),
                      textAlign: TextAlign.left,
                    ),
                  );
                }
                final data = (datas.value ?? [])[0] as List;
                return Column(
                  children: [
                    if (data[0].isNotEmpty == true)
                      for (final menu in datas.value ?? []) ...[
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
                                    SizedBox(
                                      width: 125,
                                      height: 125,
                                      child: Image.network(
                                        menu.image_uri.toString(),
                                        errorBuilder:
                                            (context, object, stackTrace) {
                                          return const Text('Error');
                                        },
                                      ),
                                    ),
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            menu.menu_name.toString(),
                                            style: const TextStyle(
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
                                  'Terjual ${menu.qty.toInt()} pcs',
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
                                  ((datas.value ?? []).indexOf(menu) + 1)
                                      .toString(),
                                  style: TextStyle(
                                    fontSize: 120,
                                    height: 1,
                                    color:
                                        hexToColor('#1F4940').withOpacity(.25),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 16),
                      ]
                    else
                      const Text(
                        'Data Kosong',
                        style: TextStyle(color: Colors.white),
                        textAlign: TextAlign.left,
                      ),
                  ],
                );
              }
            },
            error: (error, stackTrace) {
              return const Text('Error');
            },
            loading: () {
              return const Center(child: CustomLoadingIndicator());
            },
          ),
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
                      final now = DateTime.now();
                      final format = DateFormat('yyyy-MM-dd');
                      final start = format
                          .format(DateTime(now.year, now.month, now.day - 1));
                      final end =
                          format.format(DateTime(now.year, now.month, now.day));
                      await ref
                          .read(dashboardControllerProvider.call(start, end));
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
                  const SizedBox(width: 4),
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
                      final now = DateTime.now();
                      final format = DateFormat('yyyy-MM-dd');
                      final start =
                          format.format(DateTime(now.year, now.month));
                      final end =
                          format.format(DateTime(now.year, now.month + 1, 0));
                      await ref
                          .read(dashboardControllerProvider.call(start, end));
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
                  const SizedBox(width: 4),
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
                        currentDate: DateTime.now(),
                        firstDate: DateTime(0),
                        lastDate: DateTime(DateTime.now().year + 5),
                      );
                      if (date?.start != null || date?.end != null) {
                        setState(() {
                          filter = 'Tanggal';
                        });
                        final format = DateFormat('yyyy-MM-dd');
                        final start = format.format(date!.start);
                        final end = format.format(date.end);
                        await ref
                            .read(dashboardControllerProvider.call(start, end));
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
