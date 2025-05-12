// ignore_for_file: deprecated_member_use

import 'package:demo_project/gen/assets.gen.dart';
import 'package:demo_project/utils/constants/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class CustomNavbar extends StatelessWidget {
  final int selectedIndex;
  final ValueChanged<int> onItemTapped;

  const CustomNavbar({
    super.key,
    required this.selectedIndex,
    required this.onItemTapped,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20), // Circular border on top-left
          topRight: Radius.circular(20), // Circular border on top-right
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black26, // Shadow color
            blurRadius: 10, // Blur radius
            offset: Offset(0, -4), // Offset to position shadow above navbar
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(20), // Circular border on top-left
          topRight: Radius.circular(20), // Circular border on top-right
        ),
        child: BottomNavigationBar(
          currentIndex: selectedIndex,
          onTap: onItemTapped,
          type: BottomNavigationBarType.fixed,
          backgroundColor: AppColors.white,
          selectedItemColor: AppColors.primary,
          iconSize: 30, // Increase icon size
          selectedFontSize: 16, // Adjust font size for selected label
          unselectedFontSize: 12, // Adjust font size for unselected label
          showSelectedLabels: true,
          showUnselectedLabels: true,
          items: [
            BottomNavigationBarItem(
              icon: SvgPicture.asset(
                Assets.icons.home,
                color:
                    selectedIndex == 0
                        ? AppColors.primary
                        : AppColors.secondary,
              ),
              label: 'Home',
            ),
            BottomNavigationBarItem(
              icon: SvgPicture.asset(
                Assets.icons.services,
                color:
                    selectedIndex == 1
                        ? AppColors.primary
                        : AppColors.secondary,
              ),
              label: 'Tools',
            ),
            BottomNavigationBarItem(
              icon: SvgPicture.asset(
                Assets.icons.blogs,
                color:
                    selectedIndex == 2
                        ? AppColors.primary
                        : AppColors.secondary,
              ),
              label: 'Blogs',
            ),
            BottomNavigationBarItem(
              icon: SvgPicture.asset(
                Assets.icons.more,
                color:
                    selectedIndex == 3
                        ? AppColors.primary
                        : AppColors.secondary,
              ),
              label: 'More',
            ),
          ],
        ),
      ),
    );
  }
}
