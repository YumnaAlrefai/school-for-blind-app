import 'package:flutter/material.dart';
import 'package:school_for_blind_app/data/models/announcement.dart';

class AnnouncementCard extends StatelessWidget {
  final Announcement announcement;

  const AnnouncementCard({super.key, required this.announcement});

  @override
  Widget build(BuildContext context) {
    // تحديد الألوان والأيقونات حسب نوع الإعلان
    final isExam = announcement.type == 'exam_schedule';
    final cardColor = isExam ? Colors.amber[50] : Colors.blue[50];
    final iconColor = isExam ? Colors.amber[800]! : Colors.indigo;
    final iconData = isExam ? Icons.menu_book_rounded : Icons.campaign_rounded;
    final typeTitle = isExam ? 'جدول امتحانات' : 'تنويه إداري';

    return Semantics(
      // ♿ ميزة للمكفوفين: الـ Screen Reader بيقرا الكرت ككتلة واحدة مرتبة
      label: 'إعلان من نوع $typeTitle. المحتوى: ${announcement.content}',
      child: Container(
        margin: const EdgeInsets.only(bottom: 16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: IntrinsicHeight(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // 🎨 شريط ملون جانبي مع الأيقونة يعطي ثيم مودرن
              Container(
                width: 60,
                decoration: BoxDecoration(
                  color: cardColor,
                  borderRadius: const BorderRadius.only(
                    topRight: Radius.circular(20),
                    bottomRight: Radius.circular(20),
                  ),
                ),
                child: Icon(iconData, color: iconColor, size: 28),
              ),

              // 📝 تفاصيل الإعلان
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            typeTitle,
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                              color: iconColor,
                            ),
                          ),
                          // إشارة بسيطة للتمييز
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 4,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.grey[100],
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Text(
                              '#${announcement.id}',
                              style: TextStyle(
                                fontSize: 11,
                                color: Colors.grey[600],
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Text(
                        announcement.content,
                        style: const TextStyle(
                          fontSize: 15,
                          color: Colors.black87,
                          height: 1.4, // تباعد مريح للأسطر
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
