import 'package:demo_project/utils/constants/app_colors.dart';
import 'package:demo_project/utils/constants/app_text.dart';
import 'package:flutter/material.dart';

class ClearCalculateButtons extends StatelessWidget {
  final VoidCallback onClearPressed;
  final VoidCallback onCalculatePressed;

  const ClearCalculateButtons({
    Key? key,
    required this.onClearPressed,
    required this.onCalculatePressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 76,
      padding: const EdgeInsets.symmetric(horizontal: 24),
      decoration: const BoxDecoration(color: AppColors.white),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Clear Button
          Expanded(
            child: GestureDetector(
              onTap: onClearPressed,
              child: Container(
                height: 44,
                padding: const EdgeInsets.symmetric(vertical: 10),
                decoration: ShapeDecoration(
                  gradient: AppColors.redGradient,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: Center(
                  child: Text(
                    'Clear',
                    textAlign: TextAlign.center,
                    style: AppTextStyles.body16.copyWith(
                      color: AppColors.white,
                    ),
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(width: 18), // Spacing between buttons
          // Calculate Button
          Expanded(
            child: GestureDetector(
              onTap: onCalculatePressed,
              child: Container(
                height: 44,
                padding: const EdgeInsets.symmetric(vertical: 10),
                decoration: ShapeDecoration(
                  gradient: AppColors.greenGradient,

                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: Center(
                  child: Text(
                    'Calculate',
                    textAlign: TextAlign.center,
                    style: AppTextStyles.body16.copyWith(
                      color: AppColors.white,
                    ),
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
