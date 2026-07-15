import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';

import 'package:school_for_blind_app/apiTeacher/teacherRepo.dart';
import 'package:school_for_blind_app/networking/api_result.dart';
import 'package:school_for_blind_app/networking/network_exceptions.dart';
import 'package:school_for_blind_app/presentation/screens/Teacher/call/call_models.dart';

import 'call_screen.dart';

/// نقطة الدخول لزر المكالمات:
/// 1) يفحص الاتصال بالإنترنت أولاً.
/// 2) يجلب شعب المدرس من teacher/info.
/// 3) شعبة واحدة → يبدأ المكالمة فوراً.
///    أكثر من شعبة → يعرض قائمة صغيرة منسدلة بجانب الزر ليختار منها.
///
/// الاستعمال في زر المكالمات (مرّري الـ context الخاص بالأيقونة نفسها):
/// ```dart
/// IconButton(
///   icon: const Icon(Icons.call),
///   onPressed: () => openCallClassPicker(context, getIt<TeacherRepo>()),
/// )
/// ```
Future<void> openCallClassPicker(
  BuildContext context,
  TeacherRepo teacherRepo,
) async {
  // 1) فحص الاتصال أولاً — قبل أي نداء للسيرفر.
  final connectivity = await Connectivity().checkConnectivity();
  final hasNet = !connectivity.contains(ConnectivityResult.none);
  if (!hasNet) {
    if (context.mounted) {
      _snack(context, 'لا يوجد اتصال بالإنترنت، تحقق من الشبكة وحاول مجدداً');
    }
    return;
  }

  // 2) مؤشّر تحميل بسيط أثناء جلب الشعب.
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

  // شعبة واحدة → ابدأ مباشرة بدون قائمة.
  if (classes.length == 1) {
    _startCall(context, teacherRepo, classes.first);
    return;
  }

  // أكثر من شعبة → اعرض قائمة صغيرة منسدلة بجانب الزر.
  final selected = await _showClassMenuNearButton(context, classes);
  if (selected == null || !context.mounted) return;
  _startCall(context, teacherRepo, selected);
}

/// يعرض قائمة منسدلة صغيرة عند موقع الزر الذي استُدعي منه.
Future<SchoolClass?> _showClassMenuNearButton(
  BuildContext context,
  List<SchoolClass> classes,
) async {
  // نحسب موقع الزر على الشاشة لإظهار القائمة بجانبه.
  final overlay =
      Overlay.of(context).context.findRenderObject() as RenderBox?;
  final button = context.findRenderObject() as RenderBox?;
  if (overlay == null || button == null) {
    // احتياط: لو تعذّر تحديد الموقع، نعرض قرب أعلى-يمين الشاشة.
    return showMenu<SchoolClass>(
      context: context,
      position: const RelativeRect.fromLTRB(1000, 80, 16, 0),
      color: const Color(0xFF14202F),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
      items: _menuItems(classes),
    );
  }

  final position = RelativeRect.fromRect(
    Rect.fromPoints(
      button.localToGlobal(button.size.bottomLeft(Offset.zero),
          ancestor: overlay),
      button.localToGlobal(button.size.bottomRight(Offset.zero),
          ancestor: overlay),
    ),
    Offset.zero & overlay.size,
  );

  return showMenu<SchoolClass>(
    context: context,
    position: position,
    color: const Color(0xFF14202F),
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
    items: _menuItems(classes),
  );
}

List<PopupMenuEntry<SchoolClass>> _menuItems(List<SchoolClass> classes) {
  return [
    const PopupMenuItem<SchoolClass>(
      enabled: false,
      height: 34,
      child: Text(
        'اختر الشعبة',
        style: TextStyle(
          color: Colors.white54,
          fontSize: 13,
          fontWeight: FontWeight.bold,
        ),
      ),
    ),
    const PopupMenuDivider(),
    ...classes.map(
      (c) => PopupMenuItem<SchoolClass>(
        value: c,
        child: Row(
          textDirection: TextDirection.rtl,
          children: [
            const Icon(Icons.groups, color: Color(0xFFC8F526), size: 20),
            const SizedBox(width: 10),
            Expanded(
              child: Text(
                c.name,
                textDirection: TextDirection.rtl,
                style: const TextStyle(color: Colors.white, fontSize: 15),
              ),
            ),
          ],
        ),
      ),
    ),
  ];
}

void _startCall(BuildContext context, TeacherRepo repo, SchoolClass cls) {
  // اسم غرفة فريد لكل مكالمة (وقت + رقم عشوائي) لتفادي رفض السيرفر
  // "اسم الغرفة موجود مسبقاً". الشعبة تُحدّد عبر classId وليس عبر الاسم.
  final unique = DateTime.now().millisecondsSinceEpoch;
  final roomName = 'class-${cls.id}-$unique';

  Navigator.push(
    context,
    MaterialPageRoute(
      builder: (_) => CallScreen(
        roomName: roomName, // معرّف غرفة فريد يُرسل للـ API
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