import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:social_stream/src/constants/colors.dart';

class AppSnackBar {
  AppSnackBar._();

  static void showSuccess(
      BuildContext context, {
        required String message,
      }) {
    _show(
      context,
      message: message,
      title: 'Success',
      icon: Iconsax.tick_circle,
      backgroundColor: AppColors.primary,
    );
  }

  static void showError(
      BuildContext context, {
        required String message,
      }) {
    _show(
      context,
      message: message,
      title: 'Something went wrong',
      icon: Iconsax.warning_2,
      backgroundColor: const Color(0xFFD92D20),
    );
  }

  static void showInfo(
      BuildContext context, {
        required String message,
      }) {
    _show(
      context,
      message: message,
      title: 'Information',
      icon: Iconsax.info_circle,
      backgroundColor: const Color(0xFF2563EB),
    );
  }

  static void showWarning(
      BuildContext context, {
        required String message,
      }) {
    _show(
      context,
      message: message,
      title: 'Warning',
      icon: Iconsax.warning_2,
      backgroundColor: const Color(0xFFF79009),
    );
  }

  static void _show(
      BuildContext context, {
        required String message,
        required String title,
        required IconData icon,
        required Color backgroundColor,
      }) {
    final scaffoldMessenger = ScaffoldMessenger.of(context);

    // Pehle se visible snackbar remove karega.
    scaffoldMessenger
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          content: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 38,
                height: 38,
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.18),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  icon,
                  color: Colors.white,
                  size: 21,
                ),
              ),

              const SizedBox(width: 12),

              Expanded(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 14,
                        fontWeight: FontWeight.w700,
                      ),
                    ),

                    const SizedBox(height: 3),

                    Text(
                      message,
                      maxLines: 3,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        color: Colors.white.withOpacity(0.92),
                        fontSize: 13,
                        fontWeight: FontWeight.w400,
                        height: 1.35,
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(width: 8),

              GestureDetector(
                onTap: scaffoldMessenger.hideCurrentSnackBar,
                child: Container(
                  width: 28,
                  height: 28,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.14),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.close_rounded,
                    color: Colors.white,
                    size: 18,
                  ),
                ),
              ),
            ],
          ),
          backgroundColor: backgroundColor,
          behavior: SnackBarBehavior.floating,
          elevation: 8,
          duration: const Duration(seconds: 4),
          dismissDirection: DismissDirection.horizontal,
          padding: const EdgeInsets.symmetric(
            horizontal: 14,
            vertical: 13,
          ),
          margin: const EdgeInsets.fromLTRB(
            16,
            0,
            16,
            20,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
        ),
      );
  }
}