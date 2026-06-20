import 'package:flutter/material.dart';

import '../constants/colors.dart';

class CustomElevatedButtonWidget extends StatelessWidget {
  final String text;

  final VoidCallback? onPressed;

  final double? height;
  final double? width;

  final double borderRadius;
  final double elevation;

  final EdgeInsetsGeometry? padding;
  final EdgeInsetsGeometry? margin;

  final Color? backgroundColor;
  final Color? foregroundColor;
  final Color? borderColor;
  final Color? disabledColor;

  final Widget? prefixIcon;
  final Widget? suffixIcon;

  final TextStyle? textStyle;

  final bool isLoading;
  final bool isExpanded;

  final BorderSide? borderSide;

  const CustomElevatedButtonWidget({
    super.key,

    required this.text,
    required this.onPressed,

    this.height = 55,
    this.width,

    this.borderRadius = 14,
    this.elevation = 0,

    this.padding,
    this.margin,

    this.backgroundColor,
    this.foregroundColor,
    this.borderColor,
    this.disabledColor,

    this.prefixIcon,
    this.suffixIcon,

    this.textStyle,

    this.isLoading = false,
    this.isExpanded = true,

    this.borderSide,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      width: width,
      margin: margin,

      child: SizedBox(
        height: height,
        width: isExpanded ? double.infinity : width,

        child: ElevatedButton(
          onPressed: isLoading ? null : onPressed,

          style: ElevatedButton.styleFrom(
            elevation: elevation,

            padding:
            padding ??
                const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 14,
                ),

            backgroundColor:
            backgroundColor ?? AppColors.primary,

            foregroundColor:
            foregroundColor ?? AppColors.white,

            disabledBackgroundColor:
            disabledColor ?? AppColors.lightGrey,

            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(
                borderRadius,
              ),

              side:
              borderSide ??
                  BorderSide(
                    color:
                    borderColor ??
                        Colors.transparent,
                  ),
            ),
          ),

          child:
          isLoading
              ? SizedBox(
            height: 22,
            width: 22,

            child: CircularProgressIndicator(
              strokeWidth: 2.5,
              color:
              foregroundColor ??
                  AppColors.white,
            ),
          )
              : Row(
            mainAxisSize:
            isExpanded
                ? MainAxisSize.max
                : MainAxisSize.min,

            mainAxisAlignment:
            MainAxisAlignment.center,

            children: [
              if (prefixIcon != null) ...[
                prefixIcon!,
                const SizedBox(width: 10),
              ],

              Flexible(
                child: Text(
                  text,
                  overflow: TextOverflow.ellipsis,

                  style:
                  textStyle ??
                      theme.textTheme.labelLarge,
                ),
              ),

              if (suffixIcon != null) ...[
                const SizedBox(width: 10),
                suffixIcon!,
              ],
            ],
          ),
        ),
      ),
    );
  }
}