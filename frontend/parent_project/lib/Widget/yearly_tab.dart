import 'package:flutter/material.dart';
import 'app_colors.dart';
import 'subject_icon.dart'; // عدّل المسار حسب مكانها الفعلي عندك

/// ============================================================
/// YearlyTab — كل محتوى ومنطق تبويب "السنوية" في ملف واحد.
/// يستقبل iconResolver وonSubjectTap من ReportsParent لأنهما
/// يحتاجان BuildContext (للتنقل) وخريطة أيقونات معرّفة هناك.
/// ============================================================
class YearlyTab extends StatelessWidget {
  final SubjectIcon Function(String subjectName) iconResolver;
  final void Function(String subjectName) onSubjectTap;

  const YearlyTab({
    super.key,
    required this.iconResolver,
    required this.onSubjectTap,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _StudentYearlySection(
          studentName: 'رغد',
          finalScore: '2800/2900',
          subjects: const [
            'الفلسفة', 'التاريخ', 'الجغرافيا', 'اللغة العربية',
            'اللغة الإنكليزية', 'اللغة الفرنسية', 'التربية الدينية',
          ],
          iconResolver: iconResolver,
          onSubjectTap: onSubjectTap,
        ),
        const SizedBox(height: 35),
        _StudentYearlySection(
          studentName: 'محمد',
          finalScore: '2650/2900',
          subjects: const [
            'الرياضيات (جبر)', 'الفيزياء والكيمياء', 'علم الأحياء والأرض',
            'التاريخ', 'الجغرافيا', 'اللغة العربية', 'اللغة الإنكليزية',
            'اللغة الفرنسية', 'التربية الدينية',
          ],
          iconResolver: iconResolver,
          onSubjectTap: onSubjectTap,
        ),
      ],
    );
  }
}

// ------------------------------------------------------------
// قسم طالب كامل: عنوان + قائمة مواد أفقية + بطاقة المعدل
// ------------------------------------------------------------
class _StudentYearlySection extends StatelessWidget {
  final String studentName;
  final String finalScore;
  final List<String> subjects;
  final SubjectIcon Function(String subjectName) iconResolver;
  final void Function(String subjectName) onSubjectTap;

  const _StudentYearlySection({
    required this.studentName,
    required this.finalScore,
    required this.subjects,
    required this.iconResolver,
    required this.onSubjectTap,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('علامات المواد للطالب/ة $studentName:', style: const TextStyle(color: Colors.white, fontSize: 40)),
        const SizedBox(height: 20),
        SizedBox(
          height: 130,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            itemCount: subjects.length,
            separatorBuilder: (context, index) => const SizedBox(width: 12),
            itemBuilder: (context, index) {
              final subjectName = subjects[index];
              return _SubjectGlassCard(
                subjectIcon: iconResolver(subjectName),
                label: subjectName,
                onTap: () => onSubjectTap(subjectName),
              );
            },
          ),
        ),
        const SizedBox(height: 30),
        _AverageCard(finalScore: finalScore),
      ],
    );
  }
}

// ------------------------------------------------------------
// بطاقة مادة زجاجية واحدة
// ------------------------------------------------------------
class _SubjectGlassCard extends StatelessWidget {
  final SubjectIcon subjectIcon;
  final String label;
  final VoidCallback onTap;

  const _SubjectGlassCard({required this.subjectIcon, required this.label, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 130,
        width: 130,
        padding: const EdgeInsets.symmetric(vertical: 12),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.06),
          borderRadius: BorderRadius.circular(10),
          border: Border(
            top: BorderSide(color: Colors.white.withOpacity(0.15), width: 1.1),
            bottom: BorderSide(color: Colors.white.withOpacity(0.15), width: 1.1),
            left: BorderSide(color: Colors.white.withOpacity(0.15), width: 0.5),
            right: BorderSide(color: Colors.white.withOpacity(0.15), width: 0.5),
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            subjectIcon.build(color: AppColors.accentGreen),
            const SizedBox(height: 8),
            Text(label, textAlign: TextAlign.center, style: const TextStyle(color: Colors.white, fontSize: 28)),
          ],
        ),
      ),
    );
  }
}

// ------------------------------------------------------------
// بطاقة المعدل النهائي
// ------------------------------------------------------------
class _AverageCard extends StatelessWidget {
  final String finalScore;

  const _AverageCard({required this.finalScore});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 105,
      padding: const EdgeInsets.symmetric(vertical: 5),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [AppColors.accentGreen, Color(0xFF628500)],
        ),
      ),
      child: Column(
        children: [
          const Text('المعدل النهائي:', style: TextStyle(color: Colors.white, fontSize: 35, fontWeight: FontWeight.w500)),
          const SizedBox(height: 1),
          Text(finalScore, style: const TextStyle(color: Colors.white, fontSize: 30)),
        ],
      ),
    );
  }
}