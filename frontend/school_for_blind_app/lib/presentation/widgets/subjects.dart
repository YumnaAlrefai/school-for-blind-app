import 'package:flutter/material.dart';
import 'package:school_for_blind_app/business_logic/cubit/student_cubit.dart';
import 'package:school_for_blind_app/core/injection.dart';
import 'package:school_for_blind_app/presentation/widgets/subject_card.dart';

class Subjects extends StatefulWidget {
  const Subjects({super.key});

  @override
  State<Subjects> createState() => _SubjectsState();
}

class _SubjectsState extends State<Subjects> {
  int _refreshKeyCounter = 0;

  final Map<String, IconData> twelfthClassSubjects = {
    'الفلسفة': Icons.psychology,
    'التاريخ': Icons.history_edu,
    'الجغرافيا': Icons.public,
    'اللغة العربية': Icons.auto_stories,
    'اللغة الإنكليزية': Icons.translate,
    'اللغة الفرنس': Icons.language,
    'التربية الدينية': Icons.mosque,
  };

  final Map<String, IconData> ninthClassSubjects = {
    'الرياضيات': Icons.functions,
    'الفيزياء والكيمياء': Icons.science,
    'علم الأحياء والأرض': Icons.biotech,
    'التاريخ': Icons.history_edu,
    'الجغرافيا': Icons.public,
    'اللغة العربية': Icons.auto_stories,
    'اللغة الإنكليزية': Icons.translate,
    'اللغة الفرنسية': Icons.language,
    'التربية الدينية': Icons.mosque,
  };

  Future<void> _handleRefresh() async {
    setState(() {
      _refreshKeyCounter++;
    });
    await Future.delayed(const Duration(milliseconds: 800));
  }

  @override
  Widget build(BuildContext context) {
    final level = getIt<StudentCubit>().currentStudent?.level;
    final subjectsList = level == 'twelfth'
        ? twelfthClassSubjects.entries.toList()
        : ninthClassSubjects.entries.toList();

    return Expanded(
      child: RefreshIndicator(
        onRefresh: _handleRefresh,
        color: Theme.of(context).colorScheme.primary,
        child: ListView.builder(
          key: ValueKey('subjects_list_$_refreshKeyCounter'),
          itemCount: subjectsList.length,
          addAutomaticKeepAlives: true,
          itemBuilder: (context, index) {
            final currentSubject = subjectsList[index];
            final int subjectId = level == 'twelfth' ? index + 1 : index + 8;
            return SubjectCard(
              key: ValueKey('${subjectId}_$_refreshKeyCounter'),
              subjectId: subjectId,
              subjectName: currentSubject.key,
              icon: currentSubject.value,
            );
          },
        ),
      ),
    );
  }
}
