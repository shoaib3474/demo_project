import 'package:demo_project/providers/base_calculator_provider.dart';
import 'package:demo_project/view/screens/landing_screen.dart';
import 'package:demo_project/widgets/export_result_ui.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart'; // ✅ Required for GetX
import 'package:provider/provider.dart';

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (_) => BaseCalculatorProvider(),
      child: const MyApp(), // ✅ Wrap with a custom MyApp widget
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      // ✅ Use GetMaterialApp instead of MaterialApp
      debugShowCheckedModeBanner: false,
      title: 'Demo Project',
      home: Scaffold(body: LandingScreen()),
    );
  }
}
