import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'app_colors.dart';

class AppTheme {
  // ═══════════════════════════════════════
  // 🌙 PREMIUM DARK THEME
  // ═══════════════════════════════════════
  static ThemeData get premiumTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      primaryColor: AppColors.ocean, // ✅ للـ primaryColor
      scaffoldBackgroundColor: AppColors.night,

      colorScheme: ColorScheme.fromSeed(
        seedColor: AppColors.ocean,
        brightness: Brightness.dark,
      ).copyWith(
        primary: AppColors.ocean,
        secondary: AppColors.gold,
        surface: AppColors.surface,
        background: AppColors.night,
        onPrimary: Colors.white,
        onSecondary: Colors.white,
        onSurface: AppColors.textPrimary,
        onBackground: AppColors.textPrimary,
      ),

      // ✅ Google Fonts
      textTheme: GoogleFonts.cairoTextTheme(ThemeData.dark().textTheme),

      appBarTheme: const AppBarTheme(
        elevation: 0,
        centerTitle: true,
        backgroundColor: Colors.transparent,
        foregroundColor: AppColors.textPrimary,
        titleTextStyle: TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.w600,
          color: AppColors.textPrimary,
        ),
      ),

      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.ocean,
          foregroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
        ),
      ),

      cardTheme: CardThemeData(
        elevation: 2,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(24.0), // ← 24.0
        ),
        color: Colors.white,
        surfaceTintColor: Colors.transparent,
      ),

      // ✅ Bottom Navigation للـ Dark
      bottomNavigationBarTheme: const BottomNavigationBarThemeData(
        backgroundColor: AppColors.surface,
        selectedItemColor: AppColors.ocean,
        unselectedItemColor: AppColors.textSecondary,
        type: BottomNavigationBarType.fixed,
      ),

      // ✅ Input Decoration للـ Dark
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: AppColors.surface,
        contentPadding: const EdgeInsets.all(18),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide(color: AppColors.ocean.withOpacity(0.2)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(color: AppColors.gold, width: 2),
        ),
      ),
    );
  }

  // ═══════════════════════════════════════
  // ☀️ GOVERNMENT LIGHT THEME (محدث كامل)
  // ═══════════════════════════════════════
  static ThemeData get governmentTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      primaryColor: _primaryGreen, // ✅ مطلوب للـ AppBar و FAB
      scaffoldBackgroundColor: _backgroundLight,

      colorScheme: ColorScheme.fromSeed(
        seedColor: _primaryGreen,
        brightness: Brightness.light,
      ).copyWith(
        primary: _primaryGreen,
        secondary: _gold,
        surface: Colors.white,
        background: _backgroundLight,
        surfaceVariant: _backgroundLight.withOpacity(0.7), // ✅ للـ cards
        onPrimary: Colors.white,
        onSecondary: Colors.black,
        onSurface: _textPrimary,
        onBackground: _textPrimary,
        onSurfaceVariant: _textSecondary, // ✅ للـ unselected items
      ),

      // ✅ Google Fonts
      textTheme: GoogleFonts.cairoTextTheme(ThemeData.light().textTheme),

      appBarTheme: AppBarTheme(
        elevation: 0,
        centerTitle: true,
        backgroundColor: Colors.transparent,
        foregroundColor: _textPrimary, // ✅ محدد صح
        titleTextStyle: TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.w600,
          color: _textPrimary,
        ),
      ),

      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: _primaryGreen,
          foregroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 14),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
          ),
        ),
      ),

      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: Colors.white,
        contentPadding: const EdgeInsets.all(18),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide(color: _primaryGreen.withOpacity(0.2)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide(color: _gold, width: 2),
        ),
      ),

      cardTheme: CardThemeData(
        elevation: 2,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(18),
        ),
        color: Colors.white,
      ),

      // ✅ Bottom Navigation ممتاز للـ Light
      bottomNavigationBarTheme: BottomNavigationBarThemeData(
        backgroundColor: Colors.white,
        selectedItemColor: _primaryGreen,
        unselectedItemColor: _textSecondary,
        type: BottomNavigationBarType.fixed,
        selectedLabelStyle: TextStyle(fontWeight: FontWeight.w600),
        unselectedLabelStyle: TextStyle(fontWeight: FontWeight.w400),
      ),
    );
  }

  // ═══════════════════════════════════════
  // 🎨 COLORS (حكومي) - محدثة
  // ═══════════════════════════════════════
  static const Color _primaryGreen = Color(0xFF0E7A4A);
  static const Color _gold = Color(0xFFFFC107);
  static const Color _backgroundLight = Color(0xFFF5F7FA);
  static const Color _textPrimary = Color(0xFF1A1A1A);
  static const Color _textSecondary = Color(0xFF757575);
}