import 'package:demo_project/providers/base_calculator_provider.dart';
import 'package:demo_project/view/screens/calculators/bank/compound_interest_view.dart';
import 'package:demo_project/view/screens/calculators/bank/simple_interest_view.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (_) => BaseCalculatorProvider(),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        home: CompoundInterestView(),
      ),
    ),
  );
}
