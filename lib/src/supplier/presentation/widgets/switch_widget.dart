// ignore_for_file: avoid_positional_boolean_parameters

import 'package:flutter/material.dart';
import 'package:raskop_fe_backoffice/shared/const.dart';

///
class CustomSwitch extends StatefulWidget {
  ///
  const CustomSwitch({required this.isON, required this.onSwitch, super.key});

  /// Status awal
  final bool isON;

  /// Callback saat switch diubah
  final Future<bool> Function(bool isActive) onSwitch;

  @override
  State<CustomSwitch> createState() => _CustomSwitchState();
}

class _CustomSwitchState extends State<CustomSwitch> {
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
        width: 90,
        height: 50,
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
                width: 40,
                height: 40,
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
                padding: const EdgeInsets.symmetric(horizontal: 7),
                child: Text(
                  _currentStatus ? 'ON' : 'OFF',
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
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
