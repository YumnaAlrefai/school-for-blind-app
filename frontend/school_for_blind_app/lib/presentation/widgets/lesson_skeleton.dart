import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:school_for_blind_app/presentation/widgets/glass_effect.dart';
import 'package:shimmer/shimmer.dart';

class LessonsSkeleton extends StatelessWidget {
  const LessonsSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: 10,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemBuilder: (context, index) => const LessonSkeleton(),
    );
  }
}

class LessonSkeleton extends StatelessWidget {
  const LessonSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 20.h, horizontal: 18.w),

      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Container(
            width: 354.w,
            height: 97.h,
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.surface,
              borderRadius: BorderRadius.only(bottomLeft: Radius.circular(16)),
              border: Border.all(
                color: Theme.of(context).colorScheme.onBackground,
                width: 0.2.w,
              ),
            ),
            child: Shimmer.fromColors(
              baseColor: Theme.of(context).colorScheme.surface,
              highlightColor: Theme.of(
                context,
              ).colorScheme.onSurface.withOpacity(0.1),
              child: Container(
                decoration: BoxDecoration(
                  color: Theme.of(
                    context,
                  ).colorScheme.onSurface.withOpacity(0.4),
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(16),
                  ),
                ),
              ),
            ),
          ),
          GlassEffect(
            borderRadius: BorderRadius.only(bottomLeft: Radius.circular(16)),
          ),
        ],
      ),
    );
  }
}
