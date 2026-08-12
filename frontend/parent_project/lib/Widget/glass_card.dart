
import 'dart:ui';
import 'package:flutter/material.dart';

 class GlassCard extends StatelessWidget {
  final Widget child;
  const GlassCard({required this.child});

  @override
  Widget build(BuildContext context) {
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
                Colors.white.withOpacity(0),
                Colors.white.withOpacity(0),
              ],
            ),
            border: Border(
               top: BorderSide(color: Colors.white.withOpacity(0.15), width: 1.5),
              bottom: BorderSide(color: Colors.white.withOpacity(0.15), width: 1.5),
              left:  BorderSide(color: Colors.white.withOpacity(0.15), width: 0.8),
              right: BorderSide(color: Colors.white.withOpacity(0.15), width: 0.8),
            ),
           
          ),
          child: child,
        ),
      ),
    );
  }
}