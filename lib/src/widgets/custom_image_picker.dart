import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import '../constants/colors.dart';

class CustomImagePicker {

  // =====================================
  // SHOW IMAGE PICKER BOTTOM SHEET
  // =====================================

  static Future<File?> show(
      BuildContext context,
      ) async {

    File? selectedImage;

    final ImagePicker picker =
    ImagePicker();

    await showModalBottomSheet(

      context: context,

      shape:
      const RoundedRectangleBorder(

        borderRadius:
        BorderRadius.vertical(

          top: Radius.circular(24),
        ),
      ),

      builder: (context) {

        return Padding(

          padding:
          const EdgeInsets.symmetric(

            horizontal: 20,
            vertical: 25,
          ),

          child: Column(

            mainAxisSize:
            MainAxisSize.min,

            children: [

              // =================================
              // TOP INDICATOR
              // =================================

              Container(

                width: 50,
                height: 5,

                decoration: BoxDecoration(

                  color:
                  AppColors.divider,

                  borderRadius:
                  BorderRadius.circular(
                    100,
                  ),
                ),
              ),

              const SizedBox(height: 25),

              // =================================
              // TITLE
              // =================================

              Text(

                "Select Profile Photo",

                style:
                Theme.of(context)
                    .textTheme
                    .titleMedium
                    ?.copyWith(

                  fontWeight:
                  FontWeight.w700,
                ),
              ),

              const SizedBox(height: 25),

              // =================================
              // OPTIONS
              // =================================

              Row(

                children: [

                  // =============================
                  // CAMERA
                  // =============================

                  Expanded(

                    child: GestureDetector(

                      onTap: () async {

                        final XFile? image =
                        await picker.pickImage(

                          source:
                          ImageSource.camera,
                        );

                        if (image != null) {

                          selectedImage =
                              File(image.path);
                        }

                        Navigator.pop(context);
                      },

                      child: Container(

                        padding:
                        const EdgeInsets.symmetric(
                          vertical: 22,
                        ),

                        decoration:
                        BoxDecoration(

                          color:
                          AppColors.background,

                          borderRadius:
                          BorderRadius.circular(
                            18,
                          ),
                        ),

                        child: Column(

                          children: [

                            const Icon(

                              Icons.camera_alt,

                              size: 34,

                              color:
                              AppColors.primary,
                            ),

                            const SizedBox(
                              height: 10,
                            ),

                            Text(

                              "Camera",

                              style: Theme.of(
                                context,
                              )
                                  .textTheme
                                  .titleSmall,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(width: 16),

                  // =============================
                  // GALLERY
                  // =============================

                  Expanded(

                    child: GestureDetector(

                      onTap: () async {

                        final XFile? image =
                        await picker.pickImage(

                          source:
                          ImageSource.gallery,
                        );

                        if (image != null) {

                          selectedImage =
                              File(image.path);
                        }

                        Navigator.pop(context);
                      },

                      child: Container(

                        padding:
                        const EdgeInsets.symmetric(
                          vertical: 22,
                        ),

                        decoration:
                        BoxDecoration(

                          color:
                          AppColors.background,

                          borderRadius:
                          BorderRadius.circular(
                            18,
                          ),
                        ),

                        child: Column(

                          children: [

                            const Icon(

                              Icons.photo,

                              size: 34,

                              color:
                              AppColors.primary,
                            ),

                            const SizedBox(
                              height: 10,
                            ),

                            Text(

                              "Gallery",

                              style: Theme.of(
                                context,
                              )
                                  .textTheme
                                  .titleSmall,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 20),
            ],
          ),
        );
      },
    );

    return selectedImage;
  }
}