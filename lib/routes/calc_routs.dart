import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:demo_project/providers/base_calculator_provider.dart';

// Import all views
import 'package:demo_project/view/screens/calculators/GST/GST_calc_view.dart';
import 'package:demo_project/view/screens/calculators/bank/compound_interest_view.dart';
import 'package:demo_project/view/screens/calculators/bank/simple_interest_view.dart';
import 'package:demo_project/view/screens/calculators/income%20tax/HRA_calc_view.dart';
import 'package:demo_project/view/screens/calculators/income%20tax/capital_gain_calc_view.dart';
import 'package:demo_project/view/screens/calculators/income%20tax/depreciation_calc_view.dart';
import 'package:demo_project/view/screens/calculators/income%20tax/tax_calc_view.dart';
import 'package:demo_project/view/screens/calculators/insurance/NPS_calc_view.dart';
import 'package:demo_project/view/screens/calculators/investment/CARG_calc_view.dart';
import 'package:demo_project/view/screens/calculators/investment/FD_calc_view.dart';
import 'package:demo_project/view/screens/calculators/investment/RD_calc_view.dart';
import 'package:demo_project/view/screens/calculators/investment/SIP_calc_view.dart';
import 'package:demo_project/view/screens/calculators/investment/lump_sum_calc_view.dart';
import 'package:demo_project/view/screens/calculators/investment/post_office_MIS_view.dart';
import 'package:demo_project/view/screens/calculators/loan/business_calc_view.dart';
import 'package:demo_project/view/screens/calculators/loan/car_calc_view.dart';
import 'package:demo_project/view/screens/calculators/loan/home_calc_view.dart';
import 'package:demo_project/view/screens/calculators/loan/personal_calc_view.dart';
import 'package:demo_project/view/screens/calculators/loan/property_calc_view.dart';

Widget wrapWithProvider(Widget child) {
  return ChangeNotifierProvider(
    create: (_) => BaseCalculatorProvider(),
    child: child,
  );
}

final Map<String, Widget Function()> calculatorRouteMap = {
  // Bank
  "Simple Interest Calculator": () => wrapWithProvider(SimpleInterestView()),
  "Compound Interest Calculator":
      () => wrapWithProvider(CompoundInterestView()),

  // Income Tax
  "HRA Calculator": () => wrapWithProvider(HRAcalcView()),
  "Depreciation Calculator": () => wrapWithProvider(DepreciationCalcView()),
  "Tax Calculator": () => wrapWithProvider(TaxtCalcView()),
  "Capital Gain Calculator": () => wrapWithProvider(CapitalGainCalcView()),

  // Investment
  "Post Office MIS": () => wrapWithProvider(PostOfficeMISView()),
  "CARG Calculator": () => wrapWithProvider(CARGcalcView()),
  "RD Calculator": () => wrapWithProvider(RDcalcView()),
  "FD Calculator": () => wrapWithProvider(FDcalcView()),
  "Lump Sum Calculator": () => wrapWithProvider(LumpSumCalcView()),
  "SIP Calculator": () => wrapWithProvider(SIPcalcView()),

  // Insurance
  "NPS Calculator": () => wrapWithProvider(NPSCalcView()),

  // Loan
  "Business Loan Calculator": () => wrapWithProvider(BusinessCalcView()),
  "Car Loan Calculator": () => wrapWithProvider(CarCalcView()),
  "Loan Against Property": () => wrapWithProvider(PropertyCalcView()),
  "Home Loan Calculator": () => wrapWithProvider(HomeCalcView()),
  "Personal Loan Calculator": () => wrapWithProvider(PersonalCalcView()),

  // GST
  "GST Calculator": () => wrapWithProvider(GSTcalcView()),
};
