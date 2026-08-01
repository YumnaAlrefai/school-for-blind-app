import 'package:flutter/material.dart';
import 'package:school_for_blind_app/core/injection.dart';
import 'package:school_for_blind_app/core/theme/app_colors.dart';
import 'package:school_for_blind_app/data/repository/teacher_repo.dart';
import 'package:school_for_blind_app/networking/api_result.dart';

class TeacherProfil extends StatefulWidget {
  const TeacherProfil({super.key});

  @override
  State<TeacherProfil> createState() => _TeacherProfilState();
}

class _TeacherProfilState extends State<TeacherProfil> {
  bool _loading = true;
  String? _error;

  String _fullName = '';
  String _phone = '';
  String _subjects = '';
  String _level = '';
  String _cvLink = '';

  @override
  void initState() {
    super.initState();
    _loadInfo();
  }

  String _levelToArabic(String level) {
    const map = {
      'seventh': 'السابع',
      'eighth': 'الثامن',
      'ninth': 'التاسع',
      'tenth': 'العاشر',
      'eleventh': 'الحادي عشر',
      'twelfth': 'بكالوريا',
    };
    return map[level.trim().toLowerCase()] ?? level;
  }

  Future<void> _loadInfo() async {
    setState(() {
      _loading = true;
      _error = null;
    });

    final result = await getIt<TeacherRepo>().getTeacherInfo();

    result.when(
      success: (data) {
        final Map map = (data is Map) ? data : const {};
        final Map t = (map['data'] is Map) ? map['data'] : map;

        
        String subjects = '';
        final taught = t['subjects'];
        if (taught is List && taught.isNotEmpty) {
          subjects = taught
              .map((e) => (e is Map ? (e['name'] ?? '') : e).toString())
              .where((s) => s.isNotEmpty)
              .join('، ');
        } else {
          subjects = (t['subjects'] ?? '').toString();
        }

        setState(() {
          _fullName = (t['full_name'] ?? '').toString();
          _phone = (t['phone'] ?? '').toString();
          _subjects = subjects;
          _level = _levelToArabic((t['level'] ?? '').toString());
          _cvLink = (t['cv_link'] ?? '').toString();
          _loading = false;
        });
      },
      failure: (_) {
        setState(() {
          _loading = false;
          _error = 'تعذّر تحميل بيانات الملف الشخصي';
        });
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.kBackgroundColor,
      body: SafeArea(
        child: _loading
            ? const Center(
                child: CircularProgressIndicator(color: Colors.white),
              )
            : _error != null
            ? _buildError()
            : SingleChildScrollView(
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 20,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    IconButton(
                      onPressed: () => Navigator.pop(context),
                      icon: Transform.flip(
                        flipX: true,
                        child: const Icon(
                          Icons.shortcut,
                          color: Colors.white,
                          size: 30,
                        ),
                      ),
                    ),
                    _buildProfileField(
                      "الاسم الكامل:",
                      _fullName,
                      Icons.person,
                    ),
                    _buildProfileField(
                      "رقم الهاتف:",
                      _phone,
                      Icons.phone_android,
                    ),
                    _buildProfileField(
                      "المادة المعطاة:",
                      _subjects,
                      Icons.menu_book,
                    ),
                    _buildProfileField(
                      "المرحلة الدراسية:",
                      _level,
                      Icons.school,
                    ),
                    _buildCvField("السيرة الذاتية:", Icons.picture_as_pdf),
                  ],
                ),
              ),
      ),
    );
  }

  Widget _buildError() {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            _error!,
            style: const TextStyle(color: Colors.white70, fontSize: 18),
          ),
          const SizedBox(height: 12),
          TextButton(
            onPressed: _loadInfo,
            child: const Text(
              'إعادة المحاولة',
              style: TextStyle(color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProfileField(String label, String value, IconData icon) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(color: Colors.white, fontSize: 30)),
        const SizedBox(height: 4),
        Container(
          width: 354,
          height: 60,
          padding: const EdgeInsets.symmetric(horizontal: 16),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.1),
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: Colors.white.withOpacity(0.5), width: 1),
          ),
          child: Row(
            textDirection: TextDirection.rtl,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Icon(icon, color: AppColors.kPrimaryColor, size: 28),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  value,
                  textDirection: TextDirection.rtl,
                  style: const TextStyle(color: Colors.white, fontSize: 24),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 20),
      ],
    );
  }

  Widget _buildCvField(String label, IconData icon) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(color: Colors.white, fontSize: 40)),
        const SizedBox(height: 8),
        Container(
          width: double.infinity,
          height: 60,
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.1),
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: Colors.white.withOpacity(0.5), width: 1),
          ),
          child: Center(
            child: Icon(icon, color: AppColors.kPrimaryColor, size: 30),
          ),
        ),
      ],
    );
  }
}
