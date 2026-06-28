import 'package:flutter/material.dart';

import 'package:school_for_blind_app/apiTeacher/teacherRepo.dart';
import 'package:school_for_blind_app/networking/api_result.dart';
import 'package:school_for_blind_app/networking/network_exceptions.dart';
import 'package:school_for_blind_app/presentation/screens/Teacher/call/call_models.dart';

import 'call_screen.dart';

/// نقطة الدخول لزر المكالمات:
/// 1) يجلب شعب المدرس من teacher/info.
/// 2) يعرضها بقائمة (أو يدخل مباشرة لو شعبة واحدة).
/// 3) عند الاختيار يبدأ المكالمة لتلك الشعبة.
///
/// الاستعمال في زر المكالمات:
/// ```dart
/// onPressed: () => openCallClassPicker(context, getIt<TeacherRepo>()),
/// ```
Future<void> openCallClassPicker(
  BuildContext context,
  TeacherRepo teacherRepo,
) async {
  // مؤشّر تحميل بسيط أثناء جلب الشعب
  showDialog(
    context: context,
    barrierDismissible: false,
    builder: (_) => const Center(
      child: CircularProgressIndicator(color: Color(0xFFC8F526)),
    ),
  );

  final result = await teacherRepo.getTeacherInfo();

  if (!context.mounted) return;
  Navigator.of(context).pop(); // إغلاق التحميل

  List<SchoolClass> classes = const [];
  String? error;
  result.when(
    success: (d) {
      final data = (d is Map) ? d['data'] : null;
      final list = (data is Map && data['classes'] is List)
          ? data['classes'] as List
          : const [];
      classes = list
          .whereType<Map>()
          .map((e) => SchoolClass.fromJson(Map<String, dynamic>.from(e)))
          .where((c) => c.id.isNotEmpty)
          .toList();
    },
    failure: (e) => error = NetworkExceptions.getErrorMessage(e),
  );

  if (error != null) {
    _snack(context, error!);
    return;
  }
  if (classes.isEmpty) {
    _snack(context, 'لا توجد شعب مسندة إليك');
    return;
  }

  // شعبة واحدة → ابدأ مباشرة بدون قائمة
  if (classes.length == 1) {
    _startCall(context, teacherRepo, classes.first);
    return;
  }

  // أكثر من شعبة → اعرض قائمة الاختيار
  final selected = await showModalBottomSheet<SchoolClass>(
    context: context,
    backgroundColor: const Color(0xFF14202F),
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
    ),
    builder: (_) => _ClassPickerSheet(classes: classes),
  );

  if (selected == null || !context.mounted) return;
  _startCall(context, teacherRepo, selected);
}

void _startCall(BuildContext context, TeacherRepo repo, SchoolClass cls) {
  Navigator.push(
    context,
    MaterialPageRoute(
      builder: (_) => CallScreen(
        roomName: 'class-${cls.id}', // معرّف الغرفة المرسل للـ API
        title: cls.name, // الاسم المعروض
        classId: cls.id,
        teacherRepo: repo,
      ),
    ),
  );
}

void _snack(BuildContext context, String msg) {
  ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(msg)));
}

class _ClassPickerSheet extends StatelessWidget {
  const _ClassPickerSheet({required this.classes});
  final List<SchoolClass> classes;

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Padding(
              padding: EdgeInsets.all(16),
              child: Text(
                'اختر الشعبة لبدء المكالمة',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const Divider(color: Colors.white12, height: 1),
            Flexible(
              child: ListView.separated(
                shrinkWrap: true,
                itemCount: classes.length,
                separatorBuilder: (_, __) =>
                    const Divider(color: Colors.white10, height: 1),
                itemBuilder: (context, i) {
                  final c = classes[i];
                  return ListTile(
                    leading: const Icon(Icons.groups, color: Color(0xFFC8F526)),
                    title: Text(
                      c.name,
                      style: const TextStyle(color: Colors.white),
                    ),
                    trailing: const Icon(Icons.call,
                        color: Colors.white54, size: 20),
                    onTap: () => Navigator.of(context).pop(c),
                  );
                },
              ),
            ),
            const SizedBox(height: 8),
          ],
        ),
      ),
    );
  }
}