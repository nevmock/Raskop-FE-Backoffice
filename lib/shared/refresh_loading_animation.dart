import 'dart:math';

import 'package:flutter/material.dart';
import 'package:raskop_fe_backoffice/res/assets.dart';
import 'package:raskop_fe_backoffice/shared/const.dart';

///
class RefreshLoadingAnimation extends StatefulWidget {
  ///
  const RefreshLoadingAnimation(
      {required this.children, required this.onRefresh, super.key});

  @override
  _RefreshLoadingAnimationState createState() =>
      _RefreshLoadingAnimationState();

  ///
  final List<Widget> children;

  ///
  final Future<void> Function() onRefresh;
}

class _RefreshLoadingAnimationState extends State<RefreshLoadingAnimation>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  bool isRefreshing = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(seconds: 3),
      vsync: this,
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> startRefresh() async {
    setState(() {
      isRefreshing = true;
      _controller.repeat();
    });
    await widget.onRefresh();
    Future.delayed(const Duration(seconds: 1), () {
      setState(() {
        isRefreshing = false;
        _controller.stop();
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return CustomPaint(
          painter: isRefreshing
              ? BorderPainter(_controller.value)
              : NormalBorderPainter(),
          child: AnimatedContainer(
            padding: const EdgeInsets.symmetric(
              horizontal: 5,
              vertical: 15,
            ),
            duration: const Duration(milliseconds: 100),
            decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.all(
                Radius.circular(15),
              ),
            ),
            child: Row(
              children: [
                Flexible(
                  child: Tooltip(
                    triggerMode: TooltipTriggerMode.longPress,
                    message: 'Refresh on Double Tap',
                    verticalOffset: -15,
                    margin: const EdgeInsets.only(left: 100),
                    child: GestureDetector(
                      onDoubleTap: () async {
                        await startRefresh();
                      },
                      child: Padding(
                        padding: const EdgeInsets.only(
                          left: 20,
                        ),
                        child: Image.asset(ImageAssets.raskop),
                      ),
                    ),
                  ),
                ),
                const Spacer(),
                ...widget.children,
              ],
            ),
          ),
        );
      },
    );
  }
}

// 🎨 Painter untuk efek border animasi
///
class BorderPainter extends CustomPainter {
  ///
  BorderPainter(this.animationValue);

  ///
  final double animationValue;

  @override
  void paint(Canvas canvas, Size size) {
    final rect = Rect.fromLTWH(0, 0, size.width, size.height);
    final Gradient gradient = SweepGradient(
      transform: GradientRotation(animationValue * 2 * pi),
      colors: [
        hexToColor('#38ACA7'),
        hexToColor('#F6DCCD'),
        hexToColor('#38ACA7'),
        hexToColor('#F6DCCD'),
        hexToColor('#38ACA7'),
      ],
      //stops: const [0.0, 0.2, 0.3, 0.4, 0.6, 0.8, 1.0],
      stops: const [0.0, 0.25, 0.5, 0.75, 1.0],
    );

    final paint = Paint()
      ..shader = gradient.createShader(rect)
      ..strokeWidth = 10
      ..style = PaintingStyle.stroke
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 5);

    final borderRect = RRect.fromRectAndRadius(rect, const Radius.circular(15));
    canvas.drawRRect(borderRect, paint);
  }

  @override
  bool shouldRepaint(BorderPainter oldDelegate) {
    return oldDelegate.animationValue != animationValue;
  }
}

// 🖌 Painter untuk border normal
///
class NormalBorderPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = const Color(0xFFE1E1E1) // Warna border default
      ..strokeWidth = 6
      ..style = PaintingStyle.stroke;

    final rect = Rect.fromLTWH(0, 0, size.width, size.height);
    final borderRect = RRect.fromRectAndRadius(rect, const Radius.circular(15));
    canvas.drawRRect(borderRect, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}
