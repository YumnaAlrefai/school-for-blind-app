import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class FlagWithAddIcon extends StatelessWidget {
  const FlagWithAddIcon({super.key});

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: [
        FaIcon(
          FontAwesomeIcons.flag,
          size: 34.r,
          color: Theme.of(context).colorScheme.onBackground,
        ),
        Positioned(
          top: 6.h,
          left: 8.w,
          child: Icon(
            Icons.add,
            size: 14.r,
            color: Theme.of(context).colorScheme.onBackground,
          ),
        ),
      ],
    );
  }
}
