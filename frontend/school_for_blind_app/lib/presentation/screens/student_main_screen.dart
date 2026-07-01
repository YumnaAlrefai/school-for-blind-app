import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:school_for_blind_app/business_logic/cubit/student_cubit.dart';
import 'package:school_for_blind_app/core/injection.dart';
import 'package:school_for_blind_app/core/services/voice_services.dart';
import 'package:school_for_blind_app/presentation/screens/student_announcements_screen.dart';
import 'package:school_for_blind_app/presentation/screens/student_bookmarks_screen.dart';
import 'package:school_for_blind_app/presentation/screens/student_chats_screen.dart';
import 'package:school_for_blind_app/presentation/widgets/app_drawer.dart';
import 'package:school_for_blind_app/presentation/widgets/main_screen_content.dart';

class StudentMainScreen extends StatefulWidget {
  const StudentMainScreen({super.key});

  @override
  State<StudentMainScreen> createState() => _StudentMainScreenState();
}

class _StudentMainScreenState extends State<StudentMainScreen> {
  int numberScreen = 0;
  late final List<Widget> screens;

  @override
  void initState() {
    getIt<VoiceServices>().speak(
      'أهْلَنْ بكَ ${getIt<StudentCubit>().currentStudent?.fullName ?? 'يا طالب'}',
    );
    screens = [
      const MainScreenContent(),
      const StudentChatsScreen(),
      const StudentBookmarksScreen(),
      const StudentAnnouncementsScreen(),
    ];
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: AppDrawer(),
      backgroundColor: Theme.of(context).colorScheme.background,
      body: IndexedStack(index: numberScreen, children: screens),
      bottomNavigationBar: NavigationBar(
        elevation: 10,
        height: 100.h,
        backgroundColor: Theme.of(context).colorScheme.background,
        selectedIndex: numberScreen,

        labelBehavior: NavigationDestinationLabelBehavior.alwaysHide,
        indicatorColor: Theme.of(context).colorScheme.background,

        onDestinationSelected: (index) {
          if (index == numberScreen) return;
          setState(() {
            numberScreen = index;
          });
        },

        destinations: [
          NavigationDestination(
            icon: Icon(
              Icons.home_outlined,
              color: Theme.of(context).colorScheme.onBackground,
              size: 48.sp,
            ),
            selectedIcon: SelectedIcon(icon: Icons.home, size: 48.sp),
            label: 'الرئيسية',
          ),
          NavigationDestination(
            icon: Icon(
              Icons.chat_outlined,
              color: Theme.of(context).colorScheme.onBackground,
              size: 43.sp,
            ),
            selectedIcon: SelectedIcon(icon: Icons.chat, size: 43.sp),
            label: 'الدردشات',
          ),
          NavigationDestination(
            icon: Icon(
              Icons.bookmarks_outlined,
              color: Theme.of(context).colorScheme.onBackground,
              size: 40.sp,
            ),
            selectedIcon: SelectedIcon(icon: Icons.bookmarks, size: 40.sp),
            label: 'المحفوظات',
          ),
          NavigationDestination(
            icon: Icon(
              Icons.campaign_outlined,
              color: Theme.of(context).colorScheme.onBackground,
              size: 50.sp,
            ),
            selectedIcon: SelectedIcon(icon: Icons.campaign, size: 50.sp),
            label: 'الإعلانات',
          ),
        ],
      ),
    );
  }
}

class SelectedIcon extends StatelessWidget {
  final IconData icon;
  final double size;
  const SelectedIcon({super.key, required this.icon, required this.size});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 18.w, vertical: 18.h),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.background,
        borderRadius: BorderRadius.circular(15.r),
      ),
      child: Icon(
        icon,
        color: Theme.of(context).colorScheme.primary,
        size: size,
      ),
    );
  }
}

