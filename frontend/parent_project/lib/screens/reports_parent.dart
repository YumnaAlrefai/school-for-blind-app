import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:parent_project/Widget/app_bottom_nav.dart';
import 'package:parent_project/Widget/app_colors.dart';
import 'package:parent_project/Widget/app_drawer.dart';
import 'package:parent_project/Widget/generic_tabs.dart';
import 'package:parent_project/Widget/subject_icon.dart';
import 'package:parent_project/Widget/theme_controller.dart';
import 'package:parent_project/Widget/theme_listener.dart';
import 'package:parent_project/features/announcements/presentation/pages/announcements_parent_page.dart';
import 'package:parent_project/features/donation/presentation/pages/donation_parent_page.dart';
import 'package:parent_project/features/reports/presentation/pages/daily_tab_page.dart';
import 'package:parent_project/features/reports/presentation/pages/monthly_tab_page.dart';
import 'package:parent_project/features/reports/presentation/pages/yearly_tab_page.dart';
import 'package:parent_project/features/schedule/presentation/pages/schedule_page.dart';
import 'package:parent_project/features/technical_support/presentation/pages/technical_support_page.dart';
import 'package:parent_project/screens/notifications_page.dart';

import 'package:parent_project/features/auth/logic/cubit/auth_cubit.dart';
import 'package:parent_project/features/auth/logic/cubit/auth_state.dart';
import 'package:parent_project/features/auth/presentation/pages/login_page.dart';
import 'package:parent_project/features/reports/presentation/pages/subject_details_page.dart';

import 'technical_support_page.dart';

enum ReportPeriod { yearly, monthly, daily }

class ReportsParent extends StatefulWidget {
  const ReportsParent({super.key});

  @override
  State<ReportsParent> createState() => _ReportsParentState();
}

class _ReportsParentState extends State<ReportsParent> {
  ReportPeriod _selectedPeriod = ReportPeriod.daily;

  final _dailyKey = GlobalKey<DailyTab1State>();
  final _monthlyKey = GlobalKey<MonthlyTab1State>();
  final _yearlyKey = GlobalKey<YearlyTab1State>();

  static final Map<String, SubjectIcon> _subjectIcons = {
    'الفلسفة': SubjectIcon.svg('assets/icons/brain.svg', size: 30),
    'التاريخ': SubjectIcon.svg('assets/icons/university-solid.svg', size: 30),
    'الجغرافيا': SubjectIcon.svg('assets/icons/mountain-solid.svg', size: 30),
    'اللغة العربية': SubjectIcon.svg('assets/icons/abjad-arabic.svg', size: 30),
    'اللغة الإنكليزية': SubjectIcon.svg('assets/icons/english.svg', size: 28),
    'اللغة الفرنسية': SubjectIcon.svg(
      'assets/icons/eiffel-tower.svg',
      size: 30,
    ),
    'التربية الدينية': SubjectIcon.svg('assets/icons/mosque.svg', size: 25),
    'الرياضيات (جبر)': SubjectIcon.icon(Icons.calculate_outlined, size: 30),
    'الفيزياء والكيمياء': SubjectIcon.icon(Icons.science_outlined, size: 30),
    'علم الأحياء والأرض': SubjectIcon.icon(Icons.eco_outlined, size: 30),
    'الكيمياء': SubjectIcon.icon(Icons.biotech_outlined, size: 30),
  };

  static final SubjectIcon _defaultSubjectIcon = SubjectIcon.icon(
    Icons.book_rounded,
    size: 30,
  );

  SubjectIcon _iconResolver(String subjectName) =>
      _subjectIcons[subjectName.trim()] ?? _defaultSubjectIcon;

