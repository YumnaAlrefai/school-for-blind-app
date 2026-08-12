class ApiEndpoints {

  static const login = "caregiver/login";
  static const logout = "caregiver/logout";
  static const supportTicket = "support-tickets";
  static const reportsDaily = "parent/reports/daily";
  static const submitAbsenceExcuse = "parent/reports/absence-excuse";
  static const reportsMonthly = "parent/reports/monthly";
  static const reportsYearly = "parent/reports/yearly";
  static String subjectDetails(int studentId, int subjectId) =>
    "parent/reports/student/$studentId/subject/$subjectId";
    static const schedule = "caregiver/schedule";
    static const announcementsList = "announcements";
static String announcementExamDetail(int id) => "announcements/exam/$id";
static String announcementTimetableDetail(int id) => "announcements/school-timetable/$id";

}