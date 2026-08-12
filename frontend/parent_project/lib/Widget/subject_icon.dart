import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';


class SubjectIcon {
  final IconData? iconData;
  final String? svgPath;
  final double size;

  const SubjectIcon._({this.iconData, this.svgPath, required this.size});

  /// إنشاء أيقونة من Material Icons الجاهزة
  factory SubjectIcon.icon(IconData icon, {double size = 30}) {
    return SubjectIcon._(iconData: icon, size: size);
  }

  /// إنشاء أيقونة من ملف SVG مخصص
  factory SubjectIcon.svg(String path, {double size = 30}) {
    return SubjectIcon._(svgPath: path, size: size);
  }

  /// يبني الويدجت المناسب تلقائيًا حسب نوع الأيقونة
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