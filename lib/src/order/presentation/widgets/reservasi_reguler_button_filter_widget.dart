import 'package:flutter/material.dart';
import 'package:raskop_fe_backoffice/core/core.dart';
import 'package:raskop_fe_backoffice/shared/const.dart';

///
class ReservasiRegulerButtonFilterWidget extends StatefulWidget {
  ///
  const ReservasiRegulerButtonFilterWidget({
    required this.onReservasi,
    required this.onReguler,
    required this.isWideScreen,
    super.key,
  });

  ///
  final FutureVoid onReservasi;

  ///
  final FutureVoid onReguler;

  ///
  final bool isWideScreen;

  @override
  State<ReservasiRegulerButtonFilterWidget> createState() =>
      _ReservasiRegulerButtonFilterWidgetState();
}

class _ReservasiRegulerButtonFilterWidgetState
    extends State<ReservasiRegulerButtonFilterWidget> {
  bool isReservasi = true;

  void onReservasi() {
    setState(() {
      isReservasi = true;
    });
  }

  void onReguler() {
    setState(() {
      isReservasi = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return PhysicalModel(
      color: Colors.white38,
      borderRadius: const BorderRadius.all(Radius.circular(50)),
      elevation: 5,
      child: AnimatedContainer(
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border.all(color: hexToColor('#E1E1E1')),
          borderRadius: const BorderRadius.all(Radius.circular(50)),
        ),
        duration: const Duration(milliseconds: 100),
        padding: EdgeInsets.symmetric(
          horizontal: 5,
          vertical: widget.isWideScreen ? 5 : 2,
        ),
        child: Row(
          children: [
            TextButton(
              style: TextButton.styleFrom(
                padding: EdgeInsets.symmetric(
                  horizontal: widget.isWideScreen ? 20 : 10,
                  vertical: widget.isWideScreen ? 10 : 5,
                ),
                backgroundColor:
                    isReservasi ? hexToColor('#1F4940') : Colors.white,
                shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(50)),
                ),
              ),
              onPressed: () async {
                if (!isReservasi) {
                  await widget.onReservasi;
                  onReservasi();
                }
              },
              child: Center(
                child: Text(
                  'Reservasi',
                  style: TextStyle(
                    color: isReservasi ? Colors.white : hexToColor('#1F4940'),
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ),
            TextButton(
              style: TextButton.styleFrom(
                padding: EdgeInsets.symmetric(
                  horizontal: widget.isWideScreen ? 20 : 10,
                  vertical: widget.isWideScreen ? 10 : 5,
                ),
                backgroundColor:
                    isReservasi ? Colors.white : hexToColor('#1F4940'),
                shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(50)),
                ),
              ),
              onPressed: () async {
                if (isReservasi) {
                  await widget.onReguler;
                  onReguler();
                }
              },
              child: Center(
                child: Text(
                  'Reguler',
                  style: TextStyle(
                    color: isReservasi ? hexToColor('#1F4940') : Colors.white,
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
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
