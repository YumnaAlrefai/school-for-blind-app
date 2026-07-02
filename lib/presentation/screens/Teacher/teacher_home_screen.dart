import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:school_for_blind_app/apiTeacher/lesson_audio_service.dart';
import 'package:school_for_blind_app/apiTeacher/teacherRepo.dart';
import 'package:school_for_blind_app/business_logic/cubit/lessons_cubit.dart';
import 'package:school_for_blind_app/business_logic/cubit/result_state.dart';
import 'package:school_for_blind_app/business_logic/cubit/teacher_cubit.dart';
import 'package:school_for_blind_app/core/injection.dart';
import 'package:school_for_blind_app/core/routing/app_routes.dart';
import 'package:school_for_blind_app/core/theme/app_colors.dart';
import 'package:school_for_blind_app/presentation/screens/Teacher/call/start_call_picker.dart';
import 'package:school_for_blind_app/presentation/widgets/custom_bottomNav_teacher.dart';
import 'package:school_for_blind_app/presentation/widgets/custom_drawer_teacher.dart';
import 'package:school_for_blind_app/presentation/widgets/lesson_audio_card.dart';

class Lesson {
  final int id;
  final String title;
  final String duration;
  final String audioUrl;

  const Lesson({
    required this.id,
    required this.title,
    required this.duration,
    required this.audioUrl,
  });

  factory Lesson.fromJson(Map<String, dynamic> json) {
    // الرد الجديد: رابط الصوت يجي من أول تسجيل داخل records (record_url).
    // بنجيب أول تسجيل فقط حالياً (الدرس ممكن يكون له عدة تسجيلات لاحقاً).
    String audio = '';
    final records = json['records'];
    if (records is List && records.isNotEmpty && records.first is Map) {
      final first = records.first as Map;
      audio = (first['record_url'] ?? first['record_path'] ?? '').toString();
    }
    // fallback للأشكال القديمة إذا رجع audio_url مباشرة
    if (audio.isEmpty) {
      audio = (json['audio_url'] ?? '').toString();
    }

    return Lesson(
      id: json['id'] ?? 0,
      title: (json['title'] ?? '').toString(),
      duration: (json['duration'] ?? '00:00').toString(),
      audioUrl: audio,
    );
  }
}

class LessonsScreen extends StatefulWidget {
  const LessonsScreen({super.key});

  @override
  State<LessonsScreen> createState() => _LessonsScreenState();
}

