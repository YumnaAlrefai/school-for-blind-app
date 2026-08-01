import 'package:flutter/material.dart';
import 'package:school_for_blind_app/core/injection.dart';
import 'package:school_for_blind_app/core/theme/app_colors.dart';
import 'package:school_for_blind_app/data/repository/teacher_repo.dart' show TeacherRepo;
import 'package:school_for_blind_app/networking/api_result.dart';

class ExamScheduleScreen extends StatefulWidget {
  final int announcementId;
  final String title;

  const ExamScheduleScreen({
    super.key,
    required this.announcementId,
    required this.title,
  });

  @override
  State<ExamScheduleScreen> createState() => _ExamScheduleScreenState();
}

class _ExamScheduleScreenState extends State<ExamScheduleScreen> {
  bool _loading = true;
  String? _error;

  List<String> _columns = [];
  List<Map<String, dynamic>> _rows = [];

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

    final result = await getIt<TeacherRepo>().getExamSchedule(
      widget.announcementId,
    );

    result.when(
      success: (data) {
        final map = (data is Map) ? Map<String, dynamic>.from(data) : {};
        final program = (map['exam_program'] is Map)
            ? Map<String, dynamic>.from(map['exam_program'])
            : {};

        final cols = (program['columns'] is List)
            ? (program['columns'] as List).map((e) => e.toString()).toList()
            : <String>[];
        final rows = (program['rows'] is List)
            ? (program['rows'] as List)
                  .whereType<Map>()
                  .map((e) => Map<String, dynamic>.from(e))
                  .toList()
            : <Map<String, dynamic>>[];

        setState(() {
          _columns = cols;
          _rows = rows;
          _loading = false;
        });
      },
      failure: (_) {
        setState(() {
          _error = 'تعذّر تحميل جدول الامتحان';
          _loading = false;
        });
      },
    );
  }

  final List<String> _rowKeys = ['date', 'subject', 'time'];

  String _cellValue(Map<String, dynamic> row, int colIndex) {
    if (colIndex < _rowKeys.length) {
      return (row[_rowKeys[colIndex]] ?? '').toString();
    }
    return '';
  }

  @override
  Widget build(BuildContext context) {
    final onSurface = Theme.of(context).colorScheme.onSurface;

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
                Divider(
                  color: onSurface.withOpacity(0.24),
                  thickness: 1,
                  height: 20,
                ),
                _buildTopBar(),
                Divider(
                  color: onSurface.withOpacity(0.24),
                  thickness: 1,
                  height: 20,
                ),
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
    final onSurface = Theme.of(context).colorScheme.onSurface;
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          child: Text(
            widget.title,
            style: TextStyle(
              color: onSurface,
              fontSize: 30,
              fontFamily: "ArabicTypesetting",
            ),
            overflow: TextOverflow.ellipsis,
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
          color: Theme.of(context).colorScheme.primary,
        ),
      );
    }
    if (_error != null) {
      return Center(
        child: Text(
          _error!,
          style: TextStyle(
            color: Theme.of(context).colorScheme.onSurface.withOpacity(0.7),
            fontSize: 20,
          ),
        ),
      );
    }
    if (_columns.isEmpty || _rows.isEmpty) {
      return Center(
        child: Text(
          'لا يوجد جدول امتحان',
          style: TextStyle(
            color: Theme.of(context).colorScheme.onSurface.withOpacity(0.5),
            fontSize: 22,
          ),
        ),
      );
    }

    return SingleChildScrollView(child: _buildTable());
  }

  Widget _buildTable() {
    final onSurface = Theme.of(context).colorScheme.onSurface;

    return Column(
      children: [
        // رأس الجدول
        Container(
          decoration: BoxDecoration(
            color: onSurface.withOpacity(0.15),
            borderRadius: const BorderRadius.vertical(top: Radius.circular(10)),
          ),
          child: Row(
            children: _columns
                .map(
                  (c) => Expanded(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        vertical: 14,
                        horizontal: 8,
                      ),
                      child: Text(
                        c,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: AppColors.kPrimaryColor,
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                )
                .toList(),
          ),
        ),
        ..._rows.asMap().entries.map((entry) {
          final i = entry.key;
          final row = entry.value;
          return Container(
            decoration: BoxDecoration(
              color: i.isEven
                  ? onSurface.withOpacity(0.03)
                  : Colors.transparent,
              border: Border(
                bottom: BorderSide(color: onSurface.withOpacity(0.1)),
              ),
            ),
            child: Row(
              children: List.generate(_columns.length, (colIndex) {
                return Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      vertical: 16,
                      horizontal: 8,
                    ),
                    child: Text(
                      _cellValue(row, colIndex),
                      textAlign: TextAlign.center,
                      style: TextStyle(color: onSurface, fontSize: 15),
                    ),
                  ),
                );
              }),
            ),
          );
        }),
      ],
    );
  }
}
