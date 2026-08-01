import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:school_for_blind_app/business_logic/cubit/subject_progress_cubit.dart';
import 'package:school_for_blind_app/business_logic/cubit/result_state.dart';
import 'package:school_for_blind_app/data/models/subject_progress.dart';
import 'package:school_for_blind_app/core/injection.dart';
import 'package:school_for_blind_app/core/routing/app_routes.dart';
import 'package:school_for_blind_app/core/theme/app_text_styles.dart';
import 'package:school_for_blind_app/presentation/widgets/glass_effect.dart';

class SubjectCard extends StatefulWidget {
  final int subjectId;
  final String subjectName;
  final IconData icon;

  const SubjectCard({
    super.key,
    required this.subjectId,
    required this.subjectName,
    required this.icon,
  });

  @override
  State<SubjectCard> createState() => _SubjectCardState();
}

class _SubjectCardState extends State<SubjectCard>
    with AutomaticKeepAliveClientMixin {
  late final SubjectProgressCubit _cubit;

  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    super.initState();
    _cubit = getIt<SubjectProgressCubit>()
      ..emitGetSubjectProgress(widget.subjectId);
  }

  void _retryLoading() {
    _cubit.emitGetSubjectProgress(widget.subjectId);
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return BlocProvider(
      create: (context) => _cubit,
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: 20.h, horizontal: 25.w),
        child: GestureDetector(
          onTap: () {
            Navigator.pushNamed(
              context,
              AppRoutes.kStudentSubjectDetailsScreen,
              arguments: {
                'subjectId': widget.subjectId,
                'subjectName': widget.subjectName,
              },
            );
          },
          child: Stack(
            clipBehavior: Clip.none,
            children: [
              Container(
                width: 354.w,
                height: 177.h,
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.surface,
                  borderRadius: const BorderRadius.only(
                    bottomLeft: Radius.circular(16),
                  ),
                  border: Border.all(
                    color: Theme.of(context).colorScheme.onBackground,
                    width: 0.2.w,
                  ),
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    SizedBox(height: 10.h),
                    Text(
                      widget.subjectName,
                      textAlign: TextAlign.center,
                      style: AppTextStyles.kBigPrimary(context),
                    ),
                    SizedBox(height: 10.h),
                    BlocBuilder<
                      SubjectProgressCubit,
                      ResultState<SubjectProgress>
                    >(
                      builder: (context, state) {
                        return state.when(
                          idle: () => _buildLoadingWidget(context),
                          loading: () => _buildLoadingWidget(context),
                          success: (SubjectProgress progressData) {
                            return Container(
                              height: 45.h,
                              width: 200.w,
                              decoration: _buildBoxDecoration(context),
                              alignment: Alignment.center,
                              child: Text(
                                'عدد الدروس: ${progressData.progressText}',
                                style: _getProgressTextStyle(context),
                              ),
                            );
                          },
                          failure: (error) {
                            return InkWell(
                              onTap: _retryLoading,
                              child: Container(
                                height: 45.h,
                                width: 200.w,
                                decoration: _buildBoxDecoration(context),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(
                                      Icons.refresh,
                                      color: Theme.of(
                                        context,
                                      ).colorScheme.onSurface,
                                      size: 18.sp,
                                    ),
                                    SizedBox(width: 5.w),
                                    Text(
                                      "إعادة المحاولة",
                                      style: _getProgressTextStyle(context),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
                        );
                      },
                    ),
                  ],
                ),
              ),
              Positioned(
                top: -25,
                right: -15,
                child: Container(
                  height: 75.h,
                  width: 75.h,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.symmetric(
                      horizontal: BorderSide(
                        color: Theme.of(context).colorScheme.onBackground,
                        width: 0.5.w,
                      ),
                    ),
                    color: Theme.of(context).colorScheme.surface,
                  ),
                  child: Icon(
                    widget.icon,
                    color: Theme.of(context).colorScheme.primary,
                    size: 48.sp,
                  ),
                ),
              ),
              GlassEffect(
                borderRadius: const BorderRadius.only(
                  bottomLeft: Radius.circular(16),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  BoxDecoration _buildBoxDecoration(BuildContext context) {
    return BoxDecoration(
      color: Theme.of(context).colorScheme.background.withOpacity(0.2),
      borderRadius: BorderRadius.circular(15.r),
      border: Border.symmetric(
        horizontal: BorderSide(
          color: Theme.of(context).colorScheme.onBackground,
          width: 0.25.w,
        ),
      ),
    );
  }

  Widget _buildLoadingWidget(BuildContext context) {
    return Container(
      height: 45.h,
      width: 200.w,
      decoration: _buildBoxDecoration(context),
      alignment: Alignment.center,
      child: Text("جاري التحميل...", style: _getProgressTextStyle(context)),
    );
  }

  TextStyle _getProgressTextStyle(BuildContext context) {
    return TextStyle(
      color: Theme.of(context).colorScheme.onBackground,
      fontSize: 32.sp,
    );
  }
}
