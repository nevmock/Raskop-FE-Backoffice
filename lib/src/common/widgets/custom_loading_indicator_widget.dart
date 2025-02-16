import 'package:flutter/material.dart';

/// Custom Loading Indicator
class CustomLoadingIndicator extends StatefulWidget {
  ///constructor
  const CustomLoadingIndicator({
    super.key,
    this.color = Colors.brown,
    this.boxWidth = 10.0,
    this.boxHeight = 20.0,
    this.boxCount = 5,
    this.duration = const Duration(seconds: 1),
  });

  /// Color
  final Color color;

  /// width
  final double boxWidth;

  /// height
  final double boxHeight;

  /// count
  final int boxCount;

  ///duration
  final Duration duration;

  @override
  _CustomLoadingIndicatorState createState() => _CustomLoadingIndicatorState();
}

class _CustomLoadingIndicatorState extends State<CustomLoadingIndicator>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late List<Animation<double>> _animations;

  @override
  void initState() {
    super.initState();

    // 1. Inisialisasi AnimationController
    _controller = AnimationController(
      vsync: this,
      duration: widget.duration,
    )..repeat(reverse: true);
    // repeat(reverse: true) agar animasi naik-turun terus berulang

    // 2. Buat list animasi untuk tiap kotak
    //    Misal: box pertama mulai animasi di 0.0 hingga 0.5,
    //           box kedua mulai di 0.1 hingga 0.6, dst.
    //    Ini menciptakan efek “bergelombang”.
    _animations = List.generate(widget.boxCount, (index) {
      final start = index * 0.1;
      final end = start + 0.5;
      return Tween<double>(begin: 0, end: 1).animate(
        CurvedAnimation(
          parent: _controller,
          curve: Interval(start, end, curve: Curves.easeInOut),
        ),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: List.generate(widget.boxCount, (index) {
        return AnimatedBuilder(
          animation: _controller,
          builder: (context, child) {
            // Ambil nilai animasi (0.0 s/d 1.0)
            final value = _animations[index].value;

            // Ubah tinggi box agar tampak naik-turun
            final currentHeight = widget.boxHeight * (0.5 + value * 0.5);

            return Container(
              margin: const EdgeInsets.symmetric(horizontal: 2),
              width: widget.boxWidth,
              height: currentHeight,
              color: widget.color,
            );
          },
        );
      }),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}
