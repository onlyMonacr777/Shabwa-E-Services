import 'package:flutter/material.dart';

class AppColors {
  // ✅ الهوية البحرية لشبوة
  static const Color deepOcean = Color(0xFF0A2E3D);      // أعمق نقطة في البحر
  static const Color ocean = Color(0xFF1A5F7A);          // بحر شبوة
  static const Color shallow = Color(0xFF2E8FAD);        // مياه ضحلة
  static const Color foam = Color(0xFF81D4FA);           // رغوة البحر

  // ✅ الذهبي - تميز وهيبة
  static const Color gold = Color(0xFFFFB300);
  static const Color goldLight = Color(0xFFFFD54F);
  static const Color goldDark = Color(0xFFFF8F00);

  // ✅ الوظائف
  static const Color success = Color(0xFF00C853);
  static const Color warning = Color(0xFFFFAB00);
  static const Color error = Color(0xFFDD2C00);
  static const Color info = Color(0xFF0091EA);

  // ✅ الخلفيات
  static const Color night = Color(0xFF051520);
  static const Color surface = Color(0xFF0D2130);
  static const Color card = Color(0xFF152A3A);

  // ✅ النصوص
  static const Color textPrimary = Color(0xFFFFFFFF);
  static const Color textSecondary = Color(0xFFB0C4DE);
  static const Color textMuted = Color(0xFF6B8CAE);

  // ✅ التدرجات الخرافية
  static LinearGradient get oceanGradient => const LinearGradient(
    colors: [deepOcean, ocean, shallow],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static LinearGradient get goldGradient => const LinearGradient(
    colors: [goldDark, gold, goldLight],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static LinearGradient get cardGradient => LinearGradient(
    colors: [card.withOpacity(0.9), surface],
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
  );
}