  void _onSubjectTap(int studentId, int subjectId, String subjectName) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => SubjectDetailsPage(
          studentId: studentId,
          subjectId: subjectId,
          subjectName: subjectName,
        ),
      ),
    );
  }

  Future<void> _handleRefresh() async {
    switch (_selectedPeriod) {
      case ReportPeriod.daily:
        await _dailyKey.currentState?.refresh();
        break;
      case ReportPeriod.monthly:
        await _monthlyKey.currentState?.refresh();
        break;
      case ReportPeriod.yearly:
        await _yearlyKey.currentState?.refresh();
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return ThemeListener(
      builder: (context) => Directionality(
        textDirection: TextDirection.rtl,
        child: BlocListener<AuthCubit, AuthState>(
          listener: (context, state) {
            if (state is LogoutLoading) {
              showDialog(
                context: context,
                barrierDismissible: false,
                builder: (_) =>
                    const Center(child: CircularProgressIndicator()),
              );
            }

            if (state is LogoutSuccess) {
              Navigator.of(context).pop();

              ScaffoldMessenger.of(
                context,
              ).showSnackBar(SnackBar(content: Text(state.message)));

              Navigator.of(context).pushAndRemoveUntil(
                MaterialPageRoute(builder: (context) => const LoginPage()),
                (route) => false,
              );
            }

            if (state is LogoutFailure) {
              Navigator.of(context).pop();

              ScaffoldMessenger.of(
                context,
              ).showSnackBar(SnackBar(content: Text(state.message)));
            }
          },
          child: Scaffold(
            backgroundColor: AppColors.bgDark,
            resizeToAvoidBottomInset: false, 
            drawer: AppDrawer(
              onSchedulePressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const SchedulePage1()),
                );
              },
              onThemesPressed: () {},
              onDonatePressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const DonationParentPage(),
                  ),
                );
              },
              onSupportPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const TechnicalSupportPage(),
                  ),
                );
              },
              onLogoutPressed: () {
                context.read<AuthCubit>().logout();
              },
            ),
            body: SafeArea(
              child: SizedBox.expand(
                child: Stack(
                  children: [
                    RefreshIndicator(
                      color: AppColors.accentGreen,
                      backgroundColor: AppColors.cardDark,
                      onRefresh: _handleRefresh,
                      child: SingleChildScrollView(
                        physics: const AlwaysScrollableScrollPhysics(),
                        padding: const EdgeInsets.fromLTRB(20, 10, 20, 110),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            _buildTopBar(),
                            const SizedBox(height: 20),
                            _buildTitle(),
                            const SizedBox(height: 15),

                            GenericTabs<ReportPeriod>(
                              items: const [
                                TabItem(
                                  label: 'اليومية',
                                  value: ReportPeriod.daily,
                                ),
                                TabItem(
                                  label: 'الشهرية',
                                  value: ReportPeriod.monthly,
                                ),
                                TabItem(
                                  label: 'السنوية',
                                  value: ReportPeriod.yearly,
                                ),
                              ],
                              selectedValue: _selectedPeriod,
                              onChanged: (period) =>
                                  setState(() => _selectedPeriod = period),
                            ),
                            const SizedBox(height: 25),

                            if (_selectedPeriod == ReportPeriod.daily)
                              DailyTab1(key: _dailyKey),
                            if (_selectedPeriod == ReportPeriod.monthly)
                              MonthlyTab1(key: _monthlyKey),
                            if (_selectedPeriod == ReportPeriod.yearly)
                              YearlyTab1(
                                key: _yearlyKey,
                                iconResolver: _iconResolver,
                                onSubjectTap: _onSubjectTap,
                              ),
                          ],
                        ),
                      ),
                    ),
                    Positioned(
                      bottom: 15,
                      left: 0,
                      right: 0,
                      child: Center(
                        child: AppBottomNav(
                          isHomeActive: true,
                          onHomeTap: () {},
                          onAnnouncementsTap: () {
                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    const AnnouncementsParentPage(),
                              ),
                            );
                          },
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTopBar() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Builder(
          builder: (context) => GestureDetector(
            onTap: () => Scaffold.of(context).openDrawer(),
            child: Icon(Icons.menu, color: AppColors.textPrimary, size: 37),
          ),
        ),
        GestureDetector(
          onTap: () => Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => const NotificationsPage()),
          ),
          child: Icon(
            Icons.notifications_rounded,
            color: AppColors.textPrimary,
            size: 32,
          ),
        ),
      ],
    );
  }

  Widget _buildTitle() {
    return Align(
      alignment: Alignment.centerRight,
      child: Text(
        'التقارير:',
        style: TextStyle(color: AppColors.textPrimary, fontSize: 48),
      ),
    );
  }
}