import 'package:demo_project/view/screens/home_screen.dart';
import 'package:flutter/material.dart';
import 'package:demo_project/utils/custom/custom_appbar.dart';
import 'package:demo_project/utils/custom/custom_nav.dart';

class LandingScreen extends StatefulWidget {
  const LandingScreen({super.key});

  @override
  State<LandingScreen> createState() => _LandingScreenState();
}

class _LandingScreenState extends State<LandingScreen> {
  int _selectedIndex = 0;

  final List<String> _titles = [
    'Home',
    'Tools',
    'Blogs',
    'More',
  ]; // Adjust based on your tabs
  final List<Widget> _pages = [
    HomeScreen(),
    Center(child: Text('Home Page')),

    Center(child: Text('Blogs')),
    Center(child: Text('More')),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(title: _titles[_selectedIndex]),
      body: _pages[_selectedIndex],
      bottomNavigationBar: CustomNavbar(
        selectedIndex: _selectedIndex,
        onItemTapped: _onItemTapped,
      ),
    );
  }
}
