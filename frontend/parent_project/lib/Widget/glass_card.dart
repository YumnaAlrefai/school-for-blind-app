import 'dart:ui';
import 'package:flutter/material.dart';
import 'app_colors.dart';

class GlassCard extends StatelessWidget {
  final Widget child;
  final Color? tintColor;
  final Color? borderColor;

  const GlassCard({
    super.key,
    required this.child,
    this.tintColor,
    this.borderColor,
  });

  @override
  Widget build(BuildContext context) {
    final Color effectiveTint = tintColor ?? AppColors.glassTint;
    final Color effectiveBorder = borderColor ?? AppColors.glassBorder;

    return ClipRRect(
      borderRadius: BorderRadius.circular(20),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 30, sigmaY: 30),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                effectiveTint,
                effectiveTint.withOpacity(effectiveTint.opacity * 0.6),
              ],
            ),
            border: Border(
              top: BorderSide(color: effectiveBorder, width: 0.15),
              bottom: BorderSide(color: effectiveBorder, width: 0.15),
              left: BorderSide(color: effectiveBorder, width: 0.11),
              right: BorderSide(color: effectiveBorder, width: 0.11),
            ),
          ),
          child: child,
        ),
      ),
    );
  }
}