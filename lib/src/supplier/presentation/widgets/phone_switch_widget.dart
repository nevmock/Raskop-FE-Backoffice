import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:raskop_fe_backoffice/shared/const.dart';

///
class PhoneSwitchWidget extends StatefulWidget {
  ///
  const PhoneSwitchWidget({super.key});

  @override
  State<PhoneSwitchWidget> createState() => _PhoneSwitchWidgetState();
}

class _PhoneSwitchWidgetState extends State<PhoneSwitchWidget> {
  bool isOn = false;

  void toggleSwitch() {
    setState(() {
      isOn = !isOn;
    });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: toggleSwitch,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
        width: MediaQuery.of(context).size.width * 0.25,
        height: MediaQuery.of(context).size.height * 0.05,
        padding: const EdgeInsets.all(5),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(25),
          color: isOn ? hexToColor('#34C759') : hexToColor('#CACACA'),
        ),
        child: Stack(
          children: [
            AnimatedAlign(
              duration: const Duration(milliseconds: 300),
              curve: Curves.easeInOut,
              alignment: isOn ? Alignment.centerRight : Alignment.centerLeft,
              child: Container(
                width: MediaQuery.of(context).size.width * 0.08,
                height: MediaQuery.of(context).size.width * 0.08,
                decoration: const BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.circle,
                ),
              ),
            ),
            AnimatedAlign(
              duration: const Duration(milliseconds: 300),
              curve: Curves.easeInOut,
              alignment: isOn ? Alignment.centerLeft : Alignment.centerRight,
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 10.w),
                child: Text(
                  isOn ? 'ON' : 'OFF',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 10.sp,
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
