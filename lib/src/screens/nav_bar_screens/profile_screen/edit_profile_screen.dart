import 'dart:io';

import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:image_picker/image_picker.dart';
import 'package:social_stream/src/constants/app_images.dart';
import 'package:social_stream/src/constants/colors.dart';
import 'package:social_stream/src/utils/media_query.dart';
import 'package:social_stream/src/widgets/custom_circle_icon_widget.dart';
import 'package:social_stream/src/widgets/custom_text_form_field_widget.dart';
import 'package:social_stream/src/widgets/custom_text_widget.dart';

class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({super.key});

  @override
  State<EditProfileScreen> createState() =>
      _EditProfileScreenState();
}

class _EditProfileScreenState
    extends State<EditProfileScreen> {

  // =========================================
  // FORM KEY
  // =========================================

  final GlobalKey<FormState> formKey =
  GlobalKey<FormState>();

  // =========================================
  // CONTROLLERS
  // =========================================

  final TextEditingController nameController =
  TextEditingController();

  final TextEditingController userNameController =
  TextEditingController();

  final TextEditingController phoneController =
  TextEditingController();

  final TextEditingController emailController =
  TextEditingController();

  final TextEditingController dobController =
  TextEditingController();

  final TextEditingController genderController =
  TextEditingController();

  // =========================================
  // IMAGE
  // =========================================

  File? selectedImage;

  // =========================================
  // DISPOSE
  // =========================================

  @override
  void dispose() {

    nameController.dispose();

    userNameController.dispose();

    phoneController.dispose();

    emailController.dispose();

    dobController.dispose();

    genderController.dispose();

    super.dispose();
  }

  // =========================================
  // PICK IMAGE
  // =========================================

  Future<void> pickImage(
      ImageSource source) async {

    final ImagePicker picker =
    ImagePicker();

    final XFile? image =
    await picker.pickImage(
      source: source,
      imageQuality: 80,
    );

    if (image != null) {

      setState(() {

        selectedImage =
            File(image.path);
      });
    }
  }

  // =========================================
  // IMAGE PICKER BOTTOM SHEET
  // =========================================

  void showImagePickerOptions() {

    showModalBottomSheet(

      context: context,

      backgroundColor: AppColors.white,

      shape:
      const RoundedRectangleBorder(

        borderRadius:
        BorderRadius.vertical(
          top: Radius.circular(28),
        ),
      ),

      builder: (context) {

        return Padding(

          padding:
          const EdgeInsets.symmetric(
            horizontal: 22,
            vertical: 24,
          ),

          child: Column(

            mainAxisSize:
            MainAxisSize.min,

            children: [

              Container(

                width: 55,
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

              const SizedBox(height: 24),

              Text(

                "Select Profile Photo",

                style:
                Theme.of(context)
                    .textTheme
                    .titleMedium
                    ?.copyWith(

                  fontWeight:
                  FontWeight.w700,

                  fontSize: 18,
                ),
              ),

              const SizedBox(height: 24),

              Row(

                children: [

                  Expanded(

                    child: _buildPickerCard(

                      icon:
                      Icons.camera_alt_rounded,

                      title: "Camera",

                      onTap: () async {

                        Navigator.pop(
                          context,
                        );

                        await pickImage(
                          ImageSource.camera,
                        );
                      },
                    ),
                  ),

                  const SizedBox(width: 16),

                  Expanded(

                    child: _buildPickerCard(

                      icon:
                      Icons.photo_library_rounded,

                      title: "Gallery",

                      onTap: () async {

                        Navigator.pop(
                          context,
                        );

                        await pickImage(
                          ImageSource.gallery,
                        );
                      },
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 12),
            ],
          ),
        );
      },
    );
  }

  // =========================================
  // PICKER CARD
  // =========================================

  Widget _buildPickerCard({

    required IconData icon,

    required String title,

    required VoidCallback onTap,

  }) {

    return GestureDetector(

      onTap: onTap,

      child: Container(

        padding:
        const EdgeInsets.symmetric(
          vertical: 24,
        ),

        decoration: BoxDecoration(

          color:
          AppColors.background,

          borderRadius:
          BorderRadius.circular(20),
        ),

        child: Column(

          children: [

            Icon(

              icon,

              size: 36,

              color:
              AppColors.primary,
            ),

            const SizedBox(height: 12),

            Text(

              title,

              style:
              Theme.of(context)
                  .textTheme
                  .titleSmall
                  ?.copyWith(

                fontWeight:
                FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // =========================================
  // FORM FIELD TITLE
  // =========================================

  Widget buildTitle(String title) {

    return Align(

      alignment: Alignment.centerLeft,

      child: Padding(

        padding:
        const EdgeInsets.only(
          bottom: 10,
        ),

        child: Text(

          title,

          style:
          Theme.of(context)
              .textTheme
              .titleMedium
              ?.copyWith(

            fontSize: 15,

            fontWeight:
            FontWeight.w600,
          ),
        ),
      ),
    );
  }

  // =========================================
  // BUILD
  // =========================================

  @override
  Widget build(BuildContext context) {

    final textStyle =
        Theme.of(context).textTheme;

    return Scaffold(

      backgroundColor:
      AppColors.white,

      appBar: AppBar(

        backgroundColor:
        AppColors.white,

        elevation: 0,

        centerTitle: true,

        leading: Padding(

          padding:
          const EdgeInsets.all(10),

          child:
          GestureDetector(

            onTap: () {

              Navigator.pop(
                context,
              );
            },

            child:
            const CustomCircleIconWidget(

              icon:
              Icons.arrow_back,
            ),
          ),
        ),

        title: const CustomTextWidget(
          text: "Edit Profile",
        ),
      ),

      body: SingleChildScrollView(

        physics:
        const BouncingScrollPhysics(),

        child: Padding(

          padding: EdgeInsets.symmetric(

            horizontal:
            screenWidth * 0.055,

            vertical:
            screenHeight * 0.015,
          ),

          child: Form(

            key: formKey,

            child: Column(

              children: [

                // =====================================
                // PROFILE IMAGE
                // =====================================

                SizedBox(
                  height:
                  screenHeight * 0.010,
                ),

                Center(

                  child: Stack(

                    children: [

                      Container(

                        width: 115,
                        height: 115,

                        decoration:
                        BoxDecoration(

                          shape:
                          BoxShape.circle,

                          border: Border.all(

                            color:
                            AppColors.primary
                                .withOpacity(
                              0.15,
                            ),

                            width: 3,
                          ),
                        ),

                        child: ClipOval(

                          child:
                          selectedImage !=
                              null

                              ? Image.file(

                            selectedImage!,

                            fit:
                            BoxFit.cover,
                          )

                              : Image.asset(

                            AppImages
                                .userImage1,

                            fit:
                            BoxFit.cover,
                          ),
                        ),
                      ),

                      Positioned(

                        bottom: 0,
                        right: 0,

                        child:
                        GestureDetector(

                          onTap:
                          showImagePickerOptions,

                          child: Container(

                            width: 34,
                            height: 34,

                            decoration:
                            BoxDecoration(

                              color:
                              AppColors.primary,

                              shape:
                              BoxShape.circle,

                              border: Border.all(

                                color:
                                AppColors.white,

                                width: 2,
                              ),
                            ),

                            child: const Icon(

                              Iconsax.edit_2,

                              size: 17,

                              color:
                              AppColors.white,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                SizedBox(
                  height:
                  screenHeight * 0.040,
                ),

                // =====================================
                // FULL NAME
                // =====================================

                buildTitle("Full Name"),

                CustomTextFormFieldWidget(

                  controller:
                  nameController,

                  hintText:
                  "John Doe",

                  fillColor:
                  AppColors.background,


                  keyboardType:
                  TextInputType.name,

                  textInputAction:
                  TextInputAction.next,

                  validator: (value) {

                    if (value == null ||
                        value.trim().isEmpty) {

                      return
                        "Full name is required";
                    }

                    return null;
                  },
                ),

                SizedBox(
                  height:
                  screenHeight * 0.022,
                ),

                // =====================================
                // USERNAME
                // =====================================

                buildTitle("Username"),

                CustomTextFormFieldWidget(

                  controller:
                  userNameController,

                  hintText:
                  "brooklyn_simmons",

                  fillColor:
                  AppColors.background,

                  keyboardType:
                  TextInputType.text,

                  textInputAction:
                  TextInputAction.next,

                  validator: (value) {

                    if (value == null ||
                        value.trim().isEmpty) {

                      return
                        "Username is required";
                    }

                    return null;
                  },
                ),

                SizedBox(
                  height:
                  screenHeight * 0.022,
                ),

                // =====================================
                // PHONE NUMBER
                // =====================================

                buildTitle("Phone Number"),

                CustomTextFormFieldWidget(

                  controller:
                  phoneController,

                  hintText:
                  "0321XXXXXXX",

                  fillColor:
                  AppColors.background,


                  keyboardType:
                  TextInputType.phone,

                  textInputAction:
                  TextInputAction.next,

                  validator: (value) {

                    if (value == null ||
                        value.trim().isEmpty) {

                      return
                        "Phone number is required";
                    }

                    return null;
                  },
                ),

                SizedBox(
                  height:
                  screenHeight * 0.022,
                ),

                // =====================================
                // EMAIL
                // =====================================

                buildTitle("Email"),

                CustomTextFormFieldWidget(

                  controller:
                  emailController,

                  hintText:
                  "user@example.com",

                  fillColor:
                  AppColors.background,

                  keyboardType:
                  TextInputType.emailAddress,

                  textInputAction:
                  TextInputAction.next,

                  validator: (value) {

                    if (value == null ||
                        value.trim().isEmpty) {

                      return
                        "Email is required";
                    }

                    return null;
                  },
                ),

                SizedBox(
                  height:
                  screenHeight * 0.022,
                ),

                // =====================================
                // DOB
                // =====================================

                buildTitle("Date of Birth"),

                CustomTextFormFieldWidget(

                  controller:
                  dobController,

                  hintText:
                  "DD/MM/YYYY",

                  fillColor:
                  AppColors.background,

                  keyboardType:
                  TextInputType.datetime,

                  textInputAction:
                  TextInputAction.next,
                ),

                SizedBox(
                  height:
                  screenHeight * 0.022,
                ),

                // =====================================
                // GENDER
                // =====================================

                buildTitle("Gender"),

                CustomTextFormFieldWidget(

                  controller:
                  genderController,

                  hintText:
                  "Male",

                  fillColor:
                  AppColors.background,

                  keyboardType:
                  TextInputType.text,

                  textInputAction:
                  TextInputAction.done,
                ),

                SizedBox(
                  height:
                  screenHeight * 0.050,
                ),

                // =====================================
                // SAVE BUTTON
                // =====================================

                SizedBox(

                  width: double.infinity,
                  height: 56,

                  child: ElevatedButton(

                    onPressed: () {

                      if (formKey.currentState!
                          .validate()) {

                        // SAVE PROFILE
                      }
                    },

                    style:
                    ElevatedButton.styleFrom(

                      backgroundColor:
                      AppColors.primary,

                      elevation: 0,

                      shape:
                      RoundedRectangleBorder(

                        borderRadius:
                        BorderRadius.circular(
                          16,
                        ),
                      ),
                    ),

                    child: Text(

                      "Save Changes",

                      style:
                      textStyle.titleMedium
                          ?.copyWith(

                        color:
                        AppColors.white,

                        fontWeight:
                        FontWeight.w700,
                      ),
                    ),
                  ),
                ),

                SizedBox(
                  height:
                  screenHeight * 0.050,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}