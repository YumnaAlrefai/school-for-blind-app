import 'package:flutter/material.dart';
import 'app_colors.dart';

class DailyTab extends StatelessWidget {
  const DailyTab({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: const [
        _AttendedCard(
          roomName: 'حصة الفلسفة:',
          totalRoomMinutes: '45 دقيقة',
          studentPresenceMinutes: '45 دقيقة',
          studentName: 'رغد',
        ),
        SizedBox(height: 20),
        _AbsentCard(),
        SizedBox(height: 20),
        _AchievementCard(
          studentName: 'رغد',
          score: '90/100',
          title: 'كويز المعرفة ومصادرها',
          subjectName: 'الفلسفة',
        ),
        SizedBox(height: 20),
        _WarningCard(
          title: 'إنذار تأخر:',
          description: 'إنذار بسبب التأخر عن البث',
        ),
      ],
    );
  }
}

class _AttendedCard extends StatelessWidget {
  final String roomName;
  final String totalRoomMinutes;
  final String studentPresenceMinutes;
  final String studentName;

  const _AttendedCard({
    required this.roomName,
    required this.totalRoomMinutes,
    required this.studentPresenceMinutes,
    required this.studentName,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(color: AppColors.cardDark, borderRadius: BorderRadius.circular(15)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(roomName, style: const TextStyle(color: Colors.white, fontSize: 40)),
          const SizedBox(height: 5),
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Text('تم الحضور', style: TextStyle(color: AppColors.accentGreen, fontSize: 32)),
              const SizedBox(width: 5),
              Icon(Icons.check_circle, color: AppColors.accentGreen, size: 22),
            ],
          ),
          const SizedBox(height: 5),
          Text('المدة الكلية للحصة: $totalRoomMinutes', style: const TextStyle(color: Colors.white70, fontSize: 32)),
          const SizedBox(height: 6),
          Text('مدة حضور الطالبة $studentName: $studentPresenceMinutes', style: const TextStyle(color: Colors.white70, fontSize: 32)),
        ],
      ),
    );
  }
}

class _AbsentCard extends StatefulWidget {
  const _AbsentCard();

  @override
  State<_AbsentCard> createState() => _AbsentCardState();
}

class _AbsentCardState extends State<_AbsentCard> {
  bool? _hasJustification;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(color: AppColors.cardDark, borderRadius: BorderRadius.circular(15)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('حصة التاريخ:', style: TextStyle(color: Colors.white, fontSize: 40)),
          const SizedBox(height: 5),
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children:  [
              Text('لم يتم الحضور', style: TextStyle(color: AppColors.redX, fontSize: 32)),
              SizedBox(width: 5),
              Icon(Icons.cancel, color: AppColors.redX, size: 22),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(child: _btn('يوجد مبرر', _hasJustification == false, () => setState(() => _hasJustification = false))),
              const SizedBox(width: 12),
              Expanded(child: _btn('لا يوجد مبرر', _hasJustification == true, () => setState(() => _hasJustification = true))),
            ],
          ),
        ],
      ),
    );
  }

  Widget _btn(String label, bool isSelected, VoidCallback onTap) {
    return ElevatedButton(
      onPressed: onTap,
      style: ElevatedButton.styleFrom(
        backgroundColor: isSelected ? AppColors.accentGreen : Colors.transparent,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
          side: BorderSide(color: AppColors.accentGreen, width: 1),
        ),
        elevation: 0,
        padding: const EdgeInsets.symmetric(vertical: 8),
      ),
      child: Text(label, style: TextStyle(color: isSelected ? AppColors.bgDark : AppColors.accentGreen, fontSize: 24)),
    );
  }
}

class _AchievementCard extends StatelessWidget {
  final String studentName;
  final String score;
  final String title;
  final String subjectName;

  const _AchievementCard({
    required this.studentName,
    required this.score,
    required this.title,
    required this.subjectName,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 20),
      decoration: BoxDecoration(color: AppColors.cardDark, borderRadius: BorderRadius.circular(15)),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(Icons.star_rounded, color: AppColors.accentGreen, size: 37),
          const SizedBox(width: 5),
          Expanded(
            child: Text(
              'حصل الطالب $studentName على علامة $score في $title في مادة $subjectName',
              textAlign: TextAlign.right,
              style: const TextStyle(color: Colors.white, fontSize: 32, height: 1.5),
            ),
          ),
        ],
      ),
    );
  }
}

class _WarningCard extends StatelessWidget {
  final String title;
  final String description;

  const _WarningCard({required this.title, required this.description});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.cardDark,
        borderRadius: BorderRadius.circular(15),
        border: Border.all(color: AppColors.redX.withOpacity(0.4), width: 1.2),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.warning_amber_rounded, color: AppColors.redX, size: 30),
              const SizedBox(width: 8),
              Text(title, style: const TextStyle(color: Colors.white, fontSize: 36)),
            ],
          ),
          const SizedBox(height: 10),
          Text(description, style: const TextStyle(color: Colors.white70, fontSize: 28)),
        ],
      ),
    );
  }
}