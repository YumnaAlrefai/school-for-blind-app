class AppValidator {
  static String? phoneValidation(String? phone) {
    if (phone == null || phone.isEmpty) return "أدخل رقم الهاتف";

    if (!phone.startsWith('09')) return "يجب أن يبدأ الرقم ب09";

    if (phone.length < 10) return "يجب أن يكون الرقم مؤلفاً من عشر خانات";

    return null;
  }

  static String? nameValidation(String? name) {
    if (name == null || name.isEmpty) return "أدخل الاسم";

    return null;
  }
}
