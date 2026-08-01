import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:school_for_blind_app/presentation/widgets/glass_effect.dart';
import 'package:shimmer/shimmer.dart';

class LibraryCardSkeleton extends StatelessWidget {
  const LibraryCardSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: 5,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemBuilder: (context, index) => const CardSkeleton(),
    );
  }
}

class CardSkeleton extends StatelessWidget {
  const CardSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(10.w),

      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Container(
            width: 358.w,
            height: 97.h,
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.surface,
              border: Border.all(
                color: Theme.of(context).colorScheme.onSurface,
                width: 0.2,
              ),
              borderRadius: BorderRadius.circular(15.r),
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
                  borderRadius: BorderRadius.all(Radius.circular(15)),
                ),
              ),
            ),
          ),
          GlassEffect(borderRadius: BorderRadius.all(Radius.circular(15))),
        ],
      ),
    );
  }
}
