import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:raskop_fe_backoffice/shared/const.dart';

///
class GroupButton extends StatefulWidget {
  ///
  const GroupButton({
    required this.isSelected,
    required this.onPressed,
    required this.borderRadius,
    required this.children,
    super.key,
  });

  ///
  final BorderRadiusGeometry? borderRadius;

  ///
  final List<bool> isSelected;

  ///
  final List<Widget> children;

  ///
  final void Function(int idx) onPressed;

  @override
  State<GroupButton> createState() => _GroupButtonState();
}

class _GroupButtonState extends State<GroupButton> {
  List<bool> get isSelected => widget.isSelected;

  void Function(int idx) get onPressed => widget.onPressed;

  @override
  Widget build(BuildContext context) {
    final btn = List<Widget>.generate(widget.children.length, (int idx) {
      return Padding(
        padding: EdgeInsets.symmetric(horizontal: 6.w),
        child: ClipRRect(
          borderRadius: widget.borderRadius ?? BorderRadius.zero,
          child: TextButton(
            style: TextButton.styleFrom(
              backgroundColor: isSelected[idx]
                  ? hexToColor('#1F4940')
                  : hexToColor('#CACACA'),
              visualDensity: VisualDensity.standard,
              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
              animationDuration: kThemeChangeDuration,
              enableFeedback: true,
              alignment: Alignment.center,
              splashFactory: InkRipple.splashFactory,
            ),
            onPressed: () {
              onPressed(idx);
            },
            child: widget.children[idx],
          ),
        ),
      );
    });
    return IntrinsicHeight(
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: btn,
        ),
      ),
    );
  }
}
