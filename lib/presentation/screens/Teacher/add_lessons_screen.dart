import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:school_for_blind_app/apiTeacher/teacherRepo.dart';
import 'package:school_for_blind_app/business_logic/cubit/lessons_cubit.dart';
import 'package:school_for_blind_app/business_logic/cubit/result_state.dart';
import 'package:school_for_blind_app/core/injection.dart';
import 'package:school_for_blind_app/core/routing/app_routes.dart';
import 'package:school_for_blind_app/core/theme/app_colors.dart';
import 'package:school_for_blind_app/networking/api_result.dart';

/// الحد الأقصى لحجم ملف الصوت (بالميجابايت)
const int _kMaxAudioSizeMB = 100;

/// شعبة (صف) يدرّسها المدرس — تجي من teacher/info ضمن classes
class TeacherClass {
  final int id;
  final String name;
  const TeacherClass({required this.id, required this.name});

  factory TeacherClass.fromJson(Map<String, dynamic> json) => TeacherClass(
    id: json['id'] as int,
    name: (json['name'] ?? '').toString(),
  );
}

class AddLessonScreen extends StatefulWidget {
  const AddLessonScreen({super.key});

  @override
  State<AddLessonScreen> createState() => _AddLessonScreenState();
}

class _AddLessonScreenState extends State<AddLessonScreen> {
  final TextEditingController _titleController = TextEditingController();
  File? _audioFile;
  String? _audioFileName;
  String? _audioFileSizeLabel;

  // قوائم المادة والشعبة (تُجلب من teacher/info)
  List<TaughtSubject> _subjects = [];
  List<TeacherClass> _classes = [];
  TaughtSubject? _selectedSubject;
  TeacherClass? _selectedClass;

  bool _loadingInfo = true;
  String? _infoError;

  /// الفئة المختارة تحت: 1 = الدروس (الحالية) ، 0 = الاختبارات
  int _selectedCategoryIndex = 1;

  @override
  void initState() {
    super.initState();
    _loadTeacherInfo();
  }

  @override
  void dispose() {
    _titleController.dispose();
    super.dispose();
  }

  Future<void> _loadTeacherInfo() async {
    setState(() {
      _loadingInfo = true;
      _infoError = null;
    });

    final result = await getIt<TeacherRepo>().getTeacherInfo();

    result.when(
      success: (data) {
        final Map map = (data is Map) ? data : const {};
        final Map teacher = (map['data'] is Map) ? map['data'] : map;

        final List subs = (teacher['subjects'] ?? []) as List;
        final List cls = (teacher['classes'] ?? []) as List;

        setState(() {
          _subjects = subs
              .map((e) => TaughtSubject.fromJson(Map<String, dynamic>.from(e)))
              .toList();
          _classes = cls
              .map((e) => TeacherClass.fromJson(Map<String, dynamic>.from(e)))
              .toList();

          _selectedSubject = _subjects.isNotEmpty ? _subjects.first : null;
          _selectedClass = _classes.isNotEmpty ? _classes.first : null;
          _loadingInfo = false;
        });
      },
      failure: (_) {
        setState(() {
          _loadingInfo = false;
          _infoError = 'تعذّر تحميل المواد والشعب، حاول مجدداً';
        });
      },
    );
  }

  Future<void> _pickAudioFile() async {
    final result = await FilePicker.pickFiles(type: FileType.audio);

    if (result == null || result.files.single.path == null) return;

    final pickedFile = File(result.files.single.path!);
    final sizeInBytes = await pickedFile.length();
    final sizeInMB = sizeInBytes / (1024 * 1024);

    if (sizeInMB > _kMaxAudioSizeMB) {
      _showMessage(
        'حجم الملف كبير جداً (${sizeInMB.toStringAsFixed(1)} م.ب). '
        'الحد الأقصى $_kMaxAudioSizeMB م.ب',
      );
      return;
    }

    setState(() {
      _audioFile = pickedFile;
      _audioFileName = result.files.single.name;
      _audioFileSizeLabel = '${sizeInMB.toStringAsFixed(1)} م.ب';

      if (_titleController.text.trim().isEmpty) {
        _titleController.text = _audioFileName!.replaceAll(
          RegExp(r'\.[^.]+$'),
          '',
        );
      }
    });
  }

