// ignore_for_file: avoid_positional_boolean_parameters

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:iconify_flutter/iconify_flutter.dart';
import 'package:raskop_fe_backoffice/shared/const.dart';
import 'package:iconify_flutter/icons/bxs.dart';
import 'package:iconify_flutter/icons/icon_park_solid.dart';

///
class TableLocationSwitch extends StatefulWidget {
  /// Constructor
  const TableLocationSwitch(
      {required this.isOutdoor, required this.onSwitch, super.key});

  /// Status awal
  final bool isOutdoor;

  /// Callback saat switch diubah
  final Future<bool> Function(bool isOutdoor) onSwitch;

  @override
  State<TableLocationSwitch> createState() => _TableLocationSwitchState();
}

class _TableLocationSwitchState extends State<TableLocationSwitch> {
  late bool _currentStatus;

  @override
  void initState() {
    super.initState();
    _currentStatus = widget.isOutdoor; // Set awal dari parent
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
                padding: EdgeInsets.symmetric(horizontal: 8.w),
                child: _currentStatus
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
