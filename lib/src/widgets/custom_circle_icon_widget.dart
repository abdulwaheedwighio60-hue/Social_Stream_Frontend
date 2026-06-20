import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';

import '../constants/colors.dart';

class CustomCircleIconWidget
    extends StatelessWidget {

  final IconData icon;
  final VoidCallback? onTap;

  final double height;
  final double width;
  final double iconSize;

  final Color? iconColor;
  final Color? borderColor;
  final Color? backgroundColor;

  const CustomCircleIconWidget({
    super.key,

    required this.icon,

    this.onTap,

    this.height = 40,
    this.width = 40,
    this.iconSize = 22,

    this.iconColor,
    this.borderColor,
    this.backgroundColor,
  });

  @override
  Widget build(BuildContext context) {

    return GestureDetector(
      onTap: onTap,

      child: Container(
        width: width,
        height: height,

        decoration: BoxDecoration(
          color:
          backgroundColor ??
              AppColors.white,

          shape: BoxShape.circle,

          border: Border.all(
            color:
            borderColor ??
                AppColors.divider,
          ),
        ),

        child: Icon(
          icon,
          size: iconSize,

          color:
          iconColor ??
              AppColors.black,
        ),
      ),
    );
  }
}