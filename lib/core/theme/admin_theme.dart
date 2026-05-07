import 'package:flutter/material.dart';

class AdminTheme {
  static const primary = Colors.teal;
  static const secondary = Colors.green;

  static final gradient = LinearGradient(
    colors: [
      Colors.teal.shade700,
      Colors.green.shade600,
    ],
  );

  static BoxDecoration cardDecoration = BoxDecoration(
    borderRadius: BorderRadius.circular(18),
    gradient: LinearGradient(
      colors: [
        Colors.white.withOpacity(0.2),
        Colors.white.withOpacity(0.1),
      ],
    ),
    border: Border.all(color: Colors.white24),
  );
}