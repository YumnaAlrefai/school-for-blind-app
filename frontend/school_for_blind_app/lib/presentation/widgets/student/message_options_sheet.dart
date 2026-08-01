import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:school_for_blind_app/business_logic/cubit/student/messages_cubit.dart';
import 'package:school_for_blind_app/presentation/widgets/student/glass_effect.dart';

void showMessageOptions({
  required BuildContext context,
  required bool isMe,
  required int messageId,
}) {
  showModalBottomSheet(
    context: context,
    backgroundColor: Theme.of(context).colorScheme.surface,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
    ),
    builder: (_) {
      return Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (isMe)
              ListTile(
                leading: Icon(Icons.delete, color: Colors.red),
                title: Text('حذف الرسالة', style: TextStyle(fontSize: 40.sp)),
                onTap: () {
                  Navigator.pop(context);
                  confirmDeleteDialog(context, messageId);
                },
              )
            else
              ListTile(
                leading: Icon(Icons.report, color: Colors.orange),
                title: Text(
                  'إبلاغ عن الرسالة',
                  style: TextStyle(fontSize: 40.sp),
                ),
                onTap: () {
                  Navigator.pop(context);
                  reportDialog(context, messageId);
                },
              ),
          ],
        ),
      );
    },
  );
}

void confirmDeleteDialog(BuildContext context, int messageId) {
  final borderRadius = BorderRadius.circular(28.r);

  showDialog(
    context: context,
    builder: (_) {
      return Dialog(
        backgroundColor: Colors.transparent,
        elevation: 0,
        insetPadding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 24.h),
        child: ClipRRect(
          borderRadius: borderRadius,
          child: SizedBox(
            width: 0.88.sw,
            child: Stack(
              children: [
                AlertDialog(
                  insetPadding: EdgeInsets.zero,
                  shape: RoundedRectangleBorder(borderRadius: borderRadius),
                  title: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "تأكيد الحذف",
                        style: TextStyle(
                          color: Theme.of(context).colorScheme.onSurface,
                          fontSize: 44.sp,
                          fontWeight: FontWeight.w100,
                        ),
                      ),
                      SizedBox(height: 3.h),
                      Divider(
                        color: Theme.of(context).colorScheme.onSurface,
                        thickness: 1.h,
                      ),
                    ],
                  ),
                  content: Text(
                    "هل أنت متأكد أنك تريد حذف هذه الرسالة؟",
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.onSurface,
                      fontSize: 38.sp,
                    ),
                  ),
                  actionsPadding: EdgeInsets.symmetric(
                    horizontal: 16.w,
                    vertical: 16.h,
                  ),
                  actions: [
                    OutlinedButton(
                      style: OutlinedButton.styleFrom(
                        side: BorderSide(
                          color: Theme.of(context).colorScheme.primary,
                          width: 0.5,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16.r),
                        ),
                        padding: EdgeInsets.symmetric(
                          horizontal: 30.w,
                          vertical: 10.h,
                        ),
                      ),
                      child: Text(
                        "إلغاء",
                        style: TextStyle(
                          color: Theme.of(context).colorScheme.primary,
                          fontSize: 36.sp,
                        ),
                      ),
                      onPressed: () => Navigator.pop(context),
                    ),
                    SizedBox(width: 5.w),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Theme.of(context).colorScheme.primary,
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16.r),
                        ),
                        padding: EdgeInsets.symmetric(
                          horizontal: 38.w,
                          vertical: 10.h,
                        ),
                      ),
                      child: Text(
                        "حذف",
                        style: TextStyle(
                          color: Theme.of(context).colorScheme.onPrimary,
                          fontSize: 36.sp,
                        ),
                      ),
                      onPressed: () {
                        Navigator.pop(context);
                        context.read<MessagesCubit>().emitDeleteMessage(
                          messageId,
                        );
                      },
                    ),
                  ],
                ),
                GlassEffect(borderRadius: borderRadius),
              ],
            ),
          ),
        ),
      );
    },
  );
}

void reportDialog(BuildContext context, int messageId) {
  final controller = TextEditingController();
  final borderRadius = BorderRadius.circular(28.r);

  showDialog(
    context: context,
    builder: (_) {
      return Dialog(
        backgroundColor: Colors.transparent,
        elevation: 0,
        insetPadding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 24.h),
        child: ClipRRect(
          borderRadius: borderRadius,
          child: SizedBox(
            width: 0.88.sw,
            child: Stack(
              children: [
                AlertDialog(
                  insetPadding: EdgeInsets.zero,
                  shape: RoundedRectangleBorder(borderRadius: borderRadius),
                  title: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "سبب الإبلاغ",
                        style: TextStyle(
                          color: Theme.of(context).colorScheme.onSurface,
                          fontSize: 44.sp,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 3.h),
                      Divider(
                        color: Theme.of(context).colorScheme.onSurface,
                        thickness: 1.h,
                      ),
                    ],
                  ),
                  content: Container(
                    padding: EdgeInsets.only(top: 8.h),
                    child: TextField(
                      controller: controller,
                      maxLines: 2,
                      style: TextStyle(fontSize: 34.sp),
                      decoration: InputDecoration(
                        hintText: "اكتب سبب الإبلاغ...",
                        hintStyle: TextStyle(
                          fontSize: 34.sp,
                          color: Theme.of(context).colorScheme.onSurface,
                        ),
                        contentPadding: EdgeInsets.all(16.w),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(16.r),
                          borderSide: BorderSide(
                            color: Theme.of(context).colorScheme.onSurface,
                            width: 1,
                          ),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(16.r),
                          borderSide: BorderSide(
                            color: Theme.of(context).colorScheme.primary,
                            width: 1,
                          ),
                        ),
                      ),
                    ),
                  ),
                  actionsPadding: EdgeInsets.symmetric(
                    horizontal: 16.w,
                    vertical: 16.h,
                  ),
                  actions: [
                    OutlinedButton(
                      style: OutlinedButton.styleFrom(
                        side: BorderSide(
                          color: Theme.of(context).colorScheme.primary,
                          width: 0.5,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16.r),
                        ),
                        padding: EdgeInsets.symmetric(
                          horizontal: 30.w,
                          vertical: 10.h,
                        ),
                      ),
                      child: Text(
                        "إلغاء",
                        style: TextStyle(
                          color: Theme.of(context).colorScheme.primary,
                          fontSize: 36.sp,
                        ),
                      ),
                      onPressed: () => Navigator.pop(context),
                    ),
                    SizedBox(width: 5.w),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Theme.of(context).colorScheme.primary,
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16.r),
                        ),
                        padding: EdgeInsets.symmetric(
                          horizontal: 38.w,
                          vertical: 10.h,
                        ),
                      ),
                      child: Text(
                        "إرسال",
                        style: TextStyle(
                          color: Theme.of(context).colorScheme.onPrimary,
                          fontSize: 36.sp,
                        ),
                      ),
                      onPressed: () {
                        Navigator.pop(context);
                        context.read<MessagesCubit>().emitReportMessage(
                          messageId: messageId,
                          reason: controller.text.trim(),
                        );
                      },
                    ),
                  ],
                ),
                GlassEffect(borderRadius: borderRadius),
              ],
            ),
          ),
        ),
      );
    },
  );
}
