import 'package:flutter/material.dart';
import 'package:school_for_blind_app/apiTeacher/teacherRepo.dart';
import 'package:school_for_blind_app/core/injection.dart';
import 'package:school_for_blind_app/core/theme/app_colors.dart';
import 'package:school_for_blind_app/networking/api_result.dart';

/// حصّة في الجدول
class ScheduleSlot {
  final int day; // 1=الأحد..
  final int periodNumber;
  final String subjectName;
  final String className;
  final String startTime;
  final String endTime;

  const ScheduleSlot({
    required this.day,
    required this.periodNumber,
    required this.subjectName,
    required this.className,
    required this.startTime,
    required this.endTime,
  });
}

class TeacherScheduleScreen extends StatefulWidget {
  const TeacherScheduleScreen({super.key});

  @override
  State<TeacherScheduleScreen> createState() => _TeacherScheduleScreenState();
}

class _TeacherScheduleScreenState extends State<TeacherScheduleScreen> {
  bool _loading = true;
  String? _error;

  // كل الحصص
  final List<ScheduleSlot> _slots = [];

  // أيام العرض (أعمدة) — 1=الأحد
  static const List<int> _days = [1, 2, 3, 4, 5];
  static const Map<int, String> _dayNames = {
    1: 'الأحد',
    2: 'الإثنين',
    3: 'الثلاثاء',
    4: 'الأربعاء',
    5: 'الخميس',
  };

  /// تحويل اسم/رقم اليوم إلى رقم موحّد (1=الأحد)
  int _dayToNumber(String raw) {
    // إن كان رقماً
    final asNum = int.tryParse(raw);
    if (asNum != null) return asNum;
    // إن كان اسماً عربياً (مع تفاوت الهمزة)
    final n = raw.trim();
    if (n.contains('أحد') || n.contains('احد')) return 1;
    if (n.contains('اثنين') || n.contains('إثنين')) return 2;
    if (n.contains('ثلاثاء') || n.contains('ثلاث')) return 3;
    if (n.contains('أربعاء') || n.contains('اربع')) return 4;
    if (n.contains('خميس')) return 5;
    if (n.contains('جمعة')) return 6;
    if (n.contains('سبت')) return 7;
    return 0;
  }

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    setState(() {
      _loading = true;
      _error = null;
    });

    final result = await getIt<TeacherRepo>().getTeacherSchedule();

