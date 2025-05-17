import 'package:demo_project/view/screens/calculators/bank/compound_interest_view.dart';
import 'package:demo_project/view/screens/calculators/bank/simple_interest_view.dart';
import 'package:demo_project/view/screens/calculators/income%20tax/HRA_calc_view.dart';
import 'package:demo_project/view/screens/calculators/income%20tax/capital_gain_calc_view.dart';
import 'package:demo_project/view/screens/calculators/income%20tax/depreciation_calc_view.dart';
import 'package:demo_project/view/screens/calculators/income%20tax/tax_calc_view.dart';
import 'package:demo_project/view/screens/calculators/investment/CAGA_calc_view.dart';
import 'package:demo_project/view/screens/calculators/investment/post_office_MIS_view.dart';
import 'package:flutter/material.dart';
// Import all required calculator views...

final Map<String, Widget Function()> calculatorRouteMap = {
  "Simple Interest Calculator": () => SimpleInterestView(),
  "Compound Interest Calculator": () => CompoundInterestView(),
  "HRA Calculator": () => HRAcalcView(),
  "Depreciation Calculator": () => DepreciationCalcView(),
  "Tax Calculator": () => TaxtCalcView(),
  "Capital Gain Calculator": () => CapitalGainCalcView(),
  "Post Office MIS": () => PostOfficeMISView(),
  "CARG Calculator": () => CARGcalcView(),
  // "RD Calculator"
  // "FD Calculator",
  // "Lump Sum Calculator",
  // "SIP Calculator",
};
