import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:school_for_blind_app/apiTeacher/teacherRepo.dart';
import 'package:school_for_blind_app/business_logic/cubit/lessons_cubit.dart';
import 'package:school_for_blind_app/business_logic/cubit/result_state.dart';
import 'package:school_for_blind_app/core/injection.dart';
import 'package:school_for_blind_app/core/theme/app_colors.dart';
import 'package:school_for_blind_app/networking/api_result.dart';

class StatisticsScreen extends StatefulWidget {
  const StatisticsScreen({super.key});

  @override
  State<StatisticsScreen> createState() => _StatisticsScreenState();
}

class _StatisticsScreenState extends State<StatisticsScreen> {
  bool _loading = true;
  String? _error;

  /// كل المواد (لاختيار المادة المطابقة)
  List<Map<String, dynamic>> _allSubjects = [];

  @override
  void initState() {
    super.initState();
    _load();
  }

  int? get _currentSubjectId => getIt<LessonsCubit>().selectedSubject?.id;

  Future<void> _load() async {
    setState(() {
      _loading = true;
      _error = null;
    });

    final result = await getIt<TeacherRepo>().getStatistics();

    result.when(
      success: (data) {
        final map = (data is Map) ? Map<String, dynamic>.from(data) : {};
        final list = (map['data'] is List) ? map['data'] as List : const [];
        setState(() {
          _allSubjects = list
              .whereType<Map>()
              .map((e) => Map<String, dynamic>.from(e))
              .toList();
          _loading = false;
        });
      },
      failure: (_) {
        setState(() {
          _loading = false;
          _error = 'تعذّر تحميل الإحصائيات، حاول مجدداً';
        });
      },
    );
  }

  /// إحصائيات المادة المختارة حالياً
  Map<String, dynamic>? get _currentStats {
    final sid = _currentSubjectId;
    for (final s in _allSubjects) {
      if (int.tryParse('${s['subject_id']}') == sid) return s;
    }
    // إن لم نجد، نعرض أول مادة
    return _allSubjects.isNotEmpty ? _allSubjects.first : null;
  }

