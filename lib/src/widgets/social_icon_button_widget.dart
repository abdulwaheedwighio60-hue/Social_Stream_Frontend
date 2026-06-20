import 'package:flutter/material.dart';

import '../constants/colors.dart';

class SocialIconButtonWidget
    extends StatelessWidget {

  final String imagePath;
  final VoidCallback? onTap;

  final double height;
  final double width;
  final double padding;
  final double borderWidth;

  final Color? backgroundColor;
  final Color? borderColor;

  const SocialIconButtonWidget({
    super.key,

    required this.imagePath,
    this.onTap,

    this.height = 60,
    this.width = 60,
    this.padding = 14,
    this.borderWidth = 1.2,

    this.backgroundColor,
    this.borderColor,
  });

  @override
  Widget build(BuildContext context) {

    return GestureDetector(
      onTap: onTap,

      child: Container(
        height: height,
        width: width,

        padding: EdgeInsets.all(
          padding,
        ),

        decoration: BoxDecoration(
          color:
          backgroundColor ??
              AppColors.white,

          shape: BoxShape.circle,

          border: Border.all(
            color:
            borderColor ??
                AppColors.divider,

            width: borderWidth,
          ),
        ),

        child: Image.asset(
          imagePath,
          fit: BoxFit.contain,
        ),
      ),
    );
  }
}