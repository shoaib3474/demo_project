// ignore_for_file: use_super_parameters

import 'package:demo_project/gen/assets.gen.dart';
import 'package:demo_project/utils/constants/app_colors.dart';
import 'package:demo_project/utils/constants/app_text.dart';
import 'package:flutter/material.dart';

import 'package:flutter_svg/flutter_svg.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final VoidCallback? onBack;
  final VoidCallback? onShare;
  final VoidCallback? onDownload;

  const CustomAppBar({
    Key? key,
    required this.title,
    this.onBack,
    this.onShare,
    this.onDownload,
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return AppBar(
      automaticallyImplyLeading: false,
      leading:
          onBack != null
              ? IconButton(
                icon: const Icon(
                  Icons.arrow_back_ios_new,
                  color: AppColors.white,
                ),
                onPressed: onBack,
              )
              : null,
      title: Text(
        title,
        style: AppTextStyles.body16.copyWith(color: AppColors.white),
      ),
      actions: [
        if (onDownload != null)
          IconButton(
            icon: SvgPicture.asset(
              Assets.icons.materialSymbolsDownload,
              color: AppColors.white,
              height: 24,
            ),
            onPressed: onDownload,
          ),
        if (onShare != null)
          IconButton(
            icon: SvgPicture.asset(
              Assets.icons.materialSymbolsShare,
              color: AppColors.white,
              height: 24,
            ),
            onPressed: onShare,
          ),
      ],
      flexibleSpace: Container(
        decoration: const BoxDecoration(
          gradient: AppColors.blueToGreenGradient,
        ),
      ),
      elevation: 0,
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
