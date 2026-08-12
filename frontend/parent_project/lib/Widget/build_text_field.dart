import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:parent_project/Widget/app_colors.dart';


class BuildTextField extends StatefulWidget {
  final String iconPath;
  final double iconSize;
  final String hint;
  final bool isPassword;
  final TextInputType? keyboardType;
  final TextEditingController? controller;

  const BuildTextField({
    super.key,
    required this.iconPath,
    this.iconSize = 28,
    required this.hint,
    this.isPassword = false,
    this.keyboardType,
    this.controller,
  });

  @override
  State<BuildTextField> createState() => _BuildTextFieldState();
}

class _BuildTextFieldState extends State<BuildTextField> {
  bool _obscureText = true;

 
  @override
  void initState() {
    super.initState();
    // إظهار النص افتراضيًا إن لم يكن الحقل كلمة مرور
    _obscureText = widget.isPassword;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 60,
      width: 330,
      decoration: BoxDecoration(
        color: AppColors.bgDark.withOpacity(0.25),
        borderRadius: BorderRadius.circular(15),
        border: Border.all(color: AppColors.fieldBorder, width: 1.5),
      ),
      child: Center(
        child: TextField(
          controller: widget.controller,
          obscureText: _obscureText,
          keyboardType: widget.keyboardType,
          textAlign: TextAlign.right,
          style: const TextStyle(color: Colors.white, fontSize: 32),
          decoration: InputDecoration(
            prefixIcon: Padding(
              padding: const EdgeInsets.only(right: 20, left: 10),
              child: SvgPicture.asset(
                widget.iconPath,
               width: widget.iconSize,
               height: widget.iconSize,
                colorFilter: const ColorFilter.mode(AppColors.accentGreen, BlendMode.srcIn),
              ),
            ),
            hintText: widget.hint,
            hintStyle: TextStyle(color: Colors.white.withOpacity(0.35), fontSize: 32),
            border: InputBorder.none,
            contentPadding: const EdgeInsets.only(right: 20),
            suffixIcon: widget.isPassword
                ? Padding(
                    padding: const EdgeInsets.only(left: 8),
                    child: IconButton(
                      icon: Icon(
                        _obscureText
                            ? Icons.visibility_off_outlined
                            : Icons.visibility_outlined,
                        color: Colors.white.withOpacity(0.35),
                        size: 23,
                      ),
                      onPressed: () {
                        setState(() {
                          _obscureText = !_obscureText;
                        });
                      },
                    ),
                  )
                : null,
          ),
        ),
      ),
    );
  }
}