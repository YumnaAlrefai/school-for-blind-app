import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';


class SubjectIcon {
  final IconData? iconData;
  final String? svgPath;
  final double size;

  const SubjectIcon._({this.iconData, this.svgPath, required this.size});

  factory SubjectIcon.icon(IconData icon, {double size = 30}) {
    return SubjectIcon._(iconData: icon, size: size);
  }

  factory SubjectIcon.svg(String path, {double size = 30}) {
    return SubjectIcon._(svgPath: path, size: size);
  }
  Widget build({required Color color}) {
    if (svgPath != null) {
      return SvgPicture.asset(
        svgPath!,
        width: size,
        height: size,
        colorFilter: ColorFilter.mode(color, BlendMode.srcIn),
      );
    }
    return Icon(iconData, color: color, size: size);
  }
}