  void _clearAudioFile() {
    setState(() {
      _audioFile = null;
      _audioFileName = null;
      _audioFileSizeLabel = null;
    });
  }

  void _uploadLesson() {
    final title = _titleController.text.trim();

    if (_selectedSubject == null) {
      _showMessage('اختر المادة أولاً');
      return;
    }
    if (_selectedClass == null) {
      _showMessage('اختر الشعبة أولاً');
      return;
    }
    if (title.isEmpty) {
      _showMessage('أدخل اسم الدرس أولاً');
      return;
    }
    if (_audioFile == null) {
      _showMessage('اختر ملف الصوت أولاً');
      return;
    }
    if (!_audioFile!.existsSync()) {
      _showMessage('الملف المختار لم يعد موجوداً، اختر ملفاً آخر');
      setState(() {
        _audioFile = null;
        _audioFileName = null;
      });
      return;
    }

    getIt<LessonsCubit>().emitUploadLesson(
      title: title,
      audioFile: _audioFile!,
      subjectId: _selectedSubject!.id,
      classId: _selectedClass!.id,
    );
  }

  void _showMessage(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message, style: const TextStyle(fontSize: 18))),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: AppColors.kBackgroundColor,
        body: SafeArea(
          child: BlocConsumer<LessonsCubit, ResultState<dynamic>>(
            bloc: getIt<LessonsCubit>(),
            listener: (context, state) {
              state.whenOrNull(
                success: (data) {
                  if (data == 'lesson_uploaded') {
                    _showMessage('تم رفع الدرس بنجاح');
                    getIt<LessonsCubit>().emitGetLessons();
                    Navigator.pop(context);
                  }
                },
                failure: (error) {
                  _showMessage('فشل رفع الدرس، تأكد من الاتصال وحاول مجدداً');
                },
              );
            },
            builder: (context, state) {
              final isUploading = state.maybeWhen(
                loading: () => true,
                orElse: () => false,
              );

              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 10),
                    _buildTopBar(),

                    Expanded(
                      child: _loadingInfo
                          ? const Center(
                              child: CircularProgressIndicator(
                                color: Colors.white,
                              ),
                            )
                          : _infoError != null
                          ? _buildInfoError()
                          : _buildForm(isUploading),
                    ),

                    _buildCategories(),
                    const SizedBox(height: 20),
                  ],
                ),
              );
            },
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
          'رفع الدروس',
          style: TextStyle(
            color: Colors.white,
            fontSize: 35,
            fontWeight: FontWeight.w500,
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

  Widget _buildInfoError() {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            _infoError!,
            style: const TextStyle(color: Colors.white70, fontSize: 18),
          ),
          const SizedBox(height: 12),
          TextButton(
            onPressed: _loadTeacherInfo,
            child: const Text(
              'إعادة المحاولة',
              style: TextStyle(color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildForm(bool isUploading) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const SizedBox(height: 40),

          // اختيار المادة
          _buildDropdown<TaughtSubject>(
            hint: 'اسم المادة',
            icon: Icons.menu_book,
            value: _selectedSubject,
            items: _subjects,
            itemLabel: (s) => s.name,
            enabled: !isUploading,
            onChanged: (v) => setState(() => _selectedSubject = v),
          ),
          const SizedBox(height: 20),

          // اختيار الشعبة
          _buildDropdown<TeacherClass>(
            hint: 'الشعبة',
            icon: Icons.menu_book,
            value: _selectedClass,
            items: _classes,
            itemLabel: (c) => c.name,
            enabled: !isUploading,
            onChanged: (v) => setState(() => _selectedClass = v),
          ),
          const SizedBox(height: 20),

          // اسم الدرس
          _buildTitleField(isUploading),
          const SizedBox(height: 20),

          // اختيار الملف الصوتي
          _buildAudioBox(isUploading),

          if (isUploading) ...[
            const SizedBox(height: 25),
            const LinearProgressIndicator(
              color: AppColors.kPrimaryColor,
              backgroundColor: Colors.white12,
            ),
            const SizedBox(height: 10),
            const Text(
              'جاري رفع الدرس  ...',
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.white54, fontSize: 16),
            ),
          ],

          const SizedBox(height: 40),

          // زر رفع الدرس
          _buildUploadButton(isUploading),
          const SizedBox(height: 20),
        ],
      ),
    );
  }

  /// حقل موحّد الشكل: 75 ارتفاع، حواف 10، خلفية #000F24 بشفافية 20%
  BoxDecoration get _fieldDecoration => BoxDecoration(
    color: AppColors.kBackgroundColor.withOpacity(0.20),
    borderRadius: BorderRadius.circular(10),
    border: Border.all(color: Colors.white.withOpacity(0.30)),
  );

  Widget _buildTitleField(bool isUploading) {
    return Container(
      height: 75,
      decoration: _fieldDecoration,
      child: TextField(
        controller: _titleController,
        enabled: !isUploading,
        textAlign: TextAlign.right,
        style: const TextStyle(color: Colors.white, fontSize: 22),
        decoration: InputDecoration(
          hintText: 'اسم الدرس',
          hintStyle: TextStyle(
            color: Colors.white.withOpacity(0.45),
            fontSize: 30,
          ),
          // الأيقونة على اليسار (نهاية السطر في RTL) مثل الصورة
          prefixIcon: const Icon(
            Icons.description_outlined,
            color: AppColors.kPrimaryColor,
            size: 26,
          ),
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(horizontal: 20),
        ),
      ),
    );
  }

  Widget _buildAudioBox(bool isUploading) {
    return InkWell(
      borderRadius: BorderRadius.circular(10),
      onTap: isUploading ? null : _pickAudioFile,
      child: Container(
        height: 75,
        padding: const EdgeInsets.symmetric(horizontal: 20),
        decoration: BoxDecoration(
          color: AppColors.kBackgroundColor.withOpacity(0.20),
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
            color: _audioFile != null
                ? AppColors.kPrimaryColor
                : Colors.white.withOpacity(0.30),
          ),
        ),
        child: Row(
          children: [
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    _audioFileName ?? 'اختيار الملف الصوتي',
                    style: TextStyle(
                      color: _audioFile != null
                          ? Colors.white
                          : Colors.white.withOpacity(0.45),
                      fontSize: 30,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                  if (_audioFileSizeLabel != null)
                    Padding(
                      padding: const EdgeInsets.only(top: 2),
                      child: Text(
                        _audioFileSizeLabel!,
                        style: const TextStyle(
                          color: Colors.white38,
                          fontSize: 13,
                        ),
                      ),
                    ),
                ],
              ),
            ),
            if (_audioFile != null && !isUploading)
              IconButton(
                icon: const Icon(Icons.close, color: Colors.white54),
                onPressed: _clearAudioFile,
              ),
            Icon(
              _audioFile != null ? Icons.audio_file : Icons.upload_outlined,
              color: _audioFile != null
                  ? AppColors.kPrimaryColor
                  : Colors.white54,
              size: 28,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildUploadButton(bool isUploading) {
    return Center(
      child: Container(
        width: 224,
        height: 54,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15),
          boxShadow: [
            BoxShadow(
              color: AppColors.kPrimaryColor.withOpacity(0.5),
              blurRadius: 2,
              offset: const Offset(0, 0),
            ),
          ],
        ),
        child: ElevatedButton(
          onPressed: isUploading ? null : _uploadLesson,
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.kPrimaryColor,
            disabledBackgroundColor: AppColors.kPrimaryColor.withOpacity(0.4),
            elevation: 0,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(14),
            ),
          ),
          child: isUploading
              ? const SizedBox(
                  width: 26,
                  height: 26,
                  child: CircularProgressIndicator(
                    color: Colors.black,
                    strokeWidth: 3,
                  ),
                )
              : const Text(
                  'رفع الدرس',
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 24,
                    fontFamily: 'ArabicTypesetting',
                  ),
                ),
        ),
      ),
    );
  }

  /// فئتان تحت: الدروس (الحالية) + الاختبارات (تنتقل لشاشة الكويز)
  Widget _buildCategories() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        _buildCategoryButton(
          text: 'الدروس',

          index: 1,
          onTap: () => setState(() => _selectedCategoryIndex = 1),
        ),
        const SizedBox(width: 12),
        _buildCategoryButton(
          text: 'الإختبارات',
          index: 0,
          onTap: () {
            // الانتقال لشاشة رفع الكويز
            Navigator.pushNamed(context, AppRoutes.kTest);
          },
        ),
      ],
    );
  }

  Widget _buildCategoryButton({
    required String text,
    required int index,
    required VoidCallback onTap,
  }) {
    final isSelected = _selectedCategoryIndex == index;
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 161,
        height: 30,
        decoration: BoxDecoration(
          color: isSelected
              ? AppColors.kPrimaryColor
              : Colors.white.withOpacity(0.10),
          borderRadius: BorderRadius.circular(10),
        ),
        alignment: Alignment.center,
        child: Text(
          text,
          style: TextStyle(
            color: isSelected ? Colors.black : Colors.white,
            fontSize: 25,
          ),
        ),
      ),
    );
  }

  /// قائمة منسدلة موحّدة الشكل (75 ارتفاع، الأيقونة على اليسار مثل الصورة)
  Widget _buildDropdown<T>({
    required String hint,
    required IconData icon,
    required T? value,
    required List<T> items,
    required String Function(T) itemLabel,
    required bool enabled,
    required ValueChanged<T?> onChanged,
  }) {
    return Container(
      height: 75,
      padding: const EdgeInsets.symmetric(horizontal: 20),
      decoration: _fieldDecoration,
      child: DropdownButtonHideUnderline(
        child: DropdownButton<T>(
          value: value,
          isExpanded: true,
          dropdownColor: AppColors.kSurfaceColor,
          iconEnabledColor: Colors.white54,
          // الأيقونة على اليسار (نهاية السطر في RTL) مثل الصورة
          hint: Row(
            children: [
              Icon(icon, color: AppColors.kPrimaryColor, size: 26),
              Expanded(
                child: Text(
                  hint,
                  textAlign: TextAlign.right,
                  style: TextStyle(
                    color: Colors.white.withOpacity(0.45),
                    fontSize: 22,
                  ),
                ),
              ),
              const SizedBox(width: 12),
            ],
          ),
          selectedItemBuilder: (context) => items.map((item) {
            return Row(
              children: [
                Icon(icon, color: AppColors.kPrimaryColor, size: 26),

                Expanded(
                  child: Text(
                    itemLabel(item),
                    textAlign: TextAlign.right,
                    style: const TextStyle(color: Colors.white, fontSize: 30),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                const SizedBox(width: 10),
              ],
            );
          }).toList(),
          items: items
              .map(
                (item) => DropdownMenuItem<T>(
                  value: item,
                  child: Text(
                    itemLabel(item),
                    textAlign: TextAlign.right,
                    style: const TextStyle(color: Colors.white, fontSize: 20),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              )
              .toList(),
          onChanged: enabled ? onChanged : null,
        ),
      ),
    );
  }
}
