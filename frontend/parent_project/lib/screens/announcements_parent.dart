import 'package:flutter/material.dart';
import 'package:parent_project/Widget/app_colors.dart';
import 'package:parent_project/screens/reports_parent.dart';

class AnnouncementsParent extends StatefulWidget {
  const AnnouncementsParent({super.key});

  @override
  State<AnnouncementsParent> createState() => _AnnouncementsParentState();
}

class _AnnouncementModel {
  final String title;
  final String time;
  final List<String> descriptionLines;
  final String? linkText;

  _AnnouncementModel({
    required this.title,
    required this.time,
    required this.descriptionLines,
    this.linkText,
  });
}

class _AnnouncementsParentState extends State<AnnouncementsParent> {

  int _selectedNavIndex = 1;

  final Map<String, List<_AnnouncementModel>> _announcementsByDate = {
    '17/3/2026': [
      _AnnouncementModel(
        title: 'عطلة رسمية',
        time: '7:00 ص',
        descriptionLines: [
          'نعلمكم بوجود عطلة يومي الأحد والإثنين',
          'بمناسبة عيد الفطر المبارك',
          'نرجو لكم عطلة سعيدة',
        ],
      ),
    ],
    '18/3/2026': [
      _AnnouncementModel(
        title: 'تعديل برنامج الدوام',
        time: '9:00 ص',
        descriptionLines: [
          'تم التبديل بين حصة الفلسفة وحصة',
          'الرياضيات ليوم الأحد للشعبة الأولى',
          'والخامسة',
          'يرجى الإطلاع على البرنامج الجديد',
        ],
      ),
      _AnnouncementModel(
        title: 'برنامج الإمتحان',
        time: '9:10 ص',
        descriptionLines: [
          'تم نشر برنامج الإمتحان',
          'أنقر هنا للإطلاع عليه',
        ],
        linkText: 'هنا',
      ),
    ],
  };

  
  final Map<String, bool> _expandedMap = {};

