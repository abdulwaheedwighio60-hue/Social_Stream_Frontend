import 'package:flutter/material.dart';

import '../constants/colors.dart';

class CustomTextFormFieldWidget
    extends StatelessWidget {

  // =========================
  // CONTROLLER
  // =========================
  final TextEditingController? controller;

  // =========================
  // TEXT
  // =========================
  final String? hintText;
  final String? labelText;
  final String? initialValue;

  // =========================
  // ICONS
  // =========================
  final Widget? prefixIcon;
  final Widget? suffixIcon;

  // =========================
  // STYLES
  // =========================
  final TextStyle? hintStyle;
  final TextStyle? textStyle;
  final TextStyle? labelStyle;

  // =========================
  // COLORS
  // =========================
  final Color? fillColor;
  final Color? focusedBorderColor;
  final Color? cursorColor;

  // =========================
  // BORDER
  // =========================
  final double borderRadius;

  // =========================
  // KEYBOARD
  // =========================
  final TextInputType? keyboardType;
  final TextInputAction? textInputAction;

  // =========================
  // TEXTFIELD SETTINGS
  // =========================
  final bool obscureText;
  final bool readOnly;
  final bool enabled;
  final bool autofocus;
  final bool expands;

  // =========================
  // LINES
  // =========================
  final int? maxLines;
  final int? minLines;
  final int? maxLength;

  // =========================
  // VALIDATION
  // =========================
  final String? Function(String?)? validator;
  final void Function(String)? onChanged;
  final void Function(String)? onFieldSubmitted;
  final VoidCallback? onTap;

  // =========================
  // PADDING
  // =========================
  final EdgeInsetsGeometry? contentPadding;
  final EdgeInsetsGeometry? margin;

  // =========================
  // FOCUS
  // =========================
  final FocusNode? focusNode;

  const CustomTextFormFieldWidget({
    super.key,

    // Controller
    this.controller,

    // Text
    this.hintText,
    this.labelText,
    this.initialValue,

    // Icons
    this.prefixIcon,
    this.suffixIcon,

    // Styles
    this.hintStyle,
    this.textStyle,
    this.labelStyle,

    // Colors
    this.fillColor,
    this.focusedBorderColor,
    this.cursorColor,

    // Border
    this.borderRadius = 10,

    // Keyboard
    this.keyboardType,
    this.textInputAction,

    // Settings
    this.obscureText = false,
    this.readOnly = false,
    this.enabled = true,
    this.autofocus = false,
    this.expands = false,

    // Lines
    this.maxLines = 1,
    this.minLines,
    this.maxLength,

    // Validation
    this.validator,
    this.onChanged,
    this.onFieldSubmitted,
    this.onTap,

    // Padding
    this.contentPadding,
    this.margin,

    // Focus
    this.focusNode,
  });

  @override
  Widget build(BuildContext context) {

    final textTheme =
        Theme.of(context).textTheme;

    return Container(
      margin: margin,

      child: TextFormField(
        controller: controller,
        initialValue: initialValue,
        focusNode: focusNode,

        keyboardType: keyboardType,
        textInputAction: textInputAction,

        obscureText: obscureText,
        readOnly: readOnly,
        enabled: enabled,
        autofocus: autofocus,
        expands: expands,

        maxLines:
        obscureText ? 1 : maxLines,

        minLines: minLines,
        maxLength: maxLength,

        validator: validator,
        onChanged: onChanged,
        onFieldSubmitted:
        onFieldSubmitted,
        onTap: onTap,

        cursorColor:
        cursorColor ??
            AppColors.primary,

        style:
        textStyle ??
            textTheme.bodyMedium
                ?.copyWith(
              color:
              AppColors
                  .textPrimary,
              fontSize: 14,
            ),

        decoration: InputDecoration(
          hintText: hintText,
          labelText: labelText,

          prefixIcon: prefixIcon,
          suffixIcon: suffixIcon,

          filled: true,

          // =========================
          // BACKGROUND COLOR
          // =========================
          fillColor:
          fillColor ??
              AppColors.background,

          hintStyle:
          hintStyle ??
              textTheme.bodyMedium
                  ?.copyWith(
                color:
                AppColors
                    .textLight,
                fontSize: 14,
              ),

          labelStyle:
          labelStyle ??
              textTheme.bodyMedium
                  ?.copyWith(
                color: AppColors
                    .textSecondary,
              ),

          counterText: "",

          contentPadding:
          contentPadding ??
              const EdgeInsets.symmetric(
                horizontal: 12,
                vertical: 8,
              ),

          // =========================
          // REMOVE ALL BORDERS
          // =========================
          border: OutlineInputBorder(
            borderRadius:
            BorderRadius.circular(
              borderRadius,
            ),

            borderSide:
            BorderSide.none,
          ),

          enabledBorder:
          OutlineInputBorder(
            borderRadius:
            BorderRadius.circular(
              borderRadius,
            ),

            borderSide:
            BorderSide.none,
          ),

          focusedBorder:
          OutlineInputBorder(
            borderRadius:
            BorderRadius.circular(
              borderRadius,
            ),

            borderSide: BorderSide.none
          ),

          errorBorder:
          OutlineInputBorder(
            borderRadius:
            BorderRadius.circular(
              borderRadius,
            ),

            borderSide:
            const BorderSide(
              color:
              AppColors.error,
            ),
          ),

          focusedErrorBorder:
          OutlineInputBorder(
            borderRadius:
            BorderRadius.circular(
              borderRadius,
            ),

            borderSide:
            const BorderSide(
              color:
              AppColors.error,

              width: 1.2,
            ),
          ),
        ),
      ),
    );
  }
}