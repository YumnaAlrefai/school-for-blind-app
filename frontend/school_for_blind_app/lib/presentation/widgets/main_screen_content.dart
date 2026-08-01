import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:school_for_blind_app/business_logic/cubit/call_cubit.dart';
import 'package:school_for_blind_app/business_logic/cubit/result_state.dart';
import 'package:school_for_blind_app/core/injection.dart';
import 'package:school_for_blind_app/core/routing/app_routes.dart';
import 'package:school_for_blind_app/core/services/voice_services.dart';
import 'package:school_for_blind_app/networking/network_exceptions.dart';
import 'package:school_for_blind_app/presentation/widgets/small_button.dart';
import 'package:school_for_blind_app/presentation/widgets/subjects.dart';

class MainScreenContent extends StatelessWidget {
  const MainScreenContent({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(height: 70.h),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Builder(
              builder: (context) {
                return SmallButton(
                  icon: Icon(Icons.menu),
                  onPressed: () => Scaffold.of(context).openDrawer(),
                );
              },
            ),
            BlocConsumer<CallCubit, ResultState<dynamic>>(
              listener: (context, state) {
                state.whenOrNull(
                  success: (data) {
                    if (data.isEmpty) {
                      getIt<VoiceServices>().speak(
                        "لا يوجد مكالمات جارية حالياً لشعبتك",
                      );
                    } else {
                      Navigator.pushNamed(
                        context,
                        AppRoutes.kStudentLiveCallScreen,
                        arguments: data,
                      );
                    }
                  },
                  failure: (networkException) {
                    getIt<VoiceServices>().speak(
                      NetworkExceptions.getErrorMessage(networkException),
                    );
                  },
                );
              },
              builder: (context, state) {
                if (state is Loading) {
                  return IconButton(
                    style: IconButton.styleFrom(
                      backgroundColor: Theme.of(context).colorScheme.surface,
                      fixedSize: Size(75.w, 70.h),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15.r),
                      ),
                    ),
                    color: Theme.of(context).colorScheme.onSurface,
                    icon: FaIcon(FontAwesomeIcons.chalkboardUser),
                    iconSize: 37.sp,
                    onPressed: () {},
                  );
                }
                return SmallButton(
                  icon: const FaIcon(FontAwesomeIcons.chalkboardUser),
                  onPressed: () {
                    context.read<CallCubit>().emitJoinCall();
                  },
                );
              },
            ),
            SmallButton(
              icon: Icon(Icons.notifications_sharp),
              onPressed: () {},
            ),
            SmallButton(
              icon: Icon(Icons.question_mark_outlined),
              onPressed: () {
                getIt<VoiceServices>().speak(
                  'أنتَ الآنَ في الصفحةِ الرئيسيةِ للتطبيق، تَظْهَرُ لكَ موادكَ وعدد الدروس التي أخذْتَها من كل مادة، في الأعلى لديك زر الإشعارات الذي يوجهك لصفحة الإشعارات، بجانبه زر الحصة الدرسية الذي يوجهك للمكالمة الحالية التي يُجريها المعلم حسب برنامج الحصص، يليه زر المزيد الذي يفتح لك الdrawer، في الdrawer يوجد بعض الخيارات، وهي: إظهار المعلومات الشخصية، عرض برنامج الدوام، تغيير ثِيم التطبيق بما يريح الكفيف الجزئي، التبرع لصالح المدرسة، وأخيرَنْ التواصل مع فريق الدعم بحال مواجهة أي مشكلة',
                );
              },
            ),
          ],
        ),
        SizedBox(height: 20.h),
        Padding(
          padding: EdgeInsets.only(right: 25.w),
          child: Text(
            'موادي:',
            style: TextStyle(
              fontSize: 56.sp,
              fontWeight: FontWeight.w400,
              color: Theme.of(context).colorScheme.onBackground,
            ),
          ),
        ),
        Subjects(),
      ],
    );
  }
}
