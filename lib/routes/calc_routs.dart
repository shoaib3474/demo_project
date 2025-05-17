import 'package:demo_project/view/screens/calculators/bank/compound_interest_view.dart';
import 'package:demo_project/view/screens/calculators/bank/simple_interest_view.dart';
import 'package:demo_project/view/screens/calculators/income%20tax/HRA_calc_view.dart';
import 'package:demo_project/view/screens/calculators/income%20tax/capital_gain_calc_view.dart';
import 'package:demo_project/view/screens/calculators/income%20tax/depreciation_calc_view.dart';
import 'package:demo_project/view/screens/calculators/income%20tax/tax_calc_view.dart';
import 'package:demo_project/view/screens/calculators/insurance/NPS_calc_view.dart';
import 'package:demo_project/view/screens/calculators/investment/CAGA_calc_view.dart';
import 'package:demo_project/view/screens/calculators/investment/FD_calc_view.dart';
import 'package:demo_project/view/screens/calculators/investment/RD_calc_view.dart';
import 'package:demo_project/view/screens/calculators/investment/SIP_calc_view.dart';
import 'package:demo_project/view/screens/calculators/investment/lump_sum_calc_view.dart';
import 'package:demo_project/view/screens/calculators/investment/post_office_MIS_view.dart';
import 'package:flutter/material.dart';
// Import all required calculator views...

final Map<String, Widget Function()> calculatorRouteMap = {
  // bank calculators
  "Simple Interest Calculator": () => SimpleInterestView(),
  "Compound Interest Calculator": () => CompoundInterestView(),
  //Income Tax Calculator
  "HRA Calculator": () => HRAcalcView(),
  "Depreciation Calculator": () => DepreciationCalcView(),
  "Tax Calculator": () => TaxtCalcView(),
  "Capital Gain Calculator": () => CapitalGainCalcView(),
  //Investment Calculators
  "Post Office MIS": () => PostOfficeMISView(),
  "CARG Calculator": () => CARGcalcView(),
  "RD Calculator": () => RDcalcView(),
  "FD Calculator": () => FDcalcView(),
  "Lump Sum Calculator": () => LumpSumCalcView(),
  "SIP Calculator": () => SIPcalcView(),
  // insurance Calculators
  "NPS Calculator": () => NPSCalcView(),
};