    result.when(
      success: (data) {
        final map = (data is Map) ? Map<String, dynamic>.from(data) : {};
        final dataObj = map['data'];

        _slots.clear();

        if (dataObj is Map) {
          final days = Map<String, dynamic>.from(dataObj);
          days.forEach((dayKey, slots) {
            final day = _dayToNumber(dayKey);
            if (day == 0 || slots is! List) return;

            for (final e in slots) {
              if (e is! Map) continue;
              final m = Map<String, dynamic>.from(e);
              final subject = (m['subject'] is Map)
                  ? Map<String, dynamic>.from(m['subject'])
                  : {};
              final klass = (m['student_class'] is Map)
                  ? Map<String, dynamic>.from(m['student_class'])
                  : {};

              final period = int.tryParse('${m['period_number']}') ?? 0;
              // تجاهل التكرار: نفس اليوم + الحصة موجودة مسبقاً
              final exists = _slots.any(
                  (x) => x.day == day && x.periodNumber == period);
              if (exists) continue;

              _slots.add(ScheduleSlot(
                day: day,
                periodNumber: period,
                subjectName: (subject['name'] ?? '').toString(),
                className: (klass['name'] ?? '').toString(),
                startTime: _shortTime((m['start_time'] ?? '').toString()),
                endTime: _shortTime((m['end_time'] ?? '').toString()),
              ));
            }
          });
        }

        setState(() => _loading = false);
      },
      failure: (_) {
        setState(() {
          _error = 'تعذّر تحميل جدول الدوام';
          _loading = false;
        });
      },
    );
  }

  String _shortTime(String t) => t.length >= 5 ? t.substring(0, 5) : t;

  /// أقصى رقم حصة (لتحديد عدد الصفوف)
  int get _maxPeriod {
    var mx = 0;
    for (final s in _slots) {
      if (s.periodNumber > mx) mx = s.periodNumber;
    }
    return mx;
  }

  /// الحصة عند (يوم، رقم الحصة) إن وُجدت
  ScheduleSlot? _slotAt(int day, int period) {
    for (final s in _slots) {
      if (s.day == day && s.periodNumber == period) return s;
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    final onSurface = Theme.of(context).colorScheme.onSurface;

    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Divider(
                    color: onSurface.withOpacity(0.24), thickness: 1, height: 20),
                _buildTopBar(),
                Divider(
                    color: onSurface.withOpacity(0.24), thickness: 1, height: 20),
                const SizedBox(height: 16),
                Expanded(child: _buildBody()),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTopBar() {
    final onSurface = Theme.of(context).colorScheme.onSurface;
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Padding(
          padding: const EdgeInsets.only(right: 8),
          child: Text(
            'جدول الدوام',
            style: TextStyle(
                color: onSurface, fontSize: 30, fontFamily: "ArabicTypesetting"),
          ),
        ),
        IconButton(
          icon: Icon(Icons.subdirectory_arrow_left, size: 30, color: onSurface),
          onPressed: () => Navigator.pop(context),
        ),
      ],
    );
  }

  Widget _buildBody() {
    if (_loading) {
      return Center(
          child: CircularProgressIndicator(
              color: Theme.of(context).colorScheme.primary));
    }
    if (_error != null) {
      return Center(
        child: Text(_error!,
            style: TextStyle(
                color: Theme.of(context).colorScheme.onSurface.withOpacity(0.7),
                fontSize: 20)),
      );
    }
    if (_slots.isEmpty) {
      return Center(
        child: Text('لا يوجد جدول دوام',
            style: TextStyle(
                color: Theme.of(context).colorScheme.onSurface.withOpacity(0.5),
                fontSize: 22)),
      );
    }

    // شبكة: أعمدة = أيام، صفوف = حصص
    return SingleChildScrollView(
      scrollDirection: Axis.vertical,
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: _buildGrid(),
      ),
    );
  }

  Widget _buildGrid() {
    final primary = Theme.of(context).colorScheme.primary;
    final onSurface = Theme.of(context).colorScheme.onSurface;

    const double cellWidth = 110;
    const double periodColWidth = 60;

    return Column(
      children: [
        // صف الرأس: زاوية فارغة + أسماء الأيام
        Row(
          children: [
            _headerCell('الحصة/اليوم', periodColWidth, primary),
            ..._days.map((d) => _headerCell(_dayNames[d]!, cellWidth, primary)),
          ],
        ),
        // صفوف الحصص
        ...List.generate(_maxPeriod, (i) {
          final period = i + 1;
          return Row(
            children: [
              // عمود رقم الحصة
              Container(
                width: periodColWidth,
                height: 70,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: AppColors.kPrimaryColor, // عمود الحصص فوسفوري
                  border: Border.all(color: Colors.black),
                ),
                child: Text('$period',
                    style: const TextStyle(
                        color: Colors.black,
                        fontSize: 18,
                        fontWeight: FontWeight.bold)),
              ),
              // خلايا الأيام
              ..._days.map((day) {
                final slot = _slotAt(day, period);
                return _buildCell(slot, cellWidth, onSurface);
              }),
            ],
          );
        }),
      ],
    );
  }

  Widget _headerCell(String text, double width, Color primary) {
    return Container(
      width: width,
      height: 46,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: AppColors.kPrimaryColor, // رأس فوسفوري
        border: Border.all(color: Colors.black), // خطوط سوداء
      ),
      child: Text(
        text,
        textAlign: TextAlign.center,
        style: const TextStyle(
            color: Colors.black, fontSize: 15, fontWeight: FontWeight.bold),
      ),
    );
  }

  Widget _buildCell(ScheduleSlot? slot, double width, Color onSurface) {
    return Container(
      width: width,
      height: 70,
      padding: const EdgeInsets.all(4),
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: Colors.white, // خلايا بيضاء
        border: Border.all(color: Colors.black), // خطوط سوداء
      ),
      child: slot == null
          ? const SizedBox.shrink()
          : Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  slot.subjectName,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                      color: Colors.black, // كتابة سوداء
                      fontSize: 14,
                      fontWeight: FontWeight.w600),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                if (slot.className.isNotEmpty) ...[
                  const SizedBox(height: 2),
                  Text(
                    slot.className,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        color: Colors.black.withOpacity(0.6), fontSize: 11),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ],
            ),
    );
  }
}