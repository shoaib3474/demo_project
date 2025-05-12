import 'package:flutter/material.dart';

class AppSize {
  static late double screenWidth;
  static late double screenHeight;
  static late double scaleFactor;

  // Padding and margin
  static late double horizontalPadding;
  static late double verticalPadding;

  // Common sizes
  static late double small;
  static late double medium;
  static late double large;

  // Initialize sizes based on screen dimensions
  static void init(BuildContext context) {
    final size = MediaQuery.of(context).size;
    screenWidth = size.width;
    screenHeight = size.height;

    // You can adjust this base width for your design reference
    scaleFactor = screenWidth / 375.0;

    horizontalPadding = 16.0 * scaleFactor;
    verticalPadding = 12.0 * scaleFactor;

    small = 8.0 * scaleFactor;
    medium = 16.0 * scaleFactor;
    large = 24.0 * scaleFactor;
  }

  // Responsive font size
  static double fontSize(double size) => size * scaleFactor;

  // Responsive box size
  static double box(double size) => size * scaleFactor;
}
