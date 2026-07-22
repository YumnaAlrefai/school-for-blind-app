import 'package:flutter/material.dart';
import 'package:school_for_blind_app/apiTeacher/teacherRepo.dart';
import 'package:school_for_blind_app/core/injection.dart';
import 'package:school_for_blind_app/core/theme/app_colors.dart';
import 'package:school_for_blind_app/networking/api_result.dart';


class SchoolTimetableScreen extends StatefulWidget {
  const SchoolTimetableScreen({super.key});

  @override
  State<SchoolTimetableScreen> createState() => _SchoolTimetableScreenState();
}

class _SchoolTimetableScreenState extends State<SchoolTimetableScreen> {
  bool _loading = true;
  String? _error;

  String _title = '';
  List<String> _columns = [];
  List<Map<String, dynamic>> _rows = [];

  
  static const Map<String, String> _columnKeys = {
    'الحصة': 'period',
    'الأحد': 'sunday',
    'الإثنين': 'monday',
    'الاثنين': 'monday',
    'الثلاثاء': 'tuesday',
    'الأربعاء': 'wednesday',
    'الاربعاء': 'wednesday',
    'الخميس': 'thursday',
    'الجمعة': 'friday',
    'السبت': 'saturday',
  };

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

    final result = await getIt<TeacherRepo>().getSchoolTimetable();

    result.when(
      success: (data) {
        final map = (data is Map) ? Map<String, dynamic>.from(data) : {};

        
        final rawTable = map['timetable_data'] ?? map['content'];
        final table = (rawTable is Map)
            ? Map<String, dynamic>.from(rawTable)
            : <String, dynamic>{};

        final cols = (table['columns'] is List)
            ? (table['columns'] as List).map((e) => e.toString()).toList()
            : <String>[];

        final rows = <Map<String, dynamic>>[];
        if (table['rows'] is List) {
          for (final r in table['rows'] as List) {
            if (r is Map) rows.add(Map<String, dynamic>.from(r));
          }
        }

        setState(() {
          _title = (map['title'] ?? 'جدول الدوام').toString();
          _columns = cols;
          _rows = rows;
          _loading = false;
        });
      },
      failure: (_) {
        setState(() {
          _loading = false;
          _error = 'تعذّر تحميل الجدول، حاول مجدداً';
        });
      },
    );
  }

  
  
  String _cellValue(Map<String, dynamic> row, String column, int colIndex) {
    final key = _columnKeys[column.trim()];
    if (key != null && row.containsKey(key)) {
      return (row[key] ?? '').toString();
    }
    
    final keys = row.keys.toList();
    if (colIndex < keys.length) {
      return (row[keys[colIndex]] ?? '').toString();
    }
    return '';
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: AppColors.kBackgroundColor,
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 10),
                _buildTopBar(),
                const SizedBox(height: 20),
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
        const Expanded(
          child: Text(
            'جدول الدوام',
            style: TextStyle(
              color: Colors.white,
              fontSize: 30,
              fontFamily: "Arabic Typesetting",
              fontWeight: FontWeight.w300,
            ),
          ),
        ),
        IconButton(
          icon: const Icon(Icons.subdirectory_arrow_left,
              size: 30, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
      ],
    );
  }

  Widget _buildBody() {
    if (_loading) {
      return const Center(
          child: CircularProgressIndicator(color: Colors.white));
    }

    if (_error != null) {
      return Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(_error!,
                style: const TextStyle(color: Colors.white70, fontSize: 20)),
            const SizedBox(height: 12),
            TextButton(
              onPressed: _load,
              child: const Text('إعادة المحاولة',
                  style: TextStyle(color: Colors.white, fontSize: 20)),
            ),
          ],
        ),
      );
    }

    if (_columns.isEmpty || _rows.isEmpty) {
      return Center(
        child: Text(
          'لا يوجد جدول دوام حالياً',
          style: TextStyle(color: Colors.white.withOpacity(0.5), fontSize: 22),
        ),
      );
    }

    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          
          if (_title.isNotEmpty) ...[
            Text(
              _title,
              style: const TextStyle(color: Colors.white70, fontSize: 20),
            ),
            const SizedBox(height: 16),
          ],

          
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Column(
              children: [
                _buildHeaderRow(),
                ..._rows.map(_buildDataRow),
              ],
            ),
          ),
          const SizedBox(height: 20),
        ],
      ),
    );
  }

  Widget _buildHeaderRow() {
    return Row(
      children: List.generate(_columns.length, (i) {
        return Container(
          width: i == 0 ? 90 : 120,
          padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 8),
          margin: const EdgeInsets.only(left: 4, bottom: 4),
          decoration: BoxDecoration(
            color: AppColors.kPrimaryColor.withOpacity(0.15),
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: AppColors.kPrimaryColor.withOpacity(0.4)),
          ),
          child: Text(
            _columns[i],
            textAlign: TextAlign.center,
            style: const TextStyle(
              color: AppColors.kPrimaryColor,
              fontSize: 18,
              fontWeight: FontWeight.w500,
            ),
          ),
        );
      }),
    );
  }

  Widget _buildDataRow(Map<String, dynamic> row) {
    return Row(
      children: List.generate(_columns.length, (i) {
        final value = _cellValue(row, _columns[i], i);
        final isFirst = i == 0;

        return Container(
          width: isFirst ? 90 : 120,
          padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 8),
          margin: const EdgeInsets.only(left: 4, bottom: 4),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(isFirst ? 0.10 : 0.05),
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: Colors.white.withOpacity(0.15)),
          ),
          child: Text(
            value.trim().isEmpty ? '—' : value,
            textAlign: TextAlign.center,
            style: TextStyle(
              color: value.trim().isEmpty ? Colors.white24 : Colors.white,
              fontSize: 18,
              fontWeight: isFirst ? FontWeight.w500 : FontWeight.normal,
            ),
          ),
        );
      }),
    );
  }
}