  String _typeLabel(String type) =>
      type.toLowerCase() == 'quiz' ? 'كويز' : 'اختبار';

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: AppColors.kBackgroundColor,
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Divider(color: Colors.white24, thickness: 1, height: 10),
                _buildTopBar(),
                const Divider(color: Colors.white24, thickness: 1, height: 10),
                const SizedBox(height: 16),
                _buildSubjectHeader(),
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
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        const Text(
          'الإحصائيات',
          style: TextStyle(
            color: Colors.white,
            fontSize: 40,
            fontFamily: 'ArabicTypesetting',
          ),
        ),
        IconButton(
          icon: const Icon(
            Icons.subdirectory_arrow_left,
            size: 30,
            color: Colors.white,
          ),
          onPressed: () => Navigator.pop(context),
        ),
      ],
    );
  }

  Widget _buildSubjectHeader() {
    final cubit = getIt<LessonsCubit>();
    return BlocBuilder<LessonsCubit, ResultState<dynamic>>(
      bloc: cubit,
      builder: (context, state) {
        final subject = cubit.selectedSubject;
        final hasMultiple = cubit.taughtSubjects.length > 1;

        return GestureDetector(
          behavior: HitTestBehavior.opaque,
          onTap: hasMultiple ? () => _showSubjectsSheet(cubit) : null,
          child: Directionality(
            textDirection: TextDirection.ltr, // ⬅️ يعكس ترتيب السهم والاسم
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Text(
                  subject != null ? ':${subject.name}' : 'المادة',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 40,
                    fontWeight: FontWeight.w400,
                  ),
                ),
                if (hasMultiple) ...[
                  const SizedBox(width: 4),
                  const Icon(
                    Icons.keyboard_arrow_down,
                    color: Colors.white,
                    size: 26,
                  ),
                ],
              ],
            ),
          ),
        );
      },
    );
  }

  void _showSubjectsSheet(LessonsCubit cubit) {
    showModalBottomSheet(
      context: context,
      backgroundColor: AppColors.kBackgroundColor,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (sheetCtx) => Directionality(
        textDirection: TextDirection.rtl,
        child: SafeArea(
          child: ListView(
            shrinkWrap: true,
            padding: const EdgeInsets.symmetric(vertical: 8),
            children: cubit.taughtSubjects.map((s) {
              final selected = s.id == cubit.selectedSubject?.id;
              return ListTile(
                title: Text(
                  s.name,
                  style: TextStyle(
                    color: selected ? AppColors.kPrimaryColor : Colors.white,
                    fontSize: 18,
                  ),
                ),
                trailing: selected
                    ? const Icon(Icons.check, color: AppColors.kPrimaryColor)
                    : null,
                onTap: () async {
                  Navigator.pop(sheetCtx);
                  await cubit.selectSubject(s);
                  if (mounted) setState(() {}); // إعادة عرض إحصائيات المادة
                },
              );
            }).toList(),
          ),
        ),
      ),
    );
  }

  Widget _buildBody() {
    if (_loading) {
      return const Center(
        child: CircularProgressIndicator(color: Colors.white),
      );
    }
    if (_error != null) {
      return Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              _error!,
              style: const TextStyle(color: Colors.white70, fontSize: 20),
            ),
            const SizedBox(height: 12),
            TextButton(
              onPressed: _load,
              child: const Text(
                'إعادة المحاولة',
                style: TextStyle(color: Colors.white, fontSize: 20),
              ),
            ),
          ],
        ),
      );
    }

    final stats = _currentStats;
    if (stats == null) {
      return _emptyMessage('لا توجد إحصائيات متاحة');
    }

    final hasAssessments = stats['has_assessments'] == true;
    final latest = (stats['latest_assessment'] is Map)
        ? Map<String, dynamic>.from(stats['latest_assessment'])
        : null;

    if (!hasAssessments || latest == null) {
      return _emptyMessage('لا توجد تقييمات لهذه المادة بعد');
    }

    // القائمة السفلية: نسب الرسوب (الكويزات)
    final critical = (stats['critical_assessments'] is List)
        ? (stats['critical_assessments'] as List)
              .whereType<Map>()
              .map((e) => Map<String, dynamic>.from(e))
              .toList()
        : <Map<String, dynamic>>[];

    return ListView(
      padding: const EdgeInsets.only(bottom: 20),
      children: [
        // البطاقة والمخطط: آخر اختبار
        _buildSummaryCard(latest),
        const SizedBox(height: 24),
        _buildBracketsChart(latest),
        if (critical.isNotEmpty) ...[
          const SizedBox(height: 24),
          _buildCriticalList(critical),
        ],
      ],
    );
  }

  Widget _emptyMessage(String msg) => Center(
    child: Text(
      msg,
      style: TextStyle(color: Colors.white.withOpacity(0.5), fontSize: 22),
    ),
  );

  Widget _buildSummaryCard(Map<String, dynamic> latest) {
     print('🟠 LATEST: $latest'); 
    final total = int.tryParse('${latest['total_students_took_it']}') ?? 0;
    final passed = int.tryParse('${latest['passed_count']}') ?? 0;
    final failed = int.tryParse('${latest['failed_count']}') ?? 0;

    final passRate = total > 0 ? ((passed / total) * 100).round() : 0;
    final failRate = total > 0 ? ((failed / total) * 100).round() : 0;

    return Container(
      width: 352,
      height: 147,
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF628500), Color(0xFFD3FF54)],
          begin: Alignment.topRight,
          end: Alignment.bottomLeft,
        ),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.white.withOpacity(0.1), width: 1),
      ),
      clipBehavior: Clip.antiAlias,
      child: Stack(
        children: [
          // مربّع زخرفي شفّاف (يسار الأعلى)
          Positioned(
            left: -20,
            top: -20,
            child: Container(
              width: 110,
              height: 150,
              decoration: BoxDecoration(
                color: const Color(0xFF1E3A5F).withOpacity(0.2),
                borderRadius: BorderRadius.circular(30),
              ),
            ),
          ),
          // مربّع زخرفي شفّاف (يسار الأسفل)
          Positioned(
            left: 20,
            bottom: -20,
            child: Container(
              width: 110,
              height: 100,
              decoration: BoxDecoration(
                color: const Color(0xFF1E3A5F).withOpacity(0.2),
                borderRadius: BorderRadius.circular(20),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _summaryRow('إجمالي الطلاب', '$total'),
                const SizedBox(height: 2),
                _summaryRow('نسبة النجاح', '$passRate%'),
                const SizedBox(height: 2),
                _summaryRow('نسبة الرسوب', '$failRate%'),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _summaryRow(String label, String value) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          ' $label : ',
          style: const TextStyle(
            color: Colors.white,
            fontFamily: 'ArabicTypesetting',

            fontSize: 30,
            fontWeight: FontWeight.w400,
          ),
        ),
        Text(
          value,
          style: const TextStyle(
            color: Colors.white,
            fontFamily: 'ArabicTypesetting',

            fontSize: 30,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(width: 6),
      ],
    );
  }

  /// رسم الأعمدة اليدوي من score_brackets_percentages
  Widget _buildBracketsChart(Map<String, dynamic> latest) {
    final brackets = (latest['score_brackets_percentages'] is Map)
        ? Map<String, dynamic>.from(latest['score_brackets_percentages'])
        : <String, dynamic>{};

    if (brackets.isEmpty) return const SizedBox.shrink();

    // نُبقي ترتيب الباك: من الشريحة الأعلى (يسار) إلى الأدنى (يمين)
    final values = brackets.values
        .map((v) => (double.tryParse('$v') ?? 0).clamp(0, 100).toDouble())
        .toList();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'النسبة المئوية لعدد الطلاب حسب الدرجة:',
          style: TextStyle(color: Colors.white, fontSize: 30),
        ),
        const SizedBox(height: 14),
        Container(
          padding: const EdgeInsets.fromLTRB(10, 16, 16, 12),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.04),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.white.withOpacity(0.1)),
          ),
          // اتجاه إنجليزي: المحور يسار والأعمدة تتدرّج لليمين
          child: Directionality(
            textDirection: TextDirection.ltr,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  // ارتفاع المنطقة = ارتفاع الأعمدة + مساحة فارغة فوقها
                  height: _maxBarHeight + _chartHeadroom,
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      _buildYAxis(),
                      const SizedBox(width: 6),
                      // خط المحور العمودي (يمتد فوق أعلى عمود)
                      Container(
                        width: 1.5,
                        height: _maxBarHeight + _chartHeadroom,
                        color: Colors.white70,
                      ),
                      Expanded(
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: List.generate(
                            values.length,
                            (i) => _buildBar(values[i], i, values.length),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                // خط الأساس الأفقي
                Padding(
                  padding: const EdgeInsets.only(left: _yAxisWidth + 6),
                  child: Container(height: 1.5, color: Colors.white70),
                ),
                const SizedBox(height: 6),
                // تدرّج المحور الأفقي: 0 .. 100
                Padding(
                  padding: const EdgeInsets.only(left: _yAxisWidth + 6),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: List.generate(6, (i) {
                      return Text(
                        '${i * 20}',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                        ),
                      );
                    }),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  /// ارتفاع العمود عند 100%
  static const double _maxBarHeight = 300;

  /// مساحة فارغة فوق أطول عمود (حتى لا يلامس أعلى المخطط)
  static const double _chartHeadroom = 40;

  static const double _yAxisWidth = 42;

  /// المحور العمودي: من 0% إلى 100% بخطوات 10%
  Widget _buildYAxis() {
    return SizedBox(
      width: _yAxisWidth,
      // نفس ارتفاع الأعمدة حتى تتطابق النسب مع الأعمدة
      height: _maxBarHeight,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: List.generate(11, (i) {
          final val = 100 - (i * 10);
          return Text(
            '$val%',
            style: const TextStyle(color: Colors.white, fontSize: 18),
          );
        }),
      ),
    );
  }

  static const List<Color> _barColors = [
    Color(0xFFD3FF54),
    Color(0xFFC5FF1F),
    Color(0xFFA5D91A),
    Color(0xFF85AF0F),
    Color(0xFF628500),
  ];

  Widget _buildBar(double pct, int index, int total) {
    final barHeight = (pct / 100) * _maxBarHeight;

    // توزيع الألوان على عدد الشرائح مهما كان
    final colorIndex = total <= 1
        ? 0
        : ((index / (total - 1)) * (_barColors.length - 1)).round();

    return Expanded(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 6),
        child: Align(
          alignment: Alignment.bottomCenter,
          child: Container(
            width: 34,
            height: barHeight < 2 ? 2 : barHeight,
            decoration: BoxDecoration(
              color: _barColors[colorIndex],
              borderRadius: const BorderRadius.vertical(
                top: Radius.circular(5),
              ),
            ),
          ),
        ),
      ),
    );
  }

  /// قائمة التقييمات ذات نسبة الرسوب العالية
  Widget _buildCriticalList(List<Map<String, dynamic>> critical) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'قائمة الكويزات التي نسبة الرسوب فيها عالية:',
          style: TextStyle(
            color: Colors.white,
            fontSize: 30,
            decoration: TextDecoration.underline,
            decorationColor: Colors.white54,
          ),
        ),
        const SizedBox(height: 12),
        ...critical.map((c) {
          final title = (c['title'] ?? '').toString();
          final type = _typeLabel((c['type'] ?? '').toString());
          final failRate = c['fail_rate'] ?? 0;

          return Container(
            margin: const EdgeInsets.only(bottom: 12),
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.06),
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: Colors.redAccent.withOpacity(0.3)),
            ),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 3,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Text(
                    type,
                    style: const TextStyle(color: Colors.white70, fontSize: 13),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    title,
                    style: const TextStyle(color: Colors.white, fontSize: 18),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                Text(
                  'رسوب $failRate%',
                  style: const TextStyle(
                    color: Colors.redAccent,
                    fontSize: 15,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          );
        }),
      ],
    );
  }
}
