import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTheme {

  static const Color primaryGreenExtraDark = Color(0xFF013A2E);
  static const Color primaryGreenDark = Color(0xFF022C22);
  static const Color emeraldDark = Color(0xFF065F46);
  static const Color primaryGreen = Color(0xFF047857);
  static const Color primaryGreenLight = Color(0xFF059669);
  static const Color emeraldLight = Color(0xFF10B981);
  static const Color white = Color(0xFFFFFFFF);


  static const Color adminYellowDark = Color(0xFFF59D26);
  static const Color adminOrange = Color(0xFFEA7D1A);


  static const Color cardWhite = Color(0xFFF8FAFC);
  static const Color textDark = Color(0xFF1A202C);
  static const Color textMedium = Color(0xFF4A5568);
  static const Color textLight = Color(0xFFA0AEC0);
  static const Color borderLight = Color(0xFFE2E8F0);
  static const Color surfaceLight = Color(0xFFF1F5F9);


  static const LinearGradient primaryGradient = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [
      primaryGreenExtraDark,
      primaryGreenDark,
      primaryGreenDark,
      emeraldDark,
      primaryGreen,
    ],
  );

  static const LinearGradient adminGradient = LinearGradient(
    begin: Alignment.centerLeft,
    end: Alignment.centerRight,
    colors: [adminOrange, adminYellowDark],
  );

  static const LinearGradient loginButtonGradient = LinearGradient(
    begin: Alignment.centerLeft,
    end: Alignment.centerRight,
    colors: [primaryGreenDark, primaryGreen],
  );

  static const LinearGradient adminButtonGradient = LinearGradient(
    begin: Alignment.centerLeft,
    end: Alignment.centerRight,
    colors: [adminOrange, adminYellowDark],
  );


  static final BoxShadow primaryShadow = BoxShadow(
    color:  const Color(0xFF022C22).withOpacity(0.7),
    blurRadius: 60,
    spreadRadius: 0,
  );

  static final BoxShadow cardShadow = BoxShadow(
    color: const Color(0xFF022C22).withOpacity(0.5),
    blurRadius: 40,
    spreadRadius: 0,
    offset: const Offset(0, 10),
  );

  static TextStyle get titleLarge => GoogleFonts.cairo(
    fontSize: 24,
    fontWeight: FontWeight.w900,
    color: white,
    height: 1.2,
  );

  static TextStyle get titleMedium => GoogleFonts.cairo(
    fontSize: 22,
    fontWeight: FontWeight.w900,
    color: white,
    height: 1.2,
  );

  static TextStyle get bodyLarge => GoogleFonts.cairo(
    fontSize: 18,
    fontWeight: FontWeight.w700,
    color: white,
  );

  static TextStyle get bodyMedium => GoogleFonts.cairo(
    fontSize: 16,
    fontWeight: FontWeight.w600,
    color: white.withOpacity(0.9),
  );

  static TextStyle get caption => GoogleFonts.cairo(
    fontSize: 14,
    fontWeight: FontWeight.w500,
    color: white.withOpacity(0.8),
  );


  static ThemeData get lightTheme => ThemeData(
    primarySwatch: createMaterialColor(primaryGreen),
    scaffoldBackgroundColor: primaryGreenDark,
    appBarTheme: const AppBarTheme(
      backgroundColor: Colors.transparent,
      elevation: 0,
      iconTheme: IconThemeData(color: white),
    ),
    textTheme: GoogleFonts.cairoTextTheme(),
    bottomNavigationBarTheme: const BottomNavigationBarThemeData(
      backgroundColor: Colors.transparent,
      elevation: 0,
    ),
  );


  static MaterialColor createMaterialColor(Color color) {
    List strengths = <double>[.05];
    Map<int, Color> swatch = {};
    final int r = color.red, g = color.green, b = color.blue;

    for (int i = 1; i < 10; i++) {
      strengths.add(0.1 * i);
    }
    for (var strength in strengths) {
      final double ds = 0.5 - strength;
      swatch[(strength * 1000).round()] = Color.fromRGBO(
        r + ((ds < 0 ? r : (255 - r)) * ds).round(),
        g + ((ds < 0 ? g : (255 - g)) * ds).round(),
        b + ((ds < 0 ? b : (255 - b)) * ds).round(),
        1,
      );
    }
    return MaterialColor(color.value, swatch);
  }
}