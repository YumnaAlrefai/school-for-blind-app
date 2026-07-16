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
import 'package:school_for_blind_app/networking/api_result.dart';
import 'package:school_for_blind_app/presentation/screens/Teacher/call/start_call_picker.dart';
import 'package:school_for_blind_app/presentation/screens/Teacher/question_bank_screen.dart';
import 'package:school_for_blind_app/presentation/widgets/custom_bottomNav_teacher.dart';
import 'package:school_for_blind_app/presentation/widgets/custom_drawer_teacher.dart';
import 'package:school_for_blind_app/presentation/widgets/lesson_audio_card.dart';

class Lesson {
  final int id;
  final String title;
  final String duration;
  final String audioUrl;
  final bool hasQuiz;

  const Lesson({
    required this.id,
    required this.title,
    required this.duration,
    required this.audioUrl,
    required this.hasQuiz,
  });

  factory Lesson.fromJson(Map<String, dynamic> json) {
    // رابط الصوت يجي من أول تسجيل داخل records (record_url).
    // بنجيب أول تسجيل فقط حالياً (الدرس ممكن يكون له عدة تسجيلات لاحقاً).
    String audio = '';
    final records = json['records'];
    if (records is List && records.isNotEmpty && records.first is Map) {
      final first = records.first as Map;
      audio =
          (first['url'] ?? first['record_url'] ?? first['record_path'] ?? '')
              .toString();
    }
    // fallback للأشكال القديمة إذا رجع audio_url مباشرة
    if (audio.isEmpty) {
      audio = (json['audio_url'] ?? '').toString();
    }

    return Lesson(
      id: json['id'] ?? 0,
      title: json['title'] ?? '',
      duration: json['duration'] ?? '00:00',
      audioUrl: audio,
      hasQuiz: json['has_quiz'] == true,
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
  int _selectedCategoryIndex = 1;
  int? _expandedIndex;
  double _speed = 1.0;
  int? _deleteModeIndex;
  // حلول الطلاب
  bool _loadingSolutions = false;
  String? _solutionsError;
  List<Map<String, dynamic>> _pendingQuizzes = [];

  /// ⬅️ رقم زر + في الـ bottom nav — عدّله ليطابق ترتيب الأزرار عندك
  static const int _addButtonIndex = 2;

  @override
  void initState() {
    super.initState();
    // يجيب مواد المدرس + دروس أول مادة
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
      return;
    }
    if (index == 1) {
      Navigator.pushNamed(context, AppRoutes.kQuestionBank);
      return;
    }
    setState(() => _currentNavIndex = index);
  }

  Future<void> _openAddLesson() async {
    // نوقف أي درس قيد التشغيل قبل مغادرة الشاشة
    await _audioService.stop();
    setState(() => _expandedIndex = null);

    if (mounted) {
      Navigator.pushNamed(context, AppRoutes.kAddLesson);
    }
  }

  Future<void> _onLessonTap(int index, Lesson lesson) async {
    setState(() => _expandedIndex = index);

    try {
      await _audioService.playUrl(lesson.audioUrl, speed: _speed);
    } catch (e) {
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
        drawer: BlocBuilder<LessonsCubit, ResultState<dynamic>>(
          bloc: getIt<LessonsCubit>(),
          builder: (context, state) {
            final cubit = getIt<LessonsCubit>();
            return CustomDrawer(
              userName: cubit.teacherName.isNotEmpty
                  ? cubit.teacherName
                  : 'مدرس',
              userPhone: cubit.teacherPhone.isNotEmpty
                  ? cubit.teacherPhone
                  : '09********',
            );
          },
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
                const SizedBox(height: 20),
                _buildSubjectHeader(), // اسم المادة + السهم
                const SizedBox(height: 15),
                _buildCategories(),
                const SizedBox(height: 25),
                _selectedCategoryIndex == 0
                    ? _buildSolutionsList()
                    : _buildLessonsList(),
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
                subject != null ? '${subject.name}:' : 'الدروس',
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 20,
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

  Widget _buildCategories() {
    return Row(
      children: [
        _buildCategoryButton('الدروس', 1),
        const SizedBox(width: 50),
        _buildCategoryButton('حلول الطلاب', 0),
      ],
    );
  }

  Widget _buildCategoryButton(String text, int index) {
    final isSelected = _selectedCategoryIndex == index;
    return GestureDetector(
      onTap: () {
        if (_selectedCategoryIndex == index) return;
        setState(() => _selectedCategoryIndex = index);
        if (index == 0) _loadSolutions(); // حلول الطلاب
      },
      child: Container(
        width: 140,
        height: 37,
        decoration: BoxDecoration(
          color: isSelected
              ? AppColors.kPrimaryColor
              : Colors.white.withOpacity(0.10),
          borderRadius: BorderRadius.circular(10),
        ),
        alignment: Alignment.center,
        child: Text(
          text,
          textAlign: TextAlign.center,
          style: TextStyle(
            color: isSelected ? Colors.black : Colors.white,
            fontWeight: FontWeight.w400,
            fontSize: 20,
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
                    audioService: _audioService,
                    speed: _speed,
                    onTap: () => _onLessonTap(index, lessons[index]),
                    onDelete: () => _confirmDelete(lessons[index]),
                    onCreateQuiz: () => _openCreateQuiz(lessons[index]),
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

  void _openCreateQuiz(Lesson lesson) {
    Navigator.pushNamed(context, AppRoutes.kQuizzes, arguments: lesson.id);
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
          title: const Text(
            'حذف الدرس',
            style: TextStyle(color: Colors.white, fontSize: 26),
          ),
          content: Text(
            'هل أنت متأكد من حذف "${lesson.title}"؟\nسيُحذف نهائياً من السيرفر.',
            style: const TextStyle(color: Colors.white70, fontSize: 24),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context, false),
              child: const Text(
                'إلغاء',
                style: TextStyle(color: Colors.white54, fontSize: 24),
              ),
            ),
            TextButton(
              onPressed: () => Navigator.pop(context, true),
              child: const Text(
                'حذف',
                style: TextStyle(color: Colors.redAccent, fontSize: 24),
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

  Future<void> _loadSolutions() async {
    setState(() {
      _loadingSolutions = true;
      _solutionsError = null;
    });

    final result = await getIt<TeacherRepo>().getQuizzesPendingGrading();

    result.when(
      success: (data) {
        final map = (data is Map) ? Map<String, dynamic>.from(data) : {};
        final raw = (map['quizzes'] is List)
            ? map['quizzes'] as List
            : const [];
        final sid = getIt<LessonsCubit>().selectedSubject?.id;

        final items = <Map<String, dynamic>>[];
        for (final e in raw) {
          if (e is! Map) continue;
          final q = Map<String, dynamic>.from(e);
          // فلترة حسب المادة المختارة
          if (sid != null && int.tryParse('${q['subject_id']}') != sid)
            continue;
          items.add(q);
        }

        setState(() {
          _pendingQuizzes = items;
          _loadingSolutions = false;
        });
      },
      failure: (_) {
        setState(() {
          _loadingSolutions = false;
          _solutionsError = 'تعذّر تحميل الحلول، حاول مجدداً';
        });
      },
    );
  }

  Widget _buildSolutionsList() {
    if (_loadingSolutions) {
      return const Expanded(
        child: Center(child: CircularProgressIndicator(color: Colors.white)),
      );
    }

    if (_solutionsError != null) {
      return Expanded(
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                _solutionsError!,
                style: const TextStyle(color: Colors.white70, fontSize: 20),
              ),
              TextButton(
                onPressed: _loadSolutions,
                child: const Text(
                  'إعادة المحاولة',
                  style: TextStyle(color: Colors.white, fontSize: 20),
                ),
              ),
            ],
          ),
        ),
      );
    }

    if (_pendingQuizzes.isEmpty) {
      return Expanded(
        child: Center(
          child: Text(
            'لا توجد حلول بانتظار التصحيح',
            style: TextStyle(
              color: Colors.white.withOpacity(0.5),
              fontSize: 22,
            ),
          ),
        ),
      );
    }

    return Expanded(
      child: RefreshIndicator(
        color: AppColors.kPrimaryColor,
        backgroundColor: AppColors.kBackgroundColor,
        onRefresh: _loadSolutions,
        child: ListView.builder(
          physics: const AlwaysScrollableScrollPhysics(),
          itemCount: _pendingQuizzes.length,
          itemBuilder: (context, i) {
            final q = _pendingQuizzes[i];
            final lesson = (q['lesson'] is Map) ? q['lesson'] as Map : const {};
            final title = (lesson['title'] ?? 'كويز').toString();
            final count = q['submissions_count'] ?? 0;
            final id = int.tryParse('${q['id']}') ?? 0;

            return GestureDetector(
              behavior: HitTestBehavior.opaque,
              onTap: () async {
                await Navigator.pushNamed(
                  context,
                  AppRoutes.kQuizSubmissions,
                  arguments: {'quizId': id, 'quizTitle': title},
                );
                if (mounted) _loadSolutions();
              },
              child: Container(
                margin: const EdgeInsets.only(bottom: 15),
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 16,
                ),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.10),
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: Colors.white.withOpacity(0.30)),
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: Text(
                        title,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 22,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.orangeAccent.withOpacity(0.15),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        '$count بانتظار التصحيح',
                        style: const TextStyle(
                          color: Colors.orangeAccent,
                          fontSize: 14,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
