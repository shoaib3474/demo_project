import 'package:demo_project/providers/base_calculator_provider.dart';
import 'package:demo_project/view/screens/landing_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (_) => BaseCalculatorProvider(),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        home: LandingScreen(),
      ),
    ),
  );
}
