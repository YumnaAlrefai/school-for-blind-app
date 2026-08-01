import 'dart:math';

import 'package:flutter/material.dart';


class AudioWaveform extends StatefulWidget {
  const AudioWaveform({
    super.key,
    required this.isActive,
    required this.color,
    this.barCount = 13,
    this.maxHeight = 26,
  });

  final bool isActive;
  final Color color;
  final int barCount;
  final double maxHeight;

  @override
  State<AudioWaveform> createState() => _AudioWaveformState();
}

class _AudioWaveformState extends State<AudioWaveform>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final List<double> _seeds;

  @override
  void initState() {
    super.initState();
    final r = Random();
    _seeds = List.generate(widget.barCount, (_) => r.nextDouble());
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 700),
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, _) {
        return Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: List.generate(widget.barCount, (i) {
            final factor = widget.isActive
                ? 0.25 +
                    (sin((_controller.value * 2 * pi) + _seeds[i] * 6) * 0.5 +
                            0.5) *
                        0.75
                : 0.22 + _seeds[i] * 0.12;
            return Container(
              width: 2.5,
              height: widget.maxHeight * factor,
              margin: const EdgeInsets.symmetric(horizontal: 1),
              decoration: BoxDecoration(
                color: widget.color,
                borderRadius: BorderRadius.circular(2),
              ),
            );
          }),
        );
      },
    );
  }
}