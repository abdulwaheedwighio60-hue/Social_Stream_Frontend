// =========================
// IMPORTS
// =========================
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:social_stream/src/constants/colors.dart';
import 'package:social_stream/src/screens/intrests_screen/intrests_screen.dart';
import 'package:social_stream/src/services/user_authentication.dart';
import 'package:social_stream/src/utils/media_query.dart';
import 'package:social_stream/src/widgets/custom_elevated_button_widget.dart';
import 'package:social_stream/src/widgets/custom_image_picker.dart';
import 'package:social_stream/src/widgets/custom_text_form_field_widget.dart';

class CompleteProfileScreen extends StatefulWidget {


  final String userName;
  final String email;
  final String password;

  const CompleteProfileScreen({
    super.key,
    required this.userName,
    required this.email,
    required this.password,
  });

  @override
  State<CompleteProfileScreen> createState() =>
      _CompleteProfileScreenState();
}

class _CompleteProfileScreenState
    extends State<CompleteProfileScreen> {

  // =========================
  // FORM KEY
  // =========================
  final GlobalKey<FormState>
  _formKey =
  GlobalKey<FormState>();

  // =========================
  // CONTROLLERS
  // =========================
  final TextEditingController
  nameController =
  TextEditingController();

  final TextEditingController
  phoneController =
  TextEditingController();

  final TextEditingController bioController = TextEditingController();
  // =========================
  // IMAGE PICKER
  // =========================
  final ImagePicker _picker =
  ImagePicker();

  File? selectedImage;

  // =========================
  // COUNTRY CODES LIST
  // =========================
  final List<String> countryCodes = [
    "+1",
    "+44",
    "+92",
    "+91",
    "+61",
    "+971",
    "+49",
    "+81",
    "+86",
    "+33",
  ];

  // =========================
  // SELECTED CODE
  // =========================
  String selectedCountryCode = "+1";

  // =========================
  // PICK IMAGE
  // =========================
  File? imageFile;

  void pickProfileImage() async {

    File? image =
    await CustomImagePicker.show(
        context);

    if (image != null) {

      setState(() {

        imageFile = image;
      });
    }
  }

  // =========================
  // SHOW IMAGE OPTIONS
  // =========================

  @override
  void dispose() {

    nameController.dispose();
    phoneController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {

    final textTheme =
        Theme.of(context).textTheme;

    return Scaffold(
      backgroundColor:
      AppColors.white,

      body: SafeArea(
        child: SingleChildScrollView(
          physics:
          const BouncingScrollPhysics(),

          child: Padding(
            padding: EdgeInsets.symmetric(
              horizontal:
              screenWidth * 0.07,

              vertical:
              screenHeight * 0.015,
            ),

            child: Form(
              key: _formKey,

              child: Column(
                crossAxisAlignment:
                CrossAxisAlignment.start,

                children: [

                  SizedBox(
                    height:
                    screenHeight * 0.010,
                  ),

                  // =========================
                  // BACK BUTTON
                  // =========================
                  Container(
                    height: 42,
                    width: 42,

                    decoration: BoxDecoration(
                      color: AppColors.white,

                      shape: BoxShape.circle,

                      border: Border.all(
                        color:
                        AppColors.divider,
                      ),
                    ),

                    child: IconButton(
                      onPressed: () {
                        Navigator.pop(
                          context,
                        );
                      },

                      icon: const Icon(
                        Icons.arrow_back_ios_new,
                        size: 18,
                        color:
                        AppColors.black,
                      ),
                    ),
                  ),

                  SizedBox(
                    height:
                    screenHeight * 0.040,
                  ),

                  // =========================
                  // TITLE SECTION
                  // =========================
                  Center(
                    child: Column(
                      children: [

                        Text(
                          "Complete Your Profile",

                          textAlign:
                          TextAlign.center,

                          style: textTheme
                              .headlineMedium
                              ?.copyWith(
                            fontSize: 28,
                            fontWeight:
                            FontWeight.w700,
                          ),
                        ),

                        SizedBox(
                          height:
                          screenHeight *
                              0.012,
                        ),

                        Text(
                          "Don't worry, only you can see your personal data. No one else will be able to see it.",

                          textAlign:
                          TextAlign.center,

                          style: textTheme
                              .bodyMedium
                              ?.copyWith(
                            color:
                            AppColors
                                .textSecondary,

                            fontSize: 14,
                            height: 1.6,
                          ),
                        ),
                      ],
                    ),
                  ),

                  SizedBox(
                    height:
                    screenHeight * 0.050,
                  ),

                  // =========================
                  // PROFILE IMAGE
                  // =========================
                  Center(
                    child: Stack(
                      clipBehavior:
                      Clip.none,

                      children: [

                        Container(
                          height: 120,
                          width: 120,

                          decoration:
                          BoxDecoration(
                            color:
                            AppColors
                                .background,

                            shape:
                            BoxShape
                                .circle,

                            image:
                            selectedImage !=
                                null
                                ? DecorationImage(
                              image:
                              FileImage(
                                selectedImage!,
                              ),
                              fit:
                              BoxFit
                                  .cover,
                            )
                                : null,
                          ),

                          child:
                          selectedImage ==
                              null
                              ? Icon(
                            Icons.person,
                            size: 70,
                            color:
                            AppColors
                                .primary,
                          )
                              : null,
                        ),

                        Positioned(
                          bottom: 2,
                          right: -2,

                          child: GestureDetector(
                            onTap:
                            pickProfileImage,

                            child: Container(
                              height: 36,
                              width: 36,

                              decoration:
                              const BoxDecoration(
                                color:
                                AppColors
                                    .primary,

                                shape:
                                BoxShape
                                    .circle,
                              ),

                              child:
                              const Icon(
                                Icons.edit,
                                color:
                                AppColors
                                    .white,
                                size: 18,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  SizedBox(
                    height:
                    screenHeight * 0.060,
                  ),

                  // NAME
                  Text(
                    "Name",

                    style: textTheme
                        .titleMedium
                        ?.copyWith(
                      fontSize: 15,
                      fontWeight:
                      FontWeight.w600,
                    ),
                  ),

                  SizedBox(
                    height:
                    screenHeight * 0.010,
                  ),

                  CustomTextFormFieldWidget(
                    controller:
                    nameController,

                    hintText:
                    "Ex. John Doe",

                    fillColor:
                    AppColors.background,

                    borderRadius: 10,
                  ),

                  SizedBox(
                    height:
                    screenHeight * 0.025,
                  ),

                  // PHONE
                  Text(
                    "Phone Number",

                    style: textTheme
                        .titleMedium
                        ?.copyWith(
                      fontSize: 15,
                      fontWeight:
                      FontWeight.w600,
                    ),
                  ),

                  SizedBox(
                    height:
                    screenHeight * 0.010,
                  ),

                  CustomTextFormFieldWidget(
                    controller:
                    phoneController,

                    hintText:
                    "Enter Phone Number",

                    fillColor:
                    AppColors.background,

                    borderRadius: 10,

                    keyboardType:
                    TextInputType.phone,

                    prefixIcon:
                    DropdownButtonHideUnderline(
                      child:
                      DropdownButton<
                          String>(
                        value:
                        selectedCountryCode,

                        borderRadius:
                        BorderRadius.circular(
                          12,
                        ),

                        items:
                        countryCodes.map((
                            code,
                            ) {

                          return DropdownMenuItem(
                            value: code,

                            child: Text(
                              code,
                              style: textTheme.bodyMedium?.copyWith(
                                color: AppColors.black,

                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          );
                        }).toList(),

                        onChanged: (
                            value,
                            ) {

                          setState(() {

                            selectedCountryCode =
                            value!;
                          });
                        },
                      ),
                    ),
                  ),

                  SizedBox(
                    height:
                    screenHeight * 0.060,
                  ),
                  Text(
                    "Bio",
                    style: textTheme.titleMedium?.copyWith(
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                    ),
                  ),

                  SizedBox(
                    height: screenHeight * 0.010,
                  ),

                  CustomTextFormFieldWidget(
                    controller: bioController,
                    hintText: "Tell us about yourself",
                    fillColor: AppColors.background,
                    borderRadius: 10,
                    maxLines: 4,
                  ),

                  SizedBox(
                    height:
                    screenHeight * 0.060,
                  ),

                  // BUTTON
                  CustomElevatedButtonWidget(
                    text:
                    "Complete Profile",

                    borderRadius:
                    100,

                    onPressed: () async {

                      if (!_formKey.currentState!.validate()) {
                        return;
                      }

                      final authProvider =
                      Provider.of<UserAuthentication>(
                        context,
                        listen: false,
                      );

                      final result =
                      await authProvider.registerUser(
                        userName: widget.userName,
                        email: widget.email,
                        password: widget.password,

                        fullName:
                        nameController.text.trim(),

                        phoneNumber:
                        "$selectedCountryCode${phoneController.text.trim()}",

                        bio: bioController.text.trim(),

                        profileImage: selectedImage,
                      );

                      if (result["success"]) {

                        ScaffoldMessenger.of(context)
                            .showSnackBar(
                          const SnackBar(
                            content: Text(
                              "Registration Successful",
                            ),
                          ),
                        );

                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            builder: (_) =>
                            const InterestsScreen(),
                          ),
                        );

                      } else {
                        print(result["message"]);
                        ScaffoldMessenger.of(context)
                            .showSnackBar(
                          SnackBar(
                            content: Text(
                              result["message"],
                            ),
                          ),
                        );
                      }
                    },
                    // onPressed: () {
                    //   Navigator.push(
                    //       context,
                    //       MaterialPageRoute(
                    //           builder: (context)=>
                    //               InterestsScreen(),
                    //       ),
                    //   );
                    //   if (_formKey
                    //       .currentState!
                    //       .validate()) {}
                    //
                    // },
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}