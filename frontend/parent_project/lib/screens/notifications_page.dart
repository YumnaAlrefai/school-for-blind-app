import 'package:flutter/material.dart';
import 'package:parent_project/Widget/app_colors.dart';
import 'package:parent_project/screens/reports_parent.dart';


class NotificationsPage extends StatefulWidget {
  const NotificationsPage({super.key});

  @override
  State<NotificationsPage> createState() => _NotificationsPageState();
}

class _NotificationModel {
  final String message;
  final String time;

  _NotificationModel({required this.message, required this.time});
}

class _NotificationsPageState extends State<NotificationsPage> {
  
  bool _notificationsMuted = false;

 
  final Map<String, List<_NotificationModel>> _notificationsByDate = {
    '17/3/2026': [
      _NotificationModel(message: 'وصلك إعلان جديد', time: '7:00 ص'),
      _NotificationModel(message: 'بدأت حصة التاريخ عند الطالبة رغد', time: '7:10 ص'),
    ],
    '18/3/2026': [
      _NotificationModel(message: 'تم تنزيل برنامج الدوام', time: '9:00 ص'),
       
    ],
  };

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: AppColors.bgDark,
        body: SafeArea(
          child: Column(
            children: [
              _buildTopBar(),
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.fromLTRB(20, 20, 20, 20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: _buildNotificationsList(),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  
  
  Widget _buildTopBar() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 20,vertical: 5),
       decoration: BoxDecoration(
        color: AppColors.bgDark,
        border: const Border(bottom: BorderSide(color: Colors.white12, width: 1),top: BorderSide(color: Colors.white12, width: 1)),
      ),
      child: Row(
        children: [
        
          Expanded(
            child: Align(
              alignment: Alignment.centerRight,
              child: Text(
                'الإشعارات',
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 40,
                ),
              ),
            ),
          ),
           const Spacer(),
           IconButton(
            onPressed: () {
              setState(() => _notificationsMuted = !_notificationsMuted);
            },
            icon: Icon(
              _notificationsMuted
                  ? Icons.notifications_off_outlined
                  : Icons.notifications_none_rounded,
              color: Colors.white,
              size: 33,
            ),
          ),
          const SizedBox(width: 12),
         
          GestureDetector(
           onTap: () {
  Navigator.pushAndRemoveUntil(
    context,
    MaterialPageRoute(builder: (context) => const ReportsParent()),
    (route) => false,
  );
},
            child: const Icon(
              Icons.subdirectory_arrow_left_outlined,
              color: Colors.white,
              size: 34,
            ),
          ),
        ],
      ),
    );
  }


  List<Widget> _buildNotificationsList() {
    final List<Widget> widgets = [];

    _notificationsByDate.forEach((date, notifications) {
      widgets.add(_buildDateLabel(date));
      widgets.add(const SizedBox(height: 14));

      for (final notification in notifications) {
        widgets.add(_buildNotificationBubble(notification));
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

  
  Widget _buildNotificationBubble(_NotificationModel notification) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 8),
      decoration: BoxDecoration(
        color: AppColors.cardDark,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            notification.message,
            textAlign: TextAlign.center,
            style: const TextStyle(color: Colors.white, fontSize: 30),
          ),
          const SizedBox(height: 1),
          Align(
            alignment: Alignment.centerLeft,
            child: Text(
              notification.time,
              style: const TextStyle(color: Colors.white38, fontSize: 12),
            ),
          ),
        ],
      ),
    );
  }
}
 