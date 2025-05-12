import 'package:flutter/material.dart';

class AppTextStyles {
  // 16px, Medium (500), 100% line height
  static const TextStyle body16 = TextStyle(
    fontFamily: 'Poppins',
    fontWeight: FontWeight.w500,
    fontSize: 16,
    height: 1.0, // 100%
    letterSpacing: 0.0,
  );

  // 14px, Medium (500), 20px line height
  static const TextStyle body14Medium = TextStyle(
    fontFamily: 'Poppins',
    fontWeight: FontWeight.w500,
    fontSize: 14,
    height: 20 / 14, // ≈1.43
    letterSpacing: 0.0,
  );

  // 14px, Regular (400), 110% line height
  static const TextStyle small14 = TextStyle(
    fontFamily: 'Poppins',
    fontWeight: FontWeight.w400,
    fontSize: 14,
    height: 1.1,
    letterSpacing: 0.0,
  );

  // 20px, Semi-bold (600), 120% line height
  static const TextStyle heading20 = TextStyle(
    fontFamily: 'Poppins',
    fontWeight: FontWeight.w600,
    fontSize: 20,
    height: 1.2,
    letterSpacing: 0.0,
  );

  // 18px, Bold (700), 32px line height
  static const TextStyle bold18Line32 = TextStyle(
    fontFamily: 'Poppins',
    fontWeight: FontWeight.w700,
    fontSize: 18,
    height: 32 / 18, // ≈1.78
    letterSpacing: 0.0,
  );

  // 24px, Bold (700), 120% line height
  static const TextStyle bold24 = TextStyle(
    fontFamily: 'Poppins',
    fontWeight: FontWeight.w700,
    fontSize: 24,
    height: 1.2,
    letterSpacing: 0.0,
  );
}