class _LessonsScreenState extends State<LessonsScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final LessonAudioService _audioService = LessonAudioService();

  int _currentNavIndex = 4;
  int? _expandedIndex;
  double _speed = 1.0;
  int? _deleteModeIndex;

  /// ⬅️ رقم زر + في الـ bottom nav — عدّله ليطابق ترتيب الأزرار عندك
  static const int _addButtonIndex = 2;

  @override
  void initState() {
    super.initState();
    // ✅ صار يجيب مواد المدرس + دروس أول مادة (بدل emitGetLessons)
    getIt<LessonsCubit>().emitInitLessons();
  }

  @override
  void dispose() {
    _audioService.dispose();
    super.dispose();
  }

  /// التنقل في الشريط السفلي — زر + يفتح شاشة رفع درس
  void _onNavTap(int index) {
    if (index == _addButtonIndex) {
      _openAddLesson();
      return; // لا نغيّر التبويب المحدد
    }
    setState(() => _currentNavIndex = index);
  }

  Future<void> _openAddLesson() async {
    // نوقف أي درس قيد التشغيل قبل مغادرة الشاشة
    await _audioService.stop();
    setState(() => _expandedIndex = null);

    if (!mounted) return;

    // نمرّر المادة الحالية لشاشة الرفع (بدل اختيارها من قائمة)
    await Navigator.pushNamed(
      context,
      AppRoutes.kAddLesson,
      arguments: getIt<LessonsCubit>().selectedSubject?.id,
    );

    // بعد الرجوع من شاشة الرفع، نحدّث دروس المادة الحالية
    getIt<LessonsCubit>().emitGetLessons();
  }

  Future<void> _onLessonTap(int index, Lesson lesson) async {
    // لمسة على أي بطاقة أثناء وضع الحذف = إلغاء الوضع
    if (_deleteModeIndex != null) {
      setState(() => _deleteModeIndex = null);
      return;
    }

    setState(() => _expandedIndex = index);

    try {
      await _audioService.playUrl(lesson.audioUrl, speed: _speed);
    } catch (_) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('تعذر تشغيل الدرس، تأكد من الاتصال')),
        );
      }
    }
  }

  Future<void> _onSpeedTap() async {
    setState(() {
      _speed = switch (_speed) {
        1.0 => 1.5,
        1.5 => 2.0,
        2.0 => 0.75,
        _ => 1.0,
      };
    });
    await _audioService.setSpeed(_speed);
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        key: _scaffoldKey,
        backgroundColor: AppColors.kBackgroundColor,
        drawer: CustomDrawer(
          userName: getIt<TeacherCubit>().currentTeacher?.fullName ?? 'مدرس',
          userPhone:
              getIt<TeacherCubit>().currentTeacher?.phone ?? '09********',
        ),
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 10),
                _buildTopBar(),
                const SizedBox(height: 20),
                _buildSearchField(),
                const SizedBox(height: 25),
                _buildSubjectHeader(), // ⬅️ بدل صف الفئات الثلاث
                const SizedBox(height: 25),
                _buildLessonsList(),
              ],
            ),
          ),
        ),
        bottomNavigationBar: CustomBottomNav(
          currentIndex: _currentNavIndex,
          onTap: _onNavTap, // ⬅️ ربط زر +
        ),
      ),
    );
  }

  Widget _buildTopBar() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        IconButton(
          icon: const Icon(Icons.menu, size: 30, color: Colors.white),
          onPressed: () => _scaffoldKey.currentState?.openDrawer(),
        ),
        Row(
          children: [
            // 📞 زر المكالمات المطور — يوقف الصوت أولاً ثم يفتح قائمة اختيار الشعب
            IconButton(
              icon: const Icon(Icons.call, size: 28, color: Colors.white),
              onPressed: () async {
                // 1) إيقاف أي درس صوتي شغال فوراً لمنع تداخل الأصوات
                await _audioService.stop();
                if (mounted) {
                  setState(() => _expandedIndex = null);
                }

                // 2) استدعاء الدالة الذكية لجلب الشعب وبدء الاتصال
                if (mounted) {
                  openCallClassPicker(context, getIt<TeacherRepo>());
                }
              },
            ),
            IconButton(
              icon: const Icon(
                Icons.notifications,
                size: 30,
                color: Colors.white,
              ),
              onPressed: () => Navigator.pushNamedAndRemoveUntil(
                context,
                AppRoutes.knotificationTeacher,
                (route) => false,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildSearchField() {
    return Container(
      width: 360,
      height: 56,
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.10),
        borderRadius: BorderRadius.circular(25),
      ),
      child: const TextField(
        textAlign: TextAlign.right,
        decoration: InputDecoration(
          hintText: 'بحث...',
          hintStyle: TextStyle(color: Colors.white38, fontSize: 30),
          prefixIcon: Icon(Icons.search, color: Colors.white38),
          border: InputBorder.none,
          contentPadding: EdgeInsets.symmetric(vertical: 5, horizontal: 20),
        ),
      ),
    );
  }

  /// اسم المادة الحالية + سهم يظهر فقط إذا المدرس يدرّس أكثر من مادة.
  /// الضغط على السهم يفتح قائمة المواد، واختيار مادة يبدّل الدروس المعروضة.
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
          child: Row(
            children: [
              Text(
                subject?.name ?? 'الدروس',
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                  fontWeight: FontWeight.w500,
                ),
              ),
              if (hasMultiple) ...[
                const SizedBox(width: 6),
                const Icon(
                  Icons.keyboard_arrow_down,
                  color: Colors.white,
                  size: 28,
                ),
              ],
            ],
          ),
        );
      },
    );
  }

  /// قائمة المواد التي يدرّسها المدرس (تظهر بالضغط على السهم)
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
                    ? Icon(Icons.check, color: AppColors.kPrimaryColor)
                    : null,
                onTap: () async {
                  Navigator.pop(sheetCtx);
                  await _audioService.stop();
                  if (!mounted) return;
                  setState(() {
                    _expandedIndex = null;
                    _deleteModeIndex = null;
                  });
                  cubit.selectSubject(s); // يعيد جلب دروس المادة المختارة
                },
              );
            }).toList(),
          ),
        ),
      ),
    );
  }

  Widget _buildLessonsList() {
    return Expanded(
      child: BlocBuilder<LessonsCubit, ResultState<dynamic>>(
        bloc: getIt<LessonsCubit>(),
        builder: (context, state) {
          return state.when(
            idle: () => const SizedBox.shrink(),
            loading: () => const Center(
              child: CircularProgressIndicator(color: Colors.white),
            ),
            failure: (error) => _buildErrorState(),
            success: (_) {
              final lessons = getIt<LessonsCubit>().lessons;
              if (lessons.isEmpty) return _buildEmptyState();

              // سحب للأسفل = تحديث دروس المادة الحالية من السيرفر
              return RefreshIndicator(
                color: AppColors.kPrimaryColor,
                backgroundColor: AppColors.kBackgroundColor,
                onRefresh: () async {
                  getIt<LessonsCubit>().emitGetLessons();
                },
                child: ListView.builder(
                  physics: const AlwaysScrollableScrollPhysics(),
                  itemCount: lessons.length,
                  itemBuilder: (context, index) => LessonAudioCard(
                    lesson: lessons[index],
                    isExpanded: _expandedIndex == index,
                    isDeleteMode: _deleteModeIndex == index,
                    audioService: _audioService,
                    speed: _speed,
                    onTap: () => _onLessonTap(index, lessons[index]),
                    onLongPress: () => _onLessonLongPress(index),
                    onDelete: () => _confirmDelete(lessons[index]),
                    onSpeedTap: _onSpeedTap,
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }

  /// شاشة فارغة توجّه المدرس لزر +
  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(
            Icons.headphones_outlined,
            size: 60,
            color: Colors.white24,
          ),
          const SizedBox(height: 15),
          const Text(
            'لا توجد دروس بعد',
            style: TextStyle(color: Colors.white70, fontSize: 18),
          ),
          const SizedBox(height: 8),
          Text(
            'اضغط زر + في الأسفل لرفع أول درس',
            style: TextStyle(
              color: Colors.white.withOpacity(0.4),
              fontSize: 14,
            ),
          ),
          const SizedBox(height: 20),
          ElevatedButton.icon(
            onPressed: _openAddLesson,
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.kPrimaryColor,
              padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            icon: const Icon(Icons.add, color: Colors.black),
            label: const Text(
              'رفع درس',
              style: TextStyle(color: Colors.black, fontSize: 16),
            ),
          ),
        ],
      ),
    );
  }

  /// حالة فشل التحميل مع زر إعادة محاولة واضح
  Widget _buildErrorState() {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.wifi_off_outlined, size: 50, color: Colors.white24),
          const SizedBox(height: 12),
          const Text(
            'تعذر تحميل الدروس',
            style: TextStyle(color: Colors.white70, fontSize: 17),
          ),
          const SizedBox(height: 15),
          TextButton.icon(
            onPressed: () => getIt<LessonsCubit>().emitInitLessons(),
            icon: const Icon(Icons.refresh, color: Colors.white),
            label: const Text(
              'إعادة المحاولة',
              style: TextStyle(color: Colors.white, fontSize: 15),
            ),
          ),
        ],
      ),
    );
  }

  void _onLessonLongPress(int index) async {
    await _audioService.stop(); // أوقف الصوت عند الدخول بوضع الحذف
    setState(() {
      _expandedIndex = null;
      _deleteModeIndex = index;
    });
  }

  Future<void> _confirmDelete(Lesson lesson) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => Directionality(
        textDirection: TextDirection.rtl,
        child: AlertDialog(
          backgroundColor: AppColors.kBackgroundColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
          title: const Text('حذف الدرس', style: TextStyle(color: Colors.white)),
          content: Text(
            'هل أنت متأكد من حذف "${lesson.title}"؟\nسيُحذف نهائياً من السيرفر.',
            style: const TextStyle(color: Colors.white70),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context, false),
              child: const Text(
                'إلغاء',
                style: TextStyle(color: Colors.white54),
              ),
            ),
            TextButton(
              onPressed: () => Navigator.pop(context, true),
              child: const Text(
                'حذف',
                style: TextStyle(color: Colors.redAccent),
              ),
            ),
          ],
        ),
      ),
    );

    if (confirmed == true) {
      getIt<LessonsCubit>().emitDeleteLesson(lesson.id);
    }
    setState(() => _deleteModeIndex = null);
  }
}