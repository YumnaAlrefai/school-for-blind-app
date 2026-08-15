import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:school_for_blind_app/business_logic/cubit/student/announcements_cubit.dart';
import 'package:school_for_blind_app/business_logic/cubit/student/result_state.dart';
import 'package:school_for_blind_app/business_logic/cubit/student/student_cubit.dart';
import 'package:school_for_blind_app/core/injection.dart';
import 'package:school_for_blind_app/core/services/voice_services.dart';
import 'package:school_for_blind_app/data/models/student/announcement_model.dart';
import 'package:school_for_blind_app/networking/network_exceptions.dart';
import 'package:school_for_blind_app/presentation/widgets/student/announcement_card.dart';
import 'package:school_for_blind_app/presentation/widgets/student/small_button.dart';

class StudentAnnouncementsScreen extends StatelessWidget {
  const StudentAnnouncementsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final studentLevel = getIt<StudentCubit>().currentStudent?.level;

    return BlocProvider(
      create: (context) => getIt<AnnouncementsCubit>()
        ..getAnnouncements()
        ..startListening(studentLevel),
      child: Scaffold(
        appBar: AppBar(
          leadingWidth: 100.w,
          toolbarHeight: 100,
          backgroundColor: Theme.of(context).colorScheme.background,
          title: Text(
            'الإعلانات',
            style: TextStyle(
              color: Theme.of(context).colorScheme.onSurface,
              fontSize: 48.sp,
            ),
          ),
          actions: [
            SmallButton(
              icon: const Icon(Icons.question_mark_outlined),
              onPressed: () {
                getIt<VoiceServices>().speak(
                  'صفحة الإعلانات، فيها يتم عرض الإعلانات التي تنشرها المدرسة بما فيها من عطل رسمية وتغيير البرامج',
                );
              },
            ),
            SizedBox(width: 20.w),
          ],
        ),
        backgroundColor: Theme.of(context).colorScheme.background,
        body: BlocBuilder<AnnouncementsCubit, ResultState<List<Announcement>>>(
          builder: (context, state) {
            return state.when(
              idle: () => const SizedBox.shrink(),
              loading: () => Center(
                child: CircularProgressIndicator(
                  color: Theme.of(context).colorScheme.primary,
                ),
              ),
              success: (announcements) {
                if (announcements.isEmpty) {
                  return RefreshIndicator(
                    color: Theme.of(context).colorScheme.primary,
                    backgroundColor: Theme.of(context).colorScheme.background,
                    onRefresh: () async {
                      context.read<AnnouncementsCubit>().getAnnouncements();
                    },
                    child: ListView(
                      physics: const AlwaysScrollableScrollPhysics(),
                      children: [
                        SizedBox(
                          height: MediaQuery.of(context).size.height * 0.7,
                          child: Center(
                            child: Text(
                              'لا توجد إعلانات متاحة حالياً.',
                              style: TextStyle(
                                color: Theme.of(context).colorScheme.onSurface,
                                fontSize: 36.sp,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                }
                return RefreshIndicator(
                  color: Theme.of(context).colorScheme.primary,
                  backgroundColor: Theme.of(context).colorScheme.background,
                  onRefresh: () async {
                    context.read<AnnouncementsCubit>().getAnnouncements();
                  },
                  child: ListView.builder(
                    padding: EdgeInsets.symmetric(
                      horizontal: 16.w,
                      vertical: 12.h,
                    ),
                    itemCount: announcements.length,
                    itemBuilder: (context, index) {
                      final item = announcements[index];
                      return AnnouncementCard(item: item);
                    },
                  ),
                );
              },
              failure: (networkException) {
                getIt<VoiceServices>().speak(
                  NetworkExceptions.getErrorMessage(networkException),
                );
                return RefreshIndicator(
                  color: Theme.of(context).colorScheme.primary,
                  backgroundColor: Theme.of(context).colorScheme.background,
                  onRefresh: () async {
                    context.read<AnnouncementsCubit>().getAnnouncements();
                  },
                  child: ListView(
                    physics: const AlwaysScrollableScrollPhysics(),
                    children: const [SizedBox.shrink()],
                  ),
                );
              },
            );
          },
        ),
      ),
    );
  }
}
