import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:school_for_blind_app/core/injection.dart';
import 'package:school_for_blind_app/core/routing/app_routes.dart';
import 'package:school_for_blind_app/core/services/voice_services.dart';
import 'package:school_for_blind_app/core/theme/app_text_styles.dart';
import 'package:school_for_blind_app/networking/network_exceptions.dart';
import 'package:school_for_blind_app/presentation/widgets/custom_app_bar.dart';
import 'package:school_for_blind_app/presentation/widgets/library_card.dart';
import 'package:school_for_blind_app/presentation/widgets/custom_tabs.dart';

class StudentLibraryScreen extends StatefulWidget {
  const StudentLibraryScreen({super.key});

  @override
  State<StudentLibraryScreen> createState() => _StudentLibraryScreenState();
}

class _StudentLibraryScreenState extends State<StudentLibraryScreen> {
  int _selectedTab = 0;

  void _onTabChanged(int tabIndex) {
    setState(() {
      _selectedTab = tabIndex;
      if (tabIndex == 0) {
        //TODO
      } else if (tabIndex == 1) {
        //_offlineCubit.loadOfflineLessons(subjectId: widget.subjectId);
      } else {
        //TODO
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(helpMessage: ''),
      backgroundColor: Theme.of(context).colorScheme.background,
      body: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SingleChildScrollView(
            child: SizedBox(
              width: 378.w,
              child: Column(
                children: [
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Padding(
                      padding: EdgeInsets.all(10.w),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          CustomTabs(
                            label: 'الكويزات',
                            isSelected: _selectedTab == 0,
                            onPressed: () => _onTabChanged(0),
                          ),
                          SizedBox(width: 10.w),
                          CustomTabs(
                            label: 'الاختبارات',
                            isSelected: _selectedTab == 1,
                            onPressed: () => _onTabChanged(1),
                          ),
                          SizedBox(width: 10.w),
                          CustomTabs(
                            label: 'الدورات',
                            isSelected: _selectedTab == 2,
                            onPressed: () => _onTabChanged(2),
                          ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(height: 30.h),
                  _selectedTab == 0
                      ? _buildQuizzesList()
                      : (_selectedTab == 1
                            ? _buildTestsList()
                            : _buildPastPapersList()),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  _buildQuizzesList() {
    return Container();
  }

  _buildTestsList() {
    return Container();
  }

  _buildPastPapersList() {
    return Container();
  }
}
