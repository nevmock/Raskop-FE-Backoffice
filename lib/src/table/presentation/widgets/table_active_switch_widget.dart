// ignore_for_file: avoid_positional_boolean_parameters

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:raskop_fe_backoffice/shared/const.dart';

///
class TableActiveSwitchWidget extends StatefulWidget {
  /// Constructor
  const TableActiveSwitchWidget(
      {required this.isON, required this.onSwitch, super.key});

  /// Status awal
  final bool isON;

  /// Callback saat switch diubah
  final Future<bool> Function(bool isActive) onSwitch;

  @override
  State<TableActiveSwitchWidget> createState() =>
      _TableActiveSwitchWidgetState();
}

class _TableActiveSwitchWidgetState extends State<TableActiveSwitchWidget> {
  late bool _currentStatus;

  @override
  void initState() {
    super.initState();
    _currentStatus = widget.isON; // Set awal dari parent
  }

  Future<void> _handleTap() async {
    final newStatus = !_currentStatus; // Optimistic update
    setState(() => _currentStatus = newStatus);

    final success = await widget.onSwitch(newStatus);

    if (!success) {
      setState(() => _currentStatus = !newStatus); // Rollback jika gagal
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: _handleTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
        width: MediaQuery.of(context).size.width * 0.25,
        height: MediaQuery.of(context).size.height * 0.05,
        padding: const EdgeInsets.all(5),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(25),
          color: _currentStatus ? hexToColor('#34C759') : hexToColor('#CACACA'),
        ),
        child: Stack(
          children: [
            AnimatedAlign(
              duration: const Duration(milliseconds: 300),
              curve: Curves.easeInOut,
              alignment:
                  _currentStatus ? Alignment.centerRight : Alignment.centerLeft,
              child: Container(
                width: 45,
                height: 45,
                decoration: const BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.circle,
                ),
              ),
            ),
            AnimatedAlign(
              duration: const Duration(milliseconds: 300),
              curve: Curves.easeInOut,
              alignment:
                  _currentStatus ? Alignment.centerLeft : Alignment.centerRight,
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 10.w),
                child: Text(
                  _currentStatus ? 'ON' : 'OFF',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 12.sp,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