  IconData _iconResolver(String title) {
    final normalizedTitle = title.trim();

    const Map<String, IconData> keywordIcons = {
      'دوام': Icons.table_chart_rounded,
      'برنامج الإمتحان': Icons.assignment_rounded,
      'امتحان': Icons.assignment_rounded,
      'إمتحان': Icons.assignment_rounded,
      'عطلة': Icons.calendar_month_rounded,
      'اجتماع': Icons.groups_rounded,
      'رحلة': Icons.directions_bus_rounded,
      'دفعة': Icons.payments_rounded,
      'دفع': Icons.payments_rounded,
      'صيانة': Icons.build_rounded,
      'تنبيه': Icons.warning_amber_rounded,
      'إنذار': Icons.warning_amber_rounded,
    };

    for (final entry in keywordIcons.entries) {
      if (normalizedTitle.contains(entry.key)) {
        return entry.value;
      }
    }

    
    return Icons.campaign_rounded;
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: AppColors.bgDark,
        body: SafeArea(
          child: SizedBox.expand(
            child: Stack(
              children: [
                Column(
                  children: [
                    _buildTopBar(),
                    Expanded(
                      child: SingleChildScrollView(
                        padding: const EdgeInsets.fromLTRB(20, 20, 20, 110),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: _buildAnnouncementsList(),
                        ),
                      ),
                    ),
                  ],
                ),

            
                Positioned(
                  bottom: 15,
                  left: 0,
                  right: 0,
                  child: Center(child: _buildBottomNav()),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  
  Widget _buildTopBar() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 3),
      decoration: BoxDecoration(
        color: AppColors.bgDark,
        border: const Border(bottom: BorderSide(color: Colors.white12, width: 1), top: BorderSide(color: Colors.white12, width: 1)),
      ),
      child: const Text(
        'الإعلانات',
        textAlign: TextAlign.center,
        style: TextStyle(color: Colors.white, fontSize: 40),
      ),
    );
  }

 
  List<Widget> _buildAnnouncementsList() {
    final List<Widget> widgets = [];

    _announcementsByDate.forEach((date, announcements) {
      widgets.add(_buildDateLabel(date));
      widgets.add(const SizedBox(height: 10));

      for (int i = 0; i < announcements.length; i++) {
        final key = '$date-$i';
        widgets.add(_buildAnnouncementCard(key, announcements[i]));
        widgets.add(const SizedBox(height: 14));
      }

      widgets.add(const SizedBox(height: 8));
    });

    return widgets;
  }

  
  Widget _buildDateLabel(String date) {
    return Center(
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 2),
        decoration: BoxDecoration(
          color: AppColors.cardDark.withOpacity(0.7),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Text(
          date,
          style: const TextStyle(color: Colors.white70, fontSize: 16),
        ),
      ),
    );
  }

 
  Widget _buildAnnouncementCard(String key, _AnnouncementModel model) {
    final bool isExpanded = _expandedMap[key] ?? false;

    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: AppColors.cardDark,
        borderRadius: BorderRadius.circular(15),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
         
          InkWell(
            borderRadius: BorderRadius.circular(15),
            onTap: () {
              setState(() {
                _expandedMap[key] = !isExpanded;
              });
            },
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
              child: Row(
                children: [
                  
                  Icon(_iconResolver(model.title), color: AppColors.accentGreen, size: 25),
                  const SizedBox(width: 8),

                
                  Text(
                    model.title,
                    style: const TextStyle(color: Colors.white, fontSize: 30),
                  ),
                  const Spacer(),

                
                  AnimatedRotation(
                    turns: isExpanded ? 0.5 : 0,
                    duration: const Duration(milliseconds: 250),
                    child: const Icon(
                      Icons.keyboard_arrow_down_rounded,
                      color: Colors.white70,
                      size: 26,
                    ),
                  ),
                ],
              ),
            ),
          ),

        
          AnimatedCrossFade(
            duration: const Duration(milliseconds: 250),
            crossFadeState: isExpanded ? CrossFadeState.showFirst : CrossFadeState.showSecond,
            firstChild: _buildExpandedContent(model),
            secondChild: const SizedBox(width: double.infinity, height: 0),
          ),
        ],
      ),
    );
  }

  
  Widget _buildExpandedContent(_AnnouncementModel model) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 0, 16, 14),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          for (int i = 0; i < model.descriptionLines.length; i++)
            Padding(
              padding: const EdgeInsets.only(bottom: 4),
              child: _buildDescriptionLine(
                model.descriptionLines[i],
                model.linkText,
              ),
            ),
          const SizedBox(height: 6),
          Align(
            alignment: Alignment.centerLeft,
            child: Text(
              model.time,
              style: const TextStyle(color: Colors.white38, fontSize: 15),
            ),
          ),
        ],
      ),
    );
  }

  
  Widget _buildDescriptionLine(String line, String? linkText) {
    if (linkText == null || !line.contains(linkText)) {
      return Text(
        line,
        textAlign: TextAlign.right,
        style: const TextStyle(color: Colors.white70, fontSize: 25, height: 1.5, fontFamily: 'ArabicTypesetting'),
      );
    }

    final parts = line.split(linkText);
    return RichText(
      textAlign: TextAlign.right,
      text: TextSpan(
        style: const TextStyle(color: Colors.white70, fontSize: 25, fontFamily: 'ArabicTypesetting', height: 1.5),
        children: [
          TextSpan(text: parts[0]),
          TextSpan(
            text: linkText,
            style: TextStyle(
              color: AppColors.accentGreen,
              decoration: TextDecoration.underline,
            ),
          ),
          if (parts.length > 1) TextSpan(text: parts[1]),
        ],
      ),
    );
  }

 
  Widget _buildBottomNav() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 26, vertical: 5),
      decoration: BoxDecoration(
        color: AppColors.bgDark,
        borderRadius: BorderRadius.circular(50),
        boxShadow: [
          BoxShadow(
            color: Colors.white.withOpacity(0.5),
            blurRadius: 5,
          ),
        ],
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          IconButton(
            onPressed: () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => const ReportsParent()),
              );
            },
            icon: Icon(
              Icons.home_rounded,
              color: Colors.white54,
              size: 36,
            ),
          ),
          const SizedBox(width: 20),
          IconButton(
            onPressed: () {},
            icon: Icon(
              Icons.campaign_rounded,
              color: AppColors.accentGreen,
              size: 40,
            ),
          ),
        ],
      ),
    );
  }
}