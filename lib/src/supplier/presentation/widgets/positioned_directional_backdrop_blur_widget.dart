// ignore_for_file: must_be_immutable

import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:raskop_fe_backoffice/shared/const.dart';

///
class PositionedDirectionalBackdropBlurWidget extends StatefulWidget {
  ///
  PositionedDirectionalBackdropBlurWidget({
    required this.isPanelVisible,
    required this.end,
    required this.content,
    required this.width,
    super.key,
  });

  ///
  bool isPanelVisible;

  ///
  final double end;

  ///
  final List<Widget> content;

  ///
  final double width;

  @override
  State<PositionedDirectionalBackdropBlurWidget> createState() =>
      _PositionedDirectionalBackdropBlurWidgetState();
}

class _PositionedDirectionalBackdropBlurWidgetState
    extends State<PositionedDirectionalBackdropBlurWidget> {
  @override
  Widget build(BuildContext context) {
    return AnimatedPositionedDirectional(
      duration: const Duration(milliseconds: 500),
      curve: Curves.easeInOut,
      top: 10.h,
      bottom: 12.h,
      end: widget.isPanelVisible ? 10.w : widget.end,
      width: widget.width,
      child: Material(
        color: hexToColor('#1F4940').withOpacity(0.2),
        borderRadius: const BorderRadius.all(
          Radius.circular(20),
        ),
        elevation: 10,
        child: ClipRRect(
          borderRadius: const BorderRadius.all(
            Radius.circular(20),
          ),
          child: Stack(
            children: [
              BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                child: Container(
                  color: hexToColor('#1F4940').withOpacity(0.2),
                ),
              ),
              Container(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: widget.content,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
