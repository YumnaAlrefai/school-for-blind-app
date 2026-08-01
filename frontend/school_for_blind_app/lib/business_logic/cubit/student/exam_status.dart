import 'package:school_for_blind_app/data/models/student/exam.dart';

enum ExamStatus { notScheduled, upcoming, ongoing, locked, ended }

extension ExamStatusX on Exam {
  ExamStatus statusAt(DateTime now, {required bool alreadyJoined}) {
    final start = examDate;
    if (start == null) return ExamStatus.notScheduled;

    final end = start.add(Duration(minutes: durationMinutes));
    final joinDeadline = start.add(const Duration(minutes: 10));

    if (now.isBefore(start)) return ExamStatus.upcoming;
    if (now.isAfter(end)) return ExamStatus.ended;
    if (now.isAfter(joinDeadline) && !alreadyJoined) return ExamStatus.locked;
    return ExamStatus.ongoing;
  }
}
