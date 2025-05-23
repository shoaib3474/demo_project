// ignore_for_file: use_super_parameters

import 'package:demo_project/utils/constants/app_colors.dart';
import 'package:demo_project/utils/constants/app_text.dart';
import 'package:flutter/material.dart';

class SearchCancelButton extends StatelessWidget {
  final VoidCallback onSearchPressed;
  final VoidCallback onCancelPressed;

  const SearchCancelButton({
    Key? key,
    required this.onSearchPressed,
    required this.onCancelPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 73,
      padding: const EdgeInsets.symmetric(horizontal: 24),
      decoration: const BoxDecoration(color: AppColors.white),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Cancel Button
          Expanded(
            child: GestureDetector(
              onTap: onCancelPressed,
              child: Container(
                height: 44,
                padding: const EdgeInsets.symmetric(vertical: 10),
                decoration: ShapeDecoration(
                  shape: RoundedRectangleBorder(
                    side: const BorderSide(
                      width: 1,
                      color: AppColors.primary, // Primary color
                    ),
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: Center(
                  child: Text(
                    'Cancel',
                    textAlign: TextAlign.center,
                    style: AppTextStyles.body16,
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(width: 20), // Spacing between buttons
          // Search Button
          Expanded(
            child: GestureDetector(
              onTap: onSearchPressed,
              child: Container(
                height: 44,
                padding: const EdgeInsets.symmetric(vertical: 10),
                decoration: ShapeDecoration(
                  color: AppColors.primary, // Primary color
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: Center(
                  child: Text(
                    'Search',
                    textAlign: TextAlign.center,
                    style: AppTextStyles.body16,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
