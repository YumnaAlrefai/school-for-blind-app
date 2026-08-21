class ApiEndpoints {

  static const login = "caregiver/login";
  static const logout = "caregiver/logout";
  static const supportTicket = "support-tickets";
  static const reportsDaily = "parent/reports/daily";
  static const submitAbsenceExcuse = "parent/reports/absence-excuse";
  static const String submitPunishmentObjection = "parent/punishment-objection";
  static const reportsMonthly = "parent/reports/monthly";
  static const reportsYearly = "parent/reports/yearly";
  static String subjectDetails(int studentId, int subjectId) =>
    "parent/reports/student/$studentId/subject/$subjectId";
    static const schedule = "caregiver/schedule";
    static const announcements = "announcements";
static String examScheduleDetail(int id) => "announcements/exam/$id";
// --- Donation ---
static const String donationCheckout = 'donation/checkout';
static const String donationConfirm = 'donation/confirm';

}