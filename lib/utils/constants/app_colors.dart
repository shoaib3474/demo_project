import 'package:flutter/material.dart';

class AppColors {
  // Primary Colors
  static const Color primary = Color(0xFF3C7CDD);
  static const Color secondary = Color(0xFF8E8E93);

  // Common Colors
  static const Color white = Colors.white;
  static const Color black26 = Colors.black26;
  static const Color darkGrey = Color(0xFF373844);

  // Gradients
  static const LinearGradient blueToGreenGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [
      Color(0xFF3C7CDD), // Start color
      Color(0xFF43CEA2), // End color
    ],
  );

  static const LinearGradient redGradient = LinearGradient(
    begin: Alignment(0.50, 0.00),
    end: Alignment(0.50, 1.00),
    colors: [Color(0xFFF96161), Color(0xFFE11E1E)],
  );

  static const LinearGradient greenGradient = LinearGradient(
    begin: Alignment(0.50, 0.00),
    end: Alignment(0.50, 1.00),
    colors: [Color(0xFF6BFF57), Color(0xFF2F7525)],
  );
}
