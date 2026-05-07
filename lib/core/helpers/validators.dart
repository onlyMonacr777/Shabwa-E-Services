class Validators {

  static String? email(String? value) {
    if (value == null || value.isEmpty) {
      return 'البريد مطلوب';
    }
    return null;
  }

  static String? password(String? value) {
    if (value == null || value.length < 6) {
      return 'كلمة المرور قصيرة';
    }
    return null;
  }
}