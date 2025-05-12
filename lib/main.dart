import 'package:demo_project/view/screens/simple_interest_view.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'providers/simple_interest_provider.dart';

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (_) => SimpleInterestProvider(),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        home: SimpleInterestView(),
      ),
    ),
  );
}
