import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:school_for_blind_app/business_logic/cubit/lessons_cubit.dart';
import 'package:school_for_blind_app/core/theme/app_text_styles.dart';

class SearchLessonsBar extends StatelessWidget {
  final bool isSearching;
  final TextEditingController controller;
  final VoidCallback onSearchTap;

  const SearchLessonsBar({
    super.key,
    required this.isSearching,
    required this.controller,
    required this.onSearchTap,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        Expanded(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 20.w),
            child: AnimatedSwitcher(
              duration: const Duration(milliseconds: 600),
              child: isSearching
                  ? TextField(
                      controller: controller,
                      autofocus: true,
                      onChanged: (value) {
                        context.read<LessonsCubit>().searchLessons(value);
                      },
                      style: AppTextStyles.kMediumPrimary(context),
                      cursorHeight: 50.h,
                      decoration: InputDecoration(
                        hintText: 'البحث عن درس..',
                        border: InputBorder.none,
                        hintStyle: AppTextStyles.kMediumPrimary(context),
                      ),
                    )
                  : Padding(
                      padding: EdgeInsets.symmetric(
                        horizontal: 10.w,
                        vertical: 10.h,
                      ),
                      child: Align(
                        alignment: Alignment.centerRight,
                        child: Text(
                          'الدروس:',
                          style: AppTextStyles.kMediumPrimary(context),
                        ),
                      ),
                    ),
            ),
          ),
        ),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 10.w),
          child: IconButton(
            onPressed: onSearchTap,
            icon: Icon(isSearching ? Icons.close : Icons.search, size: 34),
            color: isSearching
                ? Theme.of(context).colorScheme.onBackground
                : Theme.of(context).colorScheme.primary,
          ),
        ),
      ],
    );
  }